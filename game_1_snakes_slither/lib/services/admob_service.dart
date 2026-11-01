import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:puzzle_core/puzzle_core.dart' show LogCodes;

import '../logging/app_logger.dart';
import 'ads_service.dart';

/// Ad unit ids. Release builds pass the real ones with --dart-define; the
/// defaults are Google's public test units, which never pay out.
class AdUnits {
  const AdUnits._();
  static String get banner => Platform.isIOS
      ? const String.fromEnvironment('ADMOB_BANNER_IOS', defaultValue: 'ca-app-pub-3940256099942544/2435281174')
      : const String.fromEnvironment('ADMOB_BANNER_ANDROID', defaultValue: 'ca-app-pub-3940256099942544/9214589741');
  static String get interstitial => Platform.isIOS
      ? const String.fromEnvironment('ADMOB_INTERSTITIAL_IOS', defaultValue: 'ca-app-pub-3940256099942544/4411468910')
      : const String.fromEnvironment(
          'ADMOB_INTERSTITIAL_ANDROID',
          defaultValue: 'ca-app-pub-3940256099942544/1033173712',
        );
  static String get rewarded => Platform.isIOS
      ? const String.fromEnvironment('ADMOB_REWARDED_IOS', defaultValue: 'ca-app-pub-3940256099942544/1712485313')
      : const String.fromEnvironment('ADMOB_REWARDED_ANDROID', defaultValue: 'ca-app-pub-3940256099942544/5224354917');
}

/// Google AdMob behind [AdsService], with UMP consent first. Nothing loads
/// until [start] runs (after the age gate and after the first frame).
class AdMobService extends AdsService {
  InterstitialAd? _interstitial;
  RewardedAd? _rewarded;
  bool _started = false;
  bool _nonPersonalized = true;

  /// Called when a full-screen ad fails, for the `ad_fail` event.
  void Function(String placement, String error)? onFail;

  AdRequest get _request => AdRequest(nonPersonalizedAds: _nonPersonalized);

  @override
  bool get rewardedReady => _rewarded != null;

  @override
  bool get interstitialReady => _interstitial != null;

  @override
  Future<void> start({required bool childDirected}) async {
    if (_started) return;
    _started = true;
    await MobileAds.instance.updateRequestConfiguration(
      RequestConfiguration(
        ageRestrictedTreatment: childDirected ? AgeRestrictedTreatment.child : AgeRestrictedTreatment.unspecified,
        maxAdContentRating: childDirected ? MaxAdContentRating.g : MaxAdContentRating.pg,
      ),
    );
    final canRequest = await _gatherConsent(underAge: childDirected);
    // Children always get non-personalised ads; others only when they agreed.
    _nonPersonalized = childDirected || !canRequest;
    await MobileAds.instance.initialize();
    _loadInterstitial();
    _loadRewarded();
  }

  /// UMP consent (EEA / UK). Shows the form only where it is required.
  Future<bool> _gatherConsent({required bool underAge}) async {
    final done = Completer<void>();
    ConsentInformation.instance.requestConsentInfoUpdate(
      ConsentRequestParameters(tagForUnderAgeOfConsent: underAge),
      () => ConsentForm.loadAndShowConsentFormIfRequired((_) {
        if (!done.isCompleted) done.complete();
      }),
      (e) {
        AppLogger.instance.warn('ads', LogCodes.adsLoadFailure, 'consent update failed', {'error': e.message});
        if (!done.isCompleted) done.complete();
      },
    );
    await done.future.timeout(const Duration(seconds: 20), onTimeout: () {});
    return ConsentInformation.instance.canRequestAds();
  }

  /// Settings › Privacy choices.
  @override
  Future<void> showPrivacyOptions() => ConsentForm.showPrivacyOptionsForm((_) {});

  void _loadInterstitial() => InterstitialAd.load(
    adUnitId: AdUnits.interstitial,
    request: _request,
    adLoadCallback: InterstitialAdLoadCallback(
      onAdLoaded: (ad) => _interstitial = ad,
      onAdFailedToLoad: (e) {
        AppLogger.instance.warn('ads', LogCodes.adsLoadFailure, 'interstitial', {'error': e.message});
        Future.delayed(const Duration(seconds: 30), _loadInterstitial);
      },
    ),
  );

  void _loadRewarded() => RewardedAd.load(
    adUnitId: AdUnits.rewarded,
    request: _request,
    rewardedAdLoadCallback: RewardedAdLoadCallback(
      onAdLoaded: (ad) => _rewarded = ad,
      onAdFailedToLoad: (e) {
        AppLogger.instance.warn('ads', LogCodes.adsLoadFailure, 'rewarded', {'error': e.message});
        Future.delayed(const Duration(seconds: 30), _loadRewarded);
      },
    ),
  );

  @override
  Future<bool> showRewarded(String placement) async {
    final ad = _rewarded;
    if (ad == null) return false;
    _rewarded = null;
    final done = Completer<bool>();
    var earned = false;
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (a) {
        a.dispose();
        _loadRewarded();
        if (!done.isCompleted) done.complete(earned);
      },
      onAdFailedToShowFullScreenContent: (a, e) {
        a.dispose();
        _loadRewarded();
        AppLogger.instance.warn('ads', LogCodes.adsShowFailure, placement, {'error': e.message});
        onFail?.call(placement, e.message);
        if (!done.isCompleted) done.complete(false);
      },
    );
    await ad.show(onUserEarnedReward: (_, _) => earned = true);
    return done.future;
  }

  @override
  Future<bool> showInterstitial() async {
    final ad = _interstitial;
    if (ad == null) return false;
    _interstitial = null;
    final done = Completer<bool>();
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (a) {
        a.dispose();
        _loadInterstitial();
        if (!done.isCompleted) done.complete(true);
      },
      onAdFailedToShowFullScreenContent: (a, e) {
        a.dispose();
        _loadInterstitial();
        onFail?.call('interstitial', e.message);
        if (!done.isCompleted) done.complete(false);
      },
    );
    await ad.show();
    return done.future;
  }

  @override
  Widget banner() => const _AdaptiveBanner();
}

/// Anchored adaptive banner. The parent reserves its height up front, so
/// nothing moves when the ad arrives.
class _AdaptiveBanner extends StatefulWidget {
  const _AdaptiveBanner();
  @override
  State<_AdaptiveBanner> createState() => _AdaptiveBannerState();
}

class _AdaptiveBannerState extends State<_AdaptiveBanner> {
  BannerAd? _ad;
  bool _loaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_ad == null) _load();
  }

  Future<void> _load() async {
    final width = MediaQuery.sizeOf(context).width.truncate();
    final size = await AdSize.getLargeAnchoredAdaptiveBannerAdSizeWithOrientation(Orientation.portrait, width);
    if (!mounted || size == null) return;
    _ad = BannerAd(
      adUnitId: AdUnits.banner,
      size: size,
      request: const AdRequest(nonPersonalizedAds: true),
      listener: BannerAdListener(
        onAdLoaded: (_) => setState(() => _loaded = true),
        onAdFailedToLoad: (ad, e) {
          ad.dispose();
          AppLogger.instance.warn('ads', LogCodes.adsLoadFailure, 'banner', {'error': e.message});
        },
      ),
    )..load();
  }

  @override
  void dispose() {
    _ad?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      _loaded && _ad != null ? Center(child: AdWidget(ad: _ad!)) : const SizedBox.shrink();
}
