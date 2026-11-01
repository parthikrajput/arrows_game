// Full Phase 1 rules (M001–M049) and a solver, following the mechanic cards
// and the fixed move resolution order. Anything a card leaves open counts as
// "blocked / not allowed", so a solution that passes here never depends on it.

const dxs = [0, 1, 0, -1]; // U R D L (clockwise order)
const dys = [-1, 0, 1, 0];
const dirNames = ['U', 'R', 'D', 'L'];
int dirOf(String s) => dirNames.indexOf(s);
int cw(int d) => (d + 1) % 4;
int ccw(int d) => (d + 3) % 4;
int opp(int d) => (d + 2) % 4;

const colors8 = ['red', 'green', 'blue', 'yellow', 'purple', 'orange', 'pink', 'teal'];

/// Types that count as non-monotone (N) in D.
const nTypes = {
  'M007', 'M009', 'M013', 'M017', 'M018', 'M019', 'M021', 'M025', 'M027', 'M031', 'M034', 'M041',
  'M045', 'M047',
};
const hammerTypes = {'M001', 'M002', 'M016', 'M025', 'M027'};

class Snake {
  Snake(this.id, this.color, this.body, this.dir, {this.layer = 0});
  String id;
  String color;
  List<int> body;
  int dir;
  int layer;
  bool caterpillar = false;
  bool isChild = false;
  // variants (set from mechanics)
  bool reverse = false;
  bool hydra = false;
  int wideSide = -1; // absolute dir of the side column
  Snake copy() => Snake(id, color, List.of(body), dir, layer: layer)
    ..caterpillar = caterpillar
    ..isChild = isChild
    ..reverse = reverse
    ..hydra = hydra
    ..wideSide = wideSide;
}

class Mech {
  Mech(this.id, this.type, this.cells, [Map<String, dynamic>? params]) : params = params ?? {};
  String id;
  String type;
  List<int> cells;
  Map<String, dynamic> params;
  // parsed helpers
  int path = -1; // snake index
  List<int> paths = [];
  int k = 0, n = 0, hp = 0;
  String color = '';
  int arrow = -1, axis = -1; // axis: 0 = H, 1 = V
  int side = -1; // edge side dir
  List<int> gates = [];
  int gateInit = 0; // bitmask open
  int state = 0;
  List<int> rot = []; // for M044: dir delta per burrow (+1 CW, -1 CCW)
  List<String> cycle = [];
  int start = 0;
  Snake? child;
  int childIdx = -1;
  List<int> turntables = []; // mech indices
  int keyPath = -1;
  List<int> keyPaths = [];
  List<int> order = [];
  int headCell = -1, loopDir = -1;
  // static derived
  Set<int> neighbours = {};
  Set<int> hidden = {}, touching = {};
  bool gearLinked = false;
  String orient = '';
}

class Level {
  Level(this.w, this.h);
  int w, h;
  int layers = 1;
  List<Snake> snakes = []; // children appended at the end (isChild)
  List<Mech> mechs = [];
  int get cellCount => w * h;
  int cx(int c) => c % w;
  int cy(int c) => c ~/ w;
  int cell(int x, int y) => y * w + x;
  bool inb(int x, int y) => x >= 0 && y >= 0 && x < w && y < h;
  int step(int c, int d) {
    final x = c % w + dxs[d], y = c ~/ w + dys[d];
    return inb(x, y) ? y * w + x : -1;
  }

  bool adj(int a, int b) => (cx(a) - cx(b)).abs() + (cy(a) - cy(b)).abs() == 1;
  int dirFromTo(int a, int b) {
    for (var d = 0; d < 4; d++) {
      if (step(a, d) == b) return d;
    }
    return -1;
  }

  int get baseSnakes => snakes.where((s) => !s.isChild).length;
}

/// Static lookup tables built once per level.
class Rules {
  Rules(this.lv) {
    cellMech = List.filled(lv.cellCount, -1);
    gateOf = List.filled(lv.cellCount, -1);
    plateGateOf = List.filled(lv.cellCount, -1);
    for (var i = 0; i < lv.mechs.length; i++) {
      final m = lv.mechs[i];
      typeIdx.putIfAbsent(m.type, () => []).add(i);
      switch (m.type) {
        case 'M029' || 'M030' || 'M031':
          for (final c in m.cells) {
            edge[c * 4 + m.side] = i;
          }
        case 'M003' || 'M011' || 'M012' || 'M017' || 'M021' || 'M022' || 'M023' || 'M024' ||
            'M028' || 'M032' || 'M033' || 'M039' || 'M040' || 'M041' || 'M046' || 'M047' ||
            'M048':
          break;
        case 'M025' || 'M027':
          break; // dynamic cells
        case 'M035':
          for (final c in m.cells) {
            cellMech[c] = i;
          }
        default:
          for (final c in m.cells) {
            cellMech[c] = i;
          }
      }
      if (m.type == 'M009') {
        for (var g = 0; g < m.gates.length; g++) {
          gateOf[m.gates[g]] = i * 8 + g;
        }
      }
      if (m.type == 'M019') {
        for (final g in m.gates) {
          plateGateOf[g] = i;
        }
      }
      if (m.type == 'M013') lilyOf[m.path] = i;
      if (m.type == 'M012') sleepyOf[m.path] = i;
      if (m.type == 'M017') restless.add(i);
      if (m.type == 'M021') phantom.add(m.path);
      if (m.type == 'M036') hungryOf[m.path] = i;
      if (m.type == 'M041') chameleonOf[m.path] = i;
      if (m.type == 'M047') growing.add(i);
      if (m.type == 'M011' || m.type == 'M039' || m.type == 'M048') {
        for (final p in m.paths) {
          groupOf[p] = i;
        }
      }
    }
    for (final i in typeIdx['M045'] ?? const <int>[]) {
      for (final t in lv.mechs[i].turntables) {
        lv.mechs[t].gearLinked = true;
      }
    }
    timeKey = lv.mechs.any((m) => m.type == 'M021' || m.type == 'M041');
  }
  final Level lv;
  late List<int> cellMech;
  late List<int> gateOf; // M009 gate cell -> mech*8+gateIndex
  late List<int> plateGateOf;
  final Map<int, int> edge = {}; // cell*4+side -> mech
  final Map<String, List<int>> typeIdx = {};
  final Map<int, int> lilyOf = {}, sleepyOf = {}, hungryOf = {}, chameleonOf = {}, groupOf = {};
  final List<int> restless = [], growing = [];
  final Set<int> phantom = {};
  bool timeKey = false;
  List<int> of(String t) => typeIdx[t] ?? const [];
}

