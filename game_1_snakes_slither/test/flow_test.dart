import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:puzzle_core/puzzle_core.dart';
import 'package:snakes_slither/app/app.dart';
import 'package:snakes_slither/contracts/app_keys.dart';
import 'package:snakes_slither/data/save_store.dart';
import 'package:snakes_slither/features/gameplay/game_bloc.dart';
import 'package:snakes_slither/services/ads_service.dart';
import 'package:snakes_slither/services/audio_service.dart';
import 'package:snakes_slither/state/compliance_cubit.dart';
import 'package:snakes_slither/state/progress_cubit.dart';
import 'package:snakes_slither/state/tutorial_cubit.dart';
import 'package:snakes_slither/state/wallet_cubit.dart';
import 'package:snakes_slither/ui/board/board_canvas.dart';

import 'helpers.dart';

// These tests only use contract keys and real state, never on-screen text,
// so they keep passing whatever the UI looks like.

class InstantAds extends AdsService {
  InstantAds({this.reward = true});
  bool reward;
  int interstitials = 0;
  @override
  bool get rewardedReady => true;
  @override
  bool get interstitialReady => true;
  @override
  Future<bool> showRewarded(String placement) async => reward;
  @override
  Future<bool> showInterstitial() async {
    interstitials++;
    return true;
  }
}

Future<void> tapCell(WidgetTester t, int x, int y, int columns) async {
  final f = find.byType(BoardCanvas);
  final origin = t.getTopLeft(f);
  final cell = t.getSize(f).width / columns;
  await t.tapAt(origin + Offset((x + .5) * cell, (y + .5) * cell));
  await t.pumpAndSettle();
}

Future<void> go(WidgetTester t, Key k) async {
  await t.tap(find.byKey(k));
  await t.pumpAndSettle();
}

T read<T extends StateStreamable<Object?>>(WidgetTester t, Key screen) =>
    t.element(find.byKey(screen)).read<T>();

