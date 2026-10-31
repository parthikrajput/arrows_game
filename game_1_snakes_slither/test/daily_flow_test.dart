import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snakes_slither/contracts/app_keys.dart';
import 'package:snakes_slither/contracts/view_models.dart';
import 'package:snakes_slither/data/daily_level_factory.dart';
import 'package:snakes_slither/data/save_store.dart';
import 'package:snakes_slither/services/ads_service.dart';
import 'package:snakes_slither/services/time_guard.dart';
import 'package:snakes_slither/state/ads_cubit.dart';
import 'package:snakes_slither/state/daily_cubit.dart';
import 'package:snakes_slither/state/streak_cubit.dart';
import 'package:snakes_slither/state/wallet_cubit.dart';
import 'package:snakes_slither/ui/popups/daily_result_popup.dart';
import 'package:snakes_slither/ui/popups/streak_saver_dialog.dart';
import 'package:snakes_slither/ui/screens/daily_screen.dart';

class _FakeClock implements Clock {
  _FakeClock(this.current);
  DateTime current;
  @override
  DateTime now() => current;
}

void main() {
  late Directory temp;

  setUp(() async {
    temp = await Directory.systemTemp.createTemp('daily_flow_test_');
  });

  tearDown(() async {
    try {
      await temp.delete(recursive: true);
    } catch (_) {}
  });

  group('DailyLevelFactory Tests', () {
    test('Builds valid deterministic levels for all 7 weekdays', () {
      final base = DateTime(2026, 11, 2); // Monday
      for (var i = 0; i < 7; i++) {
        final d = base.add(Duration(days: i));
        final dayKey = '2026-11-0${2 + i}';
        final level = DailyLevelFactory.buildDailyLevel(
          dayKey: dayKey,
          date: d,
          modifier: DailyModifier.classic,
          highestCleared: 20,
        );

        expect(level.board.width, equals(7));
        expect(level.board.height, equals(7));
        expect(level.board.snakes.isNotEmpty, isTrue);
        expect(level.parMoves, greaterThan(0));
        expect(level.solution.isNotEmpty, isTrue);
      }
    });

    test('Big Board modifier generates 8x8 grid on Saturday', () {
      final saturday = DateTime(2026, 11, 7);
      final level = DailyLevelFactory.buildDailyLevel(
        dayKey: '2026-11-07',
        date: saturday,
        modifier: DailyModifier.bigBoard,
        highestCleared: 50,
      );

      expect(level.board.width, equals(8));
      expect(level.board.height, equals(8));
      expect(level.board.snakes.length, equals(10));
    });
  });

  group('StreakCubit declineSaver test', () {
    test('declineSaver resets currentDay to 1 and clears offer', () async {
      final store = await SaveStore.at(temp.path);
      final clock = _FakeClock(DateTime(2026, 11, 1));
      final time = TimeGuard(store, clock);
      final wallet = WalletCubit(store);
      final ads = AdsCubit(store, FakeAdsService(), time);
      final streak = StreakCubit(store, time, wallet, ads);

      // Clear Day 1
      streak.onDailyCompleted();
      expect(streak.state.currentDay, equals(2));

      // Fast forward 2 days (missed 1 day: Nov 2 missed, now Nov 3)
      clock.current = DateTime(2026, 11, 3);
      final streak2 = StreakCubit(store, time, wallet, ads);
      expect(streak2.state.hasSaverOffer, isTrue);
      expect(streak2.state.currentDay, equals(2));

      // Decline saver
      streak2.declineSaver();
      expect(streak2.state.hasSaverOffer, isFalse);
      expect(streak2.state.currentDay, equals(1));
    });
  });

  group('UI Screens & Popups Tests', () {
    testWidgets('DailyScreen renders 7-day ladder and triggers onPlay', (tester) async {
      tester.view.physicalSize = const Size(400, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      var played = false;
      var saverOpened = false;

      final data = DailyData(
        dayTitle: 'Monday · Classic',
        modifierLabel: 'Classic',
        modifierDescription: 'Standard rules',
        currentStreakDays: 3,
        currentCycleDay: 4,
        clearCoinsReward: 100,
        completedToday: false,
        saverAvailable: true,
        saverStatus: 'Offer waiting · Tap',
        trophyTierLabel: '🥉 Bronze Coil',
        timeLeft: '6h 12m left',
        ladderCoins: const [50, 75, 100, 150, 150, 200, 450],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: DailyScreen(
            data: data,
            onPlay: () => played = true,
            onBack: () {},
            onOpenSaver: () => saverOpened = true,
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 600));

      expect(find.byKey(AppKeys.dailyScreen), findsOneWidget);
      expect(find.text('Daily Jungle Puzzle'), findsOneWidget);
      expect(find.text('🔥 3 days'), findsOneWidget);
      expect(find.text('6h 12m left'), findsOneWidget);

      // Check ladder steps D1 to D7 exist
      for (var i = 1; i <= 7; i++) {
        expect(find.text('D$i'), findsOneWidget);
      }

      // Tap Play button
      await tester.tap(find.byKey(AppKeys.dailyPlay));
      await tester.pump(const Duration(milliseconds: 200));
      expect(played, isTrue);

      // Tap Streak Saver card
      await tester.ensureVisible(find.byKey(AppKeys.dailySaver));
      await tester.pump(const Duration(milliseconds: 100));
      await tester.tap(find.byKey(AppKeys.dailySaver));
      await tester.pump(const Duration(milliseconds: 200));
      expect(saverOpened, isTrue);
    });

    testWidgets('DailyResultPopup renders stamped badge and triggers onCollect', (tester) async {
      tester.view.physicalSize = const Size(400, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      var collected = false;

      const data = DailyResultData(
        dayTitle: 'TUESDAY · PAR MOVES',
        stars: 3,
        moves: 8,
        parMoves: 9,
        clearCoins: 100,
        streakDay: 4,
        streakCoins: 150,
        stampedDate: '31 Oct',
        tomorrowRewardText: 'Tomorrow: Day 5 · 150 coins + 1 Safety Shell',
        nextDailyTimeLeft: '9 h 41 m',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DailyResultPopup(
              data: data,
              onCollect: () => collected = true,
            ),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 600));

      expect(find.byKey(AppKeys.dailyResultPopup), findsOneWidget);
      expect(find.text('Daily Jungle Puzzle\ncleared!'), findsOneWidget);
      expect(find.text('Stamped 31 Oct'), findsOneWidget);
      expect(find.text('8 moves · par 9'), findsOneWidget);
      expect(find.text('+100 coins'), findsOneWidget);
      expect(find.text('+150 coins'), findsOneWidget);
      expect(find.text('Next Daily in 9 h 41 m'), findsOneWidget);

      await tester.tap(find.byKey(AppKeys.dailyResultCollect));
      await tester.pump(const Duration(milliseconds: 200));
      expect(collected, isTrue);
    });

    testWidgets('StreakSaverDialog triggers watch ad, coins, and decline', (tester) async {
      tester.view.physicalSize = const Size(400, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      var adTapped = false;
      var coinsTapped = false;
      var declined = false;

      const data = StreakSaverData(
        currentStreakDays: 3,
        nextDayNumber: 4,
        nextDayCoins: 150,
        nextDayBoosterText: '',
        coinCost: 200,
        canAffordCoins: true,
        adAvailable: true,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StreakSaverDialog(
              data: data,
              onWatchAd: () => adTapped = true,
              onSaveWithCoins: () => coinsTapped = true,
              onDecline: () => declined = true,
            ),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 600));

      expect(find.byKey(AppKeys.saverPopup), findsOneWidget);
      expect(find.text('Save your streak?'), findsOneWidget);

      // Tap Watch ad
      await tester.tap(find.byKey(AppKeys.saverWatchAd));
      await tester.pump(const Duration(milliseconds: 200));
      expect(adTapped, isTrue);

      // Tap Save for 200 coins
      await tester.tap(find.byKey(AppKeys.saverCoins));
      await tester.pump(const Duration(milliseconds: 200));
      expect(coinsTapped, isTrue);

      // Tap Decline
      await tester.tap(find.byKey(AppKeys.saverDecline));
      await tester.pump(const Duration(milliseconds: 200));
      expect(declined, isTrue);
    });
  });
}