/// Mutable game state. Lists are copied on write by [St.copy].
class St {
  St(this.status, this.bodies, this.dirs, this.ms, this.ms2, this.mlist, this.moves,
      [this.gone = const []]);
  List<int> status; // 0 not spawned, 1 on board, 2 gone
  List<List<int>> bodies;
  List<int> dirs;
  List<int> ms, ms2;
  List<List<int>> mlist;
  int moves;

  /// Mechanics smashed by the Hammer; their cells act as plain floor.
  List<int> gone;
  List<int>? _occ0, _occ1;

  St copy() => St(List.of(status), List.of(bodies), List.of(dirs), List.of(ms), List.of(ms2),
      List.of(mlist), moves, List.of(gone));
}

/// Why a tap was not a legal move. Play mode turns these into a bump
/// (blocked, noFood) or a locked tap (locked); the checker rejects them all.
enum Fail { none, locked, blocked, noFood, unclear, notInteractive }

class Trace {
  int kind = 0; // 0 exit, 1 blocked, 2 mud stop, 3 unclear, 4 blind (mist), 5 loop
  List<int> lane = [];
  List<int> jumped = [];
  Set<int> used = {}; // mech indices the lane used
  int mud = -1;
  int blocker = -1; // snake index
  bool viaBurrowHome = false;
  int edgeMech = -1;
  int endCell = -1, endDir = -1;
  @override
  String toString() => 'Trace(kind $kind lane $lane)';
}

class Outcome {
  Outcome(this.next, this.kind, [this.note = '', this.fail = Fail.none]);
  final St? next;
  final int kind; // 0 exit move, 1 other legal move, -1 not allowed
  final String note;
  final Fail fail;
  Set<int> used = {};
  bool unclear = false;

  /// Lanes of every snake that moved (or tried to), keyed by snake index.
  Map<int, Trace> traces = {};

  /// Heart-loss events from counters during this move (play mode only).
  int heartEvents = 0;
}

class Sim {
  // Sent to the Hint isolate together with St; holds plain data only.
  Sim(this.lv, {this.play = false}) : r = Rules(lv) {
    _initStatic();
  }
  final Level lv;
  final Rules r;

  /// Game-screen mode: a Restless Caterpillar timeout costs a heart and
  /// resets, a lilypad may turn into a tangle, and situations the cards leave
  /// open resolve as a bump instead of "not allowed".
  final bool play;
  bool strictUnclear = true; // unclear situations count as not allowed
  bool ignoreDynamic = false; // building: beetles and vines are placed later
  int _hearts = 0;

  /// Mechanic on cell [c], ignoring smashed ones.
  int mechAt(St st, int c) {
    final mi = r.cellMech[c];
    return mi >= 0 && st.gone.contains(mi) ? -1 : mi;
  }

  void _initStatic() {
    for (final m in lv.mechs) {
      if (m.type == 'M003') {
        final s = lv.snakes[m.path];
        m.neighbours = {};
        for (var j = 0; j < lv.snakes.length; j++) {
          if (j == m.path || lv.snakes[j].isChild) continue;
          if (lv.snakes[j].layer != s.layer) continue;
          if (lv.snakes[j].body.any((a) => s.body.any((b) => lv.adj(a, b)))) m.neighbours.add(j);
        }
      }
      if (m.type == 'M010') {
        final area = m.cells.toSet();
        m.hidden = {};
        m.touching = {};
        for (var j = 0; j < lv.snakes.length; j++) {
          final s = lv.snakes[j];
          if (s.isChild) continue;
          if (s.body.any(area.contains)) {
            m.hidden.add(j);
            m.touching.add(j);
          } else if (s.body.any((a) => area.any((b) => lv.adj(a, b)))) {
            m.touching.add(j);
          }
        }
      }
    }
  }

  St initial() {
    final st = St(
      [for (final s in lv.snakes) s.isChild ? 0 : 1],
      [for (final s in lv.snakes) s.body],
      [for (final s in lv.snakes) s.dir],
      List.filled(lv.mechs.length, 0),
      List.filled(lv.mechs.length, 0),
      List.filled(lv.mechs.length, const <int>[]),
      0,
    );
    for (var i = 0; i < lv.mechs.length; i++) {
      final m = lv.mechs[i];
      switch (m.type) {
        case 'M003':
          st.ms[i] = m.k;
        case 'M007' || 'M017' || 'M031':
          st.ms[i] = m.n;
        case 'M009':
          st.ms[i] = m.gateInit;
        case 'M016':
          st.ms[i] = m.hp;
        case 'M018':
          st.ms[i] = m.state;
        case 'M025':
          st.ms[i] = m.start;
        case 'M027':
          st.mlist[i] = List.of(m.cells);
        case 'M043':
          st.ms[i] = (1 << m.keyPaths.length) - 1;
        case 'M049':
          st.ms[i] = m.paths.length;
      }
    }
    return st;
  }

  // ---- occupancy -------------------------------------------------------

  bool isGhost(St st, int s) => r.phantom.contains(s) && st.moves.isOdd;

  List<int> wideCells(St st, int s) {
    final sn = lv.snakes[s];
    if (sn.wideSide < 0) return const [];
    return [for (final c in st.bodies[s]) lv.step(c, sn.wideSide)];
  }

