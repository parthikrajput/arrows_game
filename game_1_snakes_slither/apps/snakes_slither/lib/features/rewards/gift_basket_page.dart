import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../app/services.dart';
import '../../app/theme/text_styles.dart';
import '../../app/theme/tokens.dart';
import '../../core/widgets/bevel_button.dart';
import '../../core/widgets/common.dart';
import '../../core/widgets/confetti.dart';
import '../../services/audio_service.dart';
import '../../services/remote_config.dart';
import '../../state/wallet_cubit.dart';

Route<void> giftBasketRoute({required int level, required bool chest}) => PageRouteBuilder<void>(
      opaque: false,
      barrierColor: AppColors.scrim,
      transitionDuration: Motion.popupIn,
      pageBuilder: (_, _, _) => GiftBasketPage(level: level, chest: chest),
      transitionsBuilder: (_, a, _, child) => FadeTransition(opacity: a, child: child),
    );

/// Jungle Gift Basket (every x0 level) or the L500 Jungle Treasure Chest.
class GiftBasketPage extends StatefulWidget {
  const GiftBasketPage({super.key, required this.level, required this.chest});
  final int level;
  final bool chest;

  @override
  State<GiftBasketPage> createState() => _GiftBasketPageState();
}

enum _Stage { closed, opened, collected }

class _GiftBasketPageState extends State<GiftBasketPage> with TickerProviderStateMixin {
  late final AnimationController _shake = AnimationController(vsync: this, duration: const Duration(milliseconds: 900))..repeat();
  late final AnimationController _open = AnimationController(vsync: this, duration: const Duration(milliseconds: 700));
  _Stage _stage = _Stage.closed;

  int get _coins {
    final cfg = context.read<AppServices>().config;
    return widget.chest ? cfg.chestCoins : cfg.giftCoins(widget.level);
  }

  List<(BoosterType, int)> get _boosters {
    final cfg = context.read<AppServices>().config;
    return widget.chest ? [for (final t in BoosterType.values) (t, 2)] : [(cfg.giftBooster(widget.level), 1)];
  }

  @override
  void dispose() {
    _shake.dispose();
    _open.dispose();
    super.dispose();
  }

  void _tapOpen() {
    if (_stage != _Stage.closed) return;
    final s = context.read<AppServices>();
    s.audio.play(Sfx.giftOpen);
    s.haptics.heavy();
    s.analytics.event(widget.chest ? 'chest_open' : 'gift_open', {'level': widget.level});
    _shake.stop();
    _open.forward();
    setState(() => _stage = _Stage.opened);
  }

