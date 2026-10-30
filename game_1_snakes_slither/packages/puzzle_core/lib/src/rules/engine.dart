import '../model/board_state.dart';
import '../model/cell.dart';
import '../model/snake.dart';

/// Cells from the head forward to the board edge, and the first blocker on the way.
class LaneTrace {
  const LaneTrace({required this.cells, this.blockerIndex, this.blockerSnakeId});

  /// Every lane cell up to the edge (exit) or up to and including the blocker cell.
  final List<Cell> cells;

  /// Index in [cells] of the blocking cell, or null when the lane is clear.
  final int? blockerIndex;
  final String? blockerSnakeId;

  bool get isClear => blockerIndex == null;

  /// 1 = blocker right in front of the head.
  int get cellsToBlocker => (blockerIndex ?? -1) + 1;

  Cell? get blockerCell => blockerIndex == null ? null : cells[blockerIndex!];
}

/// Result of one tap, already resolved before any animation plays.
sealed class MoveOutcome {
  const MoveOutcome(this.snakeId);
  final String snakeId;
}

class ExitOutcome extends MoveOutcome {
  const ExitOutcome(super.snakeId, {required this.cellsToEdge, required this.next});

  final int cellsToEdge;
  final BoardState next;
}

class BumpOutcome extends MoveOutcome {
  const BumpOutcome(super.snakeId, {required this.cellsToBlocker, required this.blockerCell, this.blockerSnakeId});

  final int cellsToBlocker;
  final Cell blockerCell;
  final String? blockerSnakeId;
}

/// Tap on a snake that cannot act right now: no heart, no Move.
class LockedOutcome extends MoveOutcome {
  const LockedOutcome(super.snakeId, this.reason);
  final String reason;
}

/// Core rules (standard §2). Pure and synchronous: same state + same Move = same result.
abstract final class Engine {
  static LaneTrace trace(BoardState s, Snake snake) {
    final cells = <Cell>[];
    var c = snake.head.step(snake.dir);
    while (s.contains(c)) {
      cells.add(c);
      final other = s.snakeIdAt(c);
      if (other != null && other != snake.id) {
        return LaneTrace(cells: cells, blockerIndex: cells.length - 1, blockerSnakeId: other);
      }
      c = c.step(snake.dir);
    }
    return LaneTrace(cells: cells);
  }

  static bool canExit(BoardState s, Snake snake) => trace(s, snake).isClear;

  /// Unknown ids return null (e.g. a queued tap on a snake that already left).
  static MoveOutcome? apply(BoardState s, String snakeId) {
    final snake = s.snakeById(snakeId);
    if (snake == null) return null;
    final lane = trace(s, snake);
    if (lane.isClear) {
      return ExitOutcome(snakeId, cellsToEdge: lane.cells.length, next: s.without(snakeId));
    }
    return BumpOutcome(
      snakeId,
      cellsToBlocker: lane.cellsToBlocker,
      blockerCell: lane.blockerCell!,
      blockerSnakeId: lane.blockerSnakeId,
    );
  }

  /// Magic Stone Hammer: irreversible removal that counts as an exit.
  static BoardState hammer(BoardState s, String snakeId) => s.without(snakeId);

  static bool isWon(BoardState s) => s.isEmpty;
}