  List<int> occ(St st, int layer) {
    final cached = layer == 0 ? st._occ0 : st._occ1;
    if (cached != null) return cached;
    final o = List.filled(lv.cellCount, -1);
    for (var s = 0; s < lv.snakes.length; s++) {
      if (st.status[s] != 1 || lv.snakes[s].layer != layer) continue;
      if (isGhost(st, s)) continue;
      for (final c in st.bodies[s]) {
        o[c] = s;
      }
      for (final c in wideCells(st, s)) {
        if (c >= 0) o[c] = s;
      }
    }
    if (layer == 0) {
      st._occ0 = o;
    } else {
      st._occ1 = o;
    }
    return o;
  }

  /// Any body (either layer) on cell c.
  int anyBody(St st, int c) {
    final a = occ(st, 0)[c];
    if (a >= 0) return a;
    return lv.layers > 1 ? occ(st, 1)[c] : -1;
  }

  String colorOf(St st, int s) {
    final ci = r.chameleonOf[s];
    if (ci == null) return lv.snakes[s].color;
    final m = lv.mechs[ci];
    return m.cycle[(m.start + st.moves) % m.cycle.length];
  }

  bool plateCovered(St st, Mech m) {
    final c = m.cells.first;
    return anyBody(st, c) >= 0;
  }

  int beetleCell(St st, int i) => lv.mechs[i].cells[st.ms[i]];

  // ---- lane trace --------------------------------------------------------

  Trace trace(St st, int s, int startCell, int dir, {bool transparent = false, Set<int>? blockers}) {
    final t = Trace();
    final sn = lv.snakes[s];
    final layer = sn.layer;
    final o = occ(st, layer);
    final color = colorOf(st, s);
    var c = startCell, d = dir;
    final seen = <int>{};
    var jump = false;
    final beetles = ignoreDynamic ? const <int>[] : [for (final b in r.of('M025')) if (!st.gone.contains(b)) b];
    final vines = ignoreDynamic ? const <int>[] : r.of('M027');
    for (var guard = 0; guard < 400; guard++) {
      final n = lv.step(c, d);
      if (n < 0) {
        t.endCell = c;
        t.endDir = d;
        final em = r.edge[c * 4 + d];
        if (em != null) {
          final m = lv.mechs[em];
          t.used.add(em);
          t.edgeMech = em;
          if (m.type == 'M029' ||
              (m.type == 'M030' && color != '*' && color != m.color) ||
              (m.type == 'M031' && st.ms[em] <= 0)) {
            if (transparent) return t..kind = 0;
            t.kind = 1;
            return t;
          }
        }
        t.kind = 0;
        return t;
      }
      if (!seen.add(n * 4 + d)) {
        t.kind = 5;
        return t;
      }
      if (jump) {
        jump = false;
        t.jumped.add(n);
        final ob = anyBodyLayer(st, n, layer);
        if (ob >= 0) {
          if (transparent) {
            blockers?.add(ob);
          } else {
            t.kind = 1;
            t.blocker = ob;
            return t;
          }
        }
        // a jumped cell holding something the lane would react to is unclear
        final jm = mechAt(st, n);
        if (jm >= 0 && const {'M026', 'M036', 'M037', 'M008', 'M044', 'M014', 'M018', 'M020', 'M038'}
            .contains(lv.mechs[jm].type)) {
          t.kind = 3;
          return t;
        }
        c = n;
        continue;
      }
      t.lane.add(n);
      // snakes
      final ob = o[n];
      if (ob >= 0) {
        final bm = mechAt(st, n);
        final isBridge = bm >= 0 &&
            (lv.mechs[bm].type == 'M015' || (lv.mechs[bm].type == 'M042' && st.ms[bm] == 0));
        if (isBridge && (d % 2 == 0) == (lv.mechs[bm].axis == 0)) {
          // lane perpendicular to the bridge axis passes under the body
          t.used.add(bm);
        } else if (ob == s && !transparent) {
          t.kind = 1;
          t.blocker = s;
          return t;
        } else if (transparent) {
          if (ob != s) blockers?.add(ob);
        } else {
          t.kind = 1;
          t.blocker = ob;
          return t;
        }
      }
      // dynamic blockers
      var dyn = false;
      for (final b in beetles) {
        if (beetleCell(st, b) == n) {
          t.used.add(b);
          dyn = true;
        } else if (lv.mechs[b].cells.contains(n)) {
          t.used.add(b);
        }
      }
      for (final v in vines) {
        if (st.mlist[v].contains(n)) {
          t.used.add(v);
          dyn = true;
        }
      }
      if (dyn) {
        if (transparent) {
          c = n;
          continue;
        }
        t.kind = 1;
        return t;
      }
      final g = r.gateOf[n];
      if (g >= 0) {
        final mi = g ~/ 8, gi = g % 8;
        t.used.add(mi);
        if ((st.ms[mi] >> gi) & 1 == 0 && !transparent) {
          t.kind = 1;
          return t;
        }
      }
      final pg = r.plateGateOf[n];
      if (pg >= 0) {
        t.used.add(pg);
        if (!plateCovered(st, lv.mechs[pg]) && !transparent) {
          t.kind = 1;
          return t;
        }
      }
      final mi = mechAt(st, n);
      if (mi < 0) {
        c = n;
        continue;
      }
      final m = lv.mechs[mi];
      t.used.add(mi);
      bool blockedIf(bool cond) {
        if (cond && !transparent) {
          t.kind = 1;
          return true;
        }
        return false;
      }

      switch (m.type) {
        case 'M001' || 'M002':
          if (blockedIf(true)) return t;
        case 'M004':
          if (blockedIf(st.ms[mi] == 0)) return t;
        case 'M005':
          if (blockedIf(color != '*' && color != m.color)) return t;
        case 'M006':
          if (blockedIf(d != m.arrow)) return t;
        case 'M007':
          if (blockedIf(st.ms[mi] > 0)) return t;
        case 'M008' || 'M044':
          final other = m.cells[0] == n ? m.cells[1] : m.cells[0];
          final ob2 = anyBodyLayer(st, other, layer);
          if (ob2 >= 0) {
            if (transparent) {
              blockers?.add(ob2);
            } else {
              t.kind = 1;
              t.blocker = ob2;
              return t;
            }
          }
          if (m.type == 'M044') {
            final ri = m.cells[0] == n ? 1 : 0; // rotation of the exit burrow
            d = (d + m.rot[ri] + 4) % 4;
          }
          t.lane.add(other);
          c = other;
          continue;
        case 'M009' || 'M045':
          if (!transparent) {
            t.kind = 3; // lever cell: card does not say if lanes pass it
            return t;
          }
        case 'M010':
          if (st.ms[mi] == 0 && !transparent) {
            t.kind = 4;
            return t;
          }
        case 'M013':
          if (!transparent) {
            t.kind = 3; // empty lilypad: not said
            return t;
          }
        case 'M014':
          d = m.orient == '/' ? const [1, 0, 3, 2][d] : const [3, 2, 1, 0][d];
        case 'M015':
          break;
        case 'M016':
          if (blockedIf(st.ms[mi] > 0)) return t;
        case 'M018':
          d = st.ms[mi] == 0 ? ccw(d) : cw(d);
        case 'M019':
          break; // plate cell is floor
        case 'M020':
          t.kind = 0;
          t.viaBurrowHome = true;
          t.endCell = n;
          t.endDir = d;
          return t;
        case 'M026' || 'M036':
          break;
        case 'M034':
          if (!transparent) {
            t.kind = 3;
            return t;
          }
        case 'M035':
          if (st.ms[mi] != 2 && !transparent) {
            t.kind = 3; // marked egg cells before the spawn: not said
            return t;
          }
        case 'M037':
          if (!transparent) {
            t.kind = 2;
            t.mud = n;
            return t;
          }
        case 'M038':
          jump = true;
        case 'M042':
          if (blockedIf(st.ms[mi] == 1)) return t;
        case 'M043':
          if (blockedIf(st.ms[mi] != 0)) return t;
        case 'M049':
          if (blockedIf(st.ms[mi] > 0)) return t;
        default:
          if (!transparent) {
            t.kind = 3;
            return t;
          }
      }
      c = n;
    }
    t.kind = 5;
    return t;
  }

