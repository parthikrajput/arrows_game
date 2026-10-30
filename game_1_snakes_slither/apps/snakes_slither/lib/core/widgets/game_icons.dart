import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../app/theme/tokens.dart';
import '../../services/remote_config.dart';

/// Vector icons drawn in code so they look the same on every platform
/// (emoji glyphs differ between Android versions).
class CoinIcon extends StatelessWidget {
  const CoinIcon({super.key, this.size = 24});
  final double size;

  @override
  Widget build(BuildContext context) => CustomPaint(size: Size.square(size), painter: _CoinPainter());
}

class _CoinPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final c = size.center(Offset.zero);
    final r = size.width / 2;
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
    canvas.drawCircle(c, r * 0.92, Paint()..style = PaintingStyle.stroke..strokeWidth = r * 0.1..color = const Color(0xFF8D6200));
    canvas.drawCircle(c, r * 0.68, Paint()..style = PaintingStyle.stroke..strokeWidth = r * 0.07..color = AppColors.coinGoldDark.withValues(alpha: 0.7));
    // Gold leaf.
    final leaf = Path()
      ..moveTo(c.dx - r * 0.3, c.dy + r * 0.22)
      ..quadraticBezierTo(c.dx - r * 0.25, c.dy - r * 0.35, c.dx + r * 0.32, c.dy - r * 0.32)
      ..quadraticBezierTo(c.dx + r * 0.28, c.dy + r * 0.2, c.dx - r * 0.3, c.dy + r * 0.22)
      ..close();
    canvas.drawPath(leaf, Paint()..color = const Color(0xFFFFE38A));
    canvas.drawPath(leaf, Paint()..style = PaintingStyle.stroke..strokeWidth = r * 0.07..color = const Color(0xFF9A6B00));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Heart berry: red berry with a leaf. [empty] draws the lost-heart outline.
class HeartBerryIcon extends StatelessWidget {
  const HeartBerryIcon({super.key, this.size = 26, this.empty = false});
  final double size;
  final bool empty;

  @override
  Widget build(BuildContext context) => CustomPaint(size: Size.square(size), painter: _HeartPainter(empty));
}

class _HeartPainter extends CustomPainter {
  _HeartPainter(this.empty);
  final bool empty;

  @override
  void paint(Canvas canvas, Size s) {
    final w = s.width;
    final h = s.height;
    final heart = Path()
      ..moveTo(w * 0.5, h * 0.9)
      ..cubicTo(w * 0.05, h * 0.62, w * 0.02, h * 0.3, w * 0.25, h * 0.22)
      ..cubicTo(w * 0.4, h * 0.17, w * 0.48, h * 0.27, w * 0.5, h * 0.33)
      ..cubicTo(w * 0.52, h * 0.27, w * 0.6, h * 0.17, w * 0.75, h * 0.22)
      ..cubicTo(w * 0.98, h * 0.3, w * 0.95, h * 0.62, w * 0.5, h * 0.9)
      ..close();
    if (empty) {
      canvas.drawPath(heart, Paint()..color = const Color(0x33000000));
      canvas.drawPath(heart, Paint()..style = PaintingStyle.stroke..strokeWidth = w * 0.06..color = const Color(0x55000000));
      return;
    }
    canvas.drawPath(
      heart,
      Paint()
        ..shader = const RadialGradient(
          center: Alignment(-0.3, -0.3),
          colors: [Color(0xFFFF8A80), AppColors.heart, Color(0xFFB71C1C)],
        ).createShader(Offset.zero & s),
    );
    canvas.drawCircle(Offset(w * 0.33, h * 0.38), w * 0.07, Paint()..color = Colors.white.withValues(alpha: 0.7));
    final leaf = Path()
      ..moveTo(w * 0.5, h * 0.3)
      ..quadraticBezierTo(w * 0.55, h * 0.02, w * 0.78, h * 0.06)
      ..quadraticBezierTo(w * 0.7, h * 0.28, w * 0.5, h * 0.3);
    canvas.drawPath(leaf, Paint()..color = const Color(0xFF43A047));
  }

  @override
  bool shouldRepaint(covariant _HeartPainter old) => old.empty != empty;
}

class StarIcon extends StatelessWidget {
  const StarIcon({super.key, this.size = 24, this.filled = true});
  final double size;
  final bool filled;

  @override
  Widget build(BuildContext context) => CustomPaint(size: Size.square(size), painter: _StarPainter(filled));
}

class _StarPainter extends CustomPainter {
  _StarPainter(this.filled);
  final bool filled;

  @override
  void paint(Canvas canvas, Size s) {
    final c = s.center(Offset.zero);
    final outer = s.width / 2;
    final inner = outer * 0.48;
    final path = Path();
    for (var i = 0; i < 10; i++) {
      final r = i.isEven ? outer : inner;
      final a = -math.pi / 2 + i * math.pi / 5;
      final p = c + Offset(math.cos(a), math.sin(a)) * r;
      i == 0 ? path.moveTo(p.dx, p.dy) : path.lineTo(p.dx, p.dy);
    }
    path.close();
    final rounded = Paint()
      ..style = PaintingStyle.stroke
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = s.width * 0.08;
    if (filled) {
      canvas.drawPath(
        path,
        Paint()
          ..shader = const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFFF176), AppColors.coinGold, Color(0xFFFFA000)],
          ).createShader(Offset.zero & s),
      );
      canvas.drawPath(path, rounded..color = AppColors.coinGoldDark);
    } else {
      canvas.drawPath(path, Paint()..color = Colors.black.withValues(alpha: 0.12));
      canvas.drawPath(path, rounded..color = Colors.black.withValues(alpha: 0.2));
    }
  }

  @override
  bool shouldRepaint(covariant _StarPainter old) => old.filled != filled;
}

