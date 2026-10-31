import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:puzzle_core/puzzle_core.dart';
import 'package:snakes_slither/data/level_repository.dart';

/// CI gate for the level designer's file. Every level is played under the full rules;
/// levels the game screen can already play also pass the app engine's check.
void main() {
  final raws =
      ((jsonDecode(File(LevelRepository.assetPath).readAsStringSync()) as Map)['levels'] as List)
          .cast<Map<String, dynamic>>();

  test('levels are numbered 1..N in order', () {
    expect([for (final r in raws) r['level']], [for (var i = 1; i <= raws.length; i++) i]);
  });

  for (final raw in raws) {
    final n = raw['level'];
    final missing = LevelCodec.unsupportedMechanics(raw);
    test(
      'L$n ${missing.isEmpty ? 'passes all rules' : 'wins under the full rules (game screen waits for $missing)'}',
      () {
        final p = [...LevelDraftCheck.check(raw)];
        if (p.isEmpty) p.addAll(RulesCheck.check(raw));
        if (missing.isEmpty && p.isEmpty) {
          p.addAll(LevelValidator.check(LevelCodec.decode(raw)).problems);
        }
        expect(p, isEmpty, reason: 'L$n: ${p.join('; ')}');
      },
    );
  }
}
