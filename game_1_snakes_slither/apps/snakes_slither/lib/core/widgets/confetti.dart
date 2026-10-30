import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Falling confetti leaves. Renders nothing when reduce-motion is on.
class LeafConfetti extends StatefulWidget {
  const LeafConfetti({super.key, this.count = 40, this.duration = const Duration(milliseconds: 2600)});
  final int count;
  final Duration duration;

  @override
  State<LeafConfetti> createState() => _LeafConfettiState();
}

class _Leaf {
  _Leaf(math.Random r)
      : x = r.nextDouble(),
        delay = r.nextDouble() * 0.35,
        speed = 0.7 + r.nextDouble() * 0.6,
        sway = 0.02 + r.nextDouble() * 0.05,
        spin = (r.nextDouble() - 0.5) * 10,
        size = 8 + r.nextDouble() * 8,
        color = _colors[r.nextInt(_colors.length)];

  static const _colors = [Color(0xFF7CB342), Color(0xFF43A047), Color(0xFFFFCA28), Color(0xFFF06292), Color(0xFF29B6F6), Color(0xFFFFA726)];

  final double x;
  final double delay;
  final double speed;
  final double sway;
  final double spin;
  final double size;
  final Color color;
}

class _LeafConfettiState extends State<LeafConfetti> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(vsync: this, duration: widget.duration)..forward();
  late final List<_Leaf> _leaves = List.generate(widget.count, (_) => _Leaf(_rng));
  static final _rng = math.Random();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).disableAnimations) return const SizedBox.shrink();
    return IgnorePointer(
      child: RepaintBoundary(
        child: AnimatedBuilder(
          animation: _c,
          builder: (_, _) => CustomPaint(size: Size.infinite, painter: _ConfettiPainter(_leaves, _c.value)),
        ),
      ),
    );
  }
}

class _ConfettiPainter extends CustomPainter {
  _ConfettiPainter(this.leaves, this.t);
  final List<_Leaf> leaves;
  final double t;

  @override
  void paint(Canvas canvas, Size s) {
    for (final l in leaves) {
      final p = ((t - l.delay) / (1 - l.delay)).clamp(0.0, 1.0);
      if (p <= 0) continue;
      final y = -20 + p * l.speed * (s.height + 40);
      final x = (l.x + math.sin(p * math.pi * 4 + l.x * 10) * l.sway) * s.width;
      final fade = p > 0.8 ? (1 - p) / 0.2 : 1.0;
      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(p * l.spin);
      final leaf = Path()
        ..moveTo(-l.size / 2, 0)
        ..quadraticBezierTo(0, -l.size / 2, l.size / 2, 0)
        ..quadraticBezierTo(0, l.size / 2, -l.size / 2, 0)
        ..close();
      canvas.drawPath(leaf, Paint()..color = l.color.withValues(alpha: fade));
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _ConfettiPainter old) => old.t != t;
}