/// Glow Firefly · Safety Shell · Magic Stone Hammer.
class BoosterIcon extends StatelessWidget {
  const BoosterIcon(this.type, {super.key, this.size = 32});
  final BoosterType type;
  final double size;

  @override
  Widget build(BuildContext context) => CustomPaint(size: Size.square(size), painter: _BoosterPainter(type));
}

class _BoosterPainter extends CustomPainter {
  _BoosterPainter(this.type);
  final BoosterType type;

  @override
  void paint(Canvas canvas, Size s) {
    final w = s.width;
    switch (type) {
      case BoosterType.hint:
        final c = Offset(w * 0.5, w * 0.58);
        canvas.drawCircle(c, w * 0.42, Paint()..shader = RadialGradient(colors: [const Color(0xFFFFF59D).withValues(alpha: 0.9), const Color(0x00FFF59D)]).createShader(Rect.fromCircle(center: c, radius: w * 0.42)));
        // Wings.
        final wing = Paint()..color = Colors.white.withValues(alpha: 0.85);
        canvas.drawOval(Rect.fromCenter(center: Offset(w * 0.32, w * 0.36), width: w * 0.3, height: w * 0.2), wing);
        canvas.drawOval(Rect.fromCenter(center: Offset(w * 0.68, w * 0.36), width: w * 0.3, height: w * 0.2), wing);
        // Body + glowing tail.
        canvas.drawOval(Rect.fromCenter(center: Offset(w * 0.5, w * 0.42), width: w * 0.24, height: w * 0.28), Paint()..color = const Color(0xFF5D4037));
        canvas.drawOval(Rect.fromCenter(center: Offset(w * 0.5, w * 0.66), width: w * 0.28, height: w * 0.3), Paint()..color = const Color(0xFFFFEB3B));
        canvas.drawCircle(Offset(w * 0.46, w * 0.62), w * 0.05, Paint()..color = Colors.white);
        final ant = Paint()..color = const Color(0xFF5D4037)..strokeWidth = w * 0.04..style = PaintingStyle.stroke..strokeCap = StrokeCap.round;
        canvas.drawLine(Offset(w * 0.46, w * 0.3), Offset(w * 0.38, w * 0.16), ant);
        canvas.drawLine(Offset(w * 0.54, w * 0.3), Offset(w * 0.62, w * 0.16), ant);
      case BoosterType.shield:
        final shell = Path()
          ..moveTo(w * 0.5, w * 0.1)
          ..cubicTo(w * 0.95, w * 0.2, w * 0.95, w * 0.75, w * 0.5, w * 0.92)
          ..cubicTo(w * 0.05, w * 0.75, w * 0.05, w * 0.2, w * 0.5, w * 0.1)
          ..close();
        canvas.drawPath(shell, Paint()..shader = const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFFFFE0B2), Color(0xFFFFB74D), Color(0xFFE65100)]).createShader(Offset.zero & s));
        final rib = Paint()..color = const Color(0xFF8D4A00).withValues(alpha: 0.7)..strokeWidth = w * 0.05..style = PaintingStyle.stroke..strokeCap = StrokeCap.round;
        for (final dx in [-0.22, 0.0, 0.22]) {
          canvas.drawLine(Offset(w * 0.5, w * 0.16), Offset(w * (0.5 + dx), w * 0.86), rib);
        }
        canvas.drawPath(shell, Paint()..color = const Color(0xFF8D4A00)..style = PaintingStyle.stroke..strokeWidth = w * 0.05);
      case BoosterType.hammer:
        final handle = Paint()..color = const Color(0xFF8D6E63)..strokeWidth = w * 0.12..strokeCap = StrokeCap.round;
        canvas.drawLine(Offset(w * 0.3, w * 0.86), Offset(w * 0.6, w * 0.4), handle);
        canvas.save();
        canvas.translate(w * 0.62, w * 0.32);
        canvas.rotate(-0.55);
        final head = RRect.fromRectAndRadius(Rect.fromCenter(center: Offset.zero, width: w * 0.66, height: w * 0.36), Radius.circular(w * 0.12));
        canvas.drawRRect(head, Paint()..shader = const LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0xFFCFD8DC), Color(0xFF78909C)]).createShader(head.outerRect));
        canvas.drawRRect(head, Paint()..color = const Color(0xFF455A64)..style = PaintingStyle.stroke..strokeWidth = w * 0.04);
        canvas.drawCircle(Offset(-w * 0.12, -w * 0.04), w * 0.05, Paint()..color = const Color(0xFFB388FF));
        canvas.drawCircle(Offset(w * 0.14, w * 0.04), w * 0.04, Paint()..color = const Color(0xFF80DEEA));
        canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _BoosterPainter old) => old.type != type;
}

String boosterName(BoosterType t) => switch (t) {
      BoosterType.hint => 'Glow Firefly Hint',
      BoosterType.shield => 'Safety Shell Shield',
      BoosterType.hammer => 'Magic Stone Hammer',
    };

String boosterShort(BoosterType t) => switch (t) {
      BoosterType.hint => 'Hint',
      BoosterType.shield => 'Shield',
      BoosterType.hammer => 'Hammer',
    };
