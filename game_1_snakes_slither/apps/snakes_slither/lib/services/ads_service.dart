import 'dart:async';

import 'package:flutter/material.dart';

import '../app/theme/text_styles.dart';
import '../app/theme/tokens.dart';
import '../core/logging/app_logger.dart';

enum RewardedPlacement { doubleWin, revive, shopCoins, extraSpin, streakSaver }

/// Ad network seam. The AdMob + UMP implementation replaces [SimulatedAdsService]
/// once ad unit ids exist; every caller only sees this interface.
abstract class AdsService {
  bool get rewardedAvailable;
  bool get interstitialLoaded;

  /// True only when the user earned the reward (`onUserEarnedReward`).
  Future<bool> showRewarded(RewardedPlacement placement);
  Future<void> showInterstitial();
}

/// Development stand-in that shows a labelled full-screen placeholder so every
/// ad flow (reward, early close, cooldown) can be tested without an ad SDK.
class SimulatedAdsService implements AdsService {
  SimulatedAdsService(this._navigatorKey);

  final GlobalKey<NavigatorState> _navigatorKey;

  /// Flip off to test "Ad unavailable" states.
  bool available = true;

  @override
  bool get rewardedAvailable => available;

  @override
  bool get interstitialLoaded => available;

  @override
  Future<bool> showRewarded(RewardedPlacement placement) async {
    final nav = _navigatorKey.currentState;
    if (nav == null || !available) return false;
    log.i('ad_show rewarded ${placement.name}');
    final earned = await nav.push<bool>(_SimulatedAdRoute(rewarded: true));
    if (earned != true) log.w('E-ADS-003', 'Rewarded closed before reward (${placement.name})');
    return earned ?? false;
  }

  @override
  Future<void> showInterstitial() async {
    final nav = _navigatorKey.currentState;
    if (nav == null || !available) return;
    log.i('ad_show interstitial');
    await nav.push<bool>(_SimulatedAdRoute(rewarded: false));
  }
}

class _SimulatedAdRoute extends PageRouteBuilder<bool> {
  _SimulatedAdRoute({required bool rewarded})
      : super(
          opaque: true,
          transitionDuration: Motion.base,
          pageBuilder: (_, _, _) => _SimulatedAdPage(rewarded: rewarded),
          transitionsBuilder: (_, a, _, child) => FadeTransition(opacity: a, child: child),
        );
}

class _SimulatedAdPage extends StatefulWidget {
  const _SimulatedAdPage({required this.rewarded});
  final bool rewarded;

  @override
  State<_SimulatedAdPage> createState() => _SimulatedAdPageState();
}

class _SimulatedAdPageState extends State<_SimulatedAdPage> {
  late int _left = widget.rewarded ? 5 : 3;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_left <= 1) t.cancel();
      setState(() => _left--);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final done = _left <= 0;
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: const Color(0xFF14261A),
        body: SafeArea(
          child: Stack(
            children: [
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.movie_filter_rounded, size: 72, color: AppColors.coinGold),
                    const SizedBox(height: Space.lg),
                    Text('Test ad', style: AppText.h1.copyWith(color: Colors.white)),
                    const SizedBox(height: Space.sm),
                    Text(
                      widget.rewarded
                          ? (done ? 'Reward earned! You can close this now.' : 'Reward in $_left s')
                          : (done ? 'You can close this now.' : 'Closing available in $_left s'),
                      style: AppText.body.copyWith(color: Colors.white70),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: Space.sm,
                right: Space.sm,
                child: IconButton(
                  tooltip: 'Close ad',
                  onPressed: (done || widget.rewarded) ? () => Navigator.of(context).pop(widget.rewarded && done) : null,
                  icon: Icon(Icons.close_rounded, color: (done || widget.rewarded) ? Colors.white : Colors.white24),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
