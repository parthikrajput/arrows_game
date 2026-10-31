import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../theme/tokens.dart';

/// Pure vector 5-point star with gold gradient and outline.
class StarIcon extends StatelessWidget {
  const StarIcon({
    super.key,
    this.size = 28,
    this.filled = true,
  });

  final double size;
  final bool filled;

  @override
  Widget build(BuildContext context) => CustomPaint(
        size: Size.square(size),
        painter: _StarPainter(filled),
      );
}

class _StarPainter extends CustomPainter {
  const _StarPainter(this.filled);
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

    final outline = Paint()
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
      canvas.drawPath(path, outline..color = AppColors.coinGoldDark);
    } else {
      canvas.drawPath(path, Paint()..color = Colors.black.withValues(alpha: 0.1));
      canvas.drawPath(path, outline..color = Colors.black.withValues(alpha: 0.18));
    }
  }

  @override
  bool shouldRepaint(covariant _StarPainter old) => old.filled != filled;
}

/// Row of 3 stars (0–3), with optional sequential pop-in animation.
class StarRow extends StatefulWidget {
  const StarRow({
    super.key,
    required this.stars,
    this.maxStars = 3,
    this.size = 36,
    this.animate = false,
  });

  final int stars;
  final int maxStars;
  final double size;
  final bool animate;

  @override
  State<StarRow> createState() => _StarRowState();
}

class _StarRowState extends State<StarRow> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final List<Animation<double>> _scales;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );

    const step = 0.25;
    _scales = List.generate(widget.maxStars, (i) {
      final start = (i * step).clamp(0.0, 0.7);
      final end = (start + 0.35).clamp(0.0, 1.0);
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(start, end, curve: Curves.elasticOut),
        ),
      );
    });

    if (widget.animate) {
      _controller.forward();
    } else {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(covariant StarRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!oldWidget.animate && widget.animate) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final disableAnimations = MediaQuery.of(context).disableAnimations;

    return Semantics(
      label: '${widget.stars} of ${widget.maxStars} stars',
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          for (int i = 0; i < widget.maxStars; i++) ...[
            if (i > 0) SizedBox(width: widget.size * 0.2),
            if (widget.animate && !disableAnimations)
              ScaleTransition(
                scale: _scales[i],
                child: StarIcon(
                  size: i == 1 ? widget.size * 1.15 : widget.size,
                  filled: i < widget.stars,
                ),
              )
            else
              StarIcon(
                size: i == 1 ? widget.size * 1.15 : widget.size,
                filled: i < widget.stars,
              ),
          ],
        ],
      ),
    );
  }
}
