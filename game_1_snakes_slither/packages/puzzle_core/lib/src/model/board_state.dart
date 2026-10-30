import 'cell.dart';
import 'snake.dart';

/// Immutable board snapshot. Every engine call returns a new one.
class BoardState {
  BoardState({
    required this.width,
    required this.height,
    required List<Snake> snakes,
    this.exitedCount = 0,
  })  : snakes = List.unmodifiable(snakes),
        _occupancy = _index(width, snakes);

  final int width;
  final int height;
  final List<Snake> snakes;

  /// Snakes that left the board, by slithering out or by the Hammer.
  final int exitedCount;

  final Map<int, String> _occupancy;

  static Map<int, String> _index(int width, List<Snake> snakes) {
    final map = <int, String>{};
    for (final s in snakes) {
      for (final c in s.body) {
        map[c.y * width + c.x] = s.id;
      }
    }
    return map;
  }

  bool get isEmpty => snakes.isEmpty;

  bool contains(Cell c) => c.x >= 0 && c.y >= 0 && c.x < width && c.y < height;

  String? snakeIdAt(Cell c) => contains(c) ? _occupancy[c.y * width + c.x] : null;

  Snake? snakeById(String id) {
    for (final s in snakes) {
      if (s.id == id) return s;
    }
    return null;
  }

  Snake? snakeAt(Cell c) {
    final id = snakeIdAt(c);
    return id == null ? null : snakeById(id);
  }

  BoardState without(String snakeId) => BoardState(
        width: width,
        height: height,
        snakes: [for (final s in snakes) if (s.id != snakeId) s],
        exitedCount: exitedCount + 1,
      );

  /// Order-independent key for solver memoisation.
  String get key {
    final ids = [for (final s in snakes) s.id]..sort();
    return ids.join(',');
  }
}
