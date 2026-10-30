import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../app/theme/text_styles.dart';
import '../../app/theme/tokens.dart';
import '../../core/widgets/pip.dart';

enum IntroMode { full, short }

/// "Jungle Dawn" launch intro, played over a live Home. Tap anywhere skips.
/// Full 1,200 ms · short 450 ms · 150 ms fade with reduced motion.
class JungleDawnIntro extends StatefulWidget {
  const JungleDawnIntro({super.key, required this.mode, required this.onDone});
  final IntroMode mode;
  final VoidCallback onDone;

  @override
  State<JungleDawnIntro> createState() => _JungleDawnIntroState();
}

class _JungleDawnIntroState extends State<JungleDawnIntro> with SingleTickerProviderStateMixin {
  AnimationController? _c;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_c != null) return;
    final reduce = MediaQuery.of(context).disableAnimations;
    final ms = reduce ? 150 : (widget.mode == IntroMode.full ? 1200 : 450);
    _c = AnimationController(vsync: this, duration: Duration(milliseconds: ms))
      ..addStatusListener((s) {
        if (s == AnimationStatus.completed) widget.onDone();
      })
      ..forward();
  }

  @override
  void dispose() {
    _c?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = _c!;
    final full = widget.mode == IntroMode.full && !MediaQuery.of(context).disableAnimations;
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => c.value < 1 ? c.forward(from: 1) : null,
      child: AnimatedBuilder(
        animation: c,
        builder: (context, _) {
          final t = c.value;
          // Canopy parts in the last 40%; everything fades at the end.
          final part = Curves.easeInOutCubic.transform(((t - 0.55) / 0.45).clamp(0, 1));
          final fade = 1 - ((t - 0.8) / 0.2).clamp(0.0, 1.0);
          return IgnorePointer(
            ignoring: t > 0.6,
            child: Opacity(
              opacity: fade,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CustomPaint(painter: _DawnPainter(t: full ? t : 1, part: part)),
                  if (full)
                    Center(
                      child: Transform.scale(
                        scale: Curves.elasticOut.transform((t / 0.6).clamp(0, 1)),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Pip(pose: PipPose.happy, size: 120, animate: false),
                            Text('Snakes Slither', style: AppText.display.copyWith(color: Colors.white, shadows: const [Shadow(blurRadius: 10)])),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _DawnPainter extends CustomPainter {
  _DawnPainter({required this.t, required this.part});
  final double t;
  final double part;

  @override
  void paint(Canvas canvas, Size s) {
    // Dawn sky warming up behind two canopy halves that slide apart.
    final sky = Color.lerp(const Color(0xFF1B3A2A), const Color(0xFFFFE0B2), (t * 1.4).clamp(0, 1))!;
    final half = s.width / 2;
    final offset = part * half * 1.1;
    final leaf = Paint()..color = AppColors.primaryDark;
    final leafLight = Paint()..color = const Color(0xFF388E3C);
    for (final side in [-1, 1]) {
      canvas.save();
      canvas.translate(side * offset, 0);
      final rect = side < 0 ? Rect.fromLTWH(0, 0, half + 1, s.height) : Rect.fromLTWH(half, 0, half, s.height);
      canvas.drawRect(rect, Paint()..color = sky);
      final edge = side < 0 ? half : half;
      for (var i = 0; i < 9; i++) {
        final y = s.height * (i + 0.5) / 9;
        final r = 46.0 + (i % 3) * 14;
        canvas.drawCircle(Offset(edge + side * -r * 0.3, y), r, i.isEven ? leaf : leafLight);
      }
      canvas.restore();
    }
    // Rising sun.
    final sunY = s.height * (0.75 - 0.35 * Curves.easeOut.transform(t.clamp(0, 1)));
    canvas.drawCircle(
      Offset(s.width / 2, sunY),
      s.width * 0.18,
      Paint()
        ..shader = RadialGradient(colors: [const Color(0xFFFFF8E1).withValues(alpha: 1 - part), const Color(0x00FFF8E1)])
            .createShader(Rect.fromCircle(center: Offset(s.width / 2, sunY), radius: s.width * 0.18)),
    );
    // A few falling leaves.
    for (var i = 0; i < 6; i++) {
      final x = s.width * ((i * 0.17 + 0.08) % 1);
      final y = (t * s.height * 0.9 + i * 70) % s.height;
      canvas.save();
      canvas.translate(x + math.sin(t * 6 + i) * 12, y);
      canvas.rotate(t * 4 + i);
      canvas.drawOval(const Rect.fromLTWH(-8, -4, 16, 8), Paint()..color = const Color(0xFF8BC34A).withValues(alpha: 1 - part));
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _DawnPainter old) => old.t != t || old.part != part;
}
