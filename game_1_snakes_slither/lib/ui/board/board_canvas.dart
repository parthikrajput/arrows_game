// OWNER: Antigravity (UI). PLACEHOLDER by Claude: plain shapes so the game is
// testable. Replace the look and animations freely, but keep:
//  - the constructor (data, geometry, onMotionDone),
//  - drawing cells via geometry.rectOf / centerOf (taps are mapped the same way),
//  - calling onMotionDone(motion.id) exactly once when each motion finishes.
import 'package:flutter/material.dart';

import '../../contracts/view_models.dart';
import '../../features/gameplay/board_geometry.dart';
import '../theme/tokens.dart';

class BoardCanvas extends StatefulWidget {
  const BoardCanvas({
    super.key,
    required this.data,
    required this.geometry,
    required this.onMotionDone,
  });

  final BoardViewData data;
  final BoardGeometry geometry;
  final void Function(int motionId) onMotionDone;

  @override
  State<BoardCanvas> createState() => _BoardCanvasState();
}

class _BoardCanvasState extends State<BoardCanvas> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(vsync: this);
  int? _playing;

  @override
  void didUpdateWidget(BoardCanvas old) {
    super.didUpdateWidget(old);
    _maybePlay();
  }

  @override
  void initState() {
    super.initState();
    _maybePlay();
  }

  void _maybePlay() {
    final m = widget.data.motion;
    if (m == null || m.id == _playing) return;
    _playing = m.id;
    _c.duration = switch (m.kind) {
      MotionKind.exit => AppMotion.exitFor(m.lane.cells.length + m.snake.length),
      MotionKind.bump => AppMotion.bonk,
      MotionKind.locked => AppMotion.locked,
    };
    _c.forward(from: 0).whenComplete(() {
      if (mounted && _playing == m.id) widget.onMotionDone(m.id);
    });
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _c,
    builder: (_, _) => CustomPaint(
      size: widget.geometry.size,
      painter: _PlaceholderPainter(widget.data, widget.geometry, _c.value),
    ),
  );
}

class _PlaceholderPainter extends CustomPainter {
  _PlaceholderPainter(this.d, this.g, this.t);
  final BoardViewData d;
  final BoardGeometry g;
  final double t;

  @override
  void paint(Canvas canvas, Size size) {
    final r = Radius.circular(g.cornerRadius);
    canvas.drawRRect(
      RRect.fromRectAndRadius(Offset.zero & size, r),
      Paint()..color = const Color(0xFFDCEFD8),
    );
    final dot = Paint()..color = const Color(0x22000000);
    for (var x = 0; x < g.columns; x++) {
      for (var y = 0; y < g.rows; y++) {
        canvas.drawCircle(g.centerOf(Cell(x, y)), 1.5, dot);
      }
    }
    for (final rock in d.board.rocks.values) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(g.rectOf(rock.cell).deflate(4), r),
        Paint()..color = const Color(0xFF9E9E9E),
      );
    }

    final m = d.motion;
    for (final s in d.board.snakes.values) {
      var shift = Offset.zero;
      if (m != null && m.snake.id == s.id) shift = _shiftFor(m);
      final color = AppColors.snake(s.color);
      final p = Paint()..color = color;
      for (final c in s.body) {
        canvas.drawRRect(RRect.fromRectAndRadius(g.rectOf(c).deflate(5).shift(shift), r), p);
      }
      final head = g.centerOf(s.head) + shift;
      canvas.drawCircle(
        head + Offset(s.dir.dx * g.cell * .2, s.dir.dy * g.cell * .2),
        g.cell * .12,
        Paint()..color = Colors.black87,
      );
      if (d.hintSnakeId == s.id) {
        canvas.drawCircle(
          head,
          g.cell * .55,
          Paint()
            ..color = AppColors.coinGold
            ..style = PaintingStyle.stroke
            ..strokeWidth = 4,
        );
      }
    }

    final pv = d.preview;
    if (pv != null) {
      final col = pv.lane.isClear ? AppColors.previewClear : AppColors.previewBlocked;
      for (final c in pv.lane.cells) {
        canvas.drawCircle(g.centerOf(c), g.cell * .1, Paint()..color = col);
      }
      final b = pv.lane.blocker;
      if (b != null) {
        final c = g.centerOf(b), k = g.cell * .25;
        final x = Paint()
          ..color = col
          ..strokeWidth = 4;
        canvas.drawLine(c - Offset(k, k), c + Offset(k, k), x);
        canvas.drawLine(c + Offset(-k, k), c + Offset(k, -k), x);
      }
    }
    if (d.hammerMode) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(Offset.zero & size, r),
        Paint()..color = const Color(0x33FF9800),
      );
    }
  }

  /// Exit: slide out along the lane. Bump: forward to the blocker and back.
  Offset _shiftFor(Motion m) {
    final dir = Offset(m.snake.dir.dx.toDouble(), m.snake.dir.dy.toDouble());
    switch (m.kind) {
      case MotionKind.exit:
        return dir * (g.cell * (m.lane.cells.length + m.snake.length) * t);
      case MotionKind.bump:
        final reach = m.lane.cells.isEmpty ? .25 : m.lane.cells.length.toDouble();
        final there = t < .5 ? t * 2 : (1 - t) * 2;
        return dir * (g.cell * reach * there);
      case MotionKind.locked:
        return Offset(4 * (t < .5 ? t : 1 - t), 0);
    }
  }

  @override
  bool shouldRepaint(_PlaceholderPainter o) => o.t != t || o.d != d;
}
