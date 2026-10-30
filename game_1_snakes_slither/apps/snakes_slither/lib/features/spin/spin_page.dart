import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../app/services.dart';
import '../../app/theme/text_styles.dart';
import '../../app/theme/tokens.dart';
import '../../core/widgets/bevel_button.dart';
import '../../core/widgets/common.dart';
import '../../core/widgets/confetti.dart';
import '../../core/widgets/game_icons.dart';
import '../../core/widgets/garden_background.dart';
import '../../core/widgets/popup.dart';
import '../../services/ads_service.dart';
import '../../services/audio_service.dart';
import '../../services/remote_config.dart';
import '../../state/ads_cubit.dart';
import '../../state/progress_cubit.dart';
import '../../state/settings_cubit.dart';
import '../../state/spin_cubit.dart';
import '../../state/wallet_cubit.dart';
import '../daily/daily_page.dart';
import '../settings/settings_panel.dart';

class SpinPage extends StatefulWidget {
  const SpinPage({super.key});

  @override
  State<SpinPage> createState() => _SpinPageState();
}

class _SpinPageState extends State<SpinPage> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 2500));
  double _from = 0;
  double _to = 0;
  bool _spinning = false;
  int _lastTick = 0;

  static const _segments = 8;
  static const _seg = 2 * math.pi / _segments;

  @override
  void initState() {
    super.initState();
    _c.addListener(() {
      final angle = _angle;
      final tick = (angle / _seg).floor();
      if (tick != _lastTick) {
        _lastTick = tick;
        context.read<AppServices>().audio.play(Sfx.spinTick);
      }
    });
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  double get _angle => _from + (_to - _from) * Curves.decelerate.transform(_c.value);

  Future<void> _spin({required bool viaAd}) async {
    if (_spinning) return;
    final installId = context.read<SettingsCubit>().state.installId;
    final spin = context.read<SpinCubit>();
    if (viaAd) {
      final ok = await context.read<AdsCubit>().showRewarded(RewardedPlacement.extraSpin);
      if (!ok || !mounted) return;
    }
    final index = viaAd ? spin.spinAd(installId) : spin.spinFree(installId);
    // Segment i is centred at -π/2 + i·seg; rotate so it lands under the top pointer.
    final current = _angle % (2 * math.pi);
    final target = -index * _seg;
    final delta = ((target - current) % (2 * math.pi) + 2 * math.pi) % (2 * math.pi);
    setState(() {
      _spinning = true;
      _from = _angle;
      _to = _from + delta + 2 * math.pi * 5;
    });
    final reduce = MediaQuery.of(context).disableAnimations;
    _c.duration = Duration(milliseconds: reduce ? 400 : 2500);
    await _c.forward(from: 0);
    if (!mounted) return;
    _grant(spinPrizes[index]);
    setState(() => _spinning = false);
  }

  Future<void> _grant(SpinPrize p) async {
    final wallet = context.read<WalletCubit>();
    if (p.booster != null) {
      wallet.grantBooster(p.booster!);
    } else {
      wallet.earn('lucky_wheel', p.coins);
    }
    context.read<AppServices>().audio.play(Sfx.coinsFly);
    await showGamePopup<void>(
      context,
      dismissible: true,
      builder: (ctx) => Stack(
        children: [
          if (p.coins >= 100) const Positioned.fill(child: LeafConfetti()),
          PopupCard(
            title: p.coins == 500 ? 'Golden Lily Jackpot!' : 'You won!',
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (p.booster != null) RewardChip(booster: p.booster) else RewardChip(coins: p.coins),
                const SizedBox(height: Space.xl),
                BevelButton.text('Collect', expand: true, onPressed: () => Navigator.pop(ctx)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = context.read<AppServices>();
    final spin = context.watch<SpinCubit>();
    final ads = context.watch<AdsCubit>();
    final highest = context.select((ProgressCubit p) => p.state.highestCleared);
    final today = s.time.dayKey();
    final unlocked = spin.unlocked(highest);
    final clockLock = s.time.timeTravelLocked;
    final freeUsed = spin.state.freeUsed(today);
    final left = s.time.untilMidnight();

    return Scaffold(
      body: GardenBackground(
        hillsAt: 0.8,
        child: SafeArea(
          child: Column(
            children: [
              HubHeader(
                title: 'Lucky Lily Wheel',
                trailing: IconButton(tooltip: 'Odds', onPressed: () => showSpinOdds(context), icon: const Icon(Icons.info_outline_rounded)),
              ),
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(Space.gutter),
                    child: Column(
                      children: [
                        if (!unlocked)
                          CreamCard(child: Text('The wheel unlocks after you clear level ${s.config.spinUnlockLevel}.', style: AppText.bodyBold))
                        else if (clockLock)
                          const ClockLockCard()
                        else ...[
                          SizedBox(
                            width: 300,
                            height: 320,
                            child: Stack(
                              alignment: Alignment.topCenter,
                              children: [
                                Positioned(
                                  top: 26,
                                  child: AnimatedBuilder(
                                    animation: _c,
                                    builder: (_, _) => Transform.rotate(
                                      angle: _angle,
                                      child: const CustomPaint(size: Size.square(290), painter: _WheelPainter()),
                                    ),
                                  ),
                                ),
                                const CustomPaint(size: Size(36, 48), painter: _PointerPainter()),
                              ],
                            ),
                          ),
                          const SizedBox(height: Space.lg),
                          BevelButton.text(
                            freeUsed ? 'Free spin in ${left.inHours}h ${left.inMinutes % 60}m' : 'Spin free',
                            expand: true,
                            style: BevelStyle.gold,
                            logId: 'spin.free',
                            onPressed: (freeUsed || _spinning) ? null : () => _spin(viaAd: false),
                          ),
                          const SizedBox(height: Space.md),
                          BevelButton(
                            expand: true,
                            logId: 'spin.ad',
                            onPressed: (!freeUsed || ads.spinAdsLeft == 0 || !ads.rewardedAvailable || _spinning) ? null : () => _spin(viaAd: true),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.movie_filter_rounded),
                                const SizedBox(width: Space.sm),
                                Flexible(
                                  child: Text(
                                    !ads.rewardedAvailable ? 'Ad unavailable' : 'Spin again (${ads.spinAdsLeft} left)',
                                    style: AppText.button.copyWith(color: (freeUsed && ads.spinAdsLeft > 0 && ads.rewardedAvailable && !_spinning) ? Colors.white : AppColors.textDisabled),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: Space.md),
                          Text('No purchase needed. Odds are shown under ⓘ.', style: AppText.caption),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PointerPainter extends CustomPainter {
  const _PointerPainter();

  @override
  void paint(Canvas canvas, Size s) {
    final path = Path()
      ..moveTo(s.width / 2, s.height)
      ..lineTo(0, s.height * 0.3)
      ..arcToPoint(Offset(s.width, s.height * 0.3), radius: Radius.circular(s.width / 2))
      ..close();
    canvas.drawPath(path.shift(const Offset(0, 3)), Paint()..color = Colors.black26);
    canvas.drawPath(path, Paint()..color = AppColors.danger);
    canvas.drawPath(path, Paint()..color = Colors.white..style = PaintingStyle.stroke..strokeWidth = 3);
    canvas.drawCircle(Offset(s.width / 2, s.height * 0.3), s.width * 0.14, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _WheelPainter extends CustomPainter {
  const _WheelPainter();

  static const _colors = [Color(0xFFFFF59D), Color(0xFFC5E1A5), Color(0xFFF8BBD0), Color(0xFFB3E5FC)];

  @override
  void paint(Canvas canvas, Size s) {
    final c = s.center(Offset.zero);
    final r = s.width / 2;
    const seg = 2 * math.pi / 8;
    canvas.drawCircle(c + const Offset(0, 6), r, Paint()..color = Colors.black.withValues(alpha: 0.18));
    canvas.drawCircle(c, r, Paint()..color = AppColors.wood);
    for (var i = 0; i < 8; i++) {
      final start = -math.pi / 2 + i * seg - seg / 2;
      canvas.drawArc(Rect.fromCircle(center: c, radius: r - 8), start, seg, true, Paint()..color = i == 7 ? AppColors.coinGold : _colors[i % 4]);
      canvas.drawArc(
        Rect.fromCircle(center: c, radius: r - 8),
        start,
        seg,
        true,
        Paint()
          ..style = PaintingStyle.stroke
          ..color = Colors.white
          ..strokeWidth = 2,
      );
      final p = spinPrizes[i];
      canvas.save();
      canvas.translate(c.dx, c.dy);
      canvas.rotate(start + seg / 2 + math.pi / 2);
      final label = p.booster != null ? boosterShort(p.booster!) : p.label;
      final tp = TextPainter(
        text: TextSpan(text: label, style: AppText.h2.copyWith(fontSize: p.booster != null ? 14 : 20, color: AppColors.textPrimary)),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(-tp.width / 2, -r * 0.78));
      canvas.restore();
    }
    // Lily centre.
    for (var i = 0; i < 6; i++) {
      canvas.save();
      canvas.translate(c.dx, c.dy);
      canvas.rotate(i * math.pi / 3);
      canvas.drawOval(Rect.fromCenter(center: Offset(0, -r * 0.1), width: r * 0.12, height: r * 0.24), Paint()..color = const Color(0xFFF48FB1));
      canvas.restore();
    }
    canvas.drawCircle(c, r * 0.07, Paint()..color = AppColors.coinGold);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
