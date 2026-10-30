import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:puzzle_core/puzzle_core.dart';
import 'package:snakes_slither/data/save_store.dart';
import 'package:snakes_slither/features/gameplay/game_bloc.dart';
import 'package:snakes_slither/services/ads_service.dart';
import 'package:snakes_slither/services/time_guard.dart';
import 'package:snakes_slither/state/ads_cubit.dart';
import 'package:snakes_slither/state/progress_cubit.dart';
import 'package:snakes_slither/state/rewards.dart';
import 'package:snakes_slither/state/shop_cubit.dart';
import 'package:snakes_slither/state/wallet_cubit.dart';
import 'package:snakes_slither/state/wheel_cubit.dart';

import 'helpers.dart';

class FakeClock implements Clock {
  FakeClock(this.t);
  DateTime t;
  @override
  DateTime now() => t;
  void advance(Duration d) => t = t.add(d);
}

class CountingAds implements AdsService {
  bool ready = true;
  bool reward = true;
  int interstitials = 0;
  @override
  bool get rewardedReady => ready;
  @override
  bool get interstitialReady => ready;
  @override
  Future<bool> showRewarded(String placement) async => reward;
  @override
  Future<bool> showInterstitial() async {
    interstitials++;
    return true;
  }
}

late SaveStore store;
late FakeClock clock;
late TimeGuard time;
late CountingAds net;
late AdsCubit ads;
late WalletCubit wallet;
late ProgressCubit progress;

void clearUpTo(int level) {
  for (var n = 1; n <= level; n++) {
    progress.levelWon(n, 3);
  }
}