  int anyBodyLayer(St st, int c, int layer) => occ(st, layer)[c];

  /// Lane start and direction for a snake tap. [tail] picks the far head of
  /// a Two-Headed Hydra.
  (int, int) laneStart(St st, int s, {bool tail = false}) {
    final sn = lv.snakes[s];
    final b = st.bodies[s];
    if (sn.reverse || tail) {
      final end = b.last, prev = b[b.length - 2];
      return (end, lv.dirFromTo(prev, end));
    }
    return (b.first, st.dirs[s]);
  }

  Trace laneOf(St st, int s, {bool tail = false}) {
    final sn = lv.snakes[s];
    final (c, d) = laneStart(st, s, tail: tail);
    if (sn.wideSide < 0) return trace(st, s, c, d);
    // wide snake: spine lane and side lane, both straight
    final t1 = trace(st, s, c, d);
    final sc = lv.step(c, sn.wideSide);
    final t2 = trace(st, s, sc, d);
    final t = Trace();
    t.lane = [...t1.lane, ...t2.lane];
    t.used = {...t1.used, ...t2.used};
    t.kind = t1.kind != 0 ? t1.kind : t2.kind;
    t.blocker = t1.kind != 0 ? t1.blocker : t2.blocker;
    t.endCell = t1.endCell;
    t.endDir = t1.endDir;
    // the side lane must not hit the spine body and vice versa (own body)
    for (final x in [...t1.lane, ...t2.lane]) {
      final m = mechAt(st, x);
      if (m >= 0 && const {'M008', 'M014', 'M018', 'M037', 'M038', 'M044', 'M020'}
          .contains(lv.mechs[m].type)) {
        t.kind = 3;
      }
    }
    return t;
  }

  // ---- locks -------------------------------------------------------------

  bool locked(St st, int s) => lockReason(st, s) != null;

  /// Mechanic type that keeps snake [s] from moving right now, or null.
  /// 'gone' means the snake is not on the board.
  String? lockReason(St st, int s) {
    if (st.status[s] != 1) return 'gone';
    for (var i = 0; i < lv.mechs.length; i++) {
      final m = lv.mechs[i];
      switch (m.type) {
        case 'M003':
          if (m.path == s && st.ms[i] > 0) return 'M003';
        case 'M010':
          if (st.ms[i] == 0 && m.hidden.contains(s)) return 'M010';
        case 'M028':
          final idx = st.ms[i];
          if (m.order.contains(s) && (idx >= m.order.length || m.order[idx] != s)) return 'M028';
        case 'M033':
          if (m.path == s && st.ms[i] == 0) return 'M033';
        case 'M046':
          if (m.path == s && st.ms[i] == 0) return 'M046';
      }
    }
    if (isGhost(st, s)) return 'M021';
    final sn = lv.snakes[s];
    if (sn.layer == 0 && lv.layers > 1) {
      final o1 = occ(st, 1);
      if (st.bodies[s].any((c) => o1[c] >= 0)) return 'M032';
    }
    if (r.lilyOf.containsKey(s)) {
      final b = st.bodies[s];
      if (lv.step(b[0], st.dirs[s]) == b[1]) return 'M013';
    }
    return null;
  }

  // ---- actions -------------------------------------------------------------

