import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/services.dart';
import '../../../../app/theme/text_styles.dart';
import '../../../../app/theme/tokens.dart';
import '../../../../core/widgets/bevel_button.dart';
import '../../../../core/widgets/common.dart';
import '../../../../core/widgets/game_icons.dart';
import '../../../../core/widgets/pip.dart';
import '../../../../core/widgets/popup.dart';
import '../../../../services/ads_service.dart';
import '../../../../state/ads_cubit.dart';
import '../../../../state/progress_cubit.dart';
import '../../../../state/wallet_cubit.dart';
import 'mini_shop.dart';

enum ReviveChoice { ad, refill, declined }

Future<ReviveChoice> showSecondChance(
  BuildContext context, {
  required String reviveKey,
  required int refillsLeft,
}) async {
  final r = await showGamePopup<ReviveChoice>(
    context,
    builder: (_) => _SecondChance(reviveKey: reviveKey, refillsLeft: refillsLeft),
  );
  return r ?? ReviveChoice.declined;
}

class _SecondChance extends StatefulWidget {
  const _SecondChance({required this.reviveKey, required this.refillsLeft});
  final String reviveKey;
  final int refillsLeft;

  @override
  State<_SecondChance> createState() => _SecondChanceState();
}

class _SecondChanceState extends State<_SecondChance> with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late final AnimationController _ring = AnimationController(vsync: this, duration: const Duration(seconds: 10))
    ..addStatusListener((s) {
      if (s == AnimationStatus.completed && mounted) Navigator.of(context).pop(ReviveChoice.declined);
    })
    ..forward();
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _ring.dispose();
    super.dispose();
  }

  // The countdown is a popup timer only; it pauses while backgrounded.
  @override
  void didChangeAppLifecycleState(AppLifecycleState s) {
    if (s == AppLifecycleState.resumed && !_busy) {
      _ring.forward();
    } else if (s != AppLifecycleState.resumed) {
      _ring.stop();
    }
  }

  Future<void> _watchAd() async {
    setState(() => _busy = true);
    _ring.stop();
    final earned = await context.read<AdsCubit>().showRewarded(RewardedPlacement.revive);
    if (!mounted) return;
    if (earned) {
      context.read<ProgressCubit>().markAdRevive(widget.reviveKey);
      context.read<AppServices>().analytics.event('revive', {'type': 'ad', 'key': widget.reviveKey});
      Navigator.of(context).pop(ReviveChoice.ad);
      return;
    }
    setState(() => _busy = false);
    _ring.forward();
  }

  Future<void> _refill() async {
    final s = context.read<AppServices>();
    final wallet = context.read<WalletCubit>();
    final price = s.config.heartRefillPrice;
    if (!wallet.canAfford(price)) {
      setState(() => _busy = true);
      _ring.stop();
      await showMiniShop(context, coinsOnly: true, need: price);
      if (!mounted) return;
      setState(() => _busy = false);
      _ring.forward();
      return;
    }
    if (wallet.spend('heart_refill', price)) {
      s.analytics.event('revive', {'type': 'coins', 'key': widget.reviveKey});
      Navigator.of(context).pop(ReviveChoice.refill);
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = context.read<AppServices>();
    final adUsed = context.select((ProgressCubit p) => p.state.adReviveUsed.contains(widget.reviveKey));
    final adAvailable = context.read<AdsCubit>().rewardedAvailable;
    final coins = context.select((WalletCubit w) => w.state.coins);
    final price = s.config.heartRefillPrice;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop && !_busy) Navigator.of(context).pop(ReviveChoice.declined);
      },
      child: PopupCard(
        title: 'Pip needs a berry!',
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 128,
              height: 128,
              child: AnimatedBuilder(
                animation: _ring,
                builder: (_, _) => CustomPaint(
                  painter: _RingPainter(1 - _ring.value),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Pip(pose: PipPose.sad, size: 72),
                        Text('${(10 - _ring.value * 10).ceil()}', style: AppText.h2),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: Space.lg),
            BevelButton(
              expand: true,
              style: BevelStyle.primary,
              onPressed: (adUsed || !adAvailable || _busy) ? null : _watchAd,
              semanticLabel: 'Watch ad for one heart',
              logId: 'revive.ad',
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.movie_filter_rounded),
                  const SizedBox(width: Space.sm),
                  Text(
                    adUsed ? 'Used for this level' : (!adAvailable ? 'Ad unavailable' : 'Watch ad  +1'),
                    style: AppText.button.copyWith(color: (adUsed || !adAvailable) ? AppColors.textDisabled : Colors.white),
                  ),
                  if (!adUsed && adAvailable) ...[const SizedBox(width: 4), const HeartBerryIcon(size: 22)],
                ],
              ),
            ),
            const SizedBox(height: Space.md),
            BevelButton(
              expand: true,
              style: BevelStyle.gold,
              onPressed: (widget.refillsLeft <= 0 || _busy) ? null : _refill,
              semanticLabel: 'Heart Berry Refill for $price coins',
              logId: 'revive.refill',
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CoinIcon(size: 24),
                  const SizedBox(width: 6),
                  Text('$price  +1', style: AppText.button.copyWith(color: const Color(0xFF4E3500))),
                  const SizedBox(width: 4),
                  const HeartBerryIcon(size: 22),
                  const SizedBox(width: 8),
                  Text(
                    widget.refillsLeft <= 0 ? '(none left)' : '(${widget.refillsLeft} left)',
                    style: AppText.caption.copyWith(color: const Color(0xFF4E3500), fontWeight: FontWeight.w800),
                  ),
                ],
              ),
            ),
            if (coins < price && widget.refillsLeft > 0)
              Padding(
                padding: const EdgeInsets.only(top: Space.xs),
                child: Text('You have ${fmt(coins)} coins', style: AppText.caption),
              ),
            const SizedBox(height: Space.sm),
            TextButton(
              onPressed: _busy ? null : () => Navigator.of(context).pop(ReviveChoice.declined),
              child: Text('No thanks', style: AppText.bodyBold.copyWith(color: AppColors.textSecondary)),
            ),
          ],
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  _RingPainter(this.left);
  final double left;

  @override
  void paint(Canvas canvas, Size s) {
    final r = Rect.fromCircle(center: s.center(Offset.zero), radius: s.width / 2 - 6);
    canvas.drawArc(r, 0, math.pi * 2, false, Paint()..style = PaintingStyle.stroke..strokeWidth = 8..color = const Color(0x22000000));
    canvas.drawArc(
      r,
      -math.pi / 2,
      math.pi * 2 * left,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 8
        ..strokeCap = StrokeCap.round
        ..color = Color.lerp(AppColors.heart, AppColors.primary, left)!,
    );
  }

  @override
  bool shouldRepaint(covariant _RingPainter old) => old.left != left;
}
