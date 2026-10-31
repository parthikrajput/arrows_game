import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:puzzle_core/puzzle_core.dart';
import 'package:snakes_slither/data/level_repository.dart';

/// CI gate for the level designer's file. Playable levels get the full check
/// (the engine plays the solution); drafts get the structure check.
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
      'L$n ${missing.isEmpty ? 'passes all rules' : 'draft is well-formed (waits for $missing)'}',
      () {
        final p = [...LevelDraftCheck.check(raw)];
        if (missing.isEmpty && p.isEmpty) {
          p.addAll(LevelValidator.check(LevelCodec.decode(raw)).problems);
        }
        expect(p, isEmpty, reason: 'L$n: ${p.join('; ')}');
      },
    );
  }
}
