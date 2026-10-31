// Checks a level file against every Phase 1 level rule.
// Usage (from game_1_snakes_slither/):
//   dart run packages/puzzle_core/bin/validate_levels.dart [file] [--from N] [--to N]
// Result per level:
//   ✓  fully checked (the engine played the solution)
//   ⏳ draft OK — structure passes; full check runs once the engine supports its mechanics
//   ✗  problem, with the reason
// Exit code 0 = no ✗, 1 = at least one ✗.
import 'dart:convert';
import 'dart:io';

import 'package:puzzle_core/puzzle_core.dart';

void main(List<String> args) {
  var path = 'assets/levels/phase_1.json';
  var from = 1, to = 1 << 30;
  for (var i = 0; i < args.length; i++) {
    if (args[i] == '--from') {
      from = int.parse(args[++i]);
    } else if (args[i] == '--to') {
      to = int.parse(args[++i]);
    } else {
      path = args[i];
    }
  }
  final file = File(path);
  if (!file.existsSync()) {
    stderr.writeln('No file at $path');
    exit(1);
  }
  final bytes = file.readAsBytesSync();
  final text = path.endsWith('.gz') ? utf8.decode(gzip.decode(bytes)) : utf8.decode(bytes);
  final root = jsonDecode(text) as Map<String, dynamic>;
  final raws = (root['levels'] as List).cast<Map<String, dynamic>>();

  var ok = 0, draft = 0, bad = 0;
  stdout.writeln('Lv   slot       grid   snakes obst  D      result');
  for (var i = 0; i < raws.length; i++) {
    final raw = raws[i];
    final n = raw['level'];
    if (n is! int || n < from || n > to) continue;
    final problems = <String>[];
    if (n != i + 1) problems.add('levels must be numbered 1..N in order (position ${i + 1})');
    problems.addAll(LevelDraftCheck.check(raw));
    final missing = LevelCodec.unsupportedMechanics(raw);
    var dText = '${raw['difficulty'] ?? '?'}';
    if (problems.isEmpty && missing.isEmpty) {
      try {
        final r = LevelValidator.check(LevelCodec.decode(raw));
        problems.addAll(r.problems);
        dText = r.difficulty.d.toStringAsFixed(1);
      } on LevelFormatException catch (e) {
        problems.add(e.message);
      }
    }
    final grid = (raw['grid'] as List?)?.join('x') ?? '?';
    final result = problems.isNotEmpty
        ? '✗ ${problems.join('; ')}'
        : missing.isNotEmpty
        ? '⏳ draft OK, waiting for engine: ${(missing.toList()..sort()).join(', ')}'
        : '✓';
    if (problems.isNotEmpty) {
      bad++;
    } else if (missing.isNotEmpty) {
      draft++;
    } else {
      ok++;
    }
    stdout.writeln(
      '${'$n'.padRight(4)} ${'${raw['slot']}'.padRight(10)} ${grid.padRight(6)} '
      '${'${(raw['paths'] as List?)?.length ?? '?'}'.padLeft(6)} '
      '${'${(raw['mechanics'] as List?)?.length ?? 0}'.padLeft(4)}  ${dText.padRight(6)} $result',
    );
  }
  stdout.writeln(
    '\n✓ $ok fully checked · ⏳ $draft drafts waiting for engine · ✗ $bad with problems',
  );
  exit(bad == 0 ? 0 : 1);
}
