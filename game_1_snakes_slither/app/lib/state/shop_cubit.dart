import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:puzzle_core/puzzle_core.dart';

import '../data/save_store.dart';
import '../services/time_guard.dart';
import 'ads_cubit.dart';
import 'economy.dart';
import 'progress_cubit.dart';
import 'wallet_cubit.dart';

class ShopState extends Equatable {
  const ShopState({this.dayKey = '', this.freeCoinsUsed = 0, this.busy = false});
  final String dayKey;
  final int freeCoinsUsed;

  /// A rewarded ad is showing.
  final bool busy;

  int get freeCoinsLeft => ShopCubit.freeCoinsPerDay - freeCoinsUsed;

  ShopState copyWith({String? dayKey, int? freeCoinsUsed, bool? busy}) => ShopState(
    dayKey: dayKey ?? this.dayKey,
    freeCoinsUsed: freeCoinsUsed ?? this.freeCoinsUsed,
    busy: busy ?? this.busy,
  );

  @override
  List<Object?> get props => [dayKey, freeCoinsUsed, busy];
}

enum BuyResult { ok, locked, notEnoughCoins }

/// Coin side of the Shop (Boosters tab + free coins). Store purchases (Coins
/// and Offers tabs) come with the IAP milestone.
class ShopCubit extends Cubit<ShopState> {
  ShopCubit(this._store, this._time, this._wallet, this._progress, this._ads)
    : super(_load(_store, _time));

  static const _key = 'shop';
  static const freeCoinsPerDay = 5;
  static const freeCoinsAmount = 50;

  final SaveStore _store;
  final TimeGuard _time;
  final WalletCubit _wallet;
  final ProgressCubit _progress;
  final AdsCubit _ads;

  static ShopState _load(SaveStore s, TimeGuard t) {
    final j = s.read(_key) ?? const {};
    final st = ShopState(
      dayKey: j['dayKey'] as String? ?? '',
      freeCoinsUsed: j['freeCoinsUsed'] as int? ?? 0,
    );
    return st.dayKey == t.dayKey() ? st : ShopState(dayKey: t.dayKey());
  }

  @override
  void onChange(Change<ShopState> change) {
    super.onChange(change);
    _store.write(_key, {
      'dayKey': change.nextState.dayKey,
      'freeCoinsUsed': change.nextState.freeCoinsUsed,
    });
  }

  /// Resets the daily counter when the date has rolled over.
  void refreshDay() {
    final key = _time.dayKey();
    if (state.dayKey != key) emit(ShopState(dayKey: key));
  }

  /// Read-only, safe to call while building a screen.
  int get freeCoinsLeftToday =>
      state.dayKey == _time.dayKey() ? state.freeCoinsLeft : freeCoinsPerDay;

  /// Boosters can't be bought before their unlock level ("Unlocks at L15").
  bool isLocked(Booster b) => !Economy.isUnlocked(b, _progress.state.nextLevel);

  BuyResult buyBooster(Booster b, {required bool pack}) {
    if (isLocked(b)) return BuyResult.locked;
    return _wallet.buyBooster(b, pack: pack) ? BuyResult.ok : BuyResult.notEnoughCoins;
  }

  /// Returns coins granted (0 when not available or the ad was skipped).
  Future<int> watchForFreeCoins() async {
    refreshDay();
    if (state.busy || freeCoinsLeftToday <= 0 || !_ads.rewardedReady) return 0;
    emit(state.copyWith(busy: true));
    final earned = await _ads.showRewarded('shop_free_coins');
    if (!earned) {
      emit(state.copyWith(busy: false));
      return 0;
    }
    _wallet.earn(freeCoinsAmount);
    emit(state.copyWith(busy: false, freeCoinsUsed: state.freeCoinsUsed + 1));
    return freeCoinsAmount;
  }
}
