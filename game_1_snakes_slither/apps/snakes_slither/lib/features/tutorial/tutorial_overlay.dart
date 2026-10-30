import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../app/theme/text_styles.dart';
import '../../app/theme/tokens.dart';

/// One FTUE / booster tutorial step.
class TutorialStep {
  const TutorialStep({required this.id, required this.text, this.target, this.guided = false, this.bubbleOnTop = false});
  final String id;
  final String text;

  /// Cut-out in overlay coordinates. Null = plain tooltip.
  final Rect? target;

  /// Guided: only the cut-out is tappable and the step ends when the game says so.
  /// Tooltip: any tap closes it.
  final bool guided;
  final bool bubbleOnTop;
}

class TutorialOverlay extends StatefulWidget {
  const TutorialOverlay({super.key, required this.step, required this.onDismiss});
  final TutorialStep step;
  final VoidCallback onDismiss;

  @override
  State<TutorialOverlay> createState() => _TutorialOverlayState();
}

class _TutorialOverlayState extends State<TutorialOverlay> with SingleTickerProviderStateMixin {
  late final AnimationController _hand = AnimationController(vsync: this, duration: const Duration(milliseconds: 1100))..repeat();

  @override
  void dispose() {
    _hand.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final step = widget.step;
    final hole = step.target?.inflate(8);
    return LayoutBuilder(builder: (context, c) {
      final size = c.biggest;
      final blockers = <Rect>[];
      if (hole != null && step.guided) {
        blockers
          ..add(Rect.fromLTRB(0, 0, size.width, hole.top))
          ..add(Rect.fromLTRB(0, hole.bottom, size.width, size.height))
          ..add(Rect.fromLTRB(0, hole.top, hole.left, hole.bottom))
          ..add(Rect.fromLTRB(hole.right, hole.top, size.width, hole.bottom));
      }
      final bubbleTop = step.bubbleOnTop || (hole != null && hole.center.dy > size.height * 0.55);
      return Stack(
        children: [
          IgnorePointer(child: CustomPaint(size: size, painter: _ScrimPainter(hole))),
          if (step.guided)
            for (final r in blockers) Positioned.fromRect(rect: r, child: const AbsorbPointer(child: SizedBox.expand()))
          else
            Positioned.fill(child: GestureDetector(behavior: HitTestBehavior.opaque, onTap: widget.onDismiss)),
          if (hole != null)
            AnimatedBuilder(
              animation: _hand,
              builder: (_, _) {
                final t = Curves.easeInOut.transform(1 - (_hand.value * 2 - 1).abs());
                return Positioned(
                  left: hole.center.dx + 4,
                  top: hole.center.dy + 4 + t * 14,
                  child: IgnorePointer(child: Transform.rotate(angle: -math.pi / 8, child: const Icon(Icons.touch_app_rounded, size: 52, color: Colors.white, shadows: [Shadow(blurRadius: 8)]))),
                );
              },
            ),
          Positioned(
            left: Space.gutter,
            right: Space.gutter,
            top: bubbleTop ? MediaQuery.paddingOf(context).top + 80 : null,
            bottom: bubbleTop ? null : MediaQuery.paddingOf(context).bottom + 120,
            child: _Bubble(text: step.text, onGotIt: step.guided ? null : widget.onDismiss),
          ),
        ],
      );
    });
  }
}

class _Bubble extends StatelessWidget {
  const _Bubble({required this.text, this.onGotIt});
  final String text;
  final VoidCallback? onGotIt;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Motion.popupIn,
      curve: Motion.popupCurve,
      builder: (_, v, child) => Transform.scale(scale: 0.8 + 0.2 * v, child: Opacity(opacity: v.clamp(0, 1), child: child)),
      child: Container(
        padding: const EdgeInsets.all(Space.lg),
        decoration: BoxDecoration(
          color: AppColors.bgCream,
          borderRadius: BorderRadius.circular(Radii.lg),
          border: Border.all(color: Colors.white, width: 3),
          boxShadow: Shadows.elev2,
        ),
        child: Row(
          children: [
            const _Tortoise(),
            const SizedBox(width: Space.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Grandpa Tortoise', style: AppText.caption.copyWith(fontWeight: FontWeight.w800)),
                  Text(text, style: AppText.bodyBold),
                  if (onGotIt != null)
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(onPressed: onGotIt, child: const Text('Got it')),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Tortoise extends StatelessWidget {
  const _Tortoise();

  @override
  Widget build(BuildContext context) => const CustomPaint(size: Size(56, 56), painter: _TortoisePainter());
}

class _TortoisePainter extends CustomPainter {
  const _TortoisePainter();

  @override
  void paint(Canvas canvas, Size s) {
    final w = s.width;
    canvas.drawCircle(Offset(w * 0.78, w * 0.42), w * 0.17, Paint()..color = const Color(0xFF9CCC65));
    canvas.drawOval(Rect.fromLTWH(w * 0.05, w * 0.3, w * 0.7, w * 0.5), Paint()..color = const Color(0xFF6D4C41));
    canvas.drawOval(Rect.fromLTWH(w * 0.12, w * 0.34, w * 0.56, w * 0.4), Paint()..color = const Color(0xFF8D6E63));
    final hex = Paint()
      ..color = const Color(0xFF5D4037)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawCircle(Offset(w * 0.4, w * 0.54), w * 0.1, hex);
    // Glasses.
    final glass = Paint()
      ..color = const Color(0xFF263238)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6;
    canvas.drawCircle(Offset(w * 0.75, w * 0.39), w * 0.06, glass);
    canvas.drawCircle(Offset(w * 0.88, w * 0.39), w * 0.06, glass);
    for (final x in [0.3, 0.6]) {
      canvas.drawOval(Rect.fromLTWH(w * x - w * 0.06, w * 0.72, w * 0.14, w * 0.12), Paint()..color = const Color(0xFF9CCC65));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ScrimPainter extends CustomPainter {
  _ScrimPainter(this.hole);
  final Rect? hole;

  @override
  void paint(Canvas canvas, Size s) {
    final path = Path()..addRect(Offset.zero & s);
    if (hole != null) {
      path
        ..addRRect(RRect.fromRectAndRadius(hole!, const Radius.circular(16)))
        ..fillType = PathFillType.evenOdd;
    }
    canvas.drawPath(path, Paint()..color = Colors.black.withValues(alpha: 0.55));
    if (hole != null) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(hole!, const Radius.circular(16)),
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _ScrimPainter old) => old.hole != hole;
}
