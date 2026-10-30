import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../app/services.dart';
import '../services/ads_service.dart';

/// Context of a win, used to decide (or defer) the interstitial.
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

  bool get deferred => hasGiftBasket || hasRush || hasChest;
}

class AdsState extends Equatable {
  const AdsState({
    this.vipActiveUntil,
    this.winsSinceInterstitial = 0,
    this.lastFullscreenUtc,
    this.interstitialsToday = 0,
    this.shopAdsToday = 0,
    this.spinAdsToday = 0,
    this.dayKey = '',
  });

  final DateTime? vipActiveUntil;
  final int winsSinceInterstitial;
  final DateTime? lastFullscreenUtc;
  final int interstitialsToday;
  final int shopAdsToday;
  final int spinAdsToday;
  final String dayKey;

  bool vipActive(DateTime now) => vipActiveUntil != null && now.toUtc().isBefore(vipActiveUntil!);

  AdsState copyWith({
    DateTime? Function()? vipActiveUntil,
    int? winsSinceInterstitial,
    DateTime? lastFullscreenUtc,
    int? interstitialsToday,
    int? shopAdsToday,
    int? spinAdsToday,
    String? dayKey,
  }) =>
      AdsState(
        vipActiveUntil: vipActiveUntil != null ? vipActiveUntil() : this.vipActiveUntil,
        winsSinceInterstitial: winsSinceInterstitial ?? this.winsSinceInterstitial,
        lastFullscreenUtc: lastFullscreenUtc ?? this.lastFullscreenUtc,
        interstitialsToday: interstitialsToday ?? this.interstitialsToday,
        shopAdsToday: shopAdsToday ?? this.shopAdsToday,
        spinAdsToday: spinAdsToday ?? this.spinAdsToday,
        dayKey: dayKey ?? this.dayKey,
      );

  Map<String, Object?> toJson() => {
        'vipActiveUntil': vipActiveUntil?.toIso8601String(),
        'winsSinceInterstitial': winsSinceInterstitial,
        'lastFullscreenUtc': lastFullscreenUtc?.toIso8601String(),
        'interstitialsToday': interstitialsToday,
        'dailyShopAds': shopAdsToday,
        'dailySpinAds': spinAdsToday,
        'dayKey': dayKey,
      };

  static AdsState fromJson(Map<String, Object?> j) => AdsState(
        vipActiveUntil: DateTime.tryParse((j['vipActiveUntil'] as String?) ?? ''),
        winsSinceInterstitial: (j['winsSinceInterstitial'] as int?) ?? 0,
        lastFullscreenUtc: DateTime.tryParse((j['lastFullscreenUtc'] as String?) ?? ''),
        interstitialsToday: (j['interstitialsToday'] as int?) ?? 0,
        shopAdsToday: (j['dailyShopAds'] as int?) ?? 0,
        spinAdsToday: (j['dailySpinAds'] as int?) ?? 0,
        dayKey: (j['dayKey'] as String?) ?? '',
      );

  @override
  List<Object?> get props =>
      [vipActiveUntil, winsSinceInterstitial, lastFullscreenUtc, interstitialsToday, shopAdsToday, spinAdsToday, dayKey];
}

/// Ad counters, cooldown and VIP. All rules from the ads spec live here.
class AdsCubit extends Cubit<AdsState> {
  AdsCubit(this._s) : super(AdsState.fromJson(_s.save.section('ads'))) {
    rollDay();
  }

  final AppServices _s;

  bool get vipActive => state.vipActive(_s.time.now());

  /// Banners show on Home, Level Map and gameplay from L11, never for VIP.
  bool bannerAllowed({int? level}) => !vipActive && (level == null || level >= _s.config.interstitialMinLevel);

  bool get rewardedAvailable => _s.ads.rewardedAvailable;

  int get shopAdsLeft => (_s.config.shopAdDailyMax - state.shopAdsToday).clamp(0, 99);
  int get spinAdsLeft => (1 - state.spinAdsToday).clamp(0, 1);

  /// Resets per-day counters when the local day changes.
  void rollDay() {
    final key = _s.time.dayKey();
    if (state.dayKey != key) {
      _set(state.copyWith(dayKey: key, interstitialsToday: 0, shopAdsToday: 0, spinAdsToday: 0));
    }
  }

  void setVipUntil(DateTime? until) => _set(state.copyWith(vipActiveUntil: () => until));

  /// Reward only when the ad reports it was earned.
  Future<bool> showRewarded(RewardedPlacement placement) async {
    rollDay();
    if (!_s.ads.rewardedAvailable) return false;
    final earned = await _s.ads.showRewarded(placement);
    var next = state.copyWith(lastFullscreenUtc: _s.time.now().toUtc());
    if (earned && placement == RewardedPlacement.shopCoins) next = next.copyWith(shopAdsToday: state.shopAdsToday + 1);
    if (earned && placement == RewardedPlacement.extraSpin) next = next.copyWith(spinAdsToday: state.spinAdsToday + 1);
    _set(next);
    _s.analytics.event('ad_show', {'format': 'rewarded', 'placement': placement.name});
    return earned;
  }

  /// Counts the win and decides whether an interstitial is due.
  bool shouldShowInterstitial(WinContext w) {
    rollDay();
    final cfg = _s.config;
    if (vipActive) return false;
    if (w.level < cfg.interstitialMinLevel || w.isDaily || w.isRush) return false;
    if (w.deferred) return false;
    if (state.winsSinceInterstitial < cfg.interstitialEveryWins) return false;
    final last = state.lastFullscreenUtc;
    if (last != null && _s.time.now().toUtc().difference(last).inSeconds < cfg.interstitialCooldownS) return false;
    if (state.interstitialsToday >= cfg.interstitialDailyCap) return false;
    return _s.ads.interstitialLoaded;
  }

  /// Every numbered win from L11 counts, replays included; deferred wins stay counted.
  void recordWin(WinContext w) {
    if (w.isDaily || w.isRush || w.level < _s.config.interstitialMinLevel) return;
    _set(state.copyWith(winsSinceInterstitial: state.winsSinceInterstitial + 1));
  }

  /// Called after "Next" on Level Complete, before the next level loads.
  Future<void> maybeShowInterstitial(WinContext w) async {
    if (!shouldShowInterstitial(w)) return;
    await _s.ads.showInterstitial();
    _set(state.copyWith(
      winsSinceInterstitial: 0,
      lastFullscreenUtc: _s.time.now().toUtc(),
      interstitialsToday: state.interstitialsToday + 1,
    ));
    _s.analytics.event('ad_show', {'format': 'interstitial', 'placement': 'level_next'});
  }

  void _set(AdsState next) {
    emit(next);
    _s.save.write('ads', next.toJson());
  }
}
