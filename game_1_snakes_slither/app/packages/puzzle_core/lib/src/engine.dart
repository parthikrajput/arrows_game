import 'model.dart';

/// Result of tracing a snake's exit lane (used by moves and the free preview).
class LaneTrace {
  const LaneTrace({required this.cells, required this.blocker});

  /// Empty cells the head can travel through, in order, up to the blocker or edge.
  final List<Cell> cells;

  /// First blocking cell, or null when the lane is clear to the edge.
  final Cell? blocker;

  bool get isClear => blocker == null;
}

enum MoveKind { exit, bump, locked }

/// Pure description of what one tap did. The app animates from this.
class MoveResult {
  const MoveResult({
    required this.kind,
    required this.snakeId,
    required this.next,
    required this.lane,
  });

  final MoveKind kind;
  final int snakeId;
  final BoardState next;
  final LaneTrace lane;

  /// Counts toward the Move counter (locked taps do not).
  bool get countsAsMove => kind != MoveKind.locked;

  /// A bump costs a heart (or a Shield charge).
  bool get causesHeartLoss => kind == MoveKind.bump;
}

/// Deterministic rules: same state + same tap = same result.
class Engine {
  const Engine._();

  static LaneTrace trace(BoardState s, Snake snake) {
    final cells = <Cell>[];
    var c = snake.head.step(snake.dir);
    while (s.inBounds(c)) {
      if (s.snakeAt(c) != null || s.rockAt(c) != null) {
        return LaneTrace(cells: cells, blocker: c);
      }
      cells.add(c);
      c = c.step(snake.dir);
    }
    return LaneTrace(cells: cells, blocker: null);
  }

  /// Phase 1 base rules have no lock states yet; mechanic-specific locks
  /// (Frost Coil, Jungle Mist, ...) plug in here when mechanics are added.
  static bool isLocked(BoardState s, Snake snake) => false;

  static MoveResult tapSnake(BoardState s, int snakeId) {
    final snake = s.snakes[snakeId];
    if (snake == null) {
      throw ArgumentError('No snake $snakeId on the board');
    }
    final lane = trace(s, snake);
    if (isLocked(s, snake)) {
      return MoveResult(kind: MoveKind.locked, snakeId: snakeId, next: s, lane: lane);
    }
    if (lane.isClear) {
      return MoveResult(
        kind: MoveKind.exit,
        snakeId: snakeId,
        next: s.withoutSnake(snakeId),
        lane: lane,
      );
    }
    return MoveResult(kind: MoveKind.bump, snakeId: snakeId, next: s, lane: lane);
  }

  /// Snakes whose tap would exit right now.
  static List<int> exitable(BoardState s) => [
    for (final sn in s.snakes.values)
      if (!isLocked(s, sn) && trace(s, sn).isClear) sn.id,
  ]..sort();
}
