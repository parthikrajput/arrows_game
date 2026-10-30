import 'dart:math' as math;

import 'package:flutter/material.dart';

enum PipPose { happy, wave, sad, sleep }

/// Pip, the baby green snake mascot, with a gentle idle bob and blink.
class Pip extends StatefulWidget {
  const Pip({super.key, this.pose = PipPose.happy, this.size = 140, this.animate = true});
  final PipPose pose;
  final double size;
  final bool animate;

  @override
  State<Pip> createState() => _PipState();
}

class _PipState extends State<Pip> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 2600));

  @override
  void initState() {
    super.initState();
    if (widget.animate) _c.repeat();
  }

  @override
  void didUpdateWidget(Pip old) {
    super.didUpdateWidget(old);
    if (widget.animate && !_c.isAnimating) _c.repeat();
    if (!widget.animate && _c.isAnimating) _c.stop();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reduce = MediaQuery.of(context).disableAnimations;
    return ExcludeSemantics(
      child: RepaintBoundary(
        child: AnimatedBuilder(
          animation: _c,
          builder: (_, _) => CustomPaint(
            size: Size(widget.size, widget.size),
            painter: _PipPainter(widget.pose, reduce ? 0 : _c.value),
          ),
        ),
      ),
    );
  }
}

class _PipPainter extends CustomPainter {
  _PipPainter(this.pose, this.t);
  final PipPose pose;
  final double t;

  static const _body = Color(0xFF7CB342);
  static const _bodyDark = Color(0xFF558B2F);
  static const _belly = Color(0xFFDCEDC8);

  @override
  void paint(Canvas canvas, Size s) {
    final w = s.width;
    final bob = math.sin(t * math.pi * 2) * w * 0.015;
    // Ground shadow.
    canvas.drawOval(
      Rect.fromCenter(center: Offset(w * 0.5, w * 0.93), width: w * 0.7, height: w * 0.1),
      Paint()..color = Colors.black.withValues(alpha: 0.12),
    );

    // Coiled body.
    final coil = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = w * 0.17;
    final path = Path()
      ..moveTo(w * 0.78, w * 0.84)
      ..cubicTo(w * 0.98, w * 0.7, w * 0.8, w * 0.62, w * 0.5, w * 0.7)
      ..cubicTo(w * 0.18, w * 0.78, w * 0.16, w * 0.88, w * 0.45, w * 0.86)
      ..cubicTo(w * 0.7, w * 0.84, w * 0.62, w * 0.62, w * 0.5, w * 0.55 + bob);
    canvas.drawPath(path.shift(Offset(0, w * 0.02)), coil..color = _bodyDark);
    canvas.drawPath(path, coil..color = _body);
    canvas.drawPath(
      path.shift(Offset(-w * 0.012, -w * 0.02)),
      coil
        ..color = Colors.white.withValues(alpha: 0.3)
        ..strokeWidth = w * 0.045,
    );

    // Head.
    final head = Offset(w * 0.5, w * 0.4 + bob);
    final hr = w * 0.22;
    canvas.drawCircle(head + Offset(0, w * 0.015), hr, Paint()..color = _bodyDark);
    canvas.drawCircle(
      head,
      hr,
      Paint()
        ..shader = const RadialGradient(center: Alignment(-0.35, -0.4), colors: [Color(0xFFAED581), _body])
            .createShader(Rect.fromCircle(center: head, radius: hr)),
    );
    canvas.drawOval(Rect.fromCenter(center: head + Offset(0, hr * 0.45), width: hr * 1.2, height: hr * 0.6), Paint()..color = _belly);

    // Cheeks.
    final cheek = Paint()..color = const Color(0xFFFF8A80).withValues(alpha: 0.55);
    canvas.drawCircle(head + Offset(-hr * 0.62, hr * 0.25), hr * 0.16, cheek);
    canvas.drawCircle(head + Offset(hr * 0.62, hr * 0.25), hr * 0.16, cheek);

    // Eyes.
    final blink = (t > 0.92 && t < 0.97) || pose == PipPose.sleep;
    for (final sx in [-1.0, 1.0]) {
      final e = head + Offset(sx * hr * 0.38, -hr * 0.08);
      if (blink || pose == PipPose.sad) {
        final p = Paint()
          ..color = const Color(0xFF1B2B1F)
          ..style = PaintingStyle.stroke
          ..strokeWidth = w * 0.018
          ..strokeCap = StrokeCap.round;
        final arc = Rect.fromCenter(center: e, width: hr * 0.36, height: hr * 0.28);
        canvas.drawArc(arc, pose == PipPose.sad ? math.pi : 0, math.pi, false, p);
      } else {
        canvas.drawCircle(e, hr * 0.26, Paint()..color = Colors.white);
        canvas.drawCircle(e + Offset(0, hr * 0.04), hr * 0.16, Paint()..color = const Color(0xFF1B2B1F));
        canvas.drawCircle(e + Offset(-hr * 0.05, -hr * 0.03), hr * 0.06, Paint()..color = Colors.white);
      }
    }

    // Mouth.
    final mouth = Paint()
      ..color = const Color(0xFF33691E)
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.014
      ..strokeCap = StrokeCap.round;
    final m = head + Offset(0, hr * 0.35);
    if (pose == PipPose.sad) {
      canvas.drawArc(Rect.fromCenter(center: m + Offset(0, hr * 0.12), width: hr * 0.4, height: hr * 0.25), math.pi, math.pi, false, mouth);
    } else if (pose != PipPose.sleep) {
      canvas.drawArc(Rect.fromCenter(center: m, width: hr * 0.45, height: hr * 0.3), 0.15, math.pi - 0.3, false, mouth);
      // Tongue flick.
      if (t > 0.4 && t < 0.5) {
        canvas.drawLine(m + Offset(0, hr * 0.15), m + Offset(0, hr * 0.42), mouth..color = const Color(0xFFE91E63));
      }
    } else {
      // Zzz.
      final tp = TextPainter(
        text: TextSpan(text: 'z z', style: TextStyle(color: Colors.white, fontSize: w * 0.12, fontWeight: FontWeight.w700)),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, head + Offset(hr * 0.7, -hr * 1.4 - t * w * 0.05));
    }

    // Leaf hat.
    canvas.save();
    canvas.translate(head.dx + hr * 0.1, head.dy - hr * 0.9);
    canvas.rotate(-0.35 + math.sin(t * math.pi * 2) * 0.05);
    final leaf = Path()
      ..moveTo(-hr * 0.5, 0)
      ..quadraticBezierTo(0, -hr * 0.55, hr * 0.6, -hr * 0.05)
      ..quadraticBezierTo(0, hr * 0.3, -hr * 0.5, 0)
      ..close();
    canvas.drawPath(leaf, Paint()..color = const Color(0xFF43A047));
    canvas.drawLine(Offset(-hr * 0.45, 0), Offset(hr * 0.5, -hr * 0.06), Paint()..color = const Color(0xFF2E7D32)..strokeWidth = w * 0.01);
    canvas.restore();

    // Waving tail tip.
    if (pose == PipPose.wave) {
      final a = math.sin(t * math.pi * 6) * 0.4;
      final tip = Offset(w * 0.84, w * 0.6) + Offset(math.cos(-1.2 + a), math.sin(-1.2 + a)) * w * 0.12;
      canvas.drawLine(
        Offset(w * 0.8, w * 0.78),
        tip,
        Paint()
          ..color = _body
          ..strokeWidth = w * 0.08
          ..strokeCap = StrokeCap.round,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _PipPainter old) => old.t != t || old.pose != pose;
}
