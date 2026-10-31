// ignore_for_file: avoid_print
// Level generator for Phase 1 blocks. Reverse construction places snakes so
// a plain exit order always exists; mechanics are then placed around that
// order, and the solver in core.dart finds the real winning sequence.
import 'dart:math';

import 'package:puzzle_core/full_rules.dart';
import 'io.dart';

class Spec {
  const Spec(this.minG, this.maxG, this.minS, this.maxS, this.minD, this.maxD);
  final int minG, maxG, minS, maxS, minD, maxD;
}

const specs = <Spec>[
  Spec(4, 6, 2, 8, 1, 8), Spec(6, 7, 6, 10, 6, 12), Spec(6, 7, 6, 10, 6, 12),
  Spec(6, 7, 6, 10, 6, 12), Spec(6, 8, 8, 12, 9, 15), Spec(6, 8, 8, 12, 9, 15),
  Spec(6, 8, 8, 12, 9, 15), Spec(7, 8, 10, 14, 12, 18), Spec(7, 8, 10, 14, 12, 18),
  Spec(7, 8, 10, 14, 12, 18), Spec(7, 8, 10, 14, 14, 20), Spec(7, 8, 10, 14, 14, 20),
  Spec(7, 8, 10, 14, 14, 20), Spec(7, 9, 12, 16, 17, 23), Spec(7, 9, 12, 16, 17, 23),
  Spec(7, 9, 12, 16, 17, 23), Spec(7, 9, 12, 16, 17, 23), Spec(8, 9, 14, 18, 20, 26),
  Spec(8, 9, 14, 18, 20, 26), Spec(8, 9, 14, 18, 20, 26), Spec(8, 9, 14, 18, 22, 29),
  Spec(8, 9, 14, 18, 22, 29), Spec(8, 9, 14, 18, 22, 29), Spec(8, 10, 16, 20, 26, 32),
  Spec(8, 10, 16, 20, 26, 32), Spec(8, 10, 16, 20, 26, 32), Spec(8, 10, 16, 20, 26, 32),
  Spec(9, 10, 18, 22, 29, 36), Spec(9, 10, 18, 22, 29, 36), Spec(9, 10, 18, 22, 29, 36),
  Spec(9, 9, 18, 22, 30, 37), Spec(9, 9, 18, 22, 30, 37), Spec(9, 9, 18, 22, 30, 37),
  Spec(9, 10, 20, 24, 34, 40), Spec(9, 10, 20, 24, 34, 40), Spec(9, 10, 20, 24, 34, 40),
  Spec(9, 10, 20, 24, 34, 40), Spec(10, 10, 22, 26, 37, 44), Spec(10, 10, 22, 26, 37, 44),
  Spec(10, 10, 22, 26, 37, 44), Spec(10, 10, 22, 26, 38, 45), Spec(10, 10, 22, 26, 38, 45),
  Spec(10, 10, 22, 26, 38, 45), Spec(10, 11, 24, 28, 42, 48), Spec(10, 11, 24, 28, 42, 48),
  Spec(10, 11, 24, 28, 42, 48), Spec(10, 11, 24, 28, 42, 48), Spec(11, 11, 26, 30, 45, 52),
  Spec(11, 11, 26, 30, 45, 52), Spec(11, 11, 26, 30, 45, 52),
];

String slotOf(int n) {
  if (n == 500) return 'finale';
  return switch (n % 10) {
    1 => 'intro',
    2 || 3 || 4 => 'practice',
    5 => 'breather',
    6 || 7 || 8 => 'ramp',
    9 => 'hard',
    _ => 'milestone',
  };
}

String tagOf(String slot) => switch (slot) {
      'breather' => 'easy',
      'hard' => 'hard',
      'finale' => 'finale',
      _ => 'normal',
    };

String typeName(int k) => 'M${k.toString().padLeft(3, '0')}';
int blockOf(int n) => (n - 1) ~/ 10 + 1;

(int, int) obstacleRange(int n) => n <= 100
    ? (1, 4)
    : n <= 200
        ? (3, 6)
        : n <= 300
            ? (4, 8)
            : n <= 400
                ? (5, 9)
                : (6, 10);

/// Target D window per slot (inside the checker band).
(double, double) dWindow(int n) {
  final s = specs[blockOf(n) - 1];
  final lo = s.minD.toDouble(), hi = s.maxD.toDouble(), w = hi - lo;
  final slot = slotOf(n);
  if (n == 100) return (14.5, 15.5);
  if (n == 101) return (13.5, 15.0);
  if (n == 500) return (60.5, 63.5);
  final (a, b) = switch (slot) {
    'intro' => (lo - 1.5, lo + 0.3 * w),
    'breather' => (lo - 1.5, lo + 0.3 * w),
    'hard' => (hi - 0.5, hi * 1.1),
    _ => switch (n % 10) {
        2 => (lo - 0.5, lo + 0.5 * w),
        3 => (lo + 0.1 * w, lo + 0.55 * w),
        4 => (lo + 0.3 * w, lo + 0.7 * w),
        6 => (lo + 0.3 * w, lo + 0.7 * w),
        7 => (lo + 0.5 * w, lo + 0.85 * w),
        8 => (lo + 0.65 * w, hi),
        _ => (lo + 0.3 * w, lo + 0.7 * w),
      },
  };
  return (max(a, lo - 2.5), min(b, (slot == 'hard' ? hi * 1.1 : hi) + 2.5));
}

/// Mechanics never picked as extras (they reshape the whole board).
const notExtra = {'M024', 'M032', 'M039', 'M045', 'M049'};
const redirectTypes = {'M008', 'M014', 'M018', 'M037', 'M038', 'M044', 'M020'};
const edgeTypes = {'M029', 'M030', 'M031'};
const groupTypes = {'M011', 'M039', 'M048'};

bool compatible(List<String> chosen, String t) {
  final s = chosen.toSet();
  bool has(String x) => s.contains(x);
  int count(String x) => chosen.where((y) => y == x).length;
  if (t == 'M010' && has('M040') || t == 'M040' && has('M010')) return false;
  if (t == 'M024' && s.any(redirectTypes.contains)) return false;
  if (redirectTypes.contains(t) && has('M024')) return false;
  if (t == 'M036' && (has('M036') || has('M037'))) return false;
  if (t == 'M037' && has('M036')) return false;
  if ((t == 'M027' || t == 'M047') && s.any(edgeTypes.contains)) return false;
  if (edgeTypes.contains(t) && (has('M027') || has('M047'))) return false;
  if (t == 'M041' && (has('M041') || has('M048'))) return false;
  if (t == 'M048' && has('M041')) return false;
  if (count(t) >= (t == 'M001' || t == 'M002' ? 3 : 2)) return false;
  if (t == 'M017' && count('M017') >= 2) return false;
  if (t == 'M012' && count('M012') >= 3) return false;
  if (t == 'M021' && count('M021') >= 2) return false;
  if (t == 'M035' && count('M035') >= 2) return false;
  if (t == 'M020' && count('M020') >= 2) return false;
  if (const {'M034', 'M008', 'M044', 'M046', 'M025', 'M027', 'M028', 'M040', 'M010', 'M018'}.contains(t) &&
      has(t)) {
    return false;
  }
  return true;
}

class GenFail implements Exception {
  GenFail(this.why);
  final String why;
  @override
  String toString() => why;
}

class Result {
  Result(this.json, this.d, this.c, this.solution);
  final Map<String, dynamic> json;
  final double d;
  final int c;
  final List<String> solution;
}

class Gen {
  Gen(this.n, this.rng, this.types, this.w, this.p, this.targetC, this.maxLen);
  final int n;
  final Random rng;
  final List<String> types; // instances, new mechanic first
  final int w;
  final int p;
  final int targetC;
  final int maxLen;

  late Level lv;
  late Sim csim;
  final placed = <int>[];
  final lanes = <int, Set<int>>{};
  final traces = <int, Trace>{};
  final e = <int, int>{};
  final noBody = <int>{};
  final noBodyLater = <int>{};
  final mechCells = <int>{};
  final fixedColor = <int, String>{};
  final reserved = <String>{};
  final twigCrossed = <int>{};
  final stumpInfo = <int, (Mech, int)>{}; // snake -> (stump, rotations needed)
  int forkFlipAt = -1;
  List<String> _lv2types = [];
  (List<int>, int)? stumpPlan; // final pose [head, tail, dir] and turns needed
  final lilyPending = <(int, int)>[];
  final gearPending = <(int, int)>[];
  bool chameleonGate = false;
  int mongoose = -1;
  int mongooseLanesUntil = 0;
  final related = <String>[]; // ids the intro hand should point at
  final extraTapsExpected = <String>[];
  List<int> exitOrder = [];
  Map<int, int> idx = {};
  Set<int> fixedCells = {}; // finale: cells chosen by the designer

  int rnd(int a, int b) => a + rng.nextInt(b - a + 1);
  T pick<T>(List<T> l) => l[rng.nextInt(l.length)];
  bool chance(double p) => rng.nextDouble() < p;

  bool interior(int c) {
    final x = lv.cx(c), y = lv.cy(c);
    return x > 0 && y > 0 && x < lv.w - 1 && y < lv.h - 1;
  }

  List<int> get allCells => [for (var c = 0; c < lv.cellCount; c++) c];

  Mech addMech(String type, List<int> cells, [Map<String, dynamic>? params]) {
    final m = Mech('o${lv.mechs.length + 1}', type, cells, params);
    lv.mechs.add(m);
    if (!edgeTypes.contains(type)) mechCells.addAll(cells);
    return m;
  }

