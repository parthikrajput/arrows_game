import '../model/board_state.dart';
import '../rules/engine.dart';

/// Finds the next correct Move from any state.
///
/// Under the core rules an exit only ever frees cells, so any snake that can
/// exit now is part of some winning order. Mechanics that close lanes again
/// need a real search; [maxNodes] bounds it so the Hint stays inside its budget.
abstract final class Solver {
  /// Follows [solution] while the board is still on its prefix, else searches.
  static String? nextMove(BoardState s, {List<String> solution = const [], List<String> played = const [], int maxNodes = 50000}) {
    if (s.isEmpty) return null;
    if (solution.isNotEmpty && played.length < solution.length) {
      var onPrefix = true;
      for (var i = 0; i < played.length; i++) {
        if (played[i] != solution[i]) {
          onPrefix = false;
          break;
        }
      }
      if (onPrefix) {
        final next = solution[played.length];
        final snake = s.snakeById(next);
        if (snake != null && Engine.canExit(s, snake)) return next;
      }
    }
    final order = solve(s, maxNodes: maxNodes);
    return (order == null || order.isEmpty) ? null : order.first;
  }

  /// Full winning order, or null when the state is soft-locked or the budget ran out.
  static List<String>? solve(BoardState s, {int maxNodes = 50000}) {
    final dead = <String>{};
    var nodes = 0;
    List<String>? dfs(BoardState b) {
      if (b.isEmpty) return const [];
      if (++nodes > maxNodes || dead.contains(b.key)) return null;
      for (final snake in b.snakes) {
        if (!Engine.canExit(b, snake)) continue;
        final rest = dfs(b.without(snake.id));
        if (rest != null) return [snake.id, ...rest];
      }
      dead.add(b.key);
      return null;
    }

    return dfs(s);
  }

  /// No snake can move and the board is not cleared.
  static bool isSoftLocked(BoardState s) => !s.isEmpty && solve(s) == null;
}
