import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:puzzle_core/slither_engine.dart';
import 'package:snakes_slither/app/services.dart';
import 'package:snakes_slither/data/levels/level_repository.dart';
import 'package:snakes_slither/data/save/save_repository.dart';
import 'package:snakes_slither/services/ads_service.dart';
import 'package:snakes_slither/services/analytics.dart';
import 'package:snakes_slither/services/audio_service.dart';
import 'package:snakes_slither/services/haptics.dart';
import 'package:snakes_slither/services/store_service.dart';
import 'package:snakes_slither/services/time_service.dart';
import 'package:snakes_slither/state/ads_cubit.dart';
import 'package:snakes_slither/state/progress_cubit.dart';
import 'package:snakes_slither/state/spin_cubit.dart';
import 'package:snakes_slither/state/streak_cubit.dart';
import 'package:snakes_slither/state/wallet_cubit.dart';

class _FakeAds implements AdsService {
  @override
  bool rewardedAvailable = true;
  @override
  bool interstitialLoaded = true;
  int interstitials = 0;
  @override
  Future<bool> showRewarded(RewardedPlacement placement) async => true;
  @override
  Future<void> showInterstitial() async => interstitials++;
}

class _Clock {
  DateTime now = DateTime(2026, 10, 26, 9); // a Monday
}

