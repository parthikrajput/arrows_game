import 'package:puzzle_core/slither_engine.dart';

import '../../core/logging/app_logger.dart';

/// Thrown when level data is missing or corrupt (E-LVL-001 / E-LVL-002).
class LevelUnavailable implements Exception {
  const LevelUnavailable(this.level, this.code);
  final int level;
  final String code;
}

/// Source of numbered levels.
///
/// The hand-tuned Phase 1 level set (`assets/levels/phase_1.json.gz`, 49
/// mechanics, FTUE boards) is not built yet. Until it ships, [StandInLevelSource]
/// builds solvable core-rules boards so every screen and flow can be played
/// end to end. Swap the source here; nothing else depends on how levels are made.
abstract class LevelSource {
  LevelDef load(int level);
}

class LevelRepository {
  LevelRepository({LevelSource? source}) : _source = source ?? const StandInLevelSource();

  final LevelSource _source;
  final Map<int, LevelDef> _cache = {};

  LevelDef get(int level) {
    final cached = _cache[level];
    if (cached != null) return cached;
    try {
      final def = _source.load(level);
      _cache[level] = def;
      return def;
    } on FormatException catch (e) {
      log.e('E-LVL-001', 'Level $level corrupt', e);
      throw LevelUnavailable(level, 'E-LVL-001');
    } catch (e) {
      log.e('E-LVL-002', 'Level $level missing', e);
      throw LevelUnavailable(level, 'E-LVL-002');
    }
  }
}

/// Temporary core-rules boards that grow from 4×4 to 11×11 across 1–500.
class StandInLevelSource implements LevelSource {
  const StandInLevelSource();

  @override
  LevelDef load(int level) {
    if (level < 1 || level > 500) throw StateError('No level $level');
    final size = level <= 2
        ? 4
        : level <= 10
            ? 5
            : (5 + (level / 500 * 6).ceil()).clamp(5, 11);
    final x = level % 10;
    final tag = level == 500
        ? LevelTag.finale
        : level <= 10
            ? LevelTag.easy
            : x == 9
                ? LevelTag.hard
                : (x == 2 || x == 5)
                    ? LevelTag.easy
                    : LevelTag.normal;
    final count = level <= 2
        ? 2 + level
        : (size * size / (tag == LevelTag.hard ? 3.2 : 3.8)).round().clamp(3, 30);
    return BoardGenerator.generate(
      'L$level',
      GeneratorParams(
        width: size,
        height: size,
        snakeCount: count,
        minLength: 2,
        maxLength: level <= 10 ? 3 : 5,
        tangle: tag == LevelTag.hard ? 1.0 : (level <= 10 ? 0.3 : 0.6),
        caterpillarRatio: level <= 10 ? 0 : 0.3,
      ),
      Hash64.of(['snakes_slither', 'level', '$level']).seed(),
      tag: tag,
    );
  }
}
