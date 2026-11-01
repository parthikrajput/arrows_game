import 'package:flutter/widgets.dart';

/// Ad network. AdMobService on phones; the fake (always succeeds) in tests and
/// on platforms without ads. Callers go through AdsCubit, which applies the rules.
abstract class AdsService {
  /// Loads consent and the ad SDK. Children get child-directed, G-rated,
  /// non-personalised ads.
  Future<void> start({required bool childDirected}) async {}

  /// Settings › Privacy choices (UMP privacy options form).
  Future<void> showPrivacyOptions() async {}

  /// Anchored adaptive banner; empty where ads don't exist.
  Widget banner() => const SizedBox.shrink();

  bool get rewardedReady;
  bool get interstitialReady;

  /// True only when the reward callback fired (closing early = false).
  Future<bool> showRewarded(String placement);

  /// True when the ad was actually shown.
  Future<bool> showInterstitial();
}

class FakeAdsService extends AdsService {
  @override
  bool get rewardedReady => true;

  @override
  bool get interstitialReady => true;

  @override
  Future<bool> showRewarded(String placement) async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    return true;
  }

  @override
  Future<bool> showInterstitial() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return true;
  }
}
