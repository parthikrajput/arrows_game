import 'package:flutter/material.dart';

import '../../app/theme/tokens.dart';

/// Sky → hills → grass backdrop used by the hub screens. Static, so it is
/// painted once and cached by its RepaintBoundary.
class GardenBackground extends StatelessWidget {
  const GardenBackground({super.key, required this.child, this.night = false, this.hillsAt = 0.5});
  final Widget child;
  final bool night;

  /// Fraction of the height where the far hills start.
  final double hillsAt;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        RepaintBoundary(child: CustomPaint(painter: _GardenPainter(night: night, hillsAt: hillsAt))),
        child,
      ],
    );
  }
}

class _GardenPainter extends CustomPainter {
  _GardenPainter({required this.night, required this.hillsAt});
  final bool night;
  final double hillsAt;

  @override
  void paint(Canvas canvas, Size s) {
    final rect = Offset.zero & s;
    canvas.drawRect(
      rect,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: night
              ? const [Color(0xFF1A2340), Color(0xFF2C3E63), Color(0xFF35603F), Color(0xFF244A2C)]
              : const [AppColors.sky, Color(0xFFDDF1E6), AppColors.grassLight, AppColors.grass],
          stops: const [0, 0.34, 0.62, 1],
        ).createShader(rect),
    );
    // Sun glow.
    final sun = Offset(s.width * 0.82, s.height * 0.11);
    canvas.drawCircle(
      sun,
      s.width * 0.24,
      Paint()
        ..shader = RadialGradient(colors: [
          (night ? const Color(0xFFE8EAF6) : const Color(0xFFFFFBE6)).withValues(alpha: 0.95),
          const Color(0x00FFF3C4),
        ]).createShader(Rect.fromCircle(center: sun, radius: s.width * 0.24)),
    );
    // Clouds.
    final cloud = Paint()..color = Colors.white.withValues(alpha: night ? 0.12 : 0.8);
    for (final c in [
      Offset(s.width * 0.2, s.height * 0.22),
      Offset(s.width * 0.28, s.height * 0.21),
      Offset(s.width * 0.75, s.height * 0.29),
    ]) {
      canvas.drawOval(Rect.fromCenter(center: c, width: s.width * 0.22, height: s.width * 0.07), cloud);
    }
    final top = s.height * hillsAt;
    final far = Path()
      ..moveTo(0, top)
      ..quadraticBezierTo(s.width * 0.25, top - s.height * 0.1, s.width * 0.5, top - s.height * 0.03)
      ..quadraticBezierTo(s.width * 0.78, top + s.height * 0.03, s.width, top - s.height * 0.04)
      ..lineTo(s.width, s.height)
      ..lineTo(0, s.height)
      ..close();
    canvas.drawPath(far, Paint()..color = night ? const Color(0xFF2E5236) : const Color(0xFF9BD08F));
    final nearTop = top + s.height * 0.06;
    final near = Path()
      ..moveTo(0, nearTop)
      ..quadraticBezierTo(s.width * 0.3, nearTop - s.height * 0.08, s.width * 0.6, nearTop)
      ..quadraticBezierTo(s.width * 0.85, nearTop + s.height * 0.04, s.width, nearTop - s.height * 0.02)
      ..lineTo(s.width, s.height)
      ..lineTo(0, s.height)
      ..close();
    canvas.drawPath(
      near,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: night ? const [Color(0xFF2F6B35), Color(0xFF1E4423)] : const [Color(0xFF8FCB6E), Color(0xFF5DA548)],
        ).createShader(Rect.fromLTWH(0, nearTop, s.width, s.height - nearTop)),
    );
    // Bushes with flowers.
    final bush = Paint()..color = night ? const Color(0xFF1F4D24) : const Color(0xFF4E9A3D);
    canvas.drawOval(Rect.fromCenter(center: Offset(0, nearTop + s.height * 0.09), width: s.width * 0.35, height: s.height * 0.1), bush);
    canvas.drawOval(Rect.fromCenter(center: Offset(s.width, nearTop + s.height * 0.08), width: s.width * 0.38, height: s.height * 0.1), bush);
    for (final f in [
      (Offset(s.width * 0.1, nearTop + s.height * 0.06), const Color(0xFFF48FB1)),
      (Offset(s.width * 0.9, nearTop + s.height * 0.05), Colors.white),
      (Offset(s.width * 0.95, nearTop + s.height * 0.08), const Color(0xFFF48FB1)),
    ]) {
      canvas.drawCircle(f.$1, 5, Paint()..color = f.$2);
      canvas.drawCircle(f.$1, 2, Paint()..color = const Color(0xFFFFD54F));
    }
  }

  @override
  bool shouldRepaint(covariant _GardenPainter old) => old.night != night || old.hillsAt != hillsAt;
}
