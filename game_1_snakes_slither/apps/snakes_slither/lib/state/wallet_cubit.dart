import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../app/services.dart';
import '../services/remote_config.dart';

class WalletState extends Equatable {
  const WalletState({required this.coins, required this.boosters});

  final int coins;
  final Map<BoosterType, int> boosters;

  int count(BoosterType t) => boosters[t] ?? 0;

  Map<String, Object?> toJson() => {
        'coins': coins,
        'boosters': {for (final e in boosters.entries) e.key.name: e.value},
      };

  static WalletState fromJson(Map<String, Object?> j, int startingCoins) {
    final b = ((j['boosters'] as Map?) ?? const {}).cast<String, Object?>();
    return WalletState(
      coins: (j['coins'] as int?) ?? startingCoins,
      boosters: {for (final t in BoosterType.values) t: (b[t.name] as int?) ?? 0},
    );
  }

  @override
  List<Object?> get props => [coins, boosters.entries.map((e) => '${e.key.name}:${e.value}').join()];
}

/// Coins and booster inventory. Every change is written through immediately.
class WalletCubit extends Cubit<WalletState> {
  WalletCubit(this._s) : super(WalletState.fromJson(_s.save.section('wallet'), _s.config.startingCoins)) {
    if (_s.save.section('wallet').isEmpty) _persist();
  }

  final AppServices _s;

  void earn(String source, int n) {
    if (n <= 0) return;
    emit(WalletState(coins: state.coins + n, boosters: state.boosters));
    _s.analytics.event('coins_earn', {'source': source, 'amount': n});
    _persist();
  }

  bool canAfford(int n) => state.coins >= n;

  bool spend(String sink, int n) {
    if (state.coins < n) return false;
    emit(WalletState(coins: state.coins - n, boosters: state.boosters));
    _s.analytics.event('coins_spend', {'sink': sink, 'amount': n});
    _persist();
    return true;
  }

  void grantBooster(BoosterType t, [int n = 1]) {
    emit(WalletState(coins: state.coins, boosters: {...state.boosters, t: state.count(t) + n}));
    _persist();
  }

  bool consumeBooster(BoosterType t) {
    if (state.count(t) <= 0) return false;
    emit(WalletState(coins: state.coins, boosters: {...state.boosters, t: state.count(t) - 1}));
    _persist();
    return true;
  }

  /// Buys [n] boosters for [price] coins in one step.
  bool buyBooster(BoosterType t, int n, int price) {
    if (!spend('booster_${t.name}_$n', price)) return false;
    grantBooster(t, n);
    return true;
  }

  void _persist() => _s.save.write('wallet', state.toJson());
}
