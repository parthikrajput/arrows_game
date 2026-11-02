import 'dart:convert';
import 'dart:io';

import 'package:puzzle_core/src/full_rules/level_json.dart' as fj;
import 'package:puzzle_core/src/full_rules/rules.dart' as fr;

class LevelResult {
  LevelResult({
    required this.level,
    required this.slot,
    required this.tag,
    required this.grid,
    required this.snakesCount,
    required this.mechanics,
    required this.parMoves,
    required this.difficulty,
    required this.computedD,
    required this.solutionLength,
    required this.stepsCompleted,
    required this.passed,
    required this.error,
    required this.solution,
  });

  final int level;
  final String slot;
  final String tag;
  final String grid;
  final int snakesCount;
  final List<String> mechanics;
  final int parMoves;
  final double difficulty;
  final double computedD;
  final int solutionLength;
  final int stepsCompleted;
  final bool passed;
  final String? error;
  final List<String> solution;

  Map<String, dynamic> toJson() => {
    'level': level,
    'slot': slot,
    'tag': tag,
    'grid': grid,
    'snakesCount': snakesCount,
    'mechanics': mechanics,
    'parMoves': parMoves,
    'difficulty': difficulty,
    'computedD': computedD,
    'solutionLength': solutionLength,
    'stepsCompleted': stepsCompleted,
    'passed': passed,
    'error': error,
  };
}

void main() {
  final file = File('assets/levels/phase_1.json');
  final root = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
  final raws = (root['levels'] as List).cast<Map<String, dynamic>>();

  final results = <LevelResult>[];

  for (var i = 0; i < raws.length; i++) {
    final raw = raws[i];
    final n = raw['level'] as int;
    final slot = raw['slot'] as String? ?? 'normal';
    final tag = raw['tag'] as String? ?? 'normal';
    final grid = (raw['grid'] as List?)?.join('x') ?? '?';
    final snakes = (raw['paths'] as List?)?.length ?? 0;
    final solution = ((raw['solution'] as List?) ?? const []).cast<String>();
    final mechs = [for (final m in (raw['mechanics'] as List? ?? const [])) (m as Map)['type'] as String];
    final par = raw['par_moves'] as int? ?? solution.length;
    final statedD = (raw['difficulty'] as num?)?.toDouble() ?? 0.0;

    fr.Level lv;
    try {
      lv = fj.parseLevel(raw);
    } catch (e) {
      results.add(LevelResult(
        level: n,
        slot: slot,
        tag: tag,
        grid: grid,
        snakesCount: snakes,
        mechanics: mechs,
        parMoves: par,
        difficulty: statedD,
        computedD: 0.0,
        solutionLength: solution.length,
        stepsCompleted: 0,
        passed: false,
        error: 'JSON parse error: $e',
        solution: solution,
      ));
      continue;
    }

    final sim = fr.Sim(lv, play: true);
    var st = sim.initial();
    var ok = true;
    String? err;
    var stepsDone = 0;

    for (var s = 0; s < solution.length; s++) {
      final token = solution[s];
      final out = sim.apply(st, token);
      if (out.kind < 0) {
        ok = false;
        err = 'Step ${s + 1} ($token) blocked: ${out.note}';
        break;
      }
      stepsDone++;
      st = out.next!;
    }

    if (ok && !sim.won(st)) {
      ok = false;
      err = 'Board not completely cleared after $stepsDone steps';
    }

    final (compD, _, _) = fj.difficulty(lv, sim, solution.length);

    results.add(LevelResult(
      level: n,
      slot: slot,
      tag: tag,
      grid: grid,
      snakesCount: snakes,
      mechanics: mechs,
      parMoves: par,
      difficulty: statedD,
      computedD: compD,
      solutionLength: solution.length,
      stepsCompleted: stepsDone,
      passed: ok,
      error: err,
      solution: solution,
    ));
  }

  // Dump JSON summary
  final reportFile = File('tools/bot_report.json');
  reportFile.writeAsStringSync(jsonEncode({
    'timestamp': DateTime.now().toIso8601String(),
    'totalLevels': results.length,
    'passedCount': results.where((r) => r.passed).length,
    'failedCount': results.where((r) => !r.passed).length,
    'levels': [for (final r in results) r.toJson()],
  }));

  stdout.writeln('Report written to tools/bot_report.json');
  stdout.writeln('Total: ${results.length}, Passed: ${results.where((r) => r.passed).length}, Failed: ${results.where((r) => !r.passed).length}');
}
