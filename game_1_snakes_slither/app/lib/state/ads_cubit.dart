import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/save_store.dart';
import '../services/ads_service.dart';
import '../services/time_guard.dart';

class AdsState extends Equatable {
  const AdsState({
    this.winsSinceInterstitial = 0,
    this.lastFullscreenUtc,
    this.interstitialsToday = 0,
    this.dayKey = '',
    this.vipActiveUntil,
  });

  final int winsSinceInterstitial;
  final DateTime? lastFullscreenUtc;
  final int interstitialsToday;
  final String dayKey;

  /// Set from a validated subscription receipt (IAP milestone).
  final DateTime? vipActiveUntil;

  bool vipActiveAt(DateTime now) => vipActiveUntil != null && now.isBefore(vipActiveUntil!);

  Map<String, dynamic> toJson() => {
    'wins': winsSinceInterstitial,
    'lastFullscreenUtc': lastFullscreenUtc?.toIso8601String(),
    'today': interstitialsToday,
    'dayKey': dayKey,
    'vipActiveUntil': vipActiveUntil?.toIso8601String(),
  };

  factory AdsState.fromJson(Map<String, dynamic> j) => AdsState(
    winsSinceInterstitial: j['wins'] as int? ?? 0,
    lastFullscreenUtc: DateTime.tryParse(j['lastFullscreenUtc'] as String? ?? ''),
    interstitialsToday: j['today'] as int? ?? 0,
    dayKey: j['dayKey'] as String? ?? '',
    vipActiveUntil: DateTime.tryParse(j['vipActiveUntil'] as String? ?? ''),
  );

  AdsState copyWith({
    int? wins,
    DateTime? lastFullscreenUtc,
    int? today,
    String? dayKey,
    DateTime? Function()? vipActiveUntil,
  }) => AdsState(
    winsSinceInterstitial: wins ?? winsSinceInterstitial,
    lastFullscreenUtc: lastFullscreenUtc ?? this.lastFullscreenUtc,
    interstitialsToday: today ?? interstitialsToday,
    dayKey: dayKey ?? this.dayKey,
    vipActiveUntil: vipActiveUntil != null ? vipActiveUntil() : this.vipActiveUntil,
  );

  @override
  List<Object?> get props => [
    winsSinceInterstitial,
    lastFullscreenUtc,
    interstitialsToday,
    dayKey,
    vipActiveUntil,
  ];
}

/// Where a win happened, so interstitials respect the "never surprise" rules.
class WinContext {
  const WinContext({
    required this.level,
    this.isDaily = false,
    this.isRush = false,
    this.hasGiftBasket = false,
    this.hasRush = false,
    this.hasChest = false,
  });
  final int level;
  final bool isDaily;
  final bool isRush;
  final bool hasGiftBasket;
  final bool hasRush;
  final bool hasChest;
  bool get countsTowardCadence => level > AdsCubit.noAdsUpToLevel && !isDaily && !isRush;
}

/// Interstitial cadence, cooldown, daily cap and VIP. Rewarded ads also go
/// through here so the cooldown sees every full-screen ad.
class AdsCubit extends Cubit<AdsState> {
  AdsCubit(this._store, this._ads, this._time) : super(_load(_store));

  static const _key = 'ads';
  static const noAdsUpToLevel = 10;
  static const winsPerInterstitial = 5;
  static const cooldown = Duration(seconds: 120);
  static const dailyCap = 20;

  final SaveStore _store;
  final AdsService _ads;
  final TimeGuard _time;

  static AdsState _load(SaveStore s) {
    final j = s.read(_key);
    return j == null ? const AdsState() : AdsState.fromJson(j);
  }

  @override
  void onChange(Change<AdsState> change) {
    super.onChange(change);
    _store.write(_key, change.nextState.toJson());
  }

  DateTime get _now => _time.clock.now().toUtc();
  bool get vipActive => state.vipActiveAt(_now);

  AdsState _rolled() {
    final key = _time.dayKey();
    return state.dayKey == key ? state : state.copyWith(dayKey: key, today: 0);
  }

  /// Count a numbered win. A deferred win stays in the counter.
  void recordWin(WinContext w) {
    if (!w.countsTowardCadence) return;
    emit(state.copyWith(wins: state.winsSinceInterstitial + 1));
  }

  bool shouldShowInterstitial(WinContext w) {
    final s = _rolled();
    if (vipActive) return false;
    if (!w.countsTowardCadence) return false;
    if (w.hasGiftBasket || w.hasRush || w.hasChest) return false;
    if (s.winsSinceInterstitial < winsPerInterstitial) return false;
    final last = s.lastFullscreenUtc;
    if (last != null && _now.difference(last) < cooldown) return false;
    if (s.interstitialsToday >= dailyCap) return false;
    return _ads.interstitialReady;
  }

  /// Runs after "Next" on Level Complete, before the next level loads.
  Future<void> maybeShowInterstitial(WinContext w) async {
    if (!shouldShowInterstitial(w)) return;
    final shown = await _ads.showInterstitial();
    if (!shown) return;
    final s = _rolled();
    emit(s.copyWith(wins: 0, today: s.interstitialsToday + 1, lastFullscreenUtc: _now));
  }

  /// Every rewarded ad goes through here. True only when the reward was earned.
  Future<bool> showRewarded(String placement) async {
    if (!_ads.rewardedReady) return false;
    final earned = await _ads.showRewarded(placement);
    emit(state.copyWith(lastFullscreenUtc: _now));
    return earned;
  }

  bool get rewardedReady => _ads.rewardedReady;

  /// Called by the IAP layer with a validated expiry (null = not subscribed).
  void setVipUntil(DateTime? until) => emit(state.copyWith(vipActiveUntil: () => until));
}
