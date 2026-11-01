import 'dart:convert';
import 'dart:isolate';

import 'package:flutter/services.dart';
import 'package:puzzle_core/puzzle_core.dart';

/// Phase 1 levels from assets/levels/phase_1.json (schema v3). The level
/// designer owns that file; it must pass
/// `dart run packages/puzzle_core/bin/validate_levels.dart`.
///
/// Levels are decoded on first use: building the rules for all 500 at launch
/// would cost far more than one level load.
class LevelRepository {
  LevelRepository(List<Map<String, dynamic>> raws) : _raws = raws {
    for (var i = 0; i < raws.length; i++) {
      if (raws[i]['level'] != i + 1) {
        throw LevelFormatException(
          'level list must be 1..N in order; found L${raws[i]['level']} at position ${i + 1}',
        );
      }
    }
  }

  static const assetPath = 'assets/levels/phase_1.json';

  /// Parsing the 1.2 MB level file runs on a background isolate so the
  /// first frame never waits for it.
  static Future<LevelRepository> loadAsset([AssetBundle? bundle]) async {
    final json = await (bundle ?? rootBundle).loadString(assetPath, cache: false);
    return LevelRepository(await Isolate.run(() => _parse(json)));
  }

  static List<Map<String, dynamic>> _parse(String json) =>
      ((jsonDecode(json) as Map<String, dynamic>)['levels'] as List).cast<Map<String, dynamic>>();

  factory LevelRepository.fromJsonString(String json) => LevelRepository(
    ((jsonDecode(json) as Map<String, dynamic>)['levels'] as List).cast<Map<String, dynamic>>(),
  );

  /// Already decoded levels (a test or a generator built them).
  factory LevelRepository.ofLevels(List<Level> levels) =>
      LevelRepository._decoded({for (final l in levels) l.number: l}, levels.length);

  LevelRepository._decoded(Map<int, Level> cache, int count)
    : _raws = const [],
      _count = count {
    _cache.addAll(cache);
  }

  final List<Map<String, dynamic>> _raws;
  int? _count;
  final _cache = <int, Level>{};

  int get count => _count ?? _raws.length;

  /// Throws [RangeError] for an unknown level and [LevelFormatException] for
  /// a broken one; the gameplay route turns both into "Level unavailable".
  Level load(int number) {
    if (!exists(number)) throw RangeError.range(number, 1, count, 'level');
    return _cache[number] ??= LevelCodec.decodePlay(_raws[number - 1]);
  }

  bool exists(int number) => number >= 1 && number <= count;

  /// Tag without building the level (the map needs it for every node).
  LevelTag tagOf(int number) {
    final hit = _cache[number];
    if (hit != null) return hit.tag;
    return LevelTag.values.byName(_raws[number - 1]['tag'] as String);
  }

  /// Mechanic type a level introduces (first level using it), for the
  /// "NEW!" badge and the intro card.
  String? introducesMechanic(int number) => _intros[number];

  late final Map<int, String> _intros = () {
    final seen = <String>{};
    final out = <int, String>{};
    for (var n = 1; n <= count; n++) {
      final types = _cache[n]?.mechanicTypes ??
          [for (final m in (_raws[n - 1]['mechanics'] as List? ?? const [])) (m as Map)['type'] as String];
      for (final t in types.toSet().toList()..sort()) {
        if (seen.add(t)) out[n] = t;
      }
    }
    return out;
  }();
}
