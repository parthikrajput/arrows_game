import 'dart:math' as math;

import 'engine.dart';
import 'model.dart';

/// Difficulty parts: D = 0.6·P + 1.5·C + 2.0·O + 3.0·N + 1.0·S.
class Difficulty {
  const Difficulty({
    required this.p,
    required this.c,
    required this.o,
    required this.n,
    required this.s,
  });

  /// Snake count.
  final int p;

  /// Longest "must exit before" chain, counted in links (all independent = 0).
  final int c;

  /// Obstacle instances.
  final int o;

  /// Non-monotone mechanic instances (levers, counters…); none supported yet.
  final int n;

  /// Solution moves beyond one tap per snake.
  final int s;

  double get d => _round(0.6 * p + 1.5 * c + 2.0 * o + 3.0 * n + 1.0 * s);

  static double _round(double v) => (v * 10).round() / 10;

  static Difficulty of(Level l) {
    final b = l.board;
    final moves = l.solution.isEmpty ? b.snakes.length : l.solution.length;
    return Difficulty(
      p: b.snakes.length,
      c: longestChain(b),
      o: b.rocks.length,
      n: 0,
      s: moves - b.snakes.length,
    );
  }

  /// Snake X depends on every snake sitting in its exit lane at the start.
  /// Exits only ever free cells, so the starting lanes give the full graph.
  static int longestChain(BoardState b) {
    final deps = <int, Set<int>>{};
    for (final s in b.snakes.values) {
      final blockers = <int>{};
      var c = s.head.step(s.dir);
      while (b.inBounds(c)) {
        final o = b.snakeAt(c);
        if (o != null && o.id != s.id) blockers.add(o.id);
        c = c.step(s.dir);
      }
      deps[s.id] = blockers;
    }
    final memo = <int, int>{};
    int depth(int id, Set<int> stack) {
      final hit = memo[id];
      if (hit != null) return hit;
      if (!stack.add(id)) return 0; // cycle; solvability check reports it
      var best = 0;
      for (final d in deps[id]!) {
        best = math.max(best, 1 + depth(d, stack));
      }
      stack.remove(id);
      return memo[id] = best;
    }

    var best = 0;
    for (final id in deps.keys) {
      best = math.max(best, depth(id, {}));
    }
    return best;
  }
}

/// Target ranges for a level, from the tier and block tables.
class LevelTarget {
  const LevelTarget({
    required this.minGrid,
    required this.maxGrid,
    required this.minSnakes,
    required this.maxSnakes,
    required this.maxObstacles,
    required this.minD,
    required this.maxD,
    required this.maxMoves,
  });
  final int minGrid;
  final int maxGrid;
  final int minSnakes;
  final int maxSnakes;
  final int maxObstacles;
  final double minD;
  final double maxD;

  /// FTUE only (L1–3 ≤ 4, L4–10 ≤ 8); null elsewhere.
  final int? maxMoves;

  /// Limits for level [n], from the 50-row block table (doc 02 §7) and the
  /// tier table (obstacle caps). FTUE splits into L1–3 and L4–10.
  static LevelTarget forLevel(int n) {
    if (n <= 3) {
      return const LevelTarget(
        minGrid: 4,
        maxGrid: 5,
        minSnakes: 2,
        maxSnakes: 4,
        maxObstacles: 0,
        minD: 1,
        maxD: 4,
        maxMoves: 4,
      );
    }
    if (n <= 10) {
      return const LevelTarget(
        minGrid: 5,
        maxGrid: 6,
        minSnakes: 4,
        maxSnakes: 8,
        maxObstacles: 0,
        minD: 3,
        maxD: 8,
        maxMoves: 8,
      );
    }
    final b = blocks[blockOf(n) - 1];
    // The finale has its own target: band high × 1.2 ≈ 62, 30 snakes, 10 obstacles.
    if (n == 500) {
      return LevelTarget(
        minGrid: 11,
        maxGrid: 11,
        minSnakes: 30,
        maxSnakes: 30,
        maxObstacles: 10,
        minD: 62,
        maxD: 62,
        maxMoves: null,
      );
    }
    return LevelTarget(
      minGrid: b.minGrid,
      maxGrid: b.maxGrid,
      minSnakes: b.minSnakes,
      maxSnakes: b.maxSnakes,
      maxObstacles: _tierMaxObstacles(n),
      minD: b.minD.toDouble(),
      maxD: b.maxD.toDouble(),
      maxMoves: null,
    );
  }

  static int blockOf(int n) => (n - 1) ~/ 10 + 1;

  static int _tierMaxObstacles(int n) => n <= 10
      ? 0
      : n <= 100
      ? 4
      : n <= 200
      ? 6
      : n <= 300
      ? 8
      : n <= 400
      ? 9
      : 10;