AppServices _services(_Clock clock, {MemorySaveStore? store, _FakeAds? ads}) {
  final save = SaveRepository(store ?? MemorySaveStore());
  final key = GlobalKey<NavigatorState>();
  return AppServices(
    navigatorKey: key,
    save: save,
    time: TimeService(save, clock: () => clock.now),
    audio: AudioService(),
    haptics: Haptics(),
    analytics: Analytics(),
    ads: ads ?? _FakeAds(),
    store: SimulatedStoreService(key),
    levels: LevelRepository(),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('fresh install starts with 200 coins; spend fails when short', () {
    final w = WalletCubit(_services(_Clock()));
    expect(w.state.coins, 200);
    expect(w.spend('x', 500), isFalse);
    expect(w.spend('x', 120), isTrue);
    expect(w.state.coins, 80);
  });

  test('first clear pays by tag, +20 on first 3 stars only, replays pay 0', () {
    final p = ProgressCubit(_services(_Clock()));
    final first = p.levelWon(11, 2, LevelTag.hard);
    expect(first.clearCoins, 30);
    expect(first.starBonus, 0);
    final replay = p.levelWon(11, 3, LevelTag.hard);
    expect(replay.clearCoins, 0);
    expect(replay.starBonus, 20);
    final again = p.levelWon(11, 3, LevelTag.hard);
    expect(again.starBonus, 0);
    expect(p.state.starsOf(11), 3);
  });

  test('gift on x0, rush on L%25, chest on L500 — first clear only', () {
    final p = ProgressCubit(_services(_Clock()));
    final r50 = p.levelWon(50, 3, LevelTag.normal);
    expect(r50.giftDue && r50.rushDue, isTrue);
    expect(p.state.rushPendingLevel, 50);
    final replay = p.levelWon(50, 3, LevelTag.normal);
    expect(replay.giftDue || replay.rushDue, isFalse);
    final r500 = p.levelWon(500, 3, LevelTag.finale);
    expect(r500.chestDue && !r500.giftDue && r500.rushDue, isTrue);
  });

  test('ad revive is per level and resets when the level is cleared', () {
    final p = ProgressCubit(_services(_Clock()));
    p.markAdRevive('12');
    expect(p.adReviveUsed('12'), isTrue);
    p.levelWon(12, 1, LevelTag.normal);
    expect(p.adReviveUsed('12'), isFalse);
  });

  test('progress survives a restart through the save store', () {
    final store = MemorySaveStore();
    final clock = _Clock();
    ProgressCubit(_services(clock, store: store)).levelWon(7, 3, LevelTag.easy);
    final reloaded = ProgressCubit(_services(clock, store: store));
    expect(reloaded.state.highestCleared, 7);
    expect(reloaded.state.starsOf(7), 3);
  });

  test('corrupt save is restored from the backup', () async {
    final store = MemorySaveStore();
    final s = _services(_Clock(), store: store);
    ProgressCubit(s).levelWon(3, 3, LevelTag.easy);
    await s.save.backup();
    store.raw = '{not json';
    final repaired = _services(_Clock(), store: store);
    expect(repaired.save.recoveredFrom, 'backup');
    expect(ProgressCubit(repaired).state.highestCleared, 3);
  });

  group('interstitial', () {
    test('never before L11; first eligible on the 5th counted win (L15)', () {
      final ads = AdsCubit(_services(_Clock()));
      for (var l = 1; l <= 14; l++) {
        final w = WinContext(level: l);
        ads.recordWin(w);
        expect(ads.shouldShowInterstitial(w), isFalse, reason: 'L$l');
      }
      const w15 = WinContext(level: 15);
      ads.recordWin(w15);
      expect(ads.shouldShowInterstitial(w15), isTrue);
    });

    test('deferred on gift/rush wins; never for daily; cooldown 120 s', () async {
      final clock = _Clock();
      final fake = _FakeAds();
      final ads = AdsCubit(_services(clock, ads: fake));
      for (var i = 0; i < 5; i++) {
        ads.recordWin(WinContext(level: 11 + i));
      }
      expect(ads.shouldShowInterstitial(const WinContext(level: 20, hasGiftBasket: true)), isFalse);
      expect(ads.shouldShowInterstitial(const WinContext(level: 20, isDaily: true)), isFalse);
      await ads.showRewarded(RewardedPlacement.revive);
      expect(ads.shouldShowInterstitial(const WinContext(level: 21)), isFalse);
      clock.now = clock.now.add(const Duration(seconds: 121));
      await ads.maybeShowInterstitial(const WinContext(level: 21));
      expect(fake.interstitials, 1);
      expect(ads.state.winsSinceInterstitial, 0);
    });

    test('VIP turns interstitials off', () {
      final clock = _Clock();
      final ads = AdsCubit(_services(clock));
      for (var i = 0; i < 6; i++) {
        ads.recordWin(WinContext(level: 20 + i));
      }
      ads.setVipUntil(clock.now.toUtc().add(const Duration(days: 30)));
      expect(ads.shouldShowInterstitial(const WinContext(level: 30)), isFalse);
      expect(ads.bannerAllowed(level: 30), isFalse);
    });
  });

  group('streak', () {
    test('7 consecutive days walk the ladder, then a new cycle starts at Day 1', () {
      final streak = StreakCubit(_services(_Clock()));
      final coins = <int>[];
      for (var d = 0; d < 8; d++) {
        final key = '2026-11-${(d + 1).toString().padLeft(2, '0')}';
        coins.add(streak.onDailyClear(key)!.reward.coins);
      }
      expect(coins, [50, 75, 100, 150, 150, 200, 450, 50]);
      expect(streak.state.trophyTier, 1);
      expect(streak.state.totalDays, 8);
    });

    test('same day twice grants once', () {
      final streak = StreakCubit(_services(_Clock()));
      expect(streak.onDailyClear('2026-11-01'), isNotNull);
      expect(streak.onDailyClear('2026-11-01'), isNull);
    });

    test('one missed day: saver continues the streak, missed day not rewarded', () {
      final streak = StreakCubit(_services(_Clock()));
      for (var d = 1; d <= 4; d++) {
        streak.onDailyClear('2026-11-0$d');
      }
      expect(streak.state.saverOffered('2026-11-06'), isTrue);
      streak.useSaver('2026-11-06', via: 'coins');
      expect(streak.onDailyClear('2026-11-06')!.day, 5);
      // Saver already used this cycle ⇒ the next missed day resets.
      expect(streak.state.saverOffered('2026-11-08'), isFalse);
      expect(streak.onDailyClear('2026-11-08')!.day, 1);
    });

    test('two missed days reset to Day 1 without an offer', () {
      final streak = StreakCubit(_services(_Clock()));
      streak.onDailyClear('2026-11-01');
      streak.onDailyClear('2026-11-02');
      expect(streak.state.saverOffered('2026-11-05'), isFalse);
      expect(streak.onDailyClear('2026-11-05')!.day, 1);
    });
  });

  test('time-travel lock when the clock goes back more than 2 h', () async {
    final clock = _Clock();
    final s = _services(clock);
    await s.time.touch();
    clock.now = clock.now.subtract(const Duration(hours: 3));
    expect(s.time.timeTravelLocked, isTrue);
    clock.now = clock.now.add(const Duration(hours: 2));
    expect(s.time.timeTravelLocked, isFalse);
  });

  test('wheel results are deterministic and match the odds (±0.3%)', () {
    expect(SpinCubit.resultIndex('id', '2026-10-30', 0), SpinCubit.resultIndex('id', '2026-10-30', 0));
    final counts = List.filled(8, 0);
    const n = 100000;
    for (var i = 0; i < n; i++) {
      counts[SpinCubit.resultIndex('install$i', '2026-10-30', 0)]++;
    }
    const odds = [30.0, 25.0, 15.0, 12.0, 10.0, 5.0, 2.5, 0.5];
    for (var i = 0; i < 8; i++) {
      expect(counts[i] / n * 100, closeTo(odds[i], 0.3), reason: 'segment ${i + 1}');
    }
  });

  test('stand-in levels load for 1..500 and are solvable', () {
    final repo = LevelRepository();
    for (final l in [1, 2, 3, 10, 49, 100, 250, 499, 500]) {
      final def = repo.get(l);
      expect(def.snakes, isNotEmpty);
      expect(Solver.solve(def.toBoard()), isNotNull, reason: 'L$l');
    }
    expect(() => repo.get(501), throwsA(isA<LevelUnavailable>()));
  });
}