  // ---------------------------------------------------------------------
  Result? run({void Function(Gen g)? preStatic}) {
    lv = Level(w, w);
    if (types.contains('M032')) lv.layers = 2;
    preStatic?.call(this);
    final staticTypes = types.where(_isStatic).toList();
    if (types.contains('M041') && staticTypes.contains('M005')) {
      staticTypes.remove('M005');
      chameleonGate = true;
    }
    for (final t in staticTypes) {
      if (preStatic != null && (t == 'M049' || t == 'M020')) continue;
      if (!_placeStatic(t)) throw GenFail('static $t');
    }
    csim = Sim(lv)..ignoreDynamic = true;
    _construct();
    exitOrder = placed.reversed.toList();
    idx = {for (var i = 0; i < exitOrder.length; i++) exitOrder[i]: i};
    final later = types.where((t) => !_isStatic(t) || t == 'M049').toList();
    for (final t in later) {
      if (!_placeDynamic(t)) throw GenFail('dynamic $t');
    }
    _finishSnakes();
    return _verify();
  }

  bool _isStatic(String t) => const {
        'M001', 'M002', 'M005', 'M006', 'M008', 'M014', 'M015', 'M018', 'M020', 'M025',
        'M029', 'M030', 'M034', 'M038', 'M042', 'M044', 'M049', 'M040', 'M032',
      }.contains(t);

  // ---- static placement ------------------------------------------------

  int? _freeCell({bool inner = true}) {
    final opts = [
      for (final c in allCells)
        if (!mechCells.contains(c) && (!inner || interior(c))) c
    ];
    if (opts.isEmpty) return null;
    return pick(opts);
  }

  int _step(int c, int d, int k) {
    var x = c;
    for (var i = 0; i < k; i++) {
      x = lv.step(x, d);
      if (x < 0) return -1;
    }
    return x;
  }

  bool _placeStatic(String t) {
    final W = lv.w;
    switch (t) {
      case 'M001':
        final c = _freeCell();
        if (c == null) return false;
        addMech(t, [c], {'variant': rnd(1, 3)});
        noBody.add(c);
      case 'M002':
        for (var tries = 0; tries < 50; tries++) {
          final len = rnd(2, min(4, W - 3));
          final horiz = chance(0.5);
          final c0 = _freeCell();
          if (c0 == null) return false;
          final cells = [for (var i = 0; i < len; i++) _step(c0, horiz ? 1 : 2, i)];
          if (cells.any((c) => c < 0 || mechCells.contains(c) || !interior(c))) continue;
          addMech(t, cells, {'orient': horiz ? 'H' : 'V'});
          noBody.addAll(cells);
          return true;
        }
        return false;
      case 'M005':
        final c = _freeCell();
        if (c == null) return false;
        final usedGateColors = {for (final m in lv.mechs) if (m.type == 'M005') m.color};
        final col = usedGateColors.length >= 2 ? pick(usedGateColors.toList()) : pick(colors8);
        addMech(t, [c], {'color': col}).color = col;
        noBody.add(c);
      case 'M006':
        final c = _freeCell();
        if (c == null) return false;
        final a = rng.nextInt(4);
        addMech(t, [c], {'arrow': dirNames[a]}).arrow = a;
        noBody.add(c);
      case 'M008' || 'M044':
        for (var tries = 0; tries < 50; tries++) {
          final a = _freeCell(inner: false);
          final b = _freeCell(inner: false);
          if (a == null || b == null || a == b) continue;
          if ((lv.cx(a) - lv.cx(b)).abs() + (lv.cy(a) - lv.cy(b)).abs() < W ~/ 2) continue;
          if (t == 'M008') {
            addMech(t, [a, b], {'pair': pick(['carrot', 'daisy', 'acorn'])});
          } else {
            final rs = [pick(['CW', 'CCW']), pick(['CW', 'CCW'])];
            addMech(t, [a, b], {'pair': 'spiral', 'rot': rs}).rot = [for (final x in rs) x == 'CW' ? 1 : -1];
          }
          noBody.addAll([a, b]);
          return true;
        }
        return false;
      case 'M014':
        final c = _freeCell();
        if (c == null) return false;
        final o = chance(0.5) ? '/' : '\\';
        addMech(t, [c], {'orient': o}).orient = o;
        noBody.add(c);
      case 'M015' || 'M042':
        final c = _freeCell();
        if (c == null) return false;
        final ax = rng.nextInt(2);
        addMech(t, [c], {'axis': ax == 0 ? 'H' : 'V'}).axis = ax;
        if (t == 'M042') noBody.add(c);
      case 'M018':
        final c = _freeCell();
        if (c == null) return false;
        final s = rng.nextInt(2);
        addMech(t, [c], {'state': s == 0 ? 'L' : 'R'}).state = s;
        noBody.add(c);
        forkFlipAt = (slotOf(n) == 'intro' || chance(0.75)) ? rnd(p ~/ 3, (2 * p) ~/ 3) : -1;
        related.add(lv.mechs.last.id);
      case 'M020':
        final c = _freeCell();
        if (c == null) return false;
        addMech(t, [c], {});
        noBody.add(c);
      case 'M025':
        for (var tries = 0; tries < 50; tries++) {
          final bw = rnd(2, 3), bh = bw == 3 ? 2 : rnd(2, 3);
          final x0 = rnd(0, W - bw), y0 = rnd(0, lv.h - bh);
          final ring = _ring(x0, y0, bw, bh);
          if (ring.any(mechCells.contains)) continue;
          final st = rng.nextInt(ring.length);
          addMech(t, ring, {'start': st}).start = st;
          noBody.addAll(ring);
          return true;
        }
        return false;
      case 'M029' || 'M030':
        for (var tries = 0; tries < 50; tries++) {
          final side = rng.nextInt(4);
          final len = t == 'M029' ? rnd(2, max(2, W - 3)) : rnd(1, 2);
          final start = rnd(0, W - len);
          final cells = [for (var i = 0; i < len; i++) _edgeCell(side, start + i)];
          final usedEdges = {
            for (final m in lv.mechs)
              if (edgeTypes.contains(m.type)) for (final c in m.cells) c * 4 + m.side
          };
          if (cells.any((c) => usedEdges.contains(c * 4 + side))) continue;
          if (t == 'M029') {
            addMech(t, cells, {'side': dirNames[side]}).side = side;
          } else {
            final col = pick(colors8);
            addMech(t, cells, {'side': dirNames[side], 'color': col})
              ..side = side
              ..color = col;
          }
          return true;
        }
        return false;
      case 'M034':
        for (var tries = 0; tries < 50; tries++) {
          final x0 = rnd(1, W - 3), y0 = rnd(1, lv.h - 3);
          final cells = [lv.cell(x0, y0), lv.cell(x0 + 1, y0), lv.cell(x0, y0 + 1), lv.cell(x0 + 1, y0 + 1)];
          if (cells.any(mechCells.contains)) continue;
          // start pose faces a rock, so the stump must turn at least once
          final tl = cells[0], tr = cells[1], bl = cells[2], br = cells[3];
          final cycles = [
            [[tl, tr, 3], [tr, br, 0], [br, bl, 1], [bl, tl, 2]],
            [[tr, tl, 1], [br, tr, 2], [bl, br, 3], [tl, bl, 0]],
          ];
          final cyc = pick(cycles);
          final i0 = rng.nextInt(4), r = rnd(1, 3);
          final start = cyc[i0], end = cyc[(i0 + r) % 4];
          final rock = lv.step(start[0], start[2]);
          if (rock < 0 || mechCells.contains(rock) || cells.contains(rock)) continue;
          addMech(t, cells, {});
          noBody.addAll(cells);
          addMech('M001', [rock], {'variant': rnd(1, 3)});
          noBody.add(rock);
          stumpPlan = (end, r);
          return true;
        }
        return false;
      case 'M038':
        for (var tries = 0; tries < 60; tries++) {
          final c = _freeCell();
          if (c == null) return false;
          final d = rng.nextInt(4);
          final r = lv.step(c, d);
          if (r < 0 || mechCells.contains(r) || !interior(r)) continue;
          if (lv.step(r, d) < 0) continue;
          addMech(t, [c], {});
          noBody.add(c);
          // the pad's jump target: a rock right behind it (counts as M001)
          addMech('M001', [r], {'variant': rnd(1, 3)});
          noBody.add(r);
          return true;
        }
        return false;
      case 'M040':
        addMech(t, [], {'radius': 2});
      case 'M032':
        addMech(t, [], {'obstacleLayer': 'both'});
      case 'M049':
        for (var tries = 0; tries < 50; tries++) {
          final x0 = rnd(W ~/ 2 - 2, W ~/ 2), y0 = rnd(W ~/ 2 - 2, W ~/ 2);
          final cells = [lv.cell(x0, y0), lv.cell(x0 + 1, y0), lv.cell(x0, y0 + 1), lv.cell(x0 + 1, y0 + 1)];
          if (cells.any(mechCells.contains)) continue;
          addMech(t, cells, {});
          noBody.addAll(cells);
          mongoose = lv.mechs.length - 1;
          mongooseLanesUntil = max(2, p ~/ 3);
          return true;
        }
        return false;
      default:
        throw GenFail('no static placer for $t');
    }
    return true;
  }

  List<int> _ring(int x0, int y0, int bw, int bh) {
    final out = <int>[];
    for (var x = x0; x < x0 + bw; x++) {
      out.add(lv.cell(x, y0));
    }
    for (var y = y0 + 1; y < y0 + bh; y++) {
      out.add(lv.cell(x0 + bw - 1, y));
    }
    for (var x = x0 + bw - 2; x >= x0; x--) {
      out.add(lv.cell(x, y0 + bh - 1));
    }
    for (var y = y0 + bh - 2; y > y0; y--) {
      out.add(lv.cell(x0, y));
    }
    return out;
  }

