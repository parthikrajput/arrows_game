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

import 'flow_test.dart' show InstantAds;
import 'helpers.dart';

GameState game(WidgetTester t) => t.element(find.byKey(AppKeys.gameplayScreen)).read<GameBloc>().state;

String chip(WidgetTester t) =>
    t.widgetList<Text>(find.descendant(of: find.byKey(AppKeys.botChip), matching: find.byType(Text))).first.data!;

/// Pumps in steps until [done] or [limit] of game time passes.
Future<void> until(WidgetTester t, bool Function() done, {Duration limit = const Duration(seconds: 60)}) async {
  for (var ms = 0; ms < limit.inMilliseconds && !done(); ms += 100) {
    await t.pump(const Duration(milliseconds: 100));
  }
}

/// Unmounts the app and lets the bot's pending timers run out.
Future<void> stop(WidgetTester t) async {
  await t.pumpWidget(const SizedBox());
  await t.pump(const Duration(seconds: 5));
}

void main() {
  setUpAll(() => GameBloc.useIsolateForHint = false);
  late SaveStore store;
  setUp(() async {
    store = await SaveStore.at(Directory.systemTemp.createTempSync('bots').path);
    await store.write('compliance', {'ageGateDone': true, 'underAge': false});
  });

  Future<void> boot(WidgetTester t) async {
    t.view.physicalSize = const Size(412 * 3, 915 * 3);
    t.view.devicePixelRatio = 3;
    addTearDown(t.view.reset);
    t.platformDispatcher.accessibilityFeaturesTestValue = const FakeAccessibilityFeatures(disableAnimations: true);
    addTearDown(t.platformDispatcher.clearAccessibilityFeaturesTestValue);
    await t.pumpWidget(
      SnakesSlitherApp(store: store, levels: testLevels(), ads: InstantAds(), audio: AudioService(enabled: false)),
    );
    await t.pumpAndSettle();
  }

  testWidgets('Map → Bots → locked level: the bot clears it and saves nothing', (t) async {
    await boot(t);
    await t.tap(find.byKey(AppKeys.homeMap));
    await t.pumpAndSettle();
    // Without Bots mode a locked node does nothing.
    await t.tap(find.byKey(AppKeys.mapNode(2)));
    await t.pumpAndSettle();
    expect(find.byKey(AppKeys.mapBotPlay), findsNothing);

    await t.tap(find.byKey(AppKeys.mapBotsToggle));
    await t.pumpAndSettle();
    await t.tap(find.byKey(AppKeys.mapNode(2)));
    await t.pumpAndSettle();
    await t.tap(find.byKey(AppKeys.mapBotPlay));
    await t.pump();
    expect(game(t).level.number, 2);

    await until(t, () => game(t).status == GameStatus.won);
    expect(game(t).status, GameStatus.won);
    expect(game(t).attempt.history, game(t).level.solution);
    expect(game(t).result!.stars, 3);
    final progress = t.element(find.byKey(AppKeys.gameplayScreen)).read<ProgressCubit>().state;
    expect(progress.highestCleared, 0, reason: 'a bot win must not unlock the map');
    expect(t.element(find.byKey(AppKeys.gameplayScreen)).read<WalletCubit>().state.coins, 200);

    // The next level starts with the bot still playing.
    await until(t, () => game(t).level.number == 3);
    expect(game(t).level.number, 3);
    expect(find.byKey(AppKeys.botChip), findsOneWidget);
    await until(t, () => game(t).status == GameStatus.won);
    expect(game(t).status, GameStatus.won);
    await stop(t);
  });

  testWidgets('Pause the bot, make an own move, resume: it solves from there', (t) async {
    await boot(t);
    GoRouter.of(t.element(find.byKey(AppKeys.homeScreen))).go('/play/12?bot=true');
    await t.pump();
    await t.pump();
    await t.tap(find.byKey(AppKeys.botChip)); // pause before its first tap
    await t.pump(const Duration(seconds: 2));
    expect(game(t).attempt.moves, 0);
    expect(chip(t), contains('Resume'));

    // The player clears a snake out of the stored order.
    final s = game(t);
    final sol = s.level.solution;
    final bloc = t.element(find.byKey(AppKeys.gameplayScreen)).read<GameBloc>();
    var own = -1;
    for (final token in sol.skip(1)) {
      final id = s.attempt.play.sim.snakeIndex(token);
      if (id >= 0) {
        final probe = s.attempt.tapSnake(id);
        if (probe.move.kind.name == 'exit') {
          own = id;
          break;
        }
      }
    }
    expect(own, greaterThanOrEqualTo(0));
    bloc.add(SnakeTapped(own));
    await until(t, () => game(t).status == GameStatus.playing && game(t).attempt.moves == 1);
    expect(game(t).attempt.history.first, isNot(sol.first));

    await t.tap(find.byKey(AppKeys.botChip));
    await until(t, () => game(t).status == GameStatus.won);
    expect(game(t).status, GameStatus.won);
    expect(game(t).attempt.heartsLost, 0);
    await stop(t);
  });

  testWidgets('Bots mode is hidden on the map unless asked for in the route', (t) async {
    await boot(t);
    GoRouter.of(t.element(find.byKey(AppKeys.homeScreen))).go('/play/1');
    await t.pumpAndSettle();
    expect(find.byKey(AppKeys.botChip), findsNothing);
  });
}
