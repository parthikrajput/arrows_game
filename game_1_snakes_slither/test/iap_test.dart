import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:puzzle_core/puzzle_core.dart';
import 'package:snakes_slither/data/save_store.dart';
import 'package:snakes_slither/services/store_service.dart';
import 'package:snakes_slither/services/time_guard.dart';
import 'package:snakes_slither/state/ads_cubit.dart';
import 'package:snakes_slither/state/iap_cubit.dart';
import 'package:snakes_slither/state/progress_cubit.dart';
import 'package:snakes_slither/state/wallet_cubit.dart';

import 'game_bloc_test.dart' show InstantAds;

class FakeClock implements Clock {
  DateTime t = DateTime(2026, 11, 1, 10);
  @override
  DateTime now() => t;
}

/// Answers with whatever the test sets.
class ScriptedVerifier implements PurchaseVerifier {
  Verification answer = const Verification(valid: true);
  int calls = 0;
  @override
  Future<Verification> verify(StorePurchase p) async {
    calls++;
    return answer;
  }
}

void main() {
  late SaveStore save;
  late FakeClock clock;
  late TimeGuard time;
  late WalletCubit wallet;
  late ProgressCubit progress;
  late AdsCubit ads;
  late FakeStoreService store;
  late ScriptedVerifier verifier;

  setUp(() async {
    save = await SaveStore.at(Directory.systemTemp.createTempSync('iap').path);
    clock = FakeClock();
    time = TimeGuard(save, clock);
    wallet = WalletCubit(save);
    progress = ProgressCubit(save);
    ads = AdsCubit(save, InstantAds(), time);
    store = FakeStoreService();
    verifier = ScriptedVerifier();
  });

  Future<IapCubit> iap() async {
    final c = IapCubit(save, store, verifier, time, wallet, progress, ads);
    await c.init();
    return c;
  }

  test('coin pack is granted once, even if the store replays it', () async {
    final c = await iap();
    expect(c.state.available, isTrue);
    final before = wallet.state.coins;
    await c.buy(StoreIds.coinsM);
    await pumpEventQueue();
    expect(wallet.state.coins, before + 1000);
    expect(store.completed, hasLength(1));
    // Same purchase arriving again (e.g. after a crash) pays nothing.
    await store.restore();
    final again = StorePurchase(
      productId: StoreIds.coinsM,
      purchaseId: c.state.granted.first,
      status: StorePurchaseStatus.purchased,
      receipt: 'r',
      source: 'fake',
    );
    expect(c.state.granted.contains(again.purchaseId), isTrue);
    expect(wallet.state.coins, before + 1000);
  });

  test('an unverified purchase waits and is granted on a later launch', () async {
    verifier.answer = const Verification(valid: false, retryLater: true);
    var c = await iap();
    final before = wallet.state.coins;
    await c.buy(StoreIds.coinsS);
    await pumpEventQueue();
    expect(wallet.state.coins, before, reason: 'never trust the device');
    expect(c.state.pending, hasLength(1));
    await c.close();

    verifier.answer = const Verification(valid: true);
    c = await iap(); // next launch retries the saved purchase
    expect(wallet.state.coins, before + 350);
    expect(c.state.pending, isEmpty);
  });

  test('a rejected receipt grants nothing', () async {
    verifier.answer = const Verification(valid: false);
    final c = await iap();
    final before = wallet.state.coins;
    await c.buy(StoreIds.coinsXl);
    await pumpEventQueue();
    expect(wallet.state.coins, before);
    expect(c.state.pending, isEmpty);
  });

  test('Starter Pack: offered 48 h after the first L15 clear, bought once', () async {
    final c = await iap();
    expect(c.starterLeft(), isNull);
    for (var n = 1; n <= 15; n++) {
      progress.levelWon(n, 3);
    }
    await pumpEventQueue();
    expect(c.starterLeft(), const Duration(hours: 48));
    clock.t = clock.t.add(const Duration(hours: 47));
    expect(c.starterLeft(), const Duration(hours: 1));
    final coins = wallet.state.coins;
    await c.buy(StoreIds.starterPack);
    await pumpEventQueue();
    expect(wallet.state.coins, coins + 800);
    expect(wallet.state.count(Booster.hint), greaterThanOrEqualTo(3));
    expect(c.starterLeft(), isNull, reason: 'one time only');
  });

  test('Starter Pack window closes after 48 h', () async {
    final c = await iap();
    for (var n = 1; n <= 15; n++) {
      progress.levelWon(n, 3);
    }
    await pumpEventQueue();
    clock.t = clock.t.add(const Duration(hours: 49));
    expect(c.starterLeft(), isNull);
    await c.buy(StoreIds.starterPack);
    await pumpEventQueue();
    expect(c.state.starterBought, isFalse);
  });

  test('VIP turns ads off until the verified expiry; restore brings it back', () async {
    final expiry = clock.t.toUtc().add(const Duration(days: 30));
    verifier.answer = Verification(valid: true, expiresUtc: expiry);
    final c = await iap();
    await c.buy(StoreIds.vipMonthly);
    await pumpEventQueue();
    expect(ads.vipActive, isTrue);
    ads.setVipUntil(null);
    expect(ads.vipActive, isFalse);
    await c.restore();
    await pumpEventQueue();
    expect(ads.vipActive, isTrue);
  });
}
