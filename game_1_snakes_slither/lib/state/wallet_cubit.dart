import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:puzzle_core/puzzle_core.dart';

import '../data/save_store.dart';
import 'economy.dart';

class WalletState extends Equatable {
  const WalletState({
    this.coins = Economy.startingCoins,
    this.boosters = const {},
    this.grantsGiven = const {},
  });

  final int coins;
  final Map<Booster, int> boosters;

  /// Tutorial grants already paid, so replays never pay twice.
  final Set<Booster> grantsGiven;

  int count(Booster b) => boosters[b] ?? 0;

  Map<String, dynamic> toJson() => {
    'coins': coins,
    'boosters': {for (final e in boosters.entries) e.key.name: e.value},
    'grantsGiven': [for (final b in grantsGiven) b.name],
  };

  factory WalletState.fromJson(Map<String, dynamic> j) => WalletState(
    coins: j['coins'] as int? ?? Economy.startingCoins,
    boosters: {
      for (final e in ((j['boosters'] as Map?) ?? {}).entries)
        Booster.values.byName(e.key as String): e.value as int,
    },
    grantsGiven: {
      for (final n in ((j['grantsGiven'] as List?) ?? [])) Booster.values.byName(n as String),
    },
  );

  WalletState copyWith({int? coins, Map<Booster, int>? boosters, Set<Booster>? grantsGiven}) =>
      WalletState(
        coins: coins ?? this.coins,
        boosters: boosters ?? this.boosters,
        grantsGiven: grantsGiven ?? this.grantsGiven,
      );

  @override
  List<Object?> get props => [coins, boosters, grantsGiven];
}

class WalletCubit extends Cubit<WalletState> {
  WalletCubit(this._store) : super(_load(_store));

  static const _key = 'wallet';
  final SaveStore _store;

  static WalletState _load(SaveStore s) {
    final j = s.read(_key);
    return j == null ? const WalletState() : WalletState.fromJson(j);
  }

  @override
  void onChange(Change<WalletState> change) {
    super.onChange(change);
    _store.write(_key, change.nextState.toJson());
  }

  void earn(int n) {
    if (n <= 0) return;
    emit(state.copyWith(coins: state.coins + n));
  }

  /// False (and no change) when the player can't afford it.
  bool spend(int n) {
    if (n > state.coins) return false;
    emit(state.copyWith(coins: state.coins - n));
    return true;
  }

  bool consumeBooster(Booster b) {
    if (state.count(b) <= 0) return false;
    emit(state.copyWith(boosters: {...state.boosters, b: state.count(b) - 1}));
    return true;
  }

  void grantBooster(Booster b, int n) =>
      emit(state.copyWith(boosters: {...state.boosters, b: state.count(b) + n}));

  bool buyBooster(Booster b, {required bool pack}) {
    final price = (pack ? Economy.packPrice : Economy.singlePrice)[b]!;
    if (!spend(price)) return false;
    grantBooster(b, pack ? 3 : 1);
    return true;
  }

  /// Pays the booster tutorial grant once, when its unlock level is reached.
  void grantTutorialBoosters(int level) {
    for (final b in Booster.values) {
      if (level >= Economy.unlockLevel[b]! && !state.grantsGiven.contains(b)) {
        emit(
          state.copyWith(
            boosters: {...state.boosters, b: state.count(b) + Economy.tutorialGrant[b]!},
            grantsGiven: {...state.grantsGiven, b},
          ),
        );
      }
    }
  }
}
