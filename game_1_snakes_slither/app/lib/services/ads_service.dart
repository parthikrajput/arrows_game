/// Rewarded ads. Milestone 1 uses a fake that always rewards, so revive and
/// 2X can be tested; the AdMob version replaces it in milestone 2 behind the
/// same interface.
abstract class AdsService {
  bool get rewardedReady;

  /// True only when the reward callback fired (closing early = false).
  Future<bool> showRewarded(String placement);
}

class FakeAdsService implements AdsService {
  @override
  bool get rewardedReady => true;

  @override
  Future<bool> showRewarded(String placement) async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    return true;
  }
}
