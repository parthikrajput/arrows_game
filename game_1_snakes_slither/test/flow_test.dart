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
import 'package:snakes_slither/state/progress_cubit.dart';
import 'package:snakes_slither/state/wallet_cubit.dart';
import 'package:snakes_slither/ui/board/board_canvas.dart';

// These tests only use contract keys and real state, never on-screen text,
// so they keep passing whatever the UI looks like.

class InstantAds implements AdsService {
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
  });

  Future<void> boot(WidgetTester t) async {
    t.view.physicalSize = const Size(412 * 3, 915 * 3); // phone, portrait
    t.view.devicePixelRatio = 3;
    addTearDown(t.view.reset);
    await t.pumpWidget(SnakesSlitherApp(store: store, ads: InstantAds()));
    await t.pumpAndSettle();
  }

  testWidgets('Home → L1 → clear → Level Complete → 2X → Next', (t) async {
    await boot(t);
    expect(read<WalletCubit>(t, AppKeys.homeScreen).state.coins, 200);
    await go(t, AppKeys.homePlay);
    expect(read<GameBloc>(t, AppKeys.gameplayScreen).state.level.number, 1);

    // L1 (4x4): green tail at (0,1) heads right; blue head at (2,3) heads down.
    await tapCell(t, 0, 1, 4);
    expect(read<GameBloc>(t, AppKeys.gameplayScreen).state.attempt.moves, 1);
    await tapCell(t, 2, 3, 4);

    expect(find.byKey(AppKeys.completePopup), findsOneWidget);
    expect(read<GameBloc>(t, AppKeys.gameplayScreen).state.result!.stars, 3);
    expect(read<WalletCubit>(t, AppKeys.gameplayScreen).state.coins, 200 + 15 + 20);

    await go(t, AppKeys.claimDouble);
    expect(read<WalletCubit>(t, AppKeys.gameplayScreen).state.coins, 200 + 30 + 20);
    expect(find.byKey(AppKeys.claimDouble), findsNothing);

    await go(t, AppKeys.next);
    expect(read<GameBloc>(t, AppKeys.gameplayScreen).state.level.number, 2);
    expect(read<ProgressCubit>(t, AppKeys.gameplayScreen).state.highestCleared, 1);
  });

  testWidgets('3 bonks → Second Chance → No thanks → Failed → Try again', (t) async {
    await boot(t);
    GoRouter.of(t.element(find.byKey(AppKeys.homeScreen))).go('/play/2');
    await t.pumpAndSettle();

    // L2 (5x5): red head at (1,2) faces right into yellow at (3,2).
    for (var i = 0; i < 3; i++) {
      await tapCell(t, 1, 2, 5);
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
    await tapCell(t, 2, 3, 4);
    await t.pumpWidget(const SizedBox());
    await t.pumpWidget(SnakesSlitherApp(store: store, ads: InstantAds()));
    await t.pumpAndSettle();
    expect(read<ProgressCubit>(t, AppKeys.homeScreen).state.nextLevel, 2);
    expect(read<WalletCubit>(t, AppKeys.homeScreen).state.coins, 235);
  });

  testWidgets('Home → Shop → buy 1 Hint → back home', (t) async {
    await boot(t);
    await go(t, AppKeys.homeShop);
    expect(find.byKey(AppKeys.shopScreen), findsOneWidget);
    await go(t, AppKeys.shopTile('hint', 1));
    final w = read<WalletCubit>(t, AppKeys.shopScreen).state;
    expect((w.coins, w.count(Booster.hint)), (140, 1));
  });
}
