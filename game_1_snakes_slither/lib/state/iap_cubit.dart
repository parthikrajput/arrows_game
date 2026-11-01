import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:puzzle_core/puzzle_core.dart';

import '../data/save_store.dart';
import '../logging/app_logger.dart';
import '../services/store_service.dart';
import '../services/time_guard.dart';
import 'ads_cubit.dart';
import 'progress_cubit.dart';
import 'wallet_cubit.dart';

/// What each store product grants.
class StoreCatalog {
  const StoreCatalog._();
  static const coins = {
    StoreIds.coinsS: 350,
    StoreIds.coinsM: 1000,
    StoreIds.coinsL: 2200,
    StoreIds.coinsXl: 5500,
  };
  static const starterCoins = 800;
  static const starterBoosters = {Booster.hint: 3, Booster.hammer: 2, Booster.shield: 2};

  /// Starter Pack is offered for 48 h after the first L15 clear.
  static const starterWindow = Duration(hours: 48);
  static const starterUnlockLevel = 15;
}

class IapState extends Equatable {
  const IapState({
    this.available = false,
    this.prices = const {},
    this.busy,
    this.granted = const {},
    this.starterBought = false,
    this.starterStartUtc,
    this.pending = const [],
    this.message,
  });

  /// Store reachable and products loaded.
  final bool available;
  final Map<String, String> prices;

  /// Product being bought right now.
  final String? busy;

  /// Purchase ids already delivered.
  final Set<String> granted;
  final bool starterBought;
  final DateTime? starterStartUtc;

  /// Purchases waiting for server verification (saved across launches).
  final List<Map<String, String>> pending;

  /// One-off note for the UI ("Purchases restored", "Verifying…").
  final String? message;

  IapState copyWith({
    bool? available,
    Map<String, String>? prices,
    String? Function()? busy,
    Set<String>? granted,
    bool? starterBought,
    DateTime? Function()? starterStartUtc,
    List<Map<String, String>>? pending,
    String? Function()? message,
  }) => IapState(
    available: available ?? this.available,
    prices: prices ?? this.prices,
    busy: busy != null ? busy() : this.busy,
    granted: granted ?? this.granted,
    starterBought: starterBought ?? this.starterBought,
    starterStartUtc: starterStartUtc != null ? starterStartUtc() : this.starterStartUtc,
    pending: pending ?? this.pending,
    message: message != null ? message() : this.message,
  );

  @override
  List<Object?> get props => [available, prices, busy, granted, starterBought, starterStartUtc, pending, message];
}

/// Store purchases: coin packs, the one-time Starter Pack and the VIP No-Ads
/// Pass. Nothing is granted until the receipt is verified on the server;
/// purchases that can't be verified yet are kept and retried on next launch.
class IapCubit extends Cubit<IapState> {
  IapCubit(
    this._save,
    this._store,
    this._verifier,
    this._time,
    this._wallet,
    this._progress,
    this._ads, {
    this.onTrack,
  }) : super(_load(_save)) {
    _progressSub = _progress.stream.listen((p) => _maybeOpenStarter(p.highestCleared));
    _maybeOpenStarter(_progress.state.highestCleared);
  }

  static const _key = 'iap';
  final SaveStore _save;
  final StoreService _store;
  final PurchaseVerifier _verifier;
  final TimeGuard _time;
  final WalletCubit _wallet;
  final ProgressCubit _progress;
  final AdsCubit _ads;
  final void Function(String name, Map<String, Object> params)? onTrack;
  StreamSubscription<List<StorePurchase>>? _sub;
  StreamSubscription<ProgressState>? _progressSub;

  static IapState _load(SaveStore s) {
    final j = s.read(_key) ?? const {};
    return IapState(
      granted: {...((j['granted'] as List?) ?? const []).cast<String>()},
      starterBought: j['starterBought'] as bool? ?? false,
      starterStartUtc: DateTime.tryParse(j['starterStartUtc'] as String? ?? '')?.toUtc(),
      pending: [
        for (final p in (j['pending'] as List?) ?? const []) (p as Map).cast<String, String>(),
      ],
    );
  }

  @override
  void onChange(Change<IapState> change) {
    super.onChange(change);
    final s = change.nextState;
    _save.write(_key, {
      'granted': s.granted.toList()..sort(),
      'starterBought': s.starterBought,
      'starterStartUtc': s.starterStartUtc?.toIso8601String(),
      'pending': s.pending,
    });
  }

  /// Connects to the store (deferred until after the first frame).
  Future<void> init() async {
    _sub ??= _store.purchases.listen(_onPurchases);
    try {
      if (!await _store.isAvailable()) return;
      final products = await _store.products(StoreIds.all);
      emit(state.copyWith(available: products.isNotEmpty, prices: {for (final p in products) p.id: p.price}));
    } catch (e) {
      AppLogger.instance.warn('iap', LogCodes.iapPurchaseError, 'store init failed', {'error': '$e'});
    }
    await retryPending();
  }

  void _maybeOpenStarter(int highest) {
    if (highest >= StoreCatalog.starterUnlockLevel && state.starterStartUtc == null && !state.starterBought) {
      emit(state.copyWith(starterStartUtc: () => _time.clock.now().toUtc()));
    }
  }

