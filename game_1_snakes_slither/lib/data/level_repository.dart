import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:puzzle_core/puzzle_core.dart';

/// Phase 1 levels from assets/levels/phase_1.json (schema v3). The level
/// designer owns that file; it must pass
/// `dart run packages/puzzle_core/bin/validate_levels.dart`.
class LevelRepository {
  LevelRepository(this._levels);

  static const assetPath = 'assets/levels/phase_1.json';

  static Future<LevelRepository> loadAsset([AssetBundle? bundle]) async =>
      LevelRepository.fromJsonString(await (bundle ?? rootBundle).loadString(assetPath));

  factory LevelRepository.fromJsonString(String json) =>
      LevelRepository(LevelCodec.decodeFile(jsonDecode(json) as Map<String, dynamic>));

  final List<Level> _levels;

  int get count => _levels.length;

  /// Throws [RangeError] for an unknown level; the gameplay route turns that
  /// into the "Level unavailable" message.
  Level load(int number) {
    if (number < 1 || number > _levels.length) {
      throw RangeError.range(number, 1, _levels.length, 'level');
    }
    return _levels[number - 1];
  }

  bool exists(int number) => number >= 1 && number <= _levels.length;
}
