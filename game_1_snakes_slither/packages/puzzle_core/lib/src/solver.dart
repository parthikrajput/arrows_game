import 'engine.dart';
import 'model.dart';

class Solver {
  const Solver._();

  /// With only snakes and rocks, an exit never closes another snake's lane,
  /// so clearing any exitable snake is always safe and greedy play is
  /// complete. Mechanics that can re-block lanes (levers, counters) will need
  /// a real search here.
  static List<int>? solve(BoardState start) {
    var s = start;
    final order = <int>[];
    while (!s.isEmpty) {
      final ready = Engine.exitable(s);
      if (ready.isEmpty) return null;
      order.add(ready.first);
      s = s.withoutSnake(ready.first);
    }
    return order;
  }

  static int? nextMove(BoardState s) {
    final order = solve(s);
    return (order == null || order.isEmpty) ? null : order.first;
  }

  static bool isSolvable(BoardState s) => solve(s) != null;
}