  int _edgeCell(int side, int i) => switch (side) {
        0 => lv.cell(i, 0),
        1 => lv.cell(lv.w - 1, i),
        2 => lv.cell(i, lv.h - 1),
        _ => lv.cell(0, i),
      };

  // ---- construction ----------------------------------------------------

  St _cst({bool mongooseOpen = false, int forkState = -1}) {
    final st = csim.initial();
    for (final i in csim.r.of('M018')) {
      if (forkState >= 0) st.ms[i] = forkState;
    }
    if (mongoose >= 0) st.ms[mongoose] = mongooseOpen ? 0 : 1;
    return st;
  }

  int _forkStateNow() {
    final forks = csim.r.of('M018');
    if (forks.isEmpty) return -1;
    final base = lv.mechs[forks.first].state; // state seen by early exits
    // placement runs backwards: first placed = last to exit
    final flipped = forkFlipAt >= 0 && placed.length < forkFlipAt;
    return flipped ? 1 - base : base;
  }

  bool _cellOk(int c, int layer) {
    if (c < 0) return false;
    if (noBody.contains(c)) return false;
    if (layer == 0 && noBodyLater.contains(c)) return false;
    for (final s in placed) {
      final sn = lv.snakes[s];
      if (sn.layer != layer) continue;
      if (sn.body.contains(c)) return false;
      if (sn.wideSide >= 0 && sn.body.any((b) => lv.step(b, sn.wideSide) == c)) return false;
    }
    return true;
  }

  int _lenDraw() {
    final cells = lv.cellCount - noBody.length;
    final avg = (cells * 0.58 / p).clamp(2.2, maxLen.toDouble());
    final a = rng.nextDouble() * 2 - 1;
    final v = (avg + a * 1.4).round();
    return v.clamp(2, maxLen);
  }

  Snake? _randomSnake(int len, {int layer = 0, Set<int>? seeds}) {
    final free = [for (final c in allCells) if (_cellOk(c, layer)) c];
    if (free.isEmpty) return null;
    final seeded = seeds == null ? const <int>[] : [for (final c in seeds) if (_cellOk(c, layer)) c];
    final head = seeded.isNotEmpty ? pick(seeded) : pick(free);
    final body = [head];
    var lastDir = -1;
    for (var i = 1; i < len; i++) {
      final opts = <int>[];
      for (var d = 0; d < 4; d++) {
        final nb = lv.step(body.last, d);
        if (nb >= 0 && !body.contains(nb) && _cellOk(nb, layer)) opts.add(d);
      }
      if (opts.isEmpty) break;
      final d = (lastDir >= 0 && opts.contains(lastDir) && chance(0.45)) ? lastDir : pick(opts);
      body.add(lv.step(body.last, d));
      lastDir = d;
    }
    if (body.length < 2) return null;
    final dirs = [for (var d = 0; d < 4; d++) if (lv.step(head, d) != body[1]) d];
    return Snake('?', '*', body, pick(dirs), layer: layer);
  }

  bool _bridgeOk(Snake s) {
    for (var i = 0; i < s.body.length; i++) {
      final mi = csim.r.cellMech[s.body[i]];
      if (mi < 0) continue;
      final m = lv.mechs[mi];
      if (m.type == 'M034' && s.id == 'stump') continue;
      if (m.type != 'M015') return false;
      if (i == 0 || i == s.body.length - 1) return false;
      final a = lv.dirFromTo(s.body[i - 1], s.body[i]), b = lv.dirFromTo(s.body[i], s.body[i + 1]);
      if (a != b) return false;
      if ((a % 2 == 1) != (m.axis == 0)) return false; // body runs along the axis
    }
    return true;
  }

  /// Returns (chain end height, trace) or null if the candidate can't go here.
  (int, Trace)? _evaluate(List<Snake> cands) {
    final base = lv.snakes.length;
    for (final s in cands) {
      final cells = [...s.body, if (s.wideSide >= 0) for (final b in s.body) lv.step(b, s.wideSide)];
      if (cells.any((c) => c < 0)) return null;
      final stump = s.id == 'stump';
      if (!cells.every((c) => _cellOk(c, s.layer) || (stump && noBody.contains(c)))) return null;
      if (!_bridgeOk(s)) return null;
    }
    if (cands.length == 2 && cands[0].body.any(cands[1].body.contains)) return null;
    lv.snakes.addAll(cands);
    try {
      final allowMongoose = mongoose >= 0 && placed.length < mongooseLanesUntil;
      final st = _cst(mongooseOpen: allowMongoose, forkState: _forkStateNow());
      final laneCells = <int>{};
      Trace? first;
      for (var k = 0; k < cands.length; k++) {
        final t = csim.laneOf(st, base + k);
        if (t.kind != 0) return null;
        if (t.lane.any(laneCells.contains)) return null; // group lanes must not cross
        laneCells.addAll(t.lane);
        final need = {
          for (final u in t.used)
            if (lv.mechs[u].type == 'M005' || lv.mechs[u].type == 'M030') lv.mechs[u].color
        };
        if (need.length > 1) return null;
        if (need.isNotEmpty) {
          if (cands.length > 1) return null;
          cands[k].color = need.first;
        } else if (cands.length == 1) {
          cands[k].color = '*';
        }
        for (final u in t.used) {
          if (lv.mechs[u].type == 'M042' && twigCrossed.contains(u)) return null;
        }
        first ??= t;
        traces[base + k] = t;
      }
      var eS = 0;
      final myCells = <int>{
        for (final s in cands) ...s.body,
        for (final s in cands)
          if (s.wideSide >= 0) for (final b in s.body) lv.step(b, s.wideSide)
      };
      for (final q in placed) {
        if (lv.snakes[q].layer != cands.first.layer) continue;
        if (!lanes[q]!.any(myCells.contains)) continue;
        final bl = <int>{};
        final (c, d) = csim.laneStart(st, q);
        csim.trace(st, q, c, d, transparent: true, blockers: bl);
        final sq = lv.snakes[q];
        if (sq.wideSide >= 0) csim.trace(st, q, lv.step(c, sq.wideSide), d, transparent: true, blockers: bl);
        for (var k = 0; k < cands.length; k++) {
          if (bl.contains(base + k)) eS = max(eS, e[q]! + 1);
        }
      }
      return (eS, first!);
    } finally {
      lv.snakes.removeRange(base, lv.snakes.length);
    }
  }

  void _commit(List<Snake> cands, int eS) {
    for (final s in cands) {
      final i = lv.snakes.length;
      lv.snakes.add(s);
      placed.add(i);
      final t = traces[i]!;
      lanes[i] = {...t.lane, ...t.jumped};
      e[i] = eS;
      if (s.color != '*') fixedColor[i] = s.color;
      for (final u in t.used) {
        if (lv.mechs[u].type == 'M042') twigCrossed.add(u);
      }
      if (s.layer == 1) noBodyLater.addAll(s.body);
    }
  }

  List<String> _specialQueue() {
    final q = <String>[];
    for (final t in types) {
      switch (t) {
        case 'M022':
          q.add('reverse');
        case 'M023':
          q.add('hydra');
        case 'M024':
          q.add('wide');
        case 'M039':
          q.add('pond');
        case 'M046':
          q.add('loop');
        case 'M034':
          q.add('stump');
        case 'M013':
          q.add('lily');
        case 'M045':
          const k = 2;
          for (var i = 0; i < k; i++) {
            q.add('gearlily');
          }
      }
    }
    if (types.contains('M032')) {
      final k = rnd(2, 4);
      for (var i = 0; i < k; i++) {
        q.add('canopy');
      }
    }
    return q;
  }

  final usedNew = <int>{};
  late final Set<int> newIdx = {
    for (var i = 0; i < lv.mechs.length; i++)
      if (lv.mechs[i].type == (n == 500 ? 'M049' : typeName(blockOf(n) - 1))) i
  };

  void _construct() {
    final special = _specialQueue();
    final when = <int, String>{};
    final pool = [for (var i = 1; i < p - 1; i++) i]..shuffle(rng);
    for (final s in special) {
      if (pool.isEmpty) throw GenFail('no slot for $s');
      var at = pool.removeLast();
      if (s == 'loop' || s == 'stump') at = rnd(0, max(0, p ~/ 2)); // leaves late
      if (s == 'canopy') at = rnd(p ~/ 3, p - 1);
      if (s == 'lily' || s == 'gearlily') at = rnd(p ~/ 2, p - 1);
      while (when.containsKey(at)) {
        at = (at + 1) % p;
      }
      when[at] = s;
    }
    var stepNo = 0;
    var guard = 0;
    while (lv.snakes.length < p) {
      if (++guard > p * 5) throw GenFail('construct stuck at ${lv.snakes.length}/$p');
      final kind = when[stepNo] ?? 'plain';
      if (kind == 'pond' && lv.snakes.length + 2 > p) {
        stepNo++;
        continue;
      }
      final tries = kind == 'plain' ? 14 : 80;
      List<Snake>? best;
      var bestScore = -1e9;
      final curC = e.values.fold(0, max);
      for (var t = 0; t < tries; t++) {
        final cands = _makeCandidate(kind);
        if (cands == null) continue;
        final ev = _evaluate(cands);
        if (ev == null) continue;
        final eS = ev.$1;
        if (kind == 'lily' || kind == 'gearlily') {
          final r = _lilyTurns(cands.first, kind == 'gearlily',
              needStuck: kind == 'lily' || gearPending.isEmpty);
          if (r < 0) continue;
          cands.first.id = 'lily$r';
        }
        final usesNew = ev.$2.used.any((u) => newIdx.contains(u) && !usedNew.contains(u));
        double score;
        if (curC < targetC) {
          score = eS.toDouble() * 3 + rng.nextDouble();
        } else {
          score = (eS <= targetC ? 2.0 : -5.0 * (eS - targetC)) + (eS > 0 ? 1 : 0) + rng.nextDouble();
        }
        if (usesNew) score += 4;
        if (score > bestScore) {
          bestScore = score;
          best = cands;
        }
      }
      if (best == null) {
        if (kind != 'plain') throw GenFail('could not place $kind');
        continue;
      }
      final ev = _evaluate(best)!; // refresh traces for the chosen one
      _commit(best, ev.$1);
      usedNew.addAll(ev.$2.used.where(newIdx.contains));
      if (kind == 'lily' || kind == 'gearlily') {
        final s = lv.snakes.length - 1;
        final r = int.parse(lv.snakes[s].id.substring(4));
        lv.snakes[s].id = '?';
        (kind == 'lily' ? lilyPending : gearPending).add((s, r));
      }
      if (kind == 'stump') {
        stumpInfo[lv.snakes.length - 1] = (lv.mechs.firstWhere((m) => m.type == 'M034'), stumpPlan!.$2);
      }
      stepNo++;
    }
  }

