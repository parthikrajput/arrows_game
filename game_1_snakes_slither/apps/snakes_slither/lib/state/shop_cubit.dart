import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../app/services.dart';
import '../services/remote_config.dart';
import '../services/store_service.dart';
import 'ads_cubit.dart';
import 'wallet_cubit.dart';

enum StoreLoad { loading, ready, unavailable }

class ShopState extends Equatable {
  const ShopState({
    this.load = StoreLoad.loading,
    this.products = const [],
    this.starterWindowEndUtc,
    this.starterPurchased = false,
    this.starterPopupShown = false,
    this.busySku,
  });

  final StoreLoad load;
  final List<StoreProduct> products;
  final DateTime? starterWindowEndUtc;
  final bool starterPurchased;
  final bool starterPopupShown;
  final String? busySku;

  StoreProduct? product(String sku) {
    for (final p in products) {
      if (p.sku == sku) return p;
    }
    return null;
  }

  bool starterAvailable(DateTime now) =>
      !starterPurchased && starterWindowEndUtc != null && now.toUtc().isBefore(starterWindowEndUtc!);

  ShopState copyWith({
    StoreLoad? load,
    List<StoreProduct>? products,
    DateTime? starterWindowEndUtc,
    bool? starterPurchased,
    bool? starterPopupShown,
    String? Function()? busySku,
  }) =>
      ShopState(
        load: load ?? this.load,
        products: products ?? this.products,
        starterWindowEndUtc: starterWindowEndUtc ?? this.starterWindowEndUtc,
        starterPurchased: starterPurchased ?? this.starterPurchased,
        starterPopupShown: starterPopupShown ?? this.starterPopupShown,
        busySku: busySku != null ? busySku() : this.busySku,
      );

  Map<String, Object?> toJson() => {
        'starterWindowEndUtc': starterWindowEndUtc?.toIso8601String(),
        'starterPurchased': starterPurchased,
        'starterPopupShown': starterPopupShown,
      };

  @override
  List<Object?> get props => [load, products.length, starterWindowEndUtc, starterPurchased, starterPopupShown, busySku];
}

/// Shop, IAP grants (idempotent), Starter Pack window, VIP and restore.
class ShopCubit extends Cubit<ShopState> {
  ShopCubit(this._s, this._wallet, this._ads) : super(_initial(_s));

  final AppServices _s;
  final WalletCubit _wallet;
  final AdsCubit _ads;

  static ShopState _initial(AppServices s) {
    final j = s.save.section('iap');
    return ShopState(
      starterWindowEndUtc: DateTime.tryParse((j['starterWindowEndUtc'] as String?) ?? ''),
      starterPurchased: (j['starterPurchased'] as bool?) ?? false,
      starterPopupShown: (j['starterPopupShown'] as bool?) ?? false,
    );
  }

  Future<void> loadProducts() async {
    if (state.load == StoreLoad.ready) return;
    emit(state.copyWith(load: StoreLoad.loading));
    try {
      final products = await _s.store.loadProducts();
      emit(state.copyWith(load: StoreLoad.ready, products: products));
    } catch (_) {
      emit(state.copyWith(load: StoreLoad.unavailable));
    }
  }

  /// Opens the 48 h Starter Pack window once, after the L15 clear.
  void openStarterWindowIfDue(int highestCleared) {
    if (state.starterWindowEndUtc != null || highestCleared < _s.config.dailyUnlockLevel) return;
    _set(state.copyWith(
      starterWindowEndUtc: _s.time.now().toUtc().add(Duration(hours: _s.config.starterWindowHours)),
    ));
  }

  void markStarterPopupShown() => _set(state.copyWith(starterPopupShown: true));

  Future<PurchaseStatus> buy(String sku) async {
    final product = state.product(sku);
    if (product == null || state.busySku != null) return PurchaseStatus.error;
    emit(state.copyWith(busySku: () => sku));
    final status = await _s.store.buy(product);
    emit(state.copyWith(busySku: () => null));
    if (status == PurchaseStatus.purchased) _grant(product);
    return status;
  }

  void _grant(StoreProduct p) {
    switch (p.sku) {
      case 'starter_pack':
        _wallet.earn('iap_starter', 800);
        _wallet.grantBooster(BoosterType.hint, 3);
        _wallet.grantBooster(BoosterType.hammer, 2);
        _wallet.grantBooster(BoosterType.shield, 2);
        _set(state.copyWith(starterPurchased: true));
      case 'vip_monthly':
        _ads.setVipUntil(_s.time.now().toUtc().add(const Duration(days: 30)));
      default:
        _wallet.earn('iap_${p.sku}', p.coins);
    }
    _s.analytics.event('iap_purchase', {'sku': p.sku});
  }

  /// Returns true when anything was restored.
  Future<bool> restore() async {
    final owned = await _s.store.restore();
    if (owned.contains('vip_monthly') && !_ads.vipActive) {
      _ads.setVipUntil(_s.time.now().toUtc().add(const Duration(days: 30)));
    }
    if (owned.contains('starter_pack')) _set(state.copyWith(starterPurchased: true));
    return owned.isNotEmpty;
  }

  void _set(ShopState next) {
    emit(next);
    _s.save.write('iap', next.toJson());
  }
}