  /// Time left on the Starter Pack offer, or null when it isn't offered.
  Duration? starterLeft() {
    final start = state.starterStartUtc;
    if (start == null || state.starterBought) return null;
    final left = start.add(StoreCatalog.starterWindow).difference(_time.clock.now().toUtc());
    return left.isNegative ? null : left;
  }

  Future<void> buy(String productId) async {
    if (!state.available || state.busy != null || !state.prices.containsKey(productId)) return;
    if (productId == StoreIds.starterPack && starterLeft() == null) return;
    if (productId == StoreIds.vipMonthly && _ads.vipActive) return;
    emit(state.copyWith(busy: () => productId, message: () => null));
    try {
      await _store.buy(productId, consumable: StoreIds.consumables.contains(productId));
    } catch (e) {
      AppLogger.instance.error('iap', LogCodes.iapPurchaseError, 'buy failed', {'product': productId, 'error': '$e'});
      emit(state.copyWith(busy: () => null, message: () => 'Purchase failed. Please try again.'));
    }
  }

  Future<void> restore() async {
    emit(state.copyWith(message: () => null));
    try {
      await _store.restore();
      emit(state.copyWith(message: () => 'Purchases restored'));
    } catch (e) {
      AppLogger.instance.error('iap', LogCodes.iapRestoreFailure, 'restore failed', {'error': '$e'});
      emit(state.copyWith(message: () => 'Could not restore purchases. Check your connection.'));
    }
  }

  Future<void> _onPurchases(List<StorePurchase> list) async {
    for (final p in list) {
      switch (p.status) {
        case StorePurchaseStatus.pending:
          emit(state.copyWith(message: () => 'Waiting for the store…'));
        case StorePurchaseStatus.error || StorePurchaseStatus.canceled:
          emit(state.copyWith(busy: () => null));
          await _store.complete(p);
        case StorePurchaseStatus.purchased || StorePurchaseStatus.restored:
          await _handle(p);
      }
    }
  }

  Future<void> _handle(StorePurchase p) async {
    if (state.granted.contains(p.purchaseId)) {
      await _store.complete(p);
      emit(state.copyWith(busy: () => null));
      return;
    }
    final v = await _verifier.verify(p);
    if (v.valid) {
      _grant(p, v);
      await _store.complete(p);
    } else if (v.retryLater) {
      final keep = {'productId': p.productId, 'purchaseId': p.purchaseId, 'receipt': p.receipt, 'source': p.source};
      final pending = [
        for (final x in state.pending)
          if (x['purchaseId'] != p.purchaseId) x,
        keep,
      ];
      emit(state.copyWith(pending: pending, busy: () => null, message: () => 'Your purchase will arrive once it is verified.'));
    } else {
      AppLogger.instance.error('iap', LogCodes.iapVerificationFailure, 'receipt rejected', {'product': p.productId});
      await _store.complete(p);
      emit(state.copyWith(busy: () => null, message: () => 'This purchase could not be verified.'));
    }
  }

  /// Verifies purchases saved from earlier launches.
  Future<void> retryPending() async {
    for (final x in List.of(state.pending)) {
      final p = StorePurchase(
        productId: x['productId']!,
        purchaseId: x['purchaseId']!,
        status: StorePurchaseStatus.purchased,
        receipt: x['receipt'] ?? '',
        source: x['source'] ?? '',
      );
      if (state.granted.contains(p.purchaseId)) continue;
      final v = await _verifier.verify(p);
      if (v.valid) _grant(p, v);
      if (v.valid || !v.retryLater) {
        emit(state.copyWith(pending: [for (final y in state.pending) if (y['purchaseId'] != p.purchaseId) y]));
      }
    }
  }

  void _grant(StorePurchase p, Verification v) {
    final coins = StoreCatalog.coins[p.productId];
    var starter = state.starterBought;
    if (coins != null) {
      _wallet.earn(coins);
      onTrack?.call('coins_earn', {'source': 'iap', 'amount': coins});
    } else if (p.productId == StoreIds.starterPack) {
      if (!state.starterBought) {
        _wallet.earn(StoreCatalog.starterCoins);
        StoreCatalog.starterBoosters.forEach(_wallet.grantBooster);
      }
      starter = true;
    } else if (p.productId == StoreIds.vipMonthly) {
      _ads.setVipUntil(v.expiresUtc ?? _time.clock.now().toUtc().add(const Duration(days: 30)));
    }
    onTrack?.call('iap_purchase', {'product': p.productId, 'restored': p.status == StorePurchaseStatus.restored ? 1 : 0});
    emit(
      state.copyWith(
        granted: {...state.granted, p.purchaseId},
        starterBought: starter,
        busy: () => null,
        pending: [for (final y in state.pending) if (y['purchaseId'] != p.purchaseId) y],
        message: () => p.status == StorePurchaseStatus.restored ? 'Purchases restored' : 'Thank you!',
      ),
    );
  }

  @override
  Future<void> close() async {
    await _sub?.cancel();
    await _progressSub?.cancel();
    return super.close();
  }
}