void main() {
  setUp(() async {
    store = await SaveStore.at(Directory.systemTemp.createTempSync('meta').path);
    clock = FakeClock(DateTime(2026, 10, 30, 10));
    time = TimeGuard(store, clock);
    net = CountingAds();
    ads = AdsCubit(store, net, time);
    wallet = WalletCubit(store);
    progress = ProgressCubit(store);
  });

  group('Gift Basket', () {
    test('every 10th level, coins by tier, booster rotation, chest at 500', () {
      expect(Rewards.basketFor(9), isNull);
      expect(Rewards.basketFor(10)!.boosters, {Booster.hint: 1});
      expect(Rewards.basketFor(20)!.boosters, {Booster.hammer: 1});
      expect(Rewards.basketFor(30)!.boosters, {Booster.shield: 1});
      expect([100, 110, 210, 310, 410, 490].map((l) => Rewards.basketFor(l)!.coins), [
        150,
        180,
        210,
        250,
        300,
        300,
      ]);
      final chest = Rewards.basketFor(500)!;
      expect((chest.coins, chest.isChest), (1000, true));
      expect(chest.boosters.values, everyElement(2));
    });

    test('a level-10 first clear grants the basket once, replay grants nothing', () async {
      // Level 1's board stands in for level 10 (the real L10 isn't built yet).
      final l10 = Level(number: 10, tag: LevelTag.normal, board: testLevels().load(1).board);
      Future<GameBloc> win() async {
        final b = GameBloc(
          level: l10,
          wallet: wallet,
          progress: progress,
          ads: ads,
          hasNextLevel: true,
        );
        for (final id in [0, 1]) {
          b.add(SnakeTapped(id));
          await pumpEventQueue();
          b.add(AnimationCompleted(b.state.motion!.id));
          await pumpEventQueue();
        }
        return b;
      }

      final before = wallet.state.coins;
      final first = await win();
      expect(first.state.result!.gift!.coins, 150);
      expect(wallet.state.coins, before + 20 + 20 + 150);
      // 3 from the one-time Hint tutorial grant (L3+) + 1 from the basket.
      expect(wallet.state.count(Booster.hint), 4);
      final replay = await win();
      expect(replay.state.result!.gift, isNull);
      expect(wallet.state.count(Booster.hint), 4);
    });
  });

  group('Interstitial rules', () {
    const w = WinContext(level: 15);

    void wins(int n, {int level = 15}) {
      for (var i = 0; i < n; i++) {
        ads.recordWin(WinContext(level: level));
      }
    }

    test('never for levels 1–10; first eligible on the 5th win from L11', () {
      wins(10, level: 10);
      expect(ads.state.winsSinceInterstitial, 0);
      wins(4);
      expect(ads.shouldShowInterstitial(w), isFalse);
      wins(1);
      expect(ads.shouldShowInterstitial(w), isTrue);
    });

    test('shown resets the counter; 120 s cooldown applies', () async {
      wins(5);
      await ads.maybeShowInterstitial(w);
      expect((net.interstitials, ads.state.winsSinceInterstitial), (1, 0));
      wins(5);
      clock.advance(const Duration(seconds: 119));
      expect(ads.shouldShowInterstitial(w), isFalse);
      clock.advance(const Duration(seconds: 1));
      expect(ads.shouldShowInterstitial(w), isTrue);
    });

    test('a rewarded ad also starts the cooldown', () async {
      wins(5);
      await ads.showRewarded('win_2x');
      expect(ads.shouldShowInterstitial(w), isFalse);
    });

    test('Gift Basket, Rush, Chest, Daily defer; VIP blocks all', () {
      wins(5);
      expect(ads.shouldShowInterstitial(const WinContext(level: 20, hasGiftBasket: true)), isFalse);
      expect(ads.shouldShowInterstitial(const WinContext(level: 25, hasRush: true)), isFalse);
      expect(ads.shouldShowInterstitial(const WinContext(level: 15, isDaily: true)), isFalse);
      expect(ads.state.winsSinceInterstitial, 5, reason: 'deferred wins stay counted');
      ads.setVipUntil(clock.now().toUtc().add(const Duration(days: 30)));
      expect(ads.shouldShowInterstitial(w), isFalse);
    });

    test('daily cap 20, resets at midnight', () async {
      for (var i = 0; i < 20; i++) {
        wins(5);
        clock.advance(const Duration(minutes: 3));
        await ads.maybeShowInterstitial(w);
      }
      expect(net.interstitials, 20);
      wins(5);
      clock.advance(const Duration(minutes: 3));
      expect(ads.shouldShowInterstitial(w), isFalse);
      clock.t = DateTime(2026, 10, 31, 9);
      expect(ads.shouldShowInterstitial(w), isTrue);
    });
  });

  group('Shop', () {
    ShopCubit shop() => ShopCubit(store, time, wallet, progress, ads);

    test('locked boosters cannot be bought before their unlock level', () {
      // Debug builds unlock all boosters for testing, so check the real rule directly.
      final s = shop();
      expect(s.buyBooster(Booster.hint, pack: false), BuyResult.ok);
      expect(wallet.state.coins, 200 - 60);
      expect(s.buyBooster(Booster.hammer, pack: true), BuyResult.notEnoughCoins);
    });

    test('free coins: +50, 5 per day, resets next day, skipped ad pays nothing', () async {
      final s = shop();
      net.reward = false;
      expect(await s.watchForFreeCoins(), 0);
      net.reward = true;
      for (var i = 0; i < 5; i++) {
        expect(await s.watchForFreeCoins(), 50);
      }
      expect(await s.watchForFreeCoins(), 0);
      expect(wallet.state.coins, 200 + 250);
      clock.t = DateTime(2026, 10, 31, 8);
      expect(s.freeCoinsLeftToday, 5);
      expect(await s.watchForFreeCoins(), 50);
    });
  });

  group('Lucky Lily Wheel', () {
    WheelCubit wheel() => WheelCubit(store, time, wallet, progress, ads);

    test('weights total 1000 and match the published odds', () {
      expect(LuckyWheel.prizes.fold<int>(0, (a, p) => a + p.weight), 1000);
      expect(LuckyWheel.prizes.map((p) => p.odds), [.30, .25, .15, .12, .10, .05, .025, .005]);
    });

    test('result is fixed for install + day + spin, and roughly matches the odds', () {
      int r(String day, int i) =>
          LuckyWheel.resultIndex(installId: 'abc', dayKey: day, spinIndex: i);
      expect(r('2026-10-30', 0), r('2026-10-30', 0));
      final counts = List.filled(8, 0);
      for (var d = 0; d < 20000; d++) {
        counts[LuckyWheel.resultIndex(installId: 'i$d', dayKey: 'x', spinIndex: 0)]++;
      }
      expect(counts[0] / 20000, closeTo(.30, .02));
      expect(counts[7] / 20000, closeTo(.005, .003));
    });

    test('locked until L10 is cleared', () {
      clearUpTo(9);
      expect(wheel().spinFree(), isNull);
      clearUpTo(10);
      expect(wheel().spinFree(), isNotNull);
    });

    test('1 free + 1 ad spin per day, prize granted, new day resets', () async {
      clearUpTo(10);
      final w = wheel();
      final coins = wallet.state.coins;
      final i = w.spinFree()!;
      final p = LuckyWheel.prizes[i];
      if (p.booster == null) expect(wallet.state.coins, coins + p.coins);
      expect(w.spinFree(), isNull);
      expect(await w.spinWithAd(), isNotNull);
      expect(await w.spinWithAd(), isNull);
      clock.t = DateTime(2026, 10, 31, 7);
      expect(w.freeAvailable, isTrue);
      expect(w.spinFree(), isNotNull);
    });

    test('winding the clock back locks the wheel until time catches up', () {
      clearUpTo(10);
      time.observe();
      clock.t = DateTime(2026, 10, 29, 10); // 24 h back
      final w = wheel();
      expect((w.timeLocked, w.spinFree()), (true, null));
      clock.t = DateTime(2026, 10, 30, 9); // within 2 h tolerance
      expect(w.timeLocked, isFalse);
    });
  });

  test('install id is stable across app restarts', () {
    expect(TimeGuard(store, clock).installId, time.installId);
  });
}