  /// Lane cells of the deepest snakes (to grow the chain) or of any snake.
  Set<int>? _seedCells() {
    if (placed.isEmpty) return null;
    final curC = e.values.fold(0, max);
    final want = curC < targetC ? curC : rnd(0, max(0, targetC - 1));
    final deep = [for (final q in placed) if (e[q] == want && lv.snakes[q].layer == 0) q];
    if (deep.isEmpty) return null;
    final q = pick(deep);
    final cells = lanes[q]!.where((c) => !mechCells.contains(c)).toSet();
    return cells.isEmpty ? null : cells;
  }

  Set<int>? _anyLaneCells() {
    final all = {for (final q in placed) if (lv.snakes[q].layer == 0) ...lanes[q]!}..removeAll(mechCells);
    return all.isEmpty ? null : all;
  }

  List<Snake>? _makeCandidate(String kind) {
    switch (kind) {
      case 'plain':
        final s = _randomSnake(_lenDraw(), seeds: chance(0.75) ? _seedCells() : null);
        return s == null ? null : [s];
      case 'canopy':
        final s = _randomSnake(rnd(2, min(4, maxLen)), layer: 1);
        if (s == null) return null;
        // must sit over part of a ground snake, never all of one
        var overlaps = false;
        for (final q in placed) {
          if (lv.snakes[q].layer != 0) continue;
          final b = lv.snakes[q].body;
          final k = b.where(s.body.contains).length;
          if (k == b.length) return null;
          if (k > 0) overlaps = true;
        }
        return overlaps ? [s] : null;
      case 'lily' || 'gearlily':
        final s = _randomSnake(rnd(2, max(2, min(4, maxLen))), seeds: _anyLaneCells());
        if (s == null) return null;
        // body in someone's lane, head outside it
        s.body = s.body.reversed.toList();
        final ds = [for (var d = 0; d < 4; d++) if (lv.step(s.body.first, d) != s.body[1]) d];
        s.dir = pick(ds);
        return [s];
      case 'reverse':
        final s = _randomSnake(rnd(3, max(3, min(5, maxLen))));
        if (s == null || s.body.length < 3) return null;
        s.reverse = true;
        return [s];
      case 'hydra':
        final s = _randomSnake(pick([4, 4, 6]));
        if (s == null || s.body.length.isOdd || s.body.length < 4) return null;
        s.hydra = true;
        return [s];
      case 'wide':
        final len = rnd(2, 3);
        final d = rng.nextInt(4);
        final free = [for (final c in allCells) if (_cellOk(c, 0)) c];
        if (free.isEmpty) return null;
        final body = [pick(free)];
        for (var i = 1; i < len; i++) {
          final nb = lv.step(body.last, opp(d));
          if (nb < 0) return null;
          body.add(nb);
        }
        final s = Snake('?', '*', body, d);
        s.wideSide = chance(0.5) ? cw(d) : ccw(d);
        return [s];
      case 'pond':
        final s = _randomSnake(rnd(2, min(4, maxLen)));
        if (s == null) return null;
        final m = Snake('?', '*', [for (final c in s.body) lv.cell(lv.w - 1 - lv.cx(c), lv.cy(c))],
            s.dir == 1 ? 3 : s.dir == 3 ? 1 : s.dir);
        return [s, m];
      case 'loop':
        final (bw, bh) = pick([(2, 2), (2, 3), (3, 2), (2, 4), (4, 2)]);
        final x0 = rnd(0, lv.w - bw), y0 = rnd(0, lv.h - bh);
        final ring = _ring(x0, y0, bw, bh);
        final hi = rng.nextInt(ring.length);
        final head = ring[hi];
        final outs = [for (var d = 0; d < 4; d++) if (!ring.contains(lv.step(head, d))) d];
        if (outs.isEmpty) return null;
        final body = [for (var i = 0; i < ring.length; i++) ring[(hi + i) % ring.length]];
        return [Snake('loop', '*', body, pick(outs))];
      case 'stump':
        final (o, _) = stumpPlan!;
        return [Snake('stump', '*', [o[0], o[1]], o[2])];
    }
    return null;
  }

  // ---- dynamic placement ----------------------------------------------

  bool _isPlainSnake(int s) {
    final sn = lv.snakes[s];
    if (sn.reverse || sn.hydra || sn.wideSide >= 0 || sn.layer != 0) return false;
    if (stumpInfo.containsKey(s) || sn.id == 'loop') return false;
    for (final m in lv.mechs) {
      if (m.path == s || m.paths.contains(s) || m.keyPath == s || m.keyPaths.contains(s)) return false;
      if (m.order.contains(s)) return false;
    }
    return true;
  }

  bool _isLooseSnake(int s) {
    final sn = lv.snakes[s];
    if (sn.layer != 0 || stumpInfo.containsKey(s) || sn.id == 'loop') return false;
    for (final m in lv.mechs) {
      if (m.path == s || m.paths.contains(s)) return false;
    }
    return true;
  }

  bool _empty(int c) {
    if (c < 0 || mechCells.contains(c)) return false;
    for (final s in lv.snakes) {
      if (s.body.contains(c)) return false;
      if (s.wideSide >= 0 && s.body.any((b) => lv.step(b, s.wideSide) == c)) return false;
    }
    return true;
  }

  List<int> _laneUsers(int c) => [for (final s in placed) if (lanes[s]!.contains(c)) s];

  int _minIdx(Iterable<int> ss) => ss.isEmpty ? 1 << 20 : ss.map((s) => idx[s]!).reduce(min);

  List<int> _shuffled(Iterable<int> it) => it.toList()..shuffle(rng);

  Set<int> get _allLanes => {for (final s in placed) ...lanes[s]!};

