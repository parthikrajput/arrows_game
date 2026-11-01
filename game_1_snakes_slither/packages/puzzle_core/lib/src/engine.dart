import 'model.dart';

/// Result of tracing a snake's exit lane (used by moves and the free preview).
class LaneTrace {
  const LaneTrace({
    required this.cells,
    required this.blocker,
    this.exitDir,
    this.fromTail = false,
    this.unknown = false,
  });

  /// Cells the lane travels through, in order, up to the blocker or edge.
  /// Mirrors, switches and burrows bend or jump it, so it need not be straight.
  final List<Cell> cells;

  /// First blocking cell (may sit just off the board for a hedge), or null
  /// when the lane is clear.
  final Cell? blocker;

  /// Direction the lane leaves in after its last cell (null = snake dir).
  final Dir? exitDir;

  /// The lane starts at the tail (Reverse Slither, far head of a Hydra).
  final bool fromTail;

  /// Lane runs into Jungle Mist: the preview ends in a grey "?".
  final bool unknown;

  bool get isClear => blocker == null && !unknown;
}

/// exit = left the board; bump = blocked (costs a heart); locked = no Move;
/// action = any other Move (lever, lilypad, wake-up, mud stop).
enum MoveKind { exit, bump, locked, action }

/// One snake moving in a Move, with the lane it follows.
class SnakeLane {
  const SnakeLane(this.snake, this.lane);
  final Snake snake;
  final LaneTrace lane;
}

/// Pure description of what one tap did. The app animates from this.
class MoveResult {
  const MoveResult({
    required this.kind,
    required this.snakeId,
    required this.next,
    required this.lane,
    this.obstacleId,
    this.parts = const [],
    this.lockReason,
    this.heartEvents = 0,
  });

  final MoveKind kind;

  /// Snake tapped, or -1 for an obstacle tap.
  final int snakeId;
  final int? obstacleId;
  final BoardState next;
  final LaneTrace lane;

  /// Every snake that moved together (Twins, Pond Twins, Parade), the tapped
  /// one first. Empty for single-snake engines.
  final List<SnakeLane> parts;

  /// Mechanic type behind a locked tap.
  final String? lockReason;

  /// Heart-loss events: the bump itself plus any counter that ran out.
  final int heartEvents;

  /// Counts toward the Move counter (locked taps do not).
  bool get countsAsMove => kind != MoveKind.locked;

  /// A bump costs a heart (or a Shield charge).
  bool get causesHeartLoss => kind == MoveKind.bump || heartEvents > 0;
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