  List<String> actions(St st) {
    final out = <String>[];
    final seenGroup = <int>{};
    for (var s = 0; s < lv.snakes.length; s++) {
      if (st.status[s] != 1) continue;
      final g = r.groupOf[s];
      if (g != null) {
        if (!seenGroup.add(g)) continue;
      }
      out.add(lv.snakes[s].id);
    }
    for (var i = 0; i < lv.mechs.length; i++) {
      final m = lv.mechs[i];
      switch (m.type) {
        case 'M009' || 'M018' || 'M034' || 'M045':
          out.add(m.id);
        case 'M013':
          if (!m.gearLinked && st.status[m.path] == 1) out.add(m.id);
      }
    }
    return out;
  }

  late final Map<String, int> _snakeById = {
    for (var i = 0; i < lv.snakes.length; i++) lv.snakes[i].id: i
  };
  late final Map<String, int> _mechById = {
    for (var i = 0; i < lv.mechs.length; i++) lv.mechs[i].id: i
  };

  int snakeIndex(String id) => _snakeById[id] ?? -1;
  int mechIndex(String id) => _mechById[id] ?? -1;

  Outcome apply(St st0, String a) {
    final si = _snakeById[a];
    if (si != null) return tapSnake(st0, si);
    final mi = _mechById[a];
    if (mi != null) return tapMech(st0, mi);
    return Outcome(null, -1, 'unknown $a');
  }

  /// Taps an interactive cell (lever, lilypad, switch, stump, gear).
  Outcome tapMech(St st0, int mi) {
    final m = lv.mechs[mi];
    final st = st0.copy();
    final used = <int>{mi};
    switch (m.type) {
      case 'M009':
        st.ms[mi] ^= (1 << m.gates.length) - 1;
        // a gate closing on a body is not described
        for (var g = 0; g < m.gates.length; g++) {
          if (anyBody(st, m.gates[g]) >= 0) return Outcome(null, -1, 'gate on body', Fail.locked);
        }
      case 'M013':
        if (m.gearLinked || st.status[m.path] != 1) {
          return Outcome(null, -1, 'locked', Fail.locked);
        }
        st.dirs = List.of(st.dirs);
        st.dirs[m.path] = cw(st.dirs[m.path]);
        final b = st.bodies[m.path];
        if (!play && lv.step(b[0], st.dirs[m.path]) == b[1]) {
          return Outcome(null, -1, 'tangled', Fail.locked);
        }
      case 'M018':
        st.ms[mi] ^= 1;
      case 'M034':
        final res = _rotateStump(st, m);
        if (!res) return Outcome(null, -1, 'stump locked', Fail.locked);
      case 'M045':
        st.dirs = List.of(st.dirs);
        for (final t in m.turntables) {
          final p = lv.mechs[t].path;
          if (st.status[p] != 1) continue;
          st.dirs[p] = cw(st.dirs[p]);
          final b = st.bodies[p];
          if (!play && lv.step(b[0], st.dirs[p]) == b[1]) {
            return Outcome(null, -1, 'tangled', Fail.locked);
          }
          used.add(t);
        }
      default:
        return Outcome(null, -1, 'not interactive', Fail.notInteractive);
    }
    st._occ0 = null;
    st._occ1 = null;
    final ok = _endMove(st, used);
    if (!ok) return Outcome(null, -1, 'tick violation', Fail.unclear);
    return Outcome(st, 1)
      ..used = used
      ..heartEvents = _hearts;
  }

  bool _rotateStump(St st, Mech m) {
    // cells: [tl, tr, bl, br]; CW maps tl->tr, tr->br, br->bl, bl->tl
    final tl = m.cells[0], tr = m.cells[1], bl = m.cells[2], br = m.cells[3];
    final map = {tl: tr, tr: br, br: bl, bl: tl};
    final region = map.keys.toSet();
    var any = false;
    st.bodies = List.of(st.bodies);
    st.dirs = List.of(st.dirs);
    for (var s = 0; s < lv.snakes.length; s++) {
      if (st.status[s] != 1) continue;
      final b = st.bodies[s];
      final inside = b.where(region.contains).length;
      if (inside == 0) continue;
      if (inside != b.length) return false;
      st.bodies[s] = [for (final c in b) map[c]!];
      st.dirs[s] = cw(st.dirs[s]);
      any = true;
    }
    return any;
  }

  /// Taps snake [s]. [tail] sends a Two-Headed Hydra out of its far end.
  Outcome tapSnake(St st0, int s, {bool tail = false}) {
    if (locked(st0, s)) return Outcome(null, -1, 'locked', Fail.locked);
    // sleepy python: first tap wakes it
    final sl = r.sleepyOf[s];
    if (sl != null && st0.ms[sl] == 0) {
      final st = st0.copy();
      st.ms[sl] = 1;
      if (!_endMove(st, {sl})) return Outcome(null, -1, 'tick', Fail.unclear);
      return Outcome(st, 1)
        ..used = {sl}
        ..heartEvents = _hearts;
    }
    final g = r.groupOf[s];
    final members = g == null
        ? [s]
        : [for (final p in lv.mechs[g].paths) if (st0.status[p] == 1) p];
    for (final p in members) {
      if (locked(st0, p)) return Outcome(null, -1, 'locked member', Fail.locked);
      if (p != s && r.sleepyOf[p] != null) {
        return Outcome(null, -1, 'unclear', play ? Fail.locked : Fail.unclear);
      }
    }
    final traces = <int, Trace>{};
    Outcome failed(String note, Fail why) => Outcome(null, -1, note, why)..traces = traces;
    for (final p in members) {
      final t = laneOf(st0, p, tail: tail && p == s && lv.snakes[s].hydra);
      traces[p] = t;
      if (t.kind == 2 && members.length == 1) {
        final mud = _mud(st0, p, t);
        if (mud.kind >= 0 || !play) return mud..traces = traces;
        return failed(mud.note, Fail.blocked);
      }
      if (t.kind != 0) {
        return failed('blocked ${t.kind}', t.kind == 3 && !play ? Fail.unclear : Fail.blocked);
      }
    }
    // hungry: needs food on the lane
    final st = st0.copy();
    final used = <int>{?g};
    for (final p in members) {
      final hi = r.hungryOf[p];
      if (hi != null) {
        final m = lv.mechs[hi];
        var ate = -1;
        for (final c in traces[p]!.lane) {
          final fi = m.cells.indexOf(c);
          if (fi >= 0 && (st.ms[hi] >> fi) & 1 == 0) {
            ate = fi;
            break;
          }
        }
        if (ate < 0) return failed('no food', Fail.noFood);
        st.ms[hi] |= 1 << ate;
        used.add(hi);
      }
    }
    // twig bridge crossed while a body lies on it: not described
    if (!play) {
      for (final p in members) {
        for (final c in traces[p]!.lane) {
          final bm = mechAt(st0, c);
          if (bm >= 0 && lv.mechs[bm].type == 'M042' && st.ms[bm] == 0 && anyBody(st0, c) >= 0 &&
              anyBody(st0, c) != p) {
            return failed('unclear twig', Fail.unclear);
          }
        }
      }
    }
    final moundHits = <int, int>{};
    for (final p in members) {
      used.addAll(traces[p]!.used);
      _exitTriggers(st0, st, p, traces[p]!, moundHits, used);
    }
    if (!play && moundHits.values.any((v) => v > 1)) return failed('unclear mound', Fail.unclear);
    st._occ0 = null;
    st._occ1 = null;
    if (!_endMove(st, used)) return failed('tick violation', Fail.unclear);
    return Outcome(st, 0)
      ..used = used
      ..traces = traces
      ..heartEvents = _hearts;
  }

