import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/save_store.dart';
import '../services/time_guard.dart';
import 'ads_cubit.dart';
import 'progress_cubit.dart';
import 'rewards.dart';
import 'wallet_cubit.dart';

class WheelState extends Equatable {
  const WheelState({
    this.dayKey = '',
    this.freeUsed = false,
    this.adUsed = false,
    this.lastPrize,
    this.spinSeq = 0,
    this.busy = false,
  });
  final String dayKey;
  final bool freeUsed;
  final bool adUsed;

  /// Index into LuckyWheel.prizes of the latest spin (already granted).
  final int? lastPrize;

  /// Bumps with every spin so the UI animates even for the same prize.
  final int spinSeq;
  final bool busy;

  WheelState copyWith({bool? freeUsed, bool? adUsed, int? lastPrize, bool? busy}) => WheelState(
    dayKey: dayKey,
    freeUsed: freeUsed ?? this.freeUsed,
    adUsed: adUsed ?? this.adUsed,
    lastPrize: lastPrize ?? this.lastPrize,
    spinSeq: lastPrize != null ? spinSeq + 1 : spinSeq,
    busy: busy ?? this.busy,
  );

  @override
  List<Object?> get props => [dayKey, freeUsed, adUsed, lastPrize, spinSeq, busy];
}

/// Lucky Lily Wheel: 1 free + 1 ad spin per day, unlocked after clearing L10.
/// No way to buy spins (no real-money gambling).
class WheelCubit extends Cubit<WheelState> {
  WheelCubit(this._store, this._time, this._wallet, this._progress, this._ads)
    : super(_load(_store, _time));

  static const _key = 'wheel';
  static const unlockAfterLevel = 10;

  final SaveStore _store;
  final TimeGuard _time;
  final WalletCubit _wallet;
  final ProgressCubit _progress;
  final AdsCubit _ads;

  static WheelState _load(SaveStore s, TimeGuard t) {
    final j = s.read(_key) ?? const {};
    if (j['dayKey'] != t.dayKey()) return WheelState(dayKey: t.dayKey());
    return WheelState(
      dayKey: t.dayKey(),
      freeUsed: j['freeUsed'] as bool? ?? false,
      adUsed: j['adUsed'] as bool? ?? false,
    );
  }

  @override
  void onChange(Change<WheelState> change) {
    super.onChange(change);
    final s = change.nextState;
    _store.write(_key, {'dayKey': s.dayKey, 'freeUsed': s.freeUsed, 'adUsed': s.adUsed});
  }

  bool get unlocked => _progress.state.highestCleared >= unlockAfterLevel;
  bool get timeLocked => _time.isTimeTravel;
  // Read-only "still today?" checks, so screens can ask during build.
  bool get _today => state.dayKey == _time.dayKey();
  bool get freeUsedToday => _today && state.freeUsed;
  bool get adUsedToday => _today && state.adUsed;
  bool get freeAvailable => unlocked && !timeLocked && !freeUsedToday;
  bool get adAvailable =>
      unlocked && !timeLocked && freeUsedToday && !adUsedToday && _ads.rewardedReady;

  void refreshDay() {
    _time.observe();
    if (state.dayKey != _time.dayKey()) emit(WheelState(dayKey: _time.dayKey()));
  }

  /// Returns the prize index, or null when no spin was allowed.
  int? spinFree() {
    refreshDay();
    if (!freeAvailable || state.busy) return null;
    final i = _grant(spinIndex: 0);
    emit(state.copyWith(freeUsed: true, lastPrize: i));
    return i;
  }

  Future<int?> spinWithAd() async {
    refreshDay();
    if (!adAvailable || state.busy) return null;
    emit(state.copyWith(busy: true));
    final earned = await _ads.showRewarded('wheel_extra_spin');
    if (!earned) {
      emit(state.copyWith(busy: false));
      return null;
    }
    final i = _grant(spinIndex: 1);
    emit(state.copyWith(busy: false, adUsed: true, lastPrize: i));
    return i;
  }

  int _grant({required int spinIndex}) {
    final i = LuckyWheel.resultIndex(
      installId: _time.installId,
      dayKey: state.dayKey,
      spinIndex: spinIndex,
    );
    final p = LuckyWheel.prizes[i];
    if (p.booster != null) {
      _wallet.grantBooster(p.booster!, 1);
    } else {
      _wallet.earn(p.coins);
    }
    return i;
  }
}