  bool _placeDynamic(String t) {
    final snakes = _shuffled(placed);
    switch (t) {
      case 'M003':
        for (final s in snakes) {
          if (!_isPlainSnake(s)) continue;
          final sn = lv.snakes[s];
          final nb = [
            for (final q in placed)
              if (q != s && lv.snakes[q].layer == 0 && lv.snakes[q].body.any((a) => sn.body.any((b) => lv.adj(a, b))))
                q
          ];
          final before = [for (final q in nb) if (idx[q]! < idx[s]!) q];
          if (before.isEmpty) continue;
          final k = min(before.length, n < 200 ? rnd(1, 2) : rnd(1, 3));
          addMech(t, [], {})
            ..path = s
            ..k = k;
          related.addAll([for (final q in before) '#$q']);
          return true;
        }
        return false;
      case 'M004' || 'M043':
        for (final y in snakes) {
          if (lv.snakes[y].layer != 0) continue;
          for (final c in _shuffled(lanes[y]!.where(_empty))) {
            final limit = _minIdx(_laneUsers(c));
            final keys = [
              for (final x in placed)
                if (idx[x]! < limit && _isLooseSnake(x) && !lanes[x]!.contains(c)) x
            ]..shuffle(rng);
            final need = t == 'M004' ? 1 : rnd(2, 3);
            if (keys.length < need) continue;
            final ks = keys.take(need).toList();
            if (t == 'M004') {
              addMech(t, [c], {}).keyPath = ks.first;
            } else {
              addMech(t, [c], {}).keyPaths = ks;
            }
            related.addAll([for (final k in ks) '#$k']);
            return true;
          }
        }
        return false;
      case 'M007':
        for (final y in snakes) {
          if (lv.snakes[y].layer != 0) continue;
          for (final c in _shuffled(lanes[y]!.where(_empty))) {
            final lim = _minIdx(_laneUsers(c));
            if (lim < 2) continue;
            final nn = rnd(2, min(lim, 6));
            addMech(t, [c], {}).n = nn;
            return true;
          }
        }
        return false;
      case 'M009':
        // gate A closed at start on a late lane, gate B open on an early lane
        for (var tries = 0; tries < 40; tries++) {
          final split = rnd(1, exitOrder.length - 1);
          final early = exitOrder.sublist(0, split).toSet(), late = exitOrder.sublist(split).toSet();
          final aOpts = [
            for (final s in late)
              for (final c in lanes[s]!)
                if (_empty(c) && _laneUsers(c).every(late.contains)) c
          ];
          if (aOpts.isEmpty) continue;
          final a = pick(aOpts);
          final bOpts = [
            for (final s in early)
              for (final c in lanes[s]!)
                if (_empty(c) && c != a && _laneUsers(c).every(early.contains)) c
          ];
          final gates = [a];
          var init = 0; // bit set = open
          if (n == 500 && bOpts.isEmpty) continue;
          if (bOpts.isNotEmpty && slotOf(n) != 'intro' && (n == 500 || chance(0.7))) {
            gates.add(pick(bOpts));
            init |= 1 << 1;
          }
          final lanesAll = _allLanes;
          final leverOpts = [for (final c in allCells) if (_empty(c) && !lanesAll.contains(c) && !gates.contains(c)) c];
          if (leverOpts.isEmpty) continue;
          final m = addMech(t, [pick(leverOpts)], {})
            ..gates = gates
            ..gateInit = init;
          mechCells.addAll(gates);
          related.add(m.id);
          return true;
        }
        return false;
      case 'M010':
        // try rectangles of 2–6 cells; the finale wants 3×2 bottom-left
        final rects = <(int, int, int, int)>[];
        for (final (bw, bh) in n == 500 ? [(3, 2)] : [(2, 2), (3, 2), (2, 3), (2, 1), (1, 2)]) {
          for (var y0 = 0; y0 + bh <= lv.h; y0++) {
            for (var x0 = 0; x0 + bw <= lv.w; x0++) {
              if (n == 500 && (x0 > 3 || y0 < lv.h - 5)) continue;
              rects.add((x0, y0, bw, bh));
            }
          }
        }
        rects.shuffle(rng);
        for (final (x0, y0, bw, bh) in rects) {
          final area = [for (var y = y0; y < y0 + bh; y++) for (var x = x0; x < x0 + bw; x++) lv.cell(x, y)];
          if (area.any(mechCells.contains)) continue;
          final hidden = [for (final q in placed) if (lv.snakes[q].body.any(area.contains)) q];
          if (hidden.isEmpty || hidden.any((q) => !_isPlainSnake(q))) continue;
          final touch = [
            for (final q in placed)
              if (!hidden.contains(q) && lv.snakes[q].layer == 0 &&
                  lv.snakes[q].body.any((a) => area.any((b) => lv.adj(a, b))))
                q
          ];
          final hMin = _minIdx(hidden);
          final opener = [for (final q in touch) if (idx[q]! < hMin) q];
          if (opener.isEmpty) continue;
          final firstOpen = _minIdx(opener);
          // nobody may need a lane through the mist before it clears
          final blind = {for (final c in area) ..._laneUsers(c)}.where((q) => idx[q]! <= firstOpen);
          if (blind.isNotEmpty) continue;
          addMech(t, area, {});
          related.addAll([for (final q in opener) '#$q']);
          return true;
        }
        return false;
      case 'M011' || 'M048':
        for (var tries = 0; tries < 60; tries++) {
          final size = t == 'M011' ? 2 : rnd(2, 3);
          if (exitOrder.length < size) return false;
          final i0 = rnd(0, exitOrder.length - size);
          final grp = <int>[exitOrder[i0]];
          for (var j = i0 + 1; j < exitOrder.length && grp.length < size; j++) {
            if (chance(0.6)) grp.add(exitOrder[j]);
          }
          if (grp.length < size || !grp.every(_isPlainSnake)) continue;
          var ok = true;
          for (final a in grp) {
            for (final b in grp) {
              if (a == b) continue;
              if (lv.snakes[b].body.any(lanes[a]!.contains)) ok = false;
              if (lanes[a]!.any(lanes[b]!.contains)) ok = false;
            }
          }
          if (!ok) continue;
          if (t == 'M011') {
            addMech(t, [], {}).paths = grp;
          } else {
            final col = pick(colors8.where((c) => !reserved.contains(c)).toList());
            if (grp.any((g) => fixedColor.containsKey(g) && fixedColor[g] != col)) continue;
            for (final g in grp) {
              fixedColor[g] = col;
            }
            addMech(t, [], {})
              ..paths = grp
              ..color = col;
          }
          related.add('#${grp.first}');
          return true;
        }
        return false;
      case 'M012':
        for (final s in snakes) {
          if (!_isLooseSnake(s)) continue;
          if (lv.mechs.any((m) => groupTypes.contains(m.type) && m.paths.contains(s))) continue;
          addMech(t, [], {}).path = s;
          related.add('#$s');
          return true;
        }
        return false;
      case 'M013':
        if (lilyPending.isEmpty) return false;
        final (s, r) = lilyPending.removeLast();
        final m = _lily(s, r);
        related.insert(0, m.id);
        return true;
      case 'M045':
        final pads = [for (final (s, r) in gearPending) _lily(s, r)];
        gearPending.clear();
        if (pads.length < 2) return false;
        final lanesAll = _allLanes;
        final opts = [for (final c in allCells) if (_empty(c) && !lanesAll.contains(c)) c];
        if (opts.isEmpty) return false;
        final g = addMech(t, [pick(opts)], {})..turntables = [for (final m in pads) lv.mechs.indexOf(m)];
        related.insert(0, g.id);
        return true;
      case 'M016':
        for (final want in n == 500 ? [2, 1] : [1]) {
        for (final y in snakes) {
          if (lv.snakes[y].layer != 0) continue;
          for (final c in _shuffled(lanes[y]!.where(_empty))) {
            final through = _minIdx(_laneUsers(c));
            final passers = [
              for (final q in placed)
                if (idx[q]! < through && !lanes[q]!.contains(c) && lanes[q]!.any((x) => lv.adj(x, c))) q
            ];
            if (passers.length < want) continue;
            final hp = n == 500 ? want : min(passers.length, rnd(1, 3));
            addMech(t, [c], {}).hp = hp;
            return true;
          }
        }
        }
        return false;
      case 'M017':
        for (final s in snakes) {
          if (!_isLooseSnake(s) || idx[s]! > 8) continue;
          final nn = idx[s]! + 1 + rnd(1, 3) + extraTapsExpected.length;
          addMech(t, [], {})
            ..path = s
            ..n = nn;
          related.add('#$s');
          return true;
        }
        return false;
      case 'M019':
        for (final pl in snakes) {
          if (!_isLooseSnake(pl)) continue;
          final ip = idx[pl]!;
          if (ip < 2) continue;
          final plate = pick(lv.snakes[pl].body);
          if (mechCells.contains(plate)) continue;
          final gateOpts = [
            for (final y in placed)
              if (idx[y]! < ip && y != pl)
                for (final c in lanes[y]!)
                  if (_empty(c) && !lanes[pl]!.contains(c) && _laneUsers(c).every((z) => idx[z]! < ip)) c
          ];
          if (gateOpts.isEmpty) continue;
          final g = pick(gateOpts);
          addMech(t, [plate], {}).gates = [g];
          mechCells.add(g);
          related.add('#$pl');
          return true;
        }
        return false;
      case 'M021':
        for (final s in snakes) {
          if (!_isLooseSnake(s)) continue;
          if (lv.mechs.any((m) => groupTypes.contains(m.type) && m.paths.contains(s))) continue;
          addMech(t, [], {}).path = s;
          related.add('#$s');
          return true;
        }
        return false;
      case 'M022' || 'M023' || 'M024':
        for (final s in placed) {
          final sn = lv.snakes[s];
          final f = t == 'M022' ? sn.reverse : t == 'M023' ? sn.hydra : sn.wideSide >= 0;
          if (!f || lv.mechs.any((m) => m.type == t && m.path == s)) continue;
          final m = addMech(t, [], {})..path = s;
          if (t == 'M024') m.params['side'] = sn.wideSide == cw(sn.dir) ? 'R' : 'L';
          related.add('#$s');
          return true;
        }
        return false;
      case 'M026':
        var opts = _shuffled(_allLanes.where(_empty));
        if (n == 500) {
          // gems around the Mongoose King
          final near = opts.where((c) => lv.cx(c) >= 2 && lv.cx(c) <= 8 && lv.cy(c) >= 2 && lv.cy(c) <= 8).toList();
          if (near.length >= 3) opts = near;
        }
        if (opts.isEmpty) return false;
        final k = min(opts.length, n == 500 ? 3 : rnd(2, 4));
        addMech(t, opts.take(k).toList(), {});
        return true;
      case 'M027':
        final lanesAll = _allLanes;
        final opts = [
          for (final c in allCells)
            if (_empty(c) && !lanesAll.contains(c) && lanesAll.any((x) => lv.adj(x, c))) c
        ];
        if (opts.isEmpty) return false;
        addMech(t, [pick(opts)], {}).n = rnd(3, 5);
        return true;
      case 'M028':
        final k = n == 500 ? 3 : rnd(2, min(4, placed.length));
        var pool = [for (final s in exitOrder) if (_isLooseSnake(s)) s]..shuffle(rng);
        if (n == 500) {
          // the finale's hatch order lives in the top rows
          final top = pool.where((s) => lv.cy(lv.snakes[s].body.first) <= 2).toList();
          if (top.length >= 3) pool = top;
        }
        if (pool.length < k) return false;
        final chosen = pool.take(k).toList()..sort((a, b) => idx[a]!.compareTo(idx[b]!));
        addMech(t, [], {}).order = chosen;
        related.add('#${chosen.first}');
        return true;
      case 'M031':
        for (final y in snakes) {
          final tr = traces[y]!;
          if (tr.endCell < 0 || tr.viaBurrowHome || lv.snakes[y].layer != 0) continue;
          if (idx[y]! > 10) continue;
          final seg = tr.endCell, side = tr.endDir;
          final usedEdges = {
            for (final m in lv.mechs)
              if (edgeTypes.contains(m.type)) for (final c in m.cells) c * 4 + m.side
          };
          if (usedEdges.contains(seg * 4 + side)) continue;
          final sharers = [for (final q in placed) if (traces[q]!.endCell == seg && traces[q]!.endDir == side) q];
          final last = sharers.map((q) => idx[q]!).reduce(max);
          final nn = last + 1 + rnd(1, 3) + extraTapsExpected.length;
          addMech(t, [seg], {})
            ..side = side
            ..n = nn;
          return true;
        }
        return false;
      case 'M033':
        for (final cg in snakes) {
          if (!_isLooseSnake(cg)) continue;
          final ic = idx[cg]!;
          final before = [
            for (final q in placed)
              if (idx[q]! < ic && _isPlainSnake(q) && !fixedColor.containsKey(q)) q
          ]..shuffle(rng);
          if (before.length < 2) continue;
          final usedC = {...fixedColor.values, ...reserved};
          final opts = colors8.where((c) => !usedC.contains(c)).toList();
          if (opts.isEmpty) continue;
          final col = pick(opts);
          for (final q in before.take(min(before.length, rnd(2, 3)))) {
            fixedColor[q] = col;
          }
          reserved.add(col);
          addMech(t, [], {})
            ..path = cg
            ..color = col;
          related.add('#${before.first}');
          return true;
        }
        return false;
      case 'M035':
        final lanesAll = _allLanes;
        for (final mama in snakes) {
          if (!_isLooseSnake(mama)) continue;
          for (final h in _shuffled(allCells.where((c) => _empty(c) && !lanesAll.contains(c)))) {
            for (final d in _shuffled([0, 1, 2, 3])) {
              final tail = lv.step(h, opp(d));
              if (tail < 0 || !_empty(tail) || lanesAll.contains(tail)) continue;
              final child = Snake('child', pick(colors8), [h, tail], d)..isChild = true;
              lv.snakes.add(child);
              final st = _cst(mongooseOpen: true);
              for (var s = 0; s < lv.snakes.length - 1; s++) {
                st.status[s] = 2;
              }
              st.status[lv.snakes.length - 1] = 1;
              final tr = csim.laneOf(st, lv.snakes.length - 1);
              lv.snakes.removeLast();
              if (tr.kind != 0 || tr.lane.any(mechCells.contains)) continue;
              addMech(t, [h, tail], {})
                ..path = mama
                ..child = child;
              related.add('#$mama');
              return true;
            }
          }
        }
        return false;
      case 'M036':
        for (final hs in snakes) {
          if (!_isPlainSnake(hs)) continue;
          final opts = _shuffled(lanes[hs]!.where(_empty));
          if (opts.isEmpty) continue;
          addMech(t, [opts.first], {}).path = hs;
          related.add('#$hs');
          return true;
        }
        return false;
      case 'M037':
        for (final y in snakes) {
          if (!_isPlainSnake(y)) continue;
          final tr = traces[y]!;
          if (tr.used.isNotEmpty || tr.lane.length < 2) continue;
          final opts = [for (var i = 1; i < tr.lane.length; i++) if (_empty(tr.lane[i])) tr.lane[i]];
          if (opts.isEmpty) continue;
          addMech(t, [pick(opts)], {});
          related.add('#$y');
          return true;
        }
        return false;
      case 'M041':
        for (final s in snakes) {
          if (!_isPlainSnake(s) || fixedColor.containsKey(s)) continue;
          final st = rnd(0, 2);
          const cyc = ['red', 'green', 'blue'];
          final gateOpts = [for (final c in lanes[s]!) if (_empty(c) && _laneUsers(c).length == 1) c];
          if (chameleonGate && gateOpts.isEmpty) continue;
          addMech(t, [], {})
            ..path = s
            ..cycle = cyc
            ..start = st;
          fixedColor[s] = cyc[st];
          if (chameleonGate) {
            chameleonGate = false;
            final col = cyc[(st + idx[s]!) % 3];
            addMech('M005', [pick(gateOpts)], {}).color = col;
          }
          related.add('#$s');
          return true;
        }
        return false;
      case 'M046':
        for (final s in placed) {
          if (lv.snakes[s].id != 'loop') continue;
          if (lv.mechs.any((m) => m.type == 'M046' && m.path == s)) continue;
          final keys = [for (final q in placed) if (idx[q]! < idx[s]! && _isLooseSnake(q)) q];
          if (keys.isEmpty) return false;
          final k = pick(keys);
          final sn = lv.snakes[s];
          addMech(t, [], {})
            ..path = s
            ..keyPath = k
            ..headCell = sn.body.first
            ..loopDir = sn.dir;
          related.add('#$k');
          return true;
        }
        return false;
      case 'M047':
        for (final s in snakes) {
          if (!_isPlainSnake(s) || lv.snakes[s].body.length >= 7) continue;
          addMech(t, [], {})
            ..path = s
            ..n = rnd(3, 5);
          related.add('#$s');
          return true;
        }
        return false;
      case 'M039':
        for (var i = 0; i + 1 < placed.length; i++) {
          final a = placed[i], b = placed[i + 1];
          if (!_isMirror(lv.snakes[a], lv.snakes[b])) continue;
          if (lv.mechs.any((m) => m.type == 'M039' && (m.paths.contains(a) || m.paths.contains(b)))) continue;
          addMech(t, [], {}).paths = [a, b];
          related.add('#$a');
          return true;
        }
        return false;
      case 'M049':
        if (mongoose < 0) return false;
        final m = lv.mechs[mongoose];
        final through = [for (final s in placed) if (traces[s]!.used.contains(mongoose)) s];
        final lim = _minIdx(through);
        final hp = n == 500 ? 6 : rnd(2, 3);
        final cand = [for (final s in placed) if (idx[s]! < lim && _isLooseSnake(s)) s]..shuffle(rng);
        if (cand.length < hp) return false;
        m.paths = cand.take(hp).toList();
        related.add('#${m.paths.first}');
        return true;
      case 'M005':
        // chameleon-paired gate when no chameleon took it: plain gate
        return _placeStatic('M005');
      default:
        throw GenFail('no dynamic placer for $t');
    }
  }