  /// A bump: nothing moves, but it is a Move, so counters tick.
  Outcome bump(St st0) {
    final st = st0.copy();
    _endMove(st, {});
    return Outcome(st, 1)..heartEvents = _hearts;
  }

  Outcome _mud(St st0, int s, Trace t) {
    final sn = lv.snakes[s];
    if (sn.reverse || sn.hydra || sn.wideSide >= 0) {
      return Outcome(null, -1, 'unclear mud', Fail.unclear);
    }
    // relocation lane must be a plain straight run
    for (final c in t.lane) {
      final m = mechAt(st0, c);
      if (m >= 0 && lv.mechs[m].type != 'M037') {
        return Outcome(null, -1, 'unclear mud', Fail.unclear);
      }
    }
    if (t.jumped.isNotEmpty) return Outcome(null, -1, 'unclear mud', Fail.unclear);
    final old = st0.bodies[s];
    final path = [...t.lane.reversed, ...old];
    final nb = path.sublist(0, old.length);
    // straight lane (no redirect), so the head keeps its direction
    final st = st0.copy();
    st.bodies = List.of(st.bodies);
    st.bodies[s] = nb;
    st._occ0 = null;
    st._occ1 = null;
    final used = {r.cellMech[t.mud]};
    if (!_endMove(st, used)) return Outcome(null, -1, 'tick', Fail.unclear);
    return Outcome(st, 1)
      ..used = used
      ..heartEvents = _hearts;
  }

  /// [lane] = false for a Hammer smash: the snake counts as gone for keys,
  /// counts and HP, but its lane never ran (no gems, mounds or bridges).
  void _exitTriggers(St before, St st, int s, Trace t, Map<int, int> moundHits, Set<int> used,
      {bool lane = true}) {
    st.status = st.status; // copied already
    st.status[s] = 2;
    final laneSet = t.lane.toSet();
    for (var i = 0; i < lv.mechs.length; i++) {
      final m = lv.mechs[i];
      switch (m.type) {
        case 'M003':
          if (st.ms[i] > 0 && m.neighbours.contains(s)) {
            st.ms[i]--;
            used.add(i);
          }
        case 'M004':
          if (m.keyPath == s) {
            st.ms[i] = 1;
            used.add(i);
          }
        case 'M043':
          final k = m.keyPaths.indexOf(s);
          if (k >= 0) {
            st.ms[i] &= ~(1 << k);
            used.add(i);
          }
        case 'M046':
          if (m.keyPath == s) {
            st.ms[i] = 1;
            used.add(i);
          }
        case 'M010':
          if (st.ms[i] == 0 && m.touching.contains(s)) {
            st.ms[i] = 1;
            used.add(i);
          }
        case 'M049':
          if (m.paths.contains(s) && st.ms[i] > 0) {
            st.ms[i]--;
            used.add(i);
          }
        case 'M016':
          if (lane && st.ms[i] > 0) {
            final c = m.cells.first;
            if (laneSet.any((x) => lv.adj(x, c))) {
              st.ms[i]--;
              moundHits[i] = (moundHits[i] ?? 0) + 1;
              used.add(i);
            }
          }
        case 'M026':
          if (!lane) break;
          for (var gi = 0; gi < m.cells.length; gi++) {
            if (laneSet.contains(m.cells[gi])) {
              st.ms[i] |= 1 << gi;
              used.add(i);
            }
          }
        case 'M035':
          if (m.path == s) {
            st.ms[i] = 1;
            used.add(i);
          }
        case 'M042':
          if (lane &&
              st.ms[i] == 0 &&
              (laneSet.contains(m.cells.first) || before.bodies[s].contains(m.cells.first))) {
            st.ms[i] = 1;
            used.add(i);
          }
        case 'M028':
          final idx = st.ms[i];
          if (idx < m.order.length && m.order[idx] == s) {
            st.ms[i]++;
            used.add(i);
          }
      }
    }
  }

