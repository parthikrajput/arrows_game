/// Ad network. Milestone 1–2 use a fake that always succeeds, so revive, 2X,
/// free coins and the wheel can be tested; AdMob replaces it later behind the
/// same interface. Callers go through AdsCubit, which applies the rules.
abstract class AdsService {
  bool get rewardedReady;
  bool get interstitialReady;

  /// True only when the reward callback fired (closing early = false).
  Future<bool> showRewarded(String placement);

  /// True when the ad was actually shown.
  Future<bool> showInterstitial();
}

class FakeAdsService implements AdsService {
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
