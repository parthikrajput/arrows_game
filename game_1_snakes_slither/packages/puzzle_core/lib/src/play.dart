import 'engine.dart';
import 'full_rules/level_json.dart' as fj;
import 'full_rules/rules.dart' as fr;
import 'model.dart';

const _dirs = [Dir.up, Dir.right, Dir.down, Dir.left]; // full-rules order U R D L

Dir dirFromIndex(int d) => _dirs[d];
int dirIndex(Dir d) => _dirs.indexOf(d);

/// One level ready for play under the full Phase 1 rules (M001–M049), plus
/// the conversion from engine state to the board the screen draws.
class PlayLevel {
  PlayLevel._(this.lv) : sim = fr.Sim(lv, play: true), strict = fr.Sim(lv);

  /// From level JSON (schema v3).
  factory PlayLevel.fromJson(Map<String, dynamic> raw) => PlayLevel._(fj.parseLevel(raw));

  /// From a board with only snakes and rocks (generated Daily boards, tests).
  factory PlayLevel.fromBoard(BoardState b) {
    final lv = fr.Level(b.width, b.height);
    final ids = b.snakes.keys.toList()..sort();
    for (final id in ids) {
      final s = b.snakes[id]!;
      lv.snakes.add(
        fr.Snake(
          s.ref.isEmpty ? 'p$id' : s.ref,
          s.color.name,
          [for (final c in s.body) lv.cell(c.x, c.y)],
          dirIndex(s.dir),
        )..caterpillar = s.skin == SnakeSkin.caterpillar,
      );
    }
    final rocks = b.rocks.keys.toList()..sort();
    for (final id in rocks) {
      final r = b.rocks[id]!;
      lv.mechs.add(fr.Mech(r.ref.isEmpty ? 'o$id' : r.ref, 'M001', [lv.cell(r.cell.x, r.cell.y)]));
    }
    return PlayLevel._(lv);
  }

  static final _cache = Expando<PlayLevel>();

  /// Reuses the rules already built while decoding [level].
  static void attach(Level level, PlayLevel p) => _cache[level] = p;

  /// Built once per [Level] and reused by every attempt at it.
  static PlayLevel of(Level level) => _cache[level] ??=
      level.raw != null ? PlayLevel.fromJson(level.raw!) : PlayLevel.fromBoard(level.board);

  final fr.Level lv;

  /// Game rules: bumps, heart-costing counters, tangles.
  final fr.Sim sim;

  /// Checker rules, for the Hint solver: never plans a bump or a heart loss.
  final fr.Sim strict;

  fr.St initial() => sim.initial();

  Cell cellOf(int c) => Cell(lv.cx(c), lv.cy(c));

  int snakeCount() => lv.snakes.length;

  // ---- board view -----------------------------------------------------------

  BoardState view(fr.St st) {
    final groupNo = <int, int>{};
    var g = 0;
    for (final m in lv.mechs) {
      if (const {'M011', 'M039', 'M048'}.contains(m.type)) {
        g++;
        for (final p in m.paths) {
          groupNo[p] = g;
        }
      }
    }
    final snakes = <int, Snake>{};
    for (var s = 0; s < lv.snakes.length; s++) {
      if (st.status[s] != 1) continue;
      snakes[s] = _snakeView(st, s, groupNo[s] ?? 0);
    }
    final rocks = <int, Rock>{};
    final obstacles = <Obstacle>[];
    for (var i = 0; i < lv.mechs.length; i++) {
      final m = lv.mechs[i];
      if (st.gone.contains(i)) continue;
      if (m.type == 'M001') {
        rocks[i] = Rock(id: i, cell: cellOf(m.cells.first), ref: m.id);
        continue;
      }
      final o = _obstacleView(st, i);
      if (o != null) obstacles.add(o);
    }
    return BoardState(
      width: lv.w,
      height: lv.h,
      snakes: snakes,
      rocks: rocks,
      obstacles: obstacles,
      night: lv.mechs.any((m) => m.type == 'M040'),
    );
  }

