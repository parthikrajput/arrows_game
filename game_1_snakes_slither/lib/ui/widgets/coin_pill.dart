import 'package:flutter/material.dart';

import '../theme/tokens.dart';

/// Pure vector coin icon with gold gradients and bevel outline.
class CoinIcon extends StatelessWidget {
  const CoinIcon({super.key, this.size = 24});
  final double size;

  @override
  Widget build(BuildContext context) => CustomPaint(
        size: Size.square(size),
        painter: _CoinPainter(),
      );
}

class _CoinPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final c = size.center(Offset.zero);
    final r = size.width / 2;

    // Outer coin circle with gold radial gradient
    canvas.drawCircle(
      c,
      r * 0.92,
      Paint()
        ..shader = const RadialGradient(
          center: Alignment(-0.3, -0.4),
          colors: [Color(0xFFFFF4B8), AppColors.coinGold, Color(0xFFC08A00)],
          stops: [0, 0.45, 1],
        ).createShader(Rect.fromCircle(center: c, radius: r)),
    );

    // Rim stroke
    canvas.drawCircle(
      c,
      r * 0.92,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = r * 0.1
        ..color = const Color(0xFF8D6200),
    );

    // Inner ridge
    canvas.drawCircle(
      c,
      r * 0.68,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = r * 0.07
        ..color = AppColors.coinGoldDark.withValues(alpha: 0.7),
    );

    // Embossed gold leaf symbol
    final leaf = Path()
      ..moveTo(c.dx - r * 0.28, c.dy + r * 0.2)
      ..quadraticBezierTo(c.dx - r * 0.22, c.dy - r * 0.32, c.dx + r * 0.3, c.dy - r * 0.3)
      ..quadraticBezierTo(c.dx + r * 0.25, c.dy + r * 0.18, c.dx - r * 0.28, c.dy + r * 0.2)
      ..close();
    canvas.drawPath(leaf, Paint()..color = const Color(0xFFFFE38A));
    canvas.drawPath(
      leaf,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = r * 0.06
        ..color = const Color(0xFF9A6B00),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Gold coin balance pill (🪙 + number) with optional plus button.
class CoinPill extends StatelessWidget {
  const CoinPill({
    super.key,
    required this.coins,
    this.onTap,
    this.showPlus = false,
    this.onPlusTap,
  });

  final int coins;
  final VoidCallback? onTap;
  final bool showPlus;
  final VoidCallback? onPlusTap;

  String _format(int n) {
    if (n < 1000) return '$n';
    final s = n.toString();
    final buffer = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) {
        buffer.write(',');
      }
      buffer.write(s[i]);
    }
    return buffer.toString();
  }

  @override
  Widget build(BuildContext context) {
    // HUD numbers clamp to 1.5 per doc 06 §3
    final textScale = MediaQuery.textScalerOf(context).clamp(minScaleFactor: 1.0, maxScaleFactor: 1.5);

    return Semantics(
      button: onTap != null || onPlusTap != null,
      label: '${_format(coins)} coins',
      child: GestureDetector(
        onTap: onTap ?? onPlusTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          height: 38,
          constraints: const BoxConstraints(minWidth: 48),
          padding: const EdgeInsets.only(left: 4, right: 8),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.white, AppColors.creamEdge],
            ),
            borderRadius: BorderRadius.circular(Radii.pill),
            border: Border.all(color: Colors.white, width: 1.5),
            boxShadow: Shadows.bevel(AppColors.creamLip),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const CoinIcon(size: 26),
              const SizedBox(width: Space.xs),
              MediaQuery(
                data: MediaQuery.of(context).copyWith(textScaler: textScale),
                child: Text(
                  _format(coins),
                  style: AppText.hudNumber.copyWith(fontSize: 16),
                ),
              ),
              if (showPlus) ...[
                const SizedBox(width: Space.xs),
                GestureDetector(
                  onTap: onPlusTap ?? onTap,
                  child: Container(
                    width: 22,
                    height: 22,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0xFF6CC46F), AppColors.primary],
                      ),
                    ),
                    child: const Icon(Icons.add_rounded, color: Colors.white, size: 16),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