  static const blocks = <BlockSpec>[
    BlockSpec(1, 4, 6, 2, 8, 1, 8),
    BlockSpec(2, 6, 7, 6, 10, 6, 12),
    BlockSpec(3, 6, 7, 6, 10, 6, 12),
    BlockSpec(4, 6, 7, 6, 10, 6, 12),
    BlockSpec(5, 6, 8, 8, 12, 9, 15),
    BlockSpec(6, 6, 8, 8, 12, 9, 15),
    BlockSpec(7, 6, 8, 8, 12, 9, 15),
    BlockSpec(8, 7, 8, 10, 14, 12, 18),
    BlockSpec(9, 7, 8, 10, 14, 12, 18),
    BlockSpec(10, 7, 8, 10, 14, 12, 18),
    BlockSpec(11, 7, 8, 10, 14, 14, 20),
    BlockSpec(12, 7, 8, 10, 14, 14, 20),
    BlockSpec(13, 7, 8, 10, 14, 14, 20),
    BlockSpec(14, 7, 9, 12, 16, 17, 23),
    BlockSpec(15, 7, 9, 12, 16, 17, 23),
    BlockSpec(16, 7, 9, 12, 16, 17, 23),
    BlockSpec(17, 7, 9, 12, 16, 17, 23),
    BlockSpec(18, 8, 9, 14, 18, 20, 26),
    BlockSpec(19, 8, 9, 14, 18, 20, 26),
    BlockSpec(20, 8, 9, 14, 18, 20, 26),
    BlockSpec(21, 8, 9, 14, 18, 22, 29),
    BlockSpec(22, 8, 9, 14, 18, 22, 29),
    BlockSpec(23, 8, 9, 14, 18, 22, 29),
    BlockSpec(24, 8, 10, 16, 20, 26, 32),
    BlockSpec(25, 8, 10, 16, 20, 26, 32),
    BlockSpec(26, 8, 10, 16, 20, 26, 32),
    BlockSpec(27, 8, 10, 16, 20, 26, 32),
    BlockSpec(28, 9, 10, 18, 22, 29, 36),
    BlockSpec(29, 9, 10, 18, 22, 29, 36),
    BlockSpec(30, 9, 10, 18, 22, 29, 36),
    BlockSpec(31, 9, 9, 18, 22, 30, 37),
    BlockSpec(32, 9, 9, 18, 22, 30, 37),
    BlockSpec(33, 9, 9, 18, 22, 30, 37),
    BlockSpec(34, 9, 10, 20, 24, 34, 40),
    BlockSpec(35, 9, 10, 20, 24, 34, 40),
    BlockSpec(36, 9, 10, 20, 24, 34, 40),
    BlockSpec(37, 9, 10, 20, 24, 34, 40),
    BlockSpec(38, 10, 10, 22, 26, 37, 44),
    BlockSpec(39, 10, 10, 22, 26, 37, 44),
    BlockSpec(40, 10, 10, 22, 26, 37, 44),
    BlockSpec(41, 10, 10, 22, 26, 38, 45),
    BlockSpec(42, 10, 10, 22, 26, 38, 45),
    BlockSpec(43, 10, 10, 22, 26, 38, 45),
    BlockSpec(44, 10, 11, 24, 28, 42, 48),
    BlockSpec(45, 10, 11, 24, 28, 42, 48),
    BlockSpec(46, 10, 11, 24, 28, 42, 48),
    BlockSpec(47, 10, 11, 24, 28, 42, 48),
    BlockSpec(48, 11, 11, 26, 30, 45, 52),
    BlockSpec(49, 11, 11, 26, 30, 45, 52),
    BlockSpec(50, 11, 11, 26, 30, 45, 52),
  ];

  /// Expected slot from the 10-level block pattern.
  static LevelSlot slotFor(int n) {
    if (n == 500) return LevelSlot.finale;
    if (n == 9) return LevelSlot.ramp; // no Hard inside FTUE
    return switch (n % 10) {
      1 => LevelSlot.intro,
      2 || 3 || 4 => LevelSlot.practice,
      5 => LevelSlot.breather,
      6 || 7 || 8 => LevelSlot.ramp,
      9 => LevelSlot.hard,
      _ => LevelSlot.milestone,
    };
  }

  static LevelTag tagFor(LevelSlot s) => switch (s) {
    LevelSlot.breather => LevelTag.easy,
    LevelSlot.hard => LevelTag.hard,
    LevelSlot.finale => LevelTag.finale,
    _ => LevelTag.normal,
  };

  /// Mechanic introduced by the block this level is in (M001 at L11 …), or null in FTUE.
  static String? blockMechanic(int n) {
    final block = (n - 1) ~/ 10 + 1;
    if (block < 2 || block > 50) return null;
    return 'M${(block - 1).toString().padLeft(3, '0')}';
  }
}