  bool _isMirror(Snake a, Snake b) {
    if (a.body.length != b.body.length) return false;
    for (var k = 0; k < a.body.length; k++) {
      if (b.body[k] != lv.cell(lv.w - 1 - lv.cx(a.body[k]), lv.cy(a.body[k]))) return false;
    }
    final md = a.dir == 1 ? 3 : a.dir == 3 ? 1 : a.dir;
    return b.dir == md;
  }

  /// Rotations (1–2) a lilypad snake needs from a start direction it can never
  /// leave by, or -1. Candidate is not on the board yet.
  int _lilyTurns(Snake c, bool gear, {bool needStuck = true}) {
    final head = c.body.first;
    for (final q in placed) {
      if (lanes[q]!.contains(head)) return -1; // an empty lilypad left in a later lane
    }
    final neck = lv.dirFromTo(head, c.body[1]);
    final fin = c.dir;
    lv.snakes.add(c);
    try {
      final s = lv.snakes.length - 1;
      final st = _cst();
      // who waits for the candidate (only snakes already placed can)
      final blockers = <int, Set<int>>{};
      for (final q in placed) {
        final bl = <int>{};
        final (cc, d) = csim.laneStart(st, q);
        csim.trace(st, q, cc, d, transparent: true, blockers: bl);
        blockers[q] = bl;
      }
      final waiting = <int>{};
      final todo = [s];
      while (todo.isNotEmpty) {
        final x = todo.removeLast();
        for (final q in placed) {
          if (blockers[q]!.contains(x) && waiting.add(q)) todo.add(q);
        }
      }
      for (final r in _shuffled([1, 2])) {
        var ok = true;
        for (var k = 1; k <= r; k++) {
          if ((fin - k + 8) % 4 == neck) ok = false;
        }
        if (!ok) continue;
        final d = (fin - r + 8) % 4;
        final bl = <int>{};
        final t = csim.trace(st, s, head, d, transparent: true, blockers: bl);
        if (t.kind == 5) continue;
        var stuck = bl.any(waiting.contains);
        for (final x in t.lane) {
          final mi = csim.r.cellMech[x];
          if (mi >= 0 && const {'M001', 'M002', 'M049'}.contains(lv.mechs[mi].type)) stuck = true;
        }
        if (t.edgeMech >= 0 && lv.mechs[t.edgeMech].type == 'M029') stuck = true;
        if (stuck || !needStuck) return r;
      }
      return -1;
    } finally {
      lv.snakes.removeLast();
    }
  }


  Mech _lily(int s, int r) {
    final sn = lv.snakes[s];
    sn.dir = (sn.dir - r + 8) % 4;
    final m = addMech('M013', [sn.body.first], {})..path = s;
    for (var k = 0; k < r; k++) {
      extraTapsExpected.add(m.id);
    }
    return m;
  }


  // ---- finish ----------------------------------------------------------