  /// moveCount++, ticks in the fixed order, derived states. False = a
  /// heart-loss event (restless timeout) or an unclear situation. In play
  /// mode a timeout is counted in [_hearts] and the counter starts again.
  bool _endMove(St st, Set<int> used) {
    _hearts = 0;
    st.moves++;
    st._occ0 = null;
    st._occ1 = null;
    for (final i in r.of('M007')) {
      if (st.ms[i] > 0) st.ms[i]--;
    }
    for (final i in r.restless) {
      final p = lv.mechs[i].path;
      if (st.status[p] == 1) {
        st.ms[i]--;
        if (st.ms[i] <= 0) {
          if (!play) return false;
          st.ms[i] = lv.mechs[i].n;
          _hearts++;
          used.add(i);
        }
      }
    }
    for (final i in r.of('M031')) {
      if (st.ms[i] > 0) st.ms[i]--;
    }
    for (final i in r.of('M025')) {
      if (st.gone.contains(i)) continue;
      final m = lv.mechs[i];
      final nx = (st.ms[i] + 1) % m.cells.length;
      if (anyBody(st, m.cells[nx]) < 0) st.ms[i] = nx;
    }
    for (final i in r.of('M027')) {
      final m = lv.mechs[i];
      st.ms2[i]++;
      if (st.ms2[i] >= m.n) {
        st.ms2[i] = 0;
        final grown = _growVine(st, i);
        if (grown == -2) return false;
      }
    }
    for (final i in r.growing) {
      final m = lv.mechs[i];
      st.ms2[i]++;
      if (st.ms2[i] >= m.n) {
        st.ms2[i] = 0;
        final p = m.path;
        if (st.status[p] == 1) {
          final b = st.bodies[p];
          final d = lv.dirFromTo(b[b.length - 2], b.last);
          final t = lv.step(b.last, d);
          if (t >= 0) {
            final free = anyBody(st, t) < 0 &&
                mechAt(st, t) < 0 &&
                r.gateOf[t] < 0 &&
                r.plateGateOf[t] < 0 &&
                !_dynamicAt(st, t);
            // grows onto a mechanic cell, or past 8 cells: not described
            if (!free && anyBody(st, t) < 0 && !play) return false;
            if (free && b.length >= 8 && !play) return false;
            if (free && b.length < 8) {
              st.bodies = List.of(st.bodies);
              st.bodies[p] = [...b, t];
              st._occ0 = null;
              st._occ1 = null;
              used.add(i);
            }
          }
        }
      }
    }
    _derived(st, used);
    return true;
  }

  /// Cages that open and nests that hatch once the board allows it.
  void _derived(St st, Set<int> used) {
    for (final i in r.of('M033')) {
      if (st.ms[i] == 1) continue;
      final m = lv.mechs[i];
      var any = false;
      for (var s = 0; s < lv.snakes.length; s++) {
        if (s == m.path || st.status[s] == 2) continue;
        if (st.status[s] == 0) continue;
        if (colorOf(st, s) == m.color) any = true;
      }
      if (!any) {
        st.ms[i] = 1;
        used.add(i);
      }
    }
    for (final i in r.of('M035')) {
      if (st.ms[i] != 1) continue;
      final m = lv.mechs[i];
      if (m.cells.every((c) => anyBody(st, c) < 0 && !_dynamicAt(st, c))) {
        st.ms[i] = 2;
        st.status[m.childIdx] = 1;
        st._occ0 = null;
        st._occ1 = null;
      }
    }
  }

  // ---- Magic Stone Hammer ----------------------------------------------------

  bool _gemsLeft(St st) {
    for (final i in r.of('M026')) {
      if (st.ms[i] != (1 << lv.mechs[i].cells.length) - 1) return true;
    }
    return false;
  }

  /// Visible, solid snakes can be smashed, except a closed Tail-Biter Loop
  /// and the last snake while gems are still on the board.
  bool canHammerSnake(St st, int s) {
    if (st.status[s] != 1 || isGhost(st, s)) return false;
    for (var i = 0; i < lv.mechs.length; i++) {
      final m = lv.mechs[i];
      if (m.type == 'M010' && st.ms[i] == 0 && m.hidden.contains(s)) return false;
      if (m.type == 'M046' && m.path == s && st.ms[i] == 0) return false;
    }
    if (_gemsLeft(st) && st.status.where((x) => x != 2).length <= 1) return false;
    return true;
  }

  /// Hammerable obstacles: rocks, logs, mounds, beetles, vine cells and a
  /// snapped twig bridge. Guardians, hedges, gates and locks never are.
  bool canHammerMech(St st, int mi, {int cell = -1}) {
    if (st.gone.contains(mi)) return false;
    final m = lv.mechs[mi];
    return switch (m.type) {
      'M001' || 'M002' || 'M025' => true,
      'M016' => st.ms[mi] > 0,
      'M042' => st.ms[mi] == 1,
      'M027' => st.mlist[mi].contains(cell),
      _ => false,
    };
  }

  /// Smashing a snake counts as its exit for keys, counts, HP and order.
  /// Not a Move, so nothing ticks.
  Outcome hammerSnake(St st0, int s) {
    if (!canHammerSnake(st0, s)) return Outcome(null, -1, 'not hammerable', Fail.locked);
    final st = st0.copy();
    final used = <int>{};
    _exitTriggers(st0, st, s, Trace(), {}, used, lane: false);
    st._occ0 = null;
    st._occ1 = null;
    _derived(st, used);
    return Outcome(st, 0)..used = used;
  }

  Outcome hammerMech(St st0, int mi, {int cell = -1}) {
    if (!canHammerMech(st0, mi, cell: cell)) {
      return Outcome(null, -1, 'not hammerable', Fail.locked);
    }
    final st = st0.copy();
    final m = lv.mechs[mi];
    switch (m.type) {
      case 'M016':
        st.ms[mi] = 0;
      case 'M027':
        st.mlist = List.of(st.mlist);
        st.mlist[mi] = [for (final c in st.mlist[mi]) if (c != cell) c];
      default:
        st.gone = [...st.gone, mi];
    }
    st._occ0 = null;
    st._occ1 = null;
    final used = <int>{mi};
    _derived(st, used);
    return Outcome(st, 1)..used = used;
  }