void main() {
  late SaveStore store;
  setUp(() async {
    store = await SaveStore.at(Directory.systemTemp.createTempSync('flow').path);
    // Most flows start after the first-launch age question.
    await store.write('compliance', {'ageGateDone': true, 'underAge': false});
  });

  Future<void> boot(WidgetTester t) async {
    t.view.physicalSize = const Size(412 * 3, 915 * 3); // phone, portrait
    t.view.devicePixelRatio = 3;
    addTearDown(t.view.reset);
    // Looping decoration (bob, shine, glow) never settles; the UI turns it
    // off when the system asks for less motion, as players can.
    t.platformDispatcher.accessibilityFeaturesTestValue = const FakeAccessibilityFeatures(disableAnimations: true);
    addTearDown(t.platformDispatcher.clearAccessibilityFeaturesTestValue);
    await t.pumpWidget(
      SnakesSlitherApp(
        store: store,
        levels: testLevels(),
        ads: InstantAds(),
        audio: AudioService(enabled: false),
      ),
    );
    await t.pumpAndSettle();
  }

  testWidgets('Home → L1 → clear → Level Complete → 2X → Next', (t) async {
    await boot(t);
    expect(read<WalletCubit>(t, AppKeys.homeScreen).state.coins, 200);
    await go(t, AppKeys.homePlay);
    expect(read<GameBloc>(t, AppKeys.gameplayScreen).state.level.number, 1);

    // L1 (4x4): green tail at (0,1) heads right; yellow caterpillar head at (1,3) heads down.
    await tapCell(t, 0, 1, 4);
    expect(read<GameBloc>(t, AppKeys.gameplayScreen).state.attempt.moves, 1);
    await tapCell(t, 1, 3, 4);

    expect(find.byKey(AppKeys.completePopup), findsOneWidget);
    expect(read<GameBloc>(t, AppKeys.gameplayScreen).state.result!.stars, 3);
    expect(read<WalletCubit>(t, AppKeys.gameplayScreen).state.coins, 200 + 20 + 20);

    await go(t, AppKeys.claimDouble);
    expect(read<WalletCubit>(t, AppKeys.gameplayScreen).state.coins, 200 + 40 + 20);
    expect(find.byKey(AppKeys.claimDouble), findsNothing);

    await go(t, AppKeys.next);
    expect(read<GameBloc>(t, AppKeys.gameplayScreen).state.level.number, 2);
    expect(read<ProgressCubit>(t, AppKeys.gameplayScreen).state.highestCleared, 1);
  });

  testWidgets('3 bonks → Second Chance → No thanks → Failed → Try again', (t) async {
    await boot(t);
    GoRouter.of(t.element(find.byKey(AppKeys.homeScreen))).go('/play/2');
    await t.pumpAndSettle();

    // L2 (4x4): red head at (1,0) faces right into blue at (3,0).
    for (var i = 0; i < 3; i++) {
      await tapCell(t, 1, 0, 4);
    }
    expect(find.byKey(AppKeys.secondChancePopup), findsOneWidget);
    await go(t, AppKeys.noThanks);
    expect(find.byKey(AppKeys.failedPopup), findsOneWidget);
    await go(t, AppKeys.retry);
    final s = read<GameBloc>(t, AppKeys.gameplayScreen).state;
    expect((s.status, s.attempt.hearts, s.attempt.moves), (GameStatus.playing, 3, 0));
  });

  testWidgets('pause → resume, and long-press preview never counts as a move', (t) async {
    await boot(t);
    await go(t, AppKeys.homePlay);
    final f = find.byType(BoardCanvas);
    final cell = t.getSize(f).width / 4;
    final g = await t.startGesture(t.getTopLeft(f) + Offset(1.5 * cell, 1.5 * cell));
    await t.pump(const Duration(milliseconds: 400));
    expect(read<GameBloc>(t, AppKeys.gameplayScreen).state.preview, isNotNull);
    await g.up();
    await t.pumpAndSettle();
    final s = read<GameBloc>(t, AppKeys.gameplayScreen).state;
    expect((s.preview, s.attempt.moves), (null, 0));

    await go(t, AppKeys.pauseButton);
    expect(find.byKey(AppKeys.pausePopup), findsOneWidget);
    await go(t, AppKeys.resume);
    expect(find.byKey(AppKeys.pausePopup), findsNothing);
  });

  testWidgets('progress survives an app restart', (t) async {
    await boot(t);
    await go(t, AppKeys.homePlay);
    await tapCell(t, 0, 1, 4);
    await tapCell(t, 1, 3, 4);
    await t.pumpWidget(const SizedBox());
    await t.pumpWidget(
      SnakesSlitherApp(
        store: store,
        levels: testLevels(),
        ads: InstantAds(),
        audio: AudioService(enabled: false),
      ),
    );
    await t.pumpAndSettle();
    expect(read<ProgressCubit>(t, AppKeys.homeScreen).state.nextLevel, 2);
    expect(read<WalletCubit>(t, AppKeys.homeScreen).state.coins, 240);
  });

  testWidgets('Home → Shop → buy 1 Hint → back home', (t) async {
    // Hint unlocks at L3.
    final p = ProgressCubit(store);
    for (var n = 1; n <= 3; n++) {
      p.levelWon(n, 3);
    }
    await p.close();
    await boot(t);
    await go(t, AppKeys.homeShop);
    expect(find.byKey(AppKeys.shopScreen), findsOneWidget);
    await go(t, AppKeys.shopTile('hint', 1));
    final w = read<WalletCubit>(t, AppKeys.shopScreen).state;
    expect((w.coins, w.count(Booster.hint)), (140, 1));
  });

  testWidgets('L1 tutorial: only the glowing snake reacts, the tip finishes on the win', (t) async {
    await boot(t);
    await go(t, AppKeys.homePlay);
    expect(find.byKey(AppKeys.tutorialTip), findsOneWidget);
    final bloc = read<GameBloc>(t, AppKeys.gameplayScreen);
    final guide = bloc.state.solutionNextSnake!;
    final other = bloc.state.attempt.board.snakes.keys.firstWhere((k) => k != guide);
    bloc.add(SnakeTapped(other));
    await t.pumpAndSettle();
    expect(bloc.state.attempt.moves, 0, reason: 'not the glowing snake');
    for (var i = 0; i < 2; i++) {
      bloc.add(SnakeTapped(bloc.state.solutionNextSnake!));
      await t.pumpAndSettle();
    }
    expect(find.byKey(AppKeys.completePopup), findsOneWidget);
    expect(read<TutorialCubit>(t, AppKeys.gameplayScreen).state.has('1_tap_to_slither'), isTrue);
  });

  testWidgets('L11 shows the Garden Rock intro card once', (t) async {
    final p = ProgressCubit(store);
    for (var n = 1; n <= 10; n++) {
      p.levelWon(n, 3);
    }
    await p.close();
    await boot(t);
    GoRouter.of(t.element(find.byKey(AppKeys.homeScreen))).go('/play/11');
    await t.pumpAndSettle();
    expect(find.byKey(AppKeys.introCard), findsOneWidget);
    await go(t, AppKeys.introGotIt);
    expect(find.byKey(AppKeys.introCard), findsNothing);
    expect(read<TutorialCubit>(t, AppKeys.gameplayScreen).state.has('M001'), isTrue);
  });

  testWidgets('L3 hint tip points at the Firefly and ends when it is used', (t) async {
    final p = ProgressCubit(store);
    p.levelWon(1, 3);
    p.levelWon(2, 3);
    await p.close();
    GameBloc.useIsolateForHint = false;
    await boot(t);
    GoRouter.of(t.element(find.byKey(AppKeys.homeScreen))).go('/play/3');
    await t.pumpAndSettle();
    expect(find.byKey(AppKeys.tutorialTip), findsOneWidget);
    final bloc = read<GameBloc>(t, AppKeys.gameplayScreen);
    bloc.add(const BoosterPressed(Booster.hint));
    await t.pumpAndSettle();
    expect(bloc.state.hintSnakeId, isNotNull);
    expect(find.byKey(AppKeys.tutorialTip), findsNothing);
  });

  testWidgets('L25 win → Next → Golden Slither Rush → skip → Level 26', (t) async {
    final p = ProgressCubit(store);
    for (var n = 1; n <= 24; n++) {
      p.levelWon(n, 3);
    }
    await p.close();
    await boot(t);
    GoRouter.of(t.element(find.byKey(AppKeys.homeScreen))).go('/play/25');
    await t.pumpAndSettle();
    final bloc = read<GameBloc>(t, AppKeys.gameplayScreen);
    for (final id in bloc.state.level.solution) {
      final a = bloc.state.attempt;
      final s = a.play.sim.snakeIndex(id);
      bloc.add(s >= 0 ? SnakeTapped(s) : ObstacleTapped(a.play.sim.mechIndex(id)));
      await t.pumpAndSettle();
    }
    expect(find.byKey(AppKeys.completePopup), findsOneWidget);
    await go(t, AppKeys.next);
    expect(find.byKey(AppKeys.rushIntroDialog), findsOneWidget);
    // The round's clock runs every frame, so the screen never settles.
    await t.tap(find.byKey(AppKeys.rushIntroStart));
    await t.pump();
    await t.pump(const Duration(seconds: 4));
    await t.tap(find.byKey(AppKeys.rushSkipButton));
    await t.pump();
    await t.pump(const Duration(milliseconds: 500));
    expect(find.byKey(AppKeys.rushResultsDialog), findsOneWidget);
    await go(t, AppKeys.rushResultsContinue);
    expect(read<GameBloc>(t, AppKeys.gameplayScreen).state.level.number, 26);
  });

  testWidgets('first launch: neutral age gate, nothing pre-selected, then Home', (t) async {
    // Real disk I/O must run outside the test's fake clock.
    await t.runAsync(() => store.write('compliance', {'ageGateDone': false}));
    await boot(t);
    expect(find.byKey(AppKeys.ageGateScreen), findsOneWidget);
    expect(find.byKey(AppKeys.homeScreen), findsNothing);
    await t.tap(find.byKey(AppKeys.ageGateContinue));
    await t.pumpAndSettle();
    expect(find.byKey(AppKeys.ageGateScreen), findsOneWidget, reason: 'no year picked yet');
    await t.drag(find.byKey(AppKeys.ageGateWheel), const Offset(0, -260));
    await t.pumpAndSettle();
    await go(t, AppKeys.ageGateContinue);
    expect(find.byKey(AppKeys.homeScreen), findsOneWidget);
    expect(read<ComplianceCubit>(t, AppKeys.homeScreen).state.ageGateDone, isTrue);
  });

  testWidgets('Leaderboards show local stats from Home › Ranks', (t) async {
    final p = ProgressCubit(store);
    p.levelWon(1, 3);
    p.levelWon(2, 2);
    await p.close();
    await boot(t);
    await go(t, AppKeys.homeRanks);
    expect(find.byKey(AppKeys.leaderboardsScreen), findsOneWidget);
    expect(find.text('2'), findsWidgets);
    await go(t, AppKeys.leaderboardTab('stars'));
    expect(find.text('5'), findsOneWidget);
  });
}