  void _finishSnakes() {
    for (final en in stumpInfo.entries) {
      final (m, r) = en.value;
      final sn = lv.snakes[en.key];
      final tl = m.cells[0], tr = m.cells[1], bl = m.cells[2], br = m.cells[3];
      final back = {tr: tl, br: tr, bl: br, tl: bl}; // CCW
      for (var k = 0; k < r; k++) {
        sn.body = [for (final c in sn.body) back[c]!];
        sn.dir = ccw(sn.dir);
      }
      related.insert(0, m.id);
    }
    for (final m in lv.mechs) {
      if (m.type == 'M035' && m.child != null) {
        m.childIdx = lv.snakes.length;
        lv.snakes.add(m.child!);
      }
    }
    _assignColors();
    // ids by head position (reading order) so the solution order looks scattered
    final base = [for (var i = 0; i < lv.snakes.length; i++) if (!lv.snakes[i].isChild) i]
      ..sort((a, b) => lv.snakes[a].body.first.compareTo(lv.snakes[b].body.first));
    for (var k = 0; k < base.length; k++) {
      lv.snakes[base[k]].id = 'p${k + 1}';
    }
    for (final m in lv.mechs) {
      if (m.type == 'M035') m.child!.id = '${lv.snakes[m.path].id}c';
    }
    for (final s in base) {
      if (n != 500 && chance(0.2)) lv.snakes[s].caterpillar = true;
    }
    if (n == 500) {
      for (final s in (List.of(base)..shuffle(rng)).take(6)) {
        lv.snakes[s].caterpillar = true;
      }
    }
    _writeParams();
  }

  void _assignColors() {
    final count = {for (final c in colors8) c: 0};
    for (final en in fixedColor.entries) {
      lv.snakes[en.key].color = en.value;
      count[en.value] = count[en.value]! + 1;
    }
    final order = [for (var i = 0; i < lv.snakes.length; i++) if (!fixedColor.containsKey(i)) i]..shuffle(rng);
    for (final s in order) {
      lv.snakes[s].color = '*';
    }
    for (final s in order) {
      final sn = lv.snakes[s];
      final near = <String>{};
      for (var q = 0; q < lv.snakes.length; q++) {
        if (q == s || lv.snakes[q].color == '*' || lv.snakes[q].layer != sn.layer) continue;
        if (lv.snakes[q].body.any((a) => sn.body.any((b) => lv.adj(a, b)))) near.add(lv.snakes[q].color);
      }
      final opts = colors8.where((c) => !reserved.contains(c)).toList()..shuffle(rng);
      opts.sort((a, b) {
        final pa = (near.contains(a) ? 100 : 0) + count[a]!, pb = (near.contains(b) ? 100 : 0) + count[b]!;
        return pa.compareTo(pb);
      });
      sn.color = opts.first;
      count[sn.color] = count[sn.color]! + 1;
    }
    for (final m in lv.mechs) {
      if (m.type == 'M004') m.color = lv.snakes[m.keyPath].color;
    }
  }

  void _writeParams() {
    String id(int s) => lv.snakes[s].id;
    List<int> xyOf(int c) => [lv.cx(c), lv.cy(c)];
    for (final m in lv.mechs) {
      final p = <String, dynamic>{};
      switch (m.type) {
        case 'M001':
          p['variant'] = m.params['variant'] ?? 1;
        case 'M002':
          p['orient'] = m.params['orient'];
        case 'M003':
          p['path'] = id(m.path);
          p['k'] = m.k;
        case 'M004':
          p['keyPath'] = id(m.keyPath);
          p['color'] = m.color;
        case 'M005':
          p['color'] = m.color;
        case 'M006':
          p['arrow'] = dirNames[m.arrow];
        case 'M007':
          p['n'] = m.n;
        case 'M008':
          p['pair'] = m.params['pair'];
        case 'M009':
          p['gates'] = [for (final g in m.gates) xyOf(g)];
          p['initial'] = [for (var i = 0; i < m.gates.length; i++) (m.gateInit >> i) & 1 == 1 ? 'open' : 'closed'];
        case 'M011':
          p['paths'] = [for (final s in m.paths) id(s)];
        case 'M012' || 'M013' || 'M021' || 'M022' || 'M023' || 'M036':
          p['path'] = id(m.path);
        case 'M024':
          p['path'] = id(m.path);
          p['side'] = m.params['side'];
        case 'M014':
          p['orient'] = m.orient;
        case 'M015' || 'M042':
          p['axis'] = m.axis == 0 ? 'H' : 'V';
        case 'M016':
          p['hp'] = m.hp;
        case 'M017' || 'M047':
          p['path'] = id(m.path);
          p['n'] = m.n;
        case 'M018':
          p['state'] = m.state == 0 ? 'L' : 'R';
        case 'M019':
          p['gates'] = [for (final g in m.gates) xyOf(g)];
        case 'M025':
          p['start'] = m.start;
        case 'M027':
          p['n'] = m.n;
        case 'M028':
          p['order'] = [for (final s in m.order) id(s)];
        case 'M029':
          p['side'] = dirNames[m.side];
        case 'M030':
          p['side'] = dirNames[m.side];
          p['color'] = m.color;
        case 'M031':
          p['side'] = dirNames[m.side];
          p['n'] = m.n;
        case 'M032':
          p['obstacleLayer'] = 'both';
        case 'M033':
          p['path'] = id(m.path);
          p['color'] = m.color;
        case 'M035':
          final c = m.child!;
          p['path'] = id(m.path);
          p['child'] = {'id': c.id, 'color': c.color, 'dir': dirNames[c.dir], 'body': [for (final x in c.body) xyOf(x)]};
        case 'M039':
          p['paths'] = [for (final s in m.paths) id(s)];
          p['axis'] = 'V';
        case 'M040':
          p['radius'] = 2;
        case 'M041':
          p['path'] = id(m.path);
          p['cycle'] = m.cycle;
          p['start'] = m.start;
        case 'M043':
          p['keyPaths'] = [for (final s in m.keyPaths) id(s)];
        case 'M044':
          p['pair'] = 'spiral';
          p['rot'] = m.params['rot'];
        case 'M045':
          p['turntables'] = [for (final t in m.turntables) lv.mechs[t].id];
        case 'M046':
          p['path'] = id(m.path);
          p['keyPath'] = id(m.keyPath);
          p['head'] = xyOf(m.headCell);
          p['dir'] = dirNames[m.loopDir];
        case 'M048':
          p['color'] = m.color;
          p['paths'] = [for (final s in m.paths) id(s)];
        case 'M049':
          p['linked'] = [for (final s in m.paths) id(s)];
      }
      m.params = p;
    }
    for (var i = 0; i < related.length; i++) {
      if (related[i].startsWith('#')) related[i] = id(int.parse(related[i].substring(1)));
    }
  }

  Result? _verify() {
    final gems = lv.mechs.where((m) => m.type == 'M026').fold(0, (a, m) => a + m.cells.length);
    final slot = slotOf(n);
    final draft = levelJson(lv, n, slot, tagOf(slot), const ['p1'], 0, gems: gems);
    // rebuild from JSON so the check sees exactly what gets written
    final lv2 = parseLevel(draft);
    final sim = Sim(lv2);
    final prefer = <String>[...related, for (final s in exitOrder) lv.snakes[s].id];
    final interactive = lv.mechs.where((m) => const {'M009', 'M012', 'M018', 'M034', 'M037', 'M045'}.contains(m.type)).length;
    final budget = min(extraTapsExpected.length + interactive * 2 + 2, 12);
    // every one of these needs at least one extra tap
    final minExtra = lv.mechs
        .where((m) => const {'M009', 'M012', 'M013', 'M034', 'M037', 'M045'}.contains(m.type) && !m.gearLinked)
        .length;
    final solver = Solver(sim,
        nodeLimit: n == 500 ? 300000 : 40000, minExtra: min(minExtra, budget), maxExtra: budget, prefer: prefer);
    var sol = solver.solve();
    if (sol == null) throw GenFail(solver.aborted ? 'solver gave up' : 'unsolvable');
    // intro: the tutorial hand points at solution[0], so lead with the new
    // mechanic when that costs no extra moves
    if (slotOf(n) == 'intro' && related.isNotEmpty && sol.first != related.first) {
      final o = sim.apply(sim.initial(), related.first);
      if (o.kind >= 0) {
        final s2 = Solver(sim, nodeLimit: 40000, maxExtra: budget, prefer: prefer).solve(from: o.next);
        if (s2 != null && s2.length + 1 <= sol.length) sol = [related.first, ...s2];
      }
    }
    final used = <int>{};
    final err = replay(sim, sol, used: used);
    if (err != null) throw GenFail('replay $err');
    final newType = n == 500 ? 'M049' : typeName(blockOf(n) - 1);
    _lv2types = [for (final m in lv2.mechs) m.type];
    for (var i = 0; i < lv2.mechs.length; i++) {
      final m = lv2.mechs[i];
      if (m.type != newType) continue;
      if (!_matters(m, i, used, sol)) throw GenFail('$newType does not matter');
    }
    final (d, c, _) = difficulty(lv2, sim, sol.length);
    draft['par_moves'] = sol.length;
    draft['difficulty'] = d;
    draft['solution'] = sol;
    return Result(draft, d, c, sol);
  }

  bool _matters(Mech m, int i, Set<int> used, List<String> sol) {
    switch (m.type) {
      case 'M001' || 'M002' || 'M029' || 'M040' || 'M022' || 'M023' || 'M024' || 'M012' ||
          'M017' || 'M021' || 'M028' || 'M036' || 'M032' || 'M011' || 'M039' || 'M048' || 'M026':
        return true;
      case 'M013' || 'M034' || 'M045' || 'M009':
        return sol.contains(m.id);
      case 'M041':
        // a chameleon matters only through a colour gate it passes
        return used.any((u) => const {'M005', 'M030', 'M033'}.contains(_lv2types[u]));
      case 'M018':
        return used.contains(i) && (slotOf(n) != 'intro' || sol.contains(m.id));
      case 'M035':
        return sol.contains(m.child!.id);
      case 'M027':
        return sol.length >= m.n + 1;
      default:
        return used.contains(i);
    }
  }
}