  Snake _snakeView(fr.St st, int s, int group) {
    final sn = lv.snakes[s];
    var frozen = 0, hatch = 0, restless = 0;
    var sleeping = false, hidden = false, hungry = false, growing = false, loop = false;
    String? cage, key;
    for (var i = 0; i < lv.mechs.length; i++) {
      final m = lv.mechs[i];
      switch (m.type) {
        case 'M003' when m.path == s:
          frozen = st.ms[i];
        case 'M010' when st.ms[i] == 0 && m.hidden.contains(s):
          hidden = true;
        case 'M012' when m.path == s:
          sleeping = st.ms[i] == 0;
        case 'M017' when m.path == s:
          restless = st.ms[i];
        case 'M028':
          final k = m.order.indexOf(s);
          if (k >= 0) hatch = k + 1;
        case 'M033' when m.path == s && st.ms[i] == 0:
          cage = m.color;
        case 'M004' when m.keyPath == s:
          key = _lockColor(i);
        case 'M043' when m.keyPaths.contains(s):
          key = _lockColor(i);
        case 'M046':
          if (m.keyPath == s) key = 'loop';
          if (m.path == s) loop = st.ms[i] == 0;
        case 'M036' when m.path == s:
          hungry = true;
        case 'M047' when m.path == s:
          growing = true;
      }
    }
    final color = sim.colorOf(st, s);
    return Snake(
      id: s,
      ref: sn.id,
      body: [for (final c in st.bodies[s]) cellOf(c)],
      dir: dirFromIndex(st.dirs[s]),
      color: SnakeColor.values.asNameMap()[color] ?? SnakeColor.values.byName(sn.color),
      skin: sn.caterpillar ? SnakeSkin.caterpillar : SnakeSkin.snake,
      marks: SnakeMarks(
        layer: sn.layer,
        reverse: sn.reverse,
        hydra: sn.hydra,
        wideSide: sn.wideSide >= 0 ? dirFromIndex(sn.wideSide) : null,
        lock: sim.lockReason(st, s),
        frozen: frozen,
        sleeping: sleeping,
        hidden: hidden,
        ghost: sim.isGhost(st, s),
        cageColor: cage,
        hatch: hatch,
        restless: restless,
        keyColor: key,
        hungry: hungry,
        growing: growing,
        group: group,
        child: sn.isChild,
        chameleon: sim.r.chameleonOf.containsKey(s),
        loop: loop,
      ),
    );
  }

  /// Bamboo Cage and Knot Cage carry no colour in the file; the cage takes
  /// its key snake's colour so the badge and the lock match.
  String _lockColor(int i) {
    final m = lv.mechs[i];
    if (m.color.isNotEmpty) return m.color;
    final k = m.keyPath >= 0 ? m.keyPath : (m.keyPaths.isNotEmpty ? m.keyPaths.first : -1);
    return k >= 0 ? lv.snakes[k].color : 'yellow';
  }

  Obstacle? _obstacleView(fr.St st, int i) {
    final m = lv.mechs[i];
    final hammerable = sim.canHammerMech(st, i, cell: st.mlist[i].isEmpty ? -1 : st.mlist[i].first);
    List<Cell> cells([List<int>? from]) => [for (final c in from ?? m.cells) cellOf(c)];
    Obstacle base({
      List<Cell>? at,
      int value = 0,
      bool open = false,
      String color = '',
      List<Cell> links = const [],
      List<bool> done = const [],
      bool interactive = false,
    }) => Obstacle(
      id: i,
      type: m.type,
      cells: at ?? cells(),
      ref: m.id,
      value: value,
      open: open,
      color: color.isEmpty ? m.color : color,
      arrow: m.arrow >= 0 ? dirFromIndex(m.arrow) : null,
      orient: m.orient,
      side: m.side >= 0 ? dirFromIndex(m.side) : null,
      horizontal: m.axis == 0,
      links: links,
      done: done,
      hammerable: hammerable,
      interactive: interactive,
    );
    switch (m.type) {
      // Snake-only mechanics are drawn on the snake (badges), not the board.
      case 'M003' || 'M011' || 'M012' || 'M017' || 'M021' || 'M022' || 'M023' || 'M024' ||
          'M028' || 'M032' || 'M039' || 'M040' || 'M041' || 'M047' || 'M048':
        return null;
      case 'M004':
        return base(open: st.ms[i] == 1, color: _lockColor(i));
      case 'M043':
        return base(
          open: st.ms[i] == 0,
          value: _bits(st.ms[i]),
          color: _lockColor(i),
        );
      case 'M007' || 'M031':
        return base(value: st.ms[i], open: m.type == 'M007' ? st.ms[i] == 0 : st.ms[i] > 0);
      case 'M009':
        return base(
          links: cells(m.gates),
          done: [for (var g = 0; g < m.gates.length; g++) (st.ms[i] >> g) & 1 == 1],
          interactive: true,
        );
      case 'M010':
        return st.ms[i] == 0 ? base() : null;
      case 'M013':
        return st.status[m.path] == 1
            ? base(interactive: !m.gearLinked, at: [cellOf(st.bodies[m.path].first)])
            : null;
      case 'M016':
        return st.ms[i] > 0 ? base(value: st.ms[i]) : null;
      case 'M018':
        return base(open: st.ms[i] == 1, interactive: true);
      case 'M019':
        return base(links: cells(m.gates), open: sim.plateCovered(st, m));
      case 'M025':
        return base(at: [cellOf(sim.beetleCell(st, i))], links: cells(), value: st.ms[i]);
      case 'M026':
        return base(done: [for (var k = 0; k < m.cells.length; k++) (st.ms[i] >> k) & 1 == 1]);
      case 'M027':
        return st.mlist[i].isEmpty ? null : base(at: cells(st.mlist[i]), value: m.n - st.ms2[i]);
      case 'M033':
        return st.ms[i] == 0 && st.status[m.path] == 1
            ? base(at: [for (final c in st.bodies[m.path]) cellOf(c)])
            : null;
      case 'M034':
        return base(interactive: true);
      case 'M035':
        return st.ms[i] == 2 ? null : base(open: st.ms[i] == 1);
      case 'M036':
        return base(done: [for (var k = 0; k < m.cells.length; k++) (st.ms[i] >> k) & 1 == 1]);
      case 'M042':
        return base(open: st.ms[i] == 1);
      case 'M045':
        return base(
          interactive: true,
          links: [
            for (final t in m.turntables)
              if (st.status[lv.mechs[t].path] == 1) cellOf(st.bodies[lv.mechs[t].path].first),
          ],
        );
      case 'M046':
        return null;
      case 'M049':
        return st.ms[i] > 0 ? base(value: st.ms[i]) : null;
      default:
        return base();
    }
  }

