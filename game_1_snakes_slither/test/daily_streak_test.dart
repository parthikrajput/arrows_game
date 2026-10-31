import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:puzzle_core/puzzle_core.dart';
import 'package:snakes_slither/data/save_store.dart';
import 'package:snakes_slither/services/ads_service.dart';
import 'package:snakes_slither/services/time_guard.dart';
import 'package:snakes_slither/state/ads_cubit.dart';
import 'package:snakes_slither/state/daily_cubit.dart';
import 'package:snakes_slither/state/progress_cubit.dart';
import 'package:snakes_slither/state/streak_cubit.dart';
import 'package:snakes_slither/state/wallet_cubit.dart';

class _FakeClock implements Clock {
  DateTime _now;
  _FakeClock(this._now);
  @override
  DateTime now() => _now;
  void advance(Duration d) => _now = _now.add(d);
}

void main() {
  late Directory temp;

  setUp(() async {
    temp = await Directory.systemTemp.createTemp('daily_streak_test_');
  });

  tearDown(() async {
    try {
      await temp.delete(recursive: true);
    } catch (_) {}
  });

  test('Daily challenge unlocks only after main Level 15', () async {
    final store = await SaveStore.at(temp.path);
    final clock = _FakeClock(DateTime(2026, 11, 2, 10, 0)); // Monday
    final time = TimeGuard(store, clock);
    final progress = ProgressCubit(store);
    final wallet = WalletCubit(store);
    final ads = AdsCubit(store, FakeAdsService(), time);
    final streak = StreakCubit(store, time, wallet, ads);
    final daily = DailyCubit(store, time, progress, wallet, streak);

    expect(daily.state.unlocked, isFalse);

    // Progress up to Level 15
    for (int i = 1; i <= 15; i++) {
      progress.levelWon(i, 3);
    }
    daily.checkUnlock();
    expect(daily.state.unlocked, isTrue);
  });

  test('Weekday modifiers map properly according to schedule', () async {
    final store = await SaveStore.at(temp.path);
    // Monday
    final monClock = _FakeClock(DateTime(2026, 11, 2, 10, 0));
    final time = TimeGuard(store, monClock);
    final progress = ProgressCubit(store);
    final wallet = WalletCubit(store);
    final ads = AdsCubit(store, FakeAdsService(), time);
    final streak = StreakCubit(store, time, wallet, ads);

    var daily = DailyCubit(store, time, progress, wallet, streak);
    expect(daily.state.modifier, equals(DailyModifier.classic));

    // Wednesday -> One Heart
    final wedClock = _FakeClock(DateTime(2026, 11, 4, 10, 0));
    final wedTime = TimeGuard(store, wedClock);
    daily = DailyCubit(store, wedTime, progress, wallet, streak);
    expect(daily.state.modifier, equals(DailyModifier.oneHeart));
    expect(daily.state.initialHearts, equals(1));
  });

  test('7-Day Streak ladder advances on daily clear and grants proper rewards', () async {
    final store = await SaveStore.at(temp.path);
    final clock = _FakeClock(DateTime(2026, 11, 2, 10, 0));
    final time = TimeGuard(store, clock);
    final wallet = WalletCubit(store);
    final ads = AdsCubit(store, FakeAdsService(), time);
    final streak = StreakCubit(store, time, wallet, ads);

    final initialCoins = wallet.state.coins;

    // Day 1 completion -> +50 coins
    final r1 = streak.onDailyCompleted();
    expect(r1?.coins, equals(50));
    expect(streak.state.currentDay, equals(2));
    expect(streak.state.totalStreakDays, equals(1));
    expect(wallet.state.coins, equals(initialCoins + 50));

    // Calling again same day does nothing
    final rDup = streak.onDailyCompleted();
    expect(rDup, isNull);

    // Advance to next day (Day 2)
    clock.advance(const Duration(days: 1));
    final r2 = streak.onDailyCompleted();
    expect(r2?.coins, equals(75));
    expect(streak.state.currentDay, equals(3));
    expect(streak.state.totalStreakDays, equals(2));

    // Advance to Day 3 -> +100 coins and 1 Hint booster
    clock.advance(const Duration(days: 1));
    final r3 = streak.onDailyCompleted();
    expect(r3?.coins, equals(100));
    expect(r3?.booster, equals(Booster.hint));
    expect(wallet.state.count(Booster.hint), equals(1));
  });

  test('Streak Saver Leaf triggers on exactly 1 day missed and can be saved with coins', () async {
    final store = await SaveStore.at(temp.path);
    final clock = _FakeClock(DateTime(2026, 11, 2, 10, 0));
    final time = TimeGuard(store, clock);
    final wallet = WalletCubit(store);
    final ads = AdsCubit(store, FakeAdsService(), time);
    var streak = StreakCubit(store, time, wallet, ads);

    // Clear Day 1
    streak.onDailyCompleted();
    expect(streak.state.currentDay, equals(2));

    // Miss 1 full day (advance by 2 days)
    clock.advance(const Duration(days: 2));

    // Reload cubit to trigger load check
    streak = StreakCubit(store, time, wallet, ads);
    expect(streak.state.hasSaverOffer, isTrue);

    // Save with 200 coins
    final saved = streak.saveStreakWithCoins();
    expect(saved, isTrue);
    expect(streak.state.hasSaverOffer, isFalse);
    expect(streak.state.cycleSaverUsed, isTrue);
    expect(streak.state.currentDay, equals(2)); // streak preserved!
  });
}
