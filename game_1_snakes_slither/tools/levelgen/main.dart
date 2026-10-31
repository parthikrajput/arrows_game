// ignore_for_file: avoid_print
import 'dart:convert';
import 'dart:io';

import 'package:puzzle_core/full_rules.dart';
import 'package:puzzle_core/puzzle_core.dart' show LevelDraftCheck;

import 'build.dart';
import 'io.dart';

final levelFile = Platform.environment['LEVELS'] ?? 'assets/levels/phase_1.json';

/// gen A B [--dry]  : (re)build levels A..B and write them into the level file
/// check A B        : replay every level's solution with the simulator
/// same A B         : rebuild A..B in memory and report any level that differs from the file
void main(List<String> args) {
  draftCheck = LevelDraftCheck.check;
  final cmd = args[0];
  final a = int.parse(args[1]), b = int.parse(args[2]);
  final dry = args.contains('--dry');
  final root = jsonDecode(File(levelFile).readAsStringSync()) as Map<String, dynamic>;
  final levels = (root['levels'] as List).cast<Map<String, dynamic>>();
  if (cmd == 'same') {
    var diff = 0;
    for (var n = a; n <= b; n++) {
      final r = n == 500 ? generateFinale() : generateLevel(n);
      if (jsonEncode(r.json) != jsonEncode(levels[n - 1])) {
        diff++;
        print('L$n differs from the file');
      }
    }
    print('rebuilt L$a–L$b: $diff differ');
    return;
  }
  if (cmd == 'gen') {
    final sw = Stopwatch()..start();
    for (var n = a; n <= b; n++) {
      final t0 = sw.elapsedMilliseconds;
      final r = n == 500 ? generateFinale() : generateLevel(n);
      final j = r.json;
      final types = [for (final m in j['mechanics'] as List) m['type']];
      print('L$n ${j['slot']} ${j['grid'][0]}x${j['grid'][1]} P${(j['paths'] as List).length} '
          'O${types.length} C${r.c} D${r.d} par${j['par_moves']} $types '
          '(${sw.elapsedMilliseconds - t0} ms)');
      if (dry) continue;
      if (n - 1 < levels.length) {
        levels[n - 1] = j;
      } else if (n - 1 == levels.length) {
        levels.add(j);
      } else {
        throw StateError('gap before L$n');
      }
      if (!dry && (n % 10 == 0 || n == b)) {
        File(levelFile).writeAsStringSync(encodeFile(root));
      }
    }
  } else if (cmd == 'check') {
    var bad = 0;
    for (final l in levels) {
      final n = l['level'] as int;
      if (n < a || n > b) continue;
      final probs = [...LevelDraftCheck.check(l)];
      final lv = parseLevel(l);
      final sim = Sim(lv);
      final sol = (l['solution'] as List).cast<String>();
      final err = replay(sim, sol);
      if (err != null) probs.add('replay: $err');
      final (d, _, _) = difficulty(lv, sim, sol.length);
      if ((d - (l['difficulty'] as num)).abs() > 0.05) probs.add('D says ${l['difficulty']}, sim $d');
      if (probs.isNotEmpty) {
        bad++;
        print('L$n ✗ ${probs.join('; ')}');
      }
    }
    print('checked L$a–L$b: $bad with problems');
  }
}
