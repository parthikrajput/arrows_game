import 'package:puzzle_core/puzzle_core.dart';
import 'package:puzzle_core/slither_engine.dart' as se;

import '../state/daily_cubit.dart';

class DailyLevelFactory {
  const DailyLevelFactory._();

  static Level buildDailyLevel({
    required String dayKey,
    required DateTime date,
    required DailyModifier modifier,
    required int highestCleared,
  }) {
    final silhouette = se.SilhouetteMask.forWeekday(date.weekday);
    final width = modifier == DailyModifier.bigBoard ? 8 : 7;
    final height = modifier == DailyModifier.bigBoard ? 8 : 7;
    final snakeCount = modifier == DailyModifier.bigBoard ? 10 : 8;
    final mask = silhouette.mask(width, height);

    // Deterministic seed from dayKey
    final seed = dayKey.hashCode.abs();
    final def = se.BoardGenerator.generate(
      'daily_$dayKey',
      se.GeneratorParams(
        width: width,
        height: height,
        snakeCount: snakeCount,
        mask: mask,
      ),
      seed,
    );

    final snakes = <int, Snake>{};
    for (var i = 0; i < def.snakes.length; i++) {
      final s = def.snakes[i];
      final dir = switch (s.dir) {
        se.Dir.up => Dir.up,
        se.Dir.down => Dir.down,
        se.Dir.left => Dir.left,
        se.Dir.right => Dir.right,
      };
      snakes[i] = Snake(
        id: i,
        ref: s.id,
        body: [for (final c in s.body) Cell(c.x, c.y)],
        dir: dir,
        color: SnakeColor.values.byName(s.color.name),
        skin: s.caterpillar ? SnakeSkin.caterpillar : SnakeSkin.snake,
      );
    }

    return Level(
      number: 0,
      tag: LevelTag.normal,
      board: BoardState(
        width: def.width,
        height: def.height,
        snakes: snakes,
        rocks: const {},
      ),
      parMoves: def.parMoves ?? def.solution.length,
      solution: def.solution,
    );
  }
}
