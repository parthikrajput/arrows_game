// Plays every level in Bots mode on the real game screen and writes a
// report. Slow, so it only runs when asked:
//   BOTS_ALL=1 flutter test test/bots_all_levels_test.dart
// Optional BOTS_FROM / BOTS_TO pick a range; the report goes to
// build/bots_report.json.
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:snakes_slither/app/app.dart';
import 'package:snakes_slither/contracts/app_keys.dart';
import 'package:snakes_slither/data/save_store.dart';
import 'package:snakes_slither/features/gameplay/game_bloc.dart';
import 'package:snakes_slither/services/audio_service.dart';
import 'package:snakes_slither/state/progress_cubit.dart';
import 'package:snakes_slither/state/wallet_cubit.dart';

import 'bots_mode_test.dart' show chip, game, stop;
import 'flow_test.dart' show InstantAds;
import 'helpers.dart';

final _env = Platform.environment;

void main() {
  setUpAll(() => GameBloc.useIsolateForHint = false);

  testWidgets('Bots mode plays every level', skip: _env['BOTS_ALL'] == null, (t) async {
    final from = int.tryParse(_env['BOTS_FROM'] ?? '') ?? 1;
    final levels = testLevels();
    final to = int.tryParse(_env['BOTS_TO'] ?? '') ?? levels.count;
    final store = await t.runAsync(() => SaveStore.at(Directory.systemTemp.createTempSync('bots_all').path));
    await t.runAsync(() => store!.write('compliance', {'ageGateDone': true, 'underAge': false}));
    t.view.physicalSize = const Size(412 * 3, 915 * 3);
    t.view.devicePixelRatio = 3;
    addTearDown(t.view.reset);
    await t.pumpWidget(
      SnakesSlitherApp(store: store!, levels: levels, ads: InstantAds(), audio: AudioService(enabled: false)),
    );
    await t.pump(const Duration(seconds: 3)); // launch intro
    GoRouter.of(t.element(find.byKey(AppKeys.homeScreen))).go('/play/$from?bot=true');
    await t.pump();

    final report = <int, Map<String, Object?>>{};
    var cur = 0, lastMoves = -1, sinceMove = 0, levelMs = 0;
    const tick = 100, stallMs = 30000;

    void snap(GameState s, {String? error}) {
      final sol = s.level.solution, h = s.attempt.history;
      var diverged = -1;
      for (var i = 0; i < h.length; i++) {
        if (i >= sol.length || h[i] != sol[i]) {
          diverged = i + 1;
          break;
        }
      }
      final r = report.putIfAbsent(s.level.number, () => {'level': s.level.number, 'errors': <String>[]});
      r.addAll({
        'tag': s.level.tag.name,
        'mechanics': s.level.mechanicTypes.toList(),
        'solutionSteps': sol.length,
        'parMoves': s.level.parMoves,
        'stepsDone': h.length,
        'moves': s.attempt.moves,
        'divergedAtStep': diverged,
        'heartsLost': s.attempt.heartsLost,
        'status': s.status.name,
        'stars': s.result?.stars,
        'botChip': chip(t),
        'gameMs': levelMs,
      });
      if (error != null) (r['errors'] as List<String>).add(error);
    }

    for (var guard = 0; guard < 40000000; guard += tick) {
      await t.pump(const Duration(milliseconds: tick));
      final err = t.takeException();
      final f = find.byKey(AppKeys.gameplayScreen);
      if (f.evaluate().isEmpty) {
        if (cur >= to) break;
        continue;
      }
      final s = game(t);
      final n = s.level.number;
      if (n != cur) {
        if (cur >= to) break;
        cur = n;
        lastMoves = -1;
        sinceMove = 0;
        levelMs = 0;
      }
      levelMs += tick;
      snap(s, error: err?.toString().split('\n').first);
      if (s.attempt.moves != lastMoves) {
        lastMoves = s.attempt.moves;
        sinceMove = 0;
      } else {
        sinceMove += tick;
      }
      final stopped = chip(t).contains('Stopped');
      if (s.status == GameStatus.won && n >= to) break;
      if (stopped || (sinceMove > stallMs && s.status != GameStatus.won)) {
        report[n]!['stalled'] = stopped ? chip(t) : 'no move for ${stallMs ~/ 1000} s (${s.status.name})';
        if (n >= to) break;
        GoRouter.of(t.element(f)).go('/play/${n + 1}?bot=true');
        await t.pump();
      }
    }

    final ctx = t.element(find.byType(Navigator).first);
    final progress = ctx.read<ProgressCubit>().state.highestCleared;
    final coins = ctx.read<WalletCubit>().state.coins;
    final rows = [for (var n = from; n <= to; n++) report[n] ?? {'level': n, 'status': 'not reached'}];
    final won = rows.where((r) => r['status'] == 'won').length;
    Directory('build').createSync(recursive: true);
    File('build/bots_report.json').writeAsStringSync(
      const JsonEncoder.withIndent(' ').convert({
        'from': from,
        'to': to,
        'won': won,
        'highestClearedAfter': progress,
        'coinsAfter': coins,
        'levels': rows,
      }),
    );
    await stop(t);
    expect(won, to - from + 1, reason: 'see build/bots_report.json');
    expect(progress, 0, reason: 'bot runs must not save progress');
    expect(coins, 200);
  }, timeout: const Timeout(Duration(hours: 2)));
}