  bool _dynamicAt(St st, int c) {
    for (final b in r.of('M025')) {
      if (st.gone.contains(b)) continue;
      if (beetleCell(st, b) == c) return true;
    }
    for (final v in r.of('M027')) {
      if (st.mlist[v].contains(c)) return true;
    }
    return false;
  }

  /// -1 no growth, -2 unclear, else new cell.
  int _growVine(St st, int i) {
    final cells = st.mlist[i];
    for (final c in cells) {
      for (final d in const [0, 1, 2, 3]) {
        final n = lv.step(c, d);
        if (n < 0) continue;
        if (anyBody(st, n) >= 0) continue;
        if (_dynamicAt(st, n)) continue;
        if (mechAt(st, n) >= 0 || r.gateOf[n] >= 0 || r.plateGateOf[n] >= 0) {
          continue; // obstacle or gem: not free
        }
        st.mlist = List.of(st.mlist);
        st.mlist[i] = [...cells, n];
        return n;
      }
    }
    return -1;
  }

  bool won(St st) {
    for (var s = 0; s < lv.snakes.length; s++) {
      if (st.status[s] != 2) return false;
    }
    for (final i in r.of('M026')) {
      if (st.ms[i] != (1 << lv.mechs[i].cells.length) - 1) return false;
    }
    return true;
  }

  String key(St st) {
    final sb = StringBuffer();
    sb.writeAll(st.status);
    sb.write('|');
    sb.writeAll(st.ms, ',');
    sb.write('|');
    sb.writeAll(st.ms2, ',');
    for (final i in r.of('M027')) {
      sb.write('|${st.mlist[i].join('.')}');
    }
    for (var s = 0; s < lv.snakes.length; s++) {
      if (!identical(st.bodies[s], lv.snakes[s].body)) sb.write('|$s:${st.bodies[s].join('.')}');
      if (st.dirs[s] != lv.snakes[s].dir) sb.write('|d$s:${st.dirs[s]}');
    }
    if (r.timeKey) sb.write('|t${st.moves % 6}');
    if (st.gone.isNotEmpty) sb.write('|g${st.gone.join('.')}');
    return sb.toString();
  }

  // ---- chain C (start position, snakes only, like the checker) -----------

  int chain() {
    final st = initial();
    final deps = <int, Set<int>>{};
    for (var s = 0; s < lv.snakes.length; s++) {
      if (lv.snakes[s].isChild) continue;
      final bl = <int>{};
      final (c, d) = laneStart(st, s);
      trace(st, s, c, d, transparent: true, blockers: bl);
      final sn = lv.snakes[s];
      if (sn.wideSide >= 0) {
        trace(st, s, lv.step(c, sn.wideSide), d, transparent: true, blockers: bl);
      }
      bl.remove(s);
      deps[s] = bl;
    }
    final memo = <int, int>{};
    int depth(int id, Set<int> stack) {
      final hit = memo[id];
      if (hit != null) return hit;
      if (!stack.add(id)) return 0;
      var best = 0;
      for (final d in deps[id]!) {
        final v = 1 + depth(d, stack);
        if (v > best) best = v;
      }
      stack.remove(id);
      return memo[id] = best;
    }

    var best = 0;
    for (final id in deps.keys) {
      final v = depth(id, {});
      if (v > best) best = v;
    }
    return best;
  }
}

/// Iterative deepening on non-exit moves: finds a winning sequence with the
/// fewest moves (exits are a fixed count), never using a bump.
class Solver {
  Solver(this.sim, {this.nodeLimit = 60000, this.maxExtra = 8, this.minExtra = 0, this.prefer = const []});
  final Sim sim;
  final int nodeLimit;
  final int maxExtra;
  final int minExtra; // a proven lower bound on non-exit moves
  final List<String> prefer; // action ids tried first
  int nodes = 0;
  bool aborted = false;

  List<String>? solve({St? from}) {
    final st0 = from ?? sim.initial();
    for (var e = minExtra; e <= maxExtra; e++) {
      final memo = <String, int>{};
      final path = <String>[];
      if (_dfs(st0, e, memo, path)) return path;
      if (aborted) return null;
    }
    return null;
  }

  bool _dfs(St st, int extra, Map<String, int> memo, List<String> path) {
    if (sim.won(st)) return true;
    if (++nodes > nodeLimit) {
      aborted = true;
      return false;
    }
    final k = sim.key(st);
    final seen = memo[k];
    if (seen != null && seen >= extra) return false;
    memo[k] = extra;
    final acts = sim.actions(st);
    final ordered = <String>[
      for (final p in prefer)
        if (acts.contains(p)) p,
      for (final a in acts)
        if (!prefer.contains(a)) a,
    ];
    final later = <(String, Outcome)>[];
    for (final a in ordered) {
      final o = sim.apply(st, a);
      if (o.kind < 0) continue;
      if (o.kind == 1) {
        later.add((a, o));
        continue;
      }
      path.add(a);
      if (_dfs(o.next!, extra, memo, path)) return true;
      path.removeLast();
      if (aborted) return false;
    }
    if (extra == 0) return false;
    for (final (a, o) in later) {
      path.add(a);
      if (_dfs(o.next!, extra - 1, memo, path)) return true;
      path.removeLast();
      if (aborted) return false;
    }
    return false;
  }
}

/// Plays [solution]; returns null if every step is a legal non-bump move and
/// the level is won, else the reason. Collects the mechanics the play used.
String? replay(Sim sim, List<String> solution, {Set<int>? used, List<String>? kinds}) {
  var st = sim.initial();
  for (var i = 0; i < solution.length; i++) {
    final o = sim.apply(st, solution[i]);
    if (o.kind < 0) return 'step ${i + 1} ${solution[i]}: ${o.note}';
    used?.addAll(o.used);
    kinds?.add(o.kind == 0 ? 'exit' : 'other');
    st = o.next!;
  }
  if (!sim.won(st)) return 'not won';
  return null;
}