/// One row of the Phase 1 block table.
class BlockSpec {
  const BlockSpec(
    this.block,
    this.minGrid,
    this.maxGrid,
    this.minSnakes,
    this.maxSnakes,
    this.minD,
    this.maxD,
  );
  final int block;
  final int minGrid;
  final int maxGrid;
  final int minSnakes;
  final int maxSnakes;
  final int minD;
  final int maxD;
}

class LevelReport {
  LevelReport(this.level, this.difficulty, this.problems);
  final Level level;
  final Difficulty difficulty;

  /// Empty means the level passes.
  final List<String> problems;
  bool get ok => problems.isEmpty;
}

/// Design rules from the level progression doc, on top of LevelCodec's
/// structure/solvability checks. Run by CI and by the level designer.
class LevelValidator {
  const LevelValidator._();

  /// Allowed distance between the computed D and the band edges.
  static const bandSlack = 3.0;

  /// Allowed D range for a level: block band ± slack; Hard may reach max × 1.1;
  /// the finale aims at 62 ± slack.
  static (double, double) dBand(int n, LevelSlot slot) {
    final t = LevelTarget.forLevel(n);
    final max = slot == LevelSlot.hard ? t.maxD * 1.1 : t.maxD;
    return (t.minD - bandSlack, max + bandSlack);
  }

  static LevelReport check(Level l) {
    final p = <String>[];
    final n = l.number;
    final b = l.board;
    final t = LevelTarget.forLevel(n);
    final diff = Difficulty.of(l);

    // Slot and tag follow the level number.
    final slot = LevelTarget.slotFor(n);
    if (l.slot != slot) p.add('slot is "${l.slot.name}", L$n must be "${slot.name}"');
    final tag = LevelTarget.tagFor(slot);
    if (l.tag != tag) p.add('tag is "${l.tag.name}", slot ${slot.name} needs "${tag.name}"');

    // Size and counts.
    for (final side in [b.width, b.height]) {
      if (side < t.minGrid || side > t.maxGrid) {
        p.add(
          'grid ${b.width}x${b.height} outside ${t.minGrid}x${t.minGrid}–${t.maxGrid}x${t.maxGrid}',
        );
        break;
      }
    }
    if (diff.p < t.minSnakes || diff.p > t.maxSnakes) {
      p.add('${diff.p} snakes, needs ${t.minSnakes}–${t.maxSnakes}');
    }
    if (diff.o > t.maxObstacles) p.add('${diff.o} obstacles, max ${t.maxObstacles}');

    // Difficulty band (Hard may reach max × 1.1).
    final (minD, maxD) = dBand(n, slot);
    if (diff.d < minD || diff.d > maxD) {
      p.add('D ${diff.d} outside ${minD.toStringAsFixed(1)}–${maxD.toStringAsFixed(1)}');
    }
    if ((l.difficulty - diff.d).abs() > 0.05) {
      p.add('"difficulty" says ${l.difficulty}, computed ${diff.d}');
    }

    // Solution must be a real 0-heart win, and par must match it.
    p.addAll(_checkSolution(l));
    final moves = l.solution.length;
    if (l.parMoves != moves) p.add('"par_moves" is ${l.parMoves}, solution has $moves moves');
    if (t.maxMoves != null && moves > t.maxMoves!) {
      p.add('FTUE optimal moves $moves, max ${t.maxMoves}');
    }

    // Mechanics allowed for this block.
    final intro = LevelTarget.blockMechanic(n);
    final types = l.mechanicTypes;
    if (intro == null) {
      if (types.isNotEmpty) p.add('FTUE levels must have no obstacles');
    } else {
      final introNum = int.parse(intro.substring(1));
      for (final ty in types.toSet()) {
        if (int.parse(ty.substring(1)) > introNum) p.add('$ty is not unlocked until a later block');
      }
      final introCount = types.where((x) => x == intro).length;
      if (introCount == 0) p.add('every level in this block needs at least 1 $intro');
      if (slot == LevelSlot.intro) {
        if (introCount > 2) p.add('intro level: $intro must appear 1–2 times, found $introCount');
        if (types.toSet().difference({intro}).length > 1) {
          p.add('intro level: only $intro plus at most 1 older mechanic');
        }
      }
    }
    return LevelReport(l, diff, p);
  }

  static List<String> _checkSolution(Level l) {
    if (l.solution.isEmpty) return ['"solution" is empty'];
    var board = l.board;
    final byRef = {for (final s in board.snakes.values) s.ref: s.id};
    for (var i = 0; i < l.solution.length; i++) {
      final ref = l.solution[i];
      final id = byRef[ref];
      if (id == null || !board.snakes.containsKey(id)) {
        return ['solution step ${i + 1}: "$ref" is not a snake on the board'];
      }
      final r = Engine.tapSnake(board, id);
      if (r.kind != MoveKind.exit) return ['solution step ${i + 1}: "$ref" bonks'];
      board = r.next;
    }
    if (!board.isEmpty) return ['solution leaves ${board.snakes.length} snake(s) on the board'];
    return const [];
  }
}
