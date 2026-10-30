import 'package:flutter_test/flutter_test.dart';
import 'package:puzzle_core/puzzle_core.dart';

import 'helpers.dart';

/// CI gate for the level designer's file: every level must pass every rule.
void main() {
  final repo = testLevels();

  test('level file loads and is numbered 1..N', () {
    expect(repo.count, greaterThan(0));
  });

  for (var n = 1; n <= repo.count; n++) {
    test('L$n passes the Phase 1 level rules', () {
      final r = LevelValidator.check(repo.load(n));
      expect(r.problems, isEmpty, reason: 'L$n: ${r.problems.join('; ')}');
    });
  }
}