  void _collect() {
    if (_stage != _Stage.opened) return;
    final wallet = context.read<WalletCubit>();
    wallet.earn(widget.chest ? 'treasure_chest' : 'gift_basket', _coins);
    for (final (t, n) in _boosters) {
      wallet.grantBooster(t, n);
    }
    context.read<AppServices>().audio.play(Sfx.coinsFly);
    setState(() => _stage = _Stage.collected);
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.chest ? 'Jungle Treasure Chest!' : 'Jungle Gift Basket!';
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            if (_stage != _Stage.closed) const Positioned.fill(child: LeafConfetti(count: 60)),
            SafeArea(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(title, style: AppText.display.copyWith(color: Colors.white, shadows: const [Shadow(blurRadius: 8)]), textAlign: TextAlign.center),
                    const SizedBox(height: Space.xl),
                    Semantics(
                      button: true,
                      label: 'Open ${widget.chest ? 'chest' : 'basket'}',
                      child: GestureDetector(
                        onTap: _tapOpen,
                        child: AnimatedBuilder(
                          animation: Listenable.merge([_shake, _open]),
                          builder: (_, _) {
                            final reduce = MediaQuery.of(context).disableAnimations;
                            final wobble = reduce ? 0.0 : math.sin(_shake.value * math.pi * 6) * 0.08 * (_shake.value < 0.5 ? 1 : 0);
                            final pop = Curves.elasticOut.transform(_open.value);
                            return Transform.rotate(
                              angle: wobble,
                              child: Transform.scale(
                                scale: 1 + pop * 0.1,
                                child: CustomPaint(
                                  size: Size.square(widget.chest ? 210 : 180),
                                  painter: _BasketPainter(open: _open.value, chest: widget.chest),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: Space.lg),
                    AnimatedSwitcher(
                      duration: Motion.base,
                      child: _stage == _Stage.closed
                          ? Text('Tap to open', key: const ValueKey('tap'), style: AppText.h2.copyWith(color: Colors.white))
                          : Column(
                              key: const ValueKey('rewards'),
                              children: [
                                Wrap(
                                  spacing: Space.sm,
                                  runSpacing: Space.sm,
                                  alignment: WrapAlignment.center,
                                  children: [
                                    RewardChip(coins: _coins),
                                    for (final (t, n) in _boosters) RewardChip(booster: t, count: n),
                                  ],
                                ),
                                if (widget.chest) ...[
                                  const SizedBox(height: Space.md),
                                  Chip2('Garden Hero badge', color: Colors.white, icon: Icons.emoji_events_rounded),
                                ],
                                const SizedBox(height: Space.xl),
                                BevelButton.text('Collect', onPressed: _stage == _Stage.opened ? _collect : null, logId: 'gift.collect'),
                              ],
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BasketPainter extends CustomPainter {
  _BasketPainter({required this.open, required this.chest});
  final double open;
  final bool chest;

  @override
  void paint(Canvas canvas, Size s) {
    final w = s.width;
    // Glow when opening.
    if (open > 0) {
      canvas.drawCircle(
        Offset(w / 2, w * 0.45),
        w * 0.55 * open,
        Paint()..shader = RadialGradient(colors: [const Color(0xFFFFF59D).withValues(alpha: 0.9), const Color(0x00FFF59D)]).createShader(Rect.fromCircle(center: Offset(w / 2, w * 0.45), radius: w * 0.55)),
      );
    }
    final body = RRect.fromRectAndRadius(Rect.fromLTWH(w * 0.12, w * 0.45, w * 0.76, w * 0.45), Radius.circular(w * 0.08));
    final base = chest ? const Color(0xFF8D6E63) : const Color(0xFFD7A15A);
    final dark = chest ? const Color(0xFF5D4037) : const Color(0xFFA9742F);
    canvas.drawRRect(body.shift(Offset(0, w * 0.03)), Paint()..color = dark);
    canvas.drawRRect(body, Paint()..color = base);
    // Weave / planks.
    final line = Paint()
      ..color = dark
      ..strokeWidth = w * 0.015;
    for (var i = 1; i < 4; i++) {
      final y = body.top + body.height * i / 4;
      canvas.drawLine(Offset(body.left + 6, y), Offset(body.right - 6, y), line);
    }
    if (chest) {
      final band = Paint()..color = const Color(0xFFFFCA28);
      canvas.drawRect(Rect.fromLTWH(w * 0.45, body.top, w * 0.1, body.height), band);
      canvas.drawCircle(Offset(w * 0.5, body.top + body.height * 0.35), w * 0.05, Paint()..color = const Color(0xFFB8860B));
    } else {
      // Handle.
      canvas.drawArc(
        Rect.fromLTWH(w * 0.25, w * 0.15, w * 0.5, w * 0.6),
        math.pi,
        math.pi,
        false,
        Paint()
          ..color = dark
          ..style = PaintingStyle.stroke
          ..strokeWidth = w * 0.05,
      );
      // Bow.
      canvas.drawCircle(Offset(w * 0.5, w * 0.47), w * 0.06, Paint()..color = const Color(0xFFF06292));
    }
    // Lid flies up when opened.
    canvas.save();
    canvas.translate(0, -open * w * 0.25);
    canvas.rotate(-open * 0.25);
    final lid = RRect.fromRectAndRadius(Rect.fromLTWH(w * 0.08, w * 0.36, w * 0.84, w * 0.14), Radius.circular(w * 0.06));
    canvas.drawRRect(lid, Paint()..color = chest ? const Color(0xFF6D4C41) : const Color(0xFF7CB342));
    canvas.restore();
    // Coins peeking out.
    if (open > 0.3) {
      for (var i = 0; i < 5; i++) {
        final c = Offset(w * (0.3 + i * 0.1), w * 0.44 - math.sin(i * 1.3) * w * 0.05 * open);
        canvas.drawCircle(c, w * 0.05, Paint()..color = AppColors.coinGold);
        canvas.drawCircle(c, w * 0.05, Paint()..color = AppColors.coinGoldDark..style = PaintingStyle.stroke..strokeWidth = 2);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _BasketPainter old) => old.open != open;
}
