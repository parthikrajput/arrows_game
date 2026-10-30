import 'board_state.dart';
import 'snake.dart';

/// Clear-coin band of a level.
enum LevelTag { easy, normal, hard, finale }

/// One playable board as shipped in level data (or built by the generator).
class LevelDef {
  const LevelDef({
    required this.id,
    required this.width,
    required this.height,
    required this.snakes,
    this.tag = LevelTag.normal,
    this.solution = const [],
    this.parMoves,
  });

  final String id;
  final int width;
  final int height;
  final List<Snake> snakes;
  final LevelTag tag;

  /// Known winning order of snake ids; the Hint follows it while the player is on it.
  final List<String> solution;

  /// Tuesday Daily par. Null on normal levels.
  final int? parMoves;

  BoardState toBoard() => BoardState(width: width, height: height, snakes: snakes);

  Map<String, Object?> toJson() => {
        'id': id,
        'w': width,
        'h': height,
        'tag': tag.name,
        'snakes': [for (final s in snakes) s.toJson()],
        'solution': solution,
        if (parMoves != null) 'par': parMoves,
      };

  /// Throws [FormatException] on corrupt data (E-LVL-001 / E-LVL-002 upstream).
  static LevelDef fromJson(Map<String, Object?> json) {
    final w = json['w'] as int;
    final h = json['h'] as int;
    if (w < 2 || h < 2 || w > 30 || h > 30) throw FormatException('Bad board size ${w}x$h');
    final snakes = [for (final s in json['snakes'] as List) Snake.fromJson(s as Map<String, Object?>)];
    final seen = <String>{};
    final cells = <int>{};
    for (final s in snakes) {
      if (!seen.add(s.id)) throw FormatException('Duplicate snake id ${s.id}');
      for (final c in s.body) {
        if (c.x < 0 || c.y < 0 || c.x >= w || c.y >= h) throw FormatException('Snake ${s.id} off board');
        if (!cells.add(c.y * w + c.x)) throw FormatException('Overlapping snakes at $c');
      }
    }
    return LevelDef(
      id: json['id'] as String,
      width: w,
      height: h,
      snakes: snakes,
      tag: LevelTag.values.byName((json['tag'] as String?) ?? 'normal'),
      solution: [for (final id in (json['solution'] as List?) ?? const []) id as String],
      parMoves: json['par'] as int?,
    );
  }
}
