// Checks a level file against every Phase 1 level rule.
// Usage (from game_1_snakes_slither/):
//   dart run packages/puzzle_core/bin/validate_levels.dart assets/levels/phase_1.json
// Exit code 0 = all levels pass, 1 = at least one problem.
import 'dart:convert';
import 'dart:io';

import 'package:puzzle_core/puzzle_core.dart';

void main(List<String> args) {
  final path = args.isEmpty ? 'assets/levels/phase_1.json' : args.first;
  final file = File(path);
  if (!file.existsSync()) {
    stderr.writeln('No file at $path');
    exit(1);
  }
  final bytes = file.readAsBytesSync();
  final text = path.endsWith('.gz') ? utf8.decode(gzip.decode(bytes)) : utf8.decode(bytes);
  final root = jsonDecode(text) as Map<String, dynamic>;
  final raws = (root['levels'] as List).cast<Map<String, dynamic>>();

  var failed = 0;
  stdout.writeln('Lv   slot       grid   P  C  O   D     result');
  for (var i = 0; i < raws.length; i++) {
    final raw = raws[i];
    final n = raw['level'];
    if (n != i + 1) {
      stdout.writeln('L$n  ✗ levels must be numbered 1..N in order (position ${i + 1})');
      failed++;
      continue;
    }
    try {
      final r = LevelValidator.check(LevelCodec.decode(raw));
      final d = r.difficulty;
      final b = r.level.board;
      stdout.writeln(
        '${'$n'.padRight(4)} ${r.level.slot.name.padRight(10)} '
        '${'${b.width}x${b.height}'.padRight(6)} ${'${d.p}'.padLeft(2)} ${'${d.c}'.padLeft(2)} '
        '${'${d.o}'.padLeft(2)} ${d.d.toStringAsFixed(1).padLeft(5)}  '
        '${r.ok ? '✓' : '✗ ${r.problems.join('; ')}'}',
      );
      if (!r.ok) failed++;
    } on LevelFormatException catch (e) {
      stdout.writeln('${'$n'.padRight(4)} ✗ ${e.message}');
      failed++;
    }
  }
  stdout.writeln(
    failed == 0
        ? '\nAll ${raws.length} levels pass.'
        : '\n$failed of ${raws.length} levels have problems.',
  );
  exit(failed == 0 ? 0 : 1);
}