// ---- level plan ----------------------------------------------------------

List<String> pickTypes(int n, Random rng, int count, String newType, int newCount) {
  final k = int.parse(newType.substring(1));
  final chosen = [for (var i = 0; i < newCount; i++) newType];
  final slot = slotOf(n);
  final recent = [for (var j = max(1, k - 5); j < k; j++) typeName(j)]..removeWhere(notExtra.contains);
  final older = [for (var j = 1; j < max(1, k - 5); j++) typeName(j)]..removeWhere(notExtra.contains);
  if (newType == 'M041' && rng.nextDouble() < 0.8 && chosen.length < count) chosen.add('M005');
  if (newType == 'M045') chosen.removeRange(1, chosen.length);
  // pad and stump bring their own rock: that rock is the intro's older type
  if (slot == 'intro' && (newType == 'M034' || newType == 'M038' || newType == 'M045')) return chosen;
  if (slot == 'intro') {
    // only the new mechanic plus at most one older type
    if (chosen.any((t) => t != newType)) return chosen;
    final pool = [...recent, ...older]..shuffle(rng);
    final older1 = pool.firstWhere((t) => compatible(chosen, t) && t != 'M038', orElse: () => '');
    while (chosen.length < count && older1.isNotEmpty && compatible(chosen, older1)) {
      chosen.add(older1);
    }
    return chosen;
  }
  var guard = 0;
  while (chosen.length < count && guard++ < 200) {
    final pool = (rng.nextDouble() < 0.6 || older.isEmpty) ? recent : older;
    if (pool.isEmpty) continue;
    final t = pool[rng.nextInt(pool.length)];
    if (!compatible(chosen, t)) continue;
    if (t == 'M038' && chosen.length + 2 > count) continue;
    chosen.add(t);
  }
  return chosen;
}

/// Mechanic instances the plan makes (a pad brings a rock, a gear brings lilypads).
int instanceCount(List<String> types) =>
    types.length +
    types.where((t) => t == 'M038' || t == 'M034').length +
    (types.contains('M045') ? 2 : 0);

Result generateLevel(int n, {int attempts = 400, bool verbose = false}) {
  final rng = Random(n * 7919 + 13);
  final spec = specs[blockOf(n) - 1];
  final slot = slotOf(n);
  final newType = typeName(blockOf(n) - 1);
  final (dlo, dhi) = dWindow(n);
  final dMid = (dlo + dhi) / 2;
  final (oMin, oMax) = obstacleRange(n);
  final f = switch (n % 10) {
    1 => 0.0, 2 => 0.25, 3 => 0.4, 4 => 0.5, 5 => 0.2, 6 => 0.55, 7 => 0.7, 8 => 0.85, 9 => 1.0, _ => 0.6,
  };
  Result? best;
  var bestGap = 1e9;
  final fails = <String, int>{};
  var cBias = 0;
  for (var a = 0; a < attempts; a++) {
    final w = slot == 'intro'
        ? spec.minG
        : spec.minG + ((spec.maxG - spec.minG) * min(1.0, f + rng.nextDouble() * 0.3)).round();
    int o, newCount;
    if (slot == 'intro') {
      newCount = rng.nextDouble() < 0.6 ? 1 : 2;
      o = max(newCount, min(oMax, oMin + rng.nextInt(2) + (n > 200 ? 1 : 0)));
    } else {
      o = oMin + ((oMax - oMin) * (f * 0.7 + rng.nextDouble() * 0.4)).round();
      o = o.clamp(oMin, oMax);
      newCount = rng.nextDouble() < 0.65 ? 1 : 2;
    }
    if (const {'M032', 'M039', 'M045', 'M046', 'M034', 'M024', 'M010', 'M040', 'M028', 'M025', 'M027'}
        .contains(newType)) {
      newCount = 1;
    }
    var types = pickTypes(n, rng, o, newType, newCount);
    while (instanceCount(types) > oMax && types.length > 1) {
      types = types.sublist(0, types.length - 1);
    }
    final o2 = instanceCount(types);
    final nn = types.where(nTypes.contains).length + (types.contains('M045') ? 2 : 0);
    final extraGuess = types
            .where((t) => const {'M012', 'M013', 'M009', 'M034', 'M037', 'M018', 'M035'}.contains(t))
            .length +
        (types.contains('M045') ? 2 : 0);
    // chain first: later tiers want longer "this one first" chains
    final (c0, c1) = n <= 100 ? (2, 4) : n <= 200 ? (2, 5) : n <= 300 ? (3, 7) : n <= 400 ? (4, 8) : (5, 10);
    var cWant = c0 + ((c1 - c0) * (f * 0.8 + rng.nextDouble() * 0.4)).round() + cBias;
    if (slot == 'breather' || slot == 'intro') cWant -= 1;
    cWant = cWant.clamp(1, c1 + 2);
    final room = (w * w * 0.62 / 2.3).floor();
    var p = ((dMid - 1.5 * cWant - 2.0 * o2 - 3.0 * nn - extraGuess) / 0.6).round();
    p = p.clamp(spec.minS, max(spec.minS, min(spec.maxS, room)));
    final targetC = ((dMid - 0.6 * p - 2.0 * o2 - 3.0 * nn - extraGuess) / 1.5).round().clamp(0, p - 1);
    final maxLen = n <= 100 ? 5 : n <= 200 ? 6 : 7;
    final g = Gen(n, Random(rng.nextInt(1 << 31)), types, w, p, targetC, maxLen);
    try {
      final r = g.run()!;
      final probs = draftCheck(r.json);
      if (probs.isNotEmpty) {
        final k = 'draft: ${probs.first}';
        fails[k] = (fails[k] ?? 0) + 1;
        continue;
      }
      final cMin = (slot == 'intro' || slot == 'breather') ? c0 - 1 : c0;
      var gap = r.d < dlo ? dlo - r.d : r.d > dhi ? r.d - dhi : 0.0;
      if (r.c < cMin) {
        gap += 0.5 * (cMin - r.c);
        cBias++;
      }
      if (gap < bestGap) {
        bestGap = gap;
        best = r;
      }
      if (gap == 0) break;
      if (r.d < dlo) {
        cBias++;
      } else if (r.d > dhi) {
        cBias--;
      }
      final k = 'D off';
      fails[k] = (fails[k] ?? 0) + 1;
    } on GenFail catch (e) {
      fails[e.why] = (fails[e.why] ?? 0) + 1;
    }
  }
  if (best == null || bestGap > 0 || verbose) {
    final top = fails.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
    print('L$n: ${best == null ? 'FAILED' : 'D ${best.d} gap ${bestGap.toStringAsFixed(1)}'} '
        '[${dlo.toStringAsFixed(1)}-${dhi.toStringAsFixed(1)}]; '
        '${top.take(5).map((e) => '${e.key} ×${e.value}').join(' | ')}');
  }
  if (best == null) throw GenFail('L$n failed');
  return best;
}

late List<String> Function(Map<String, dynamic>) draftCheck;

/// L500 "Mongoose King's Garden" (02 §8): 11×11, 30 snakes, Mongoose King
/// 3×3 at (4,4)–(6,6) with 6 linked snakes, plus 9 listed mechanics.
Result generateFinale({int attempts = 600}) {
  const n = 500;
  final rng = Random(500 * 7919 + 13);
  const types = ['M049', 'M004', 'M009', 'M010', 'M013', 'M016', 'M020', 'M026', 'M028', 'M041'];
  final (dlo, dhi) = dWindow(n);
  Result? best;
  var bestGap = 1e9;
  final fails = <String, int>{};
  var cBias = 0;
  for (var a = 0; a < attempts; a++) {
    final targetC = (8 + cBias).clamp(5, 12);
    final g = Gen(n, Random(rng.nextInt(1 << 31)), types, 11, 30, targetC, 5);
    try {
      final r = g.run(preStatic: (g) {
        final cells = [for (var y = 4; y <= 6; y++) for (var x = 4; x <= 6; x++) g.lv.cell(x, y)];
        g.addMech('M049', cells, {});
        g.noBody.addAll(cells);
        g.mongoose = 0;
        g.mongooseLanesUntil = 8;
        // Home Burrow at the centre-bottom, below the King
        final home = g.lv.cell(5, 8);
        g.addMech('M020', [home], {});
        g.noBody.add(home);
      })!;
      final probs = draftCheck(r.json);
      if (probs.isNotEmpty) {
        final k = 'draft: ${probs.first}';
        fails[k] = (fails[k] ?? 0) + 1;
        if (r.d < dlo) cBias++;
        if (r.d > dhi) cBias--;
        continue;
      }
      final par = r.solution.length;
      var gap = r.d < dlo ? dlo - r.d : r.d > dhi ? r.d - dhi : 0.0;
      if (par < 32 || par > 36) gap += 0.5;
      if (gap < bestGap) {
        bestGap = gap;
        best = r;
      }
      if (gap == 0) break;
      if (r.d < dlo) cBias++;
      if (r.d > dhi) cBias--;
      fails['D ${r.d} par $par'] = (fails['D ${r.d} par $par'] ?? 0) + 1;
    } on GenFail catch (e) {
      fails[e.why] = (fails[e.why] ?? 0) + 1;
    }
  }
  final top = fails.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
  print('L500: ${best == null ? 'FAILED' : 'D ${best.d} gap $bestGap'}; '
      '${top.take(6).map((e) => '${e.key} ×${e.value}').join(' | ')}');
  if (best == null) throw GenFail('L500 failed');
  return best;
}