  static int _bits(int v) {
    var n = 0;
    for (var x = v; x > 0; x >>= 1) {
      n += x & 1;
    }
    return n;
  }

  // ---- lanes ---------------------------------------------------------------

  /// Converts an engine lane for drawing. [blocked] lanes end on the cell
  /// that stopped them.
  LaneTrace lane(fr.St st, int s, fr.Trace t, {bool tail = false}) {
    final sn = lv.snakes[s];
    final fromTail = sn.reverse || tail;
    final cells = [for (final c in t.lane) cellOf(c)];
    final exitDir = t.endDir >= 0 ? dirFromIndex(t.endDir) : null;
    switch (t.kind) {
      case 0:
        return LaneTrace(cells: cells, blocker: null, exitDir: exitDir, fromTail: fromTail);
      case 2: // stops in Sticky Swamp Mud
        return LaneTrace(cells: cells, blocker: null, fromTail: fromTail);
      case 4:
        return LaneTrace(
          cells: cells.isEmpty ? cells : cells.sublist(0, cells.length - 1),
          blocker: null,
          unknown: true,
          fromTail: fromTail,
        );
    }
    // Blocked at the board edge (hedge, closed gap, wrong-colour arch).
    if (t.edgeMech >= 0 && t.endDir >= 0) {
      final e = cellOf(t.endCell);
      final d = dirFromIndex(t.endDir);
      return LaneTrace(cells: cells, blocker: e.step(d), fromTail: fromTail, exitDir: d);
    }
    if (t.jumped.isNotEmpty && t.blocker >= 0) {
      return LaneTrace(cells: cells, blocker: cellOf(t.jumped.last), fromTail: fromTail);
    }
    if (cells.isEmpty) {
      final (c, d) = sim.laneStart(st, s, tail: tail);
      return LaneTrace(cells: const [], blocker: cellOf(c).step(dirFromIndex(d)), fromTail: fromTail);
    }
    return LaneTrace(
      cells: cells.sublist(0, cells.length - 1),
      blocker: cells.last,
      fromTail: fromTail,
    );
  }

  /// Whether a tap on body cell [at] means the Hydra's far head.
  bool hydraTail(fr.St st, int s, Cell? at) {
    if (!lv.snakes[s].hydra || at == null) return false;
    final b = st.bodies[s];
    final idx = b.indexOf(lv.cell(at.x, at.y));
    if (idx < 0) return false;
    // Exact centre of an odd snake goes out of body[0].
    return idx * 2 > b.length - 1;
  }
}
