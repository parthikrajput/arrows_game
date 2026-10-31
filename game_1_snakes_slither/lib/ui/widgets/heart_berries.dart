import 'package:flutter/material.dart';

import '../theme/tokens.dart';

/// Pure vector heart berry with green leaf and 3D shine.
class HeartBerryIcon extends StatelessWidget {
  const HeartBerryIcon({
    super.key,
    this.size = 28,
    this.filled = true,
  });

  final double size;
  final bool filled;

  @override
  Widget build(BuildContext context) => CustomPaint(
        size: Size.square(size),
        painter: _HeartBerryPainter(filled),
      );
}

class _HeartBerryPainter extends CustomPainter {
  const _HeartBerryPainter(this.filled);
  final bool filled;

  @override
  void paint(Canvas canvas, Size s) {
    final w = s.width;
    final h = s.height;

    // Organic heart berry path
    final path = Path()
      ..moveTo(w * 0.5, h * 0.92)
      ..cubicTo(w * 0.06, h * 0.65, w * 0.04, h * 0.3, w * 0.25, h * 0.22)
      ..cubicTo(w * 0.4, h * 0.16, w * 0.48, h * 0.26, w * 0.5, h * 0.32)
      ..cubicTo(w * 0.52, h * 0.26, w * 0.6, h * 0.16, w * 0.75, h * 0.22)
      ..cubicTo(w * 0.96, h * 0.3, w * 0.94, h * 0.65, w * 0.5, h * 0.92)
      ..close();

    if (!filled) {
      // Empty outline
      canvas.drawPath(
        path,
        Paint()..color = const Color(0x28000000),
      );
      canvas.drawPath(
        path,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = w * 0.08
          ..strokeJoin = StrokeJoin.round
          ..color = const Color(0x40000000),
      );
      return;
    }

    // Filled berry with radial shine
    canvas.drawPath(
      path,
      Paint()
        ..shader = const RadialGradient(
          center: Alignment(-0.35, -0.3),
          colors: [Color(0xFFFF8A80), AppColors.heart, Color(0xFFB71C1C)],
        ).createShader(Offset.zero & s),
    );

    // Specular highlight dot
    canvas.drawCircle(
      Offset(w * 0.32, h * 0.38),
      w * 0.07,
      Paint()..color = Colors.white.withValues(alpha: 0.75),
    );

    // Green leaf on top
    final leaf = Path()
      ..moveTo(w * 0.5, h * 0.28)
      ..quadraticBezierTo(w * 0.55, h * 0.02, w * 0.78, h * 0.06)
      ..quadraticBezierTo(w * 0.7, h * 0.26, w * 0.5, h * 0.28);
    canvas.drawPath(
      leaf,
      Paint()..color = const Color(0xFF43A047),
    );
  }

  @override
  bool shouldRepaint(covariant _HeartBerryPainter old) => old.filled != filled;
}

/// Row of heart berries showing current hearts / max hearts,
/// with optional Safety Shell Shield overlay badge when shieldCharges > 0.
class HeartBerries extends StatelessWidget {
  const HeartBerries({
    super.key,
    required this.hearts,
    this.maxHearts = 3,
    this.shieldCharges = 0,
    this.berrySize = 28,
  });

  final int hearts;
  final int maxHearts;
  final int shieldCharges;
  final double berrySize;

  @override
  Widget build(BuildContext context) {
    final disableAnimations = MediaQuery.of(context).disableAnimations;

    final berries = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int i = 0; i < maxHearts; i++) ...[
          if (i > 0) SizedBox(width: berrySize * 0.18),
          AnimatedScale(
            duration: disableAnimations ? Duration.zero : AppMotion.fast,
            scale: i < hearts ? 1.0 : 0.88,
            child: HeartBerryIcon(
              size: berrySize,
              filled: i < hearts,
            ),
          ),
        ],
      ],
    );

    if (shieldCharges <= 0) {
      return Semantics(
        label: '$hearts of $maxHearts hearts',
        child: berries,
      );
    }

    // Shield overlay
    return Semantics(
      label: '$hearts of $maxHearts hearts, shield active with $shieldCharges charges',
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          berries,
          Positioned(
            right: -8,
            top: -6,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFFFE0B2), Color(0xFFFFB74D), Color(0xFFE65100)],
                ),
                borderRadius: BorderRadius.circular(Radii.pill),
                border: Border.all(color: Colors.white, width: 1.5),
                boxShadow: Shadows.elev1,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('🐚', style: TextStyle(fontSize: 10)),
                  const SizedBox(width: 2),
                  Text(
                    '$shieldCharges',
                    style: AppText.hudNumber.copyWith(
                      fontSize: 11,
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
