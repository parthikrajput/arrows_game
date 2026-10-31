// OWNER: UI agent. Canvas: Board.dc.html (garden board), Preview.dc.html,
// Hint.dc.html, Hammer.dc.html. Keeps the contract:
//  - constructor (data, geometry, onMotionDone),
//  - cells drawn via the geometry (one board unit = cell / 10, so cell x
//    spans x*10 .. x*10+10 exactly like geometry.rectOf),
//  - onMotionDone(motion.id) called exactly once per motion.
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../contracts/view_models.dart';
import '../../features/gameplay/board_geometry.dart';
import '../theme/tokens.dart';

class BoardCanvas extends StatefulWidget {
  const BoardCanvas({super.key, required this.data, required this.geometry, required this.onMotionDone});

  final BoardViewData data;
  final BoardGeometry geometry;
  final void Function(int motionId) onMotionDone;

  @override
  State<BoardCanvas> createState() => _BoardCanvasState();
}

class _BoardCanvasState extends State<BoardCanvas> with TickerProviderStateMixin {
  late final AnimationController _c = AnimationController(vsync: this);

  /// Slow loop for the hint glow, firefly and hammer shimmer.
  late final AnimationController _idle = AnimationController(vsync: this, duration: const Duration(milliseconds: 1600));
  int? _playing;

  bool get _reduced => widget.data.reducedMotion || AppMotion.reduced(context);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _sync();
    });
  }

  @override
  void didUpdateWidget(BoardCanvas old) {
    super.didUpdateWidget(old);
    _sync();
  }

  void _sync() {
    final d = widget.data;
    final wantIdle = !_reduced && (d.hintSnakeId != null || d.hammerMode);
    if (wantIdle && !_idle.isAnimating) _idle.repeat();
    if (!wantIdle && _idle.isAnimating) _idle.stop();

    final m = d.motion;
    if (m == null || m.id == _playing) return;
    _playing = m.id;
    _c.duration = _reduced
        ? const Duration(milliseconds: 150)
        : switch (m.kind) {
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
    _idle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Semantics(
    label: 'Garden board with ${widget.data.board.snakes.length} snakes',
    child: AnimatedBuilder(
      animation: Listenable.merge([_c, _idle]),
      builder: (_, _) => CustomPaint(
        size: widget.geometry.size,
        painter: BoardPainter(widget.data, widget.geometry, _c.value, _idle.value),
      ),
    ),
  );
}

const _u = 10.0; // board units per cell

class BoardPainter extends CustomPainter {
  BoardPainter(this.d, this.g, this.t, this.idle);
  final BoardViewData d;
  final BoardGeometry g;
  final double t;
  final double idle;

  int get cols => g.columns;
  int get rows => g.rows;

  @override
  void paint(Canvas canvas, Size size) {
    final k = g.cell / _u;
    canvas.save();
    canvas.scale(k);
    // The frame sits in the 16 dp gutter, so it never pushes cells around.
    final m = math.min(6.0, 15 / k);
    _frame(canvas, m);
    _lawn(canvas);
    _tiles(canvas);
    if (d.hammerMode) {
      canvas.drawRRect(_lawnRect(), Paint()..color = const Color(0x800F1D0B));
    }
    _shadows(canvas);
    for (final r in d.board.rocks.values) {
      _rock(canvas, r.cell);
    }
    final motion = d.motion;
    canvas.save();
    canvas.clipRRect(_lawnRect().inflate(.4));
    for (final s in d.board.snakes.values) {
      if (motion != null && motion.snake.id == s.id) continue;
      _snake(canvas, _restPose(s), s);
    }
    if (motion != null) {
      _snake(canvas, _motionPose(motion), motion.snake);
    }
    canvas.restore();
    if (motion != null && motion.kind == MotionKind.bump && motion.lane.blocker != null) {
      final flash = t < .5 ? t * 2 : (1 - t) * 2;
      _cross(canvas, _c(motion.lane.blocker!), flash);
    }
    final pv = d.preview;
    if (pv != null) {
      final s = d.board.snakes[pv.snakeId];
      if (s != null) _lane(canvas, s, pv.lane);
    }
    canvas.restore();
  }

  // ── geometry helpers ──
  Offset _c(Cell c) => Offset(c.x * _u + _u / 2, c.y * _u + _u / 2);
  RRect _lawnRect() => RRect.fromLTRBR(-1.6, -1.6, cols * _u + 1.6, rows * _u + 1.6, const Radius.circular(2.6));

  // ── frame, lawn, tiles ──
  void _frame(Canvas canvas, double m) {
    final outer = Rect.fromLTRB(-m, -m, cols * _u + m, rows * _u + m);
    final r = Radius.circular(m * .85);
    canvas.drawRRect(
      RRect.fromRectAndRadius(outer.shift(const Offset(0, 1.4)), r),
      Paint()..color = const Color(0xFF4A2C17),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(outer, r),
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFB9834F), Color(0xFF94603A), Color(0xFF6B4024)],
          stops: [0, .45, 1],
        ).createShader(outer),
    );
    // Wood grain: thin darker lines along the frame.
    final grain = Paint()
      ..color = const Color(0x225A3820)
      ..strokeWidth = .25;
    for (var y = outer.top + .8; y < outer.bottom; y += 1.3) {
      canvas.drawLine(Offset(outer.left, y), Offset(outer.left + m - 1.6, y), grain);
      canvas.drawLine(Offset(outer.right - m + 1.6, y), Offset(outer.right, y), grain);
    }
    canvas.drawRRect(
      RRect.fromRectAndRadius(outer.deflate(.4), r),
      Paint()
        ..color = const Color(0xBFD9A877)
        ..style = PaintingStyle.stroke
        ..strokeWidth = .5,
    );
    final nail = Paint()..color = const Color(0xFF3B2616);
    final head = Paint()..color = const Color(0xFFA98463);
    for (final p in [
      outer.topLeft + Offset(m * .37, m * .37),
      outer.topRight + Offset(-m * .37, m * .37),
      outer.bottomLeft + Offset(m * .37, -m * .37),
      outer.bottomRight + Offset(-m * .37, -m * .37),
    ]) {
      canvas.drawCircle(p, .62, nail);
      canvas.drawCircle(p - const Offset(.2, .22), .22, head);
    }
  }

  void _lawn(Canvas canvas) {
    final rr = _lawnRect();
    const lawn = Color(0xFF7DBF5A);
    final hi = Color.lerp(lawn, Colors.white, .28)!;
    canvas.drawRRect(
      rr,
      Paint()
        ..shader = RadialGradient(
          center: const Alignment(-.1, -.3),
          radius: .85,
          colors: [hi, lawn],
        ).createShader(rr.outerRect),
    );
    canvas.drawRRect(
      rr.deflate(.7),
      Paint()
        ..color = const Color(0x73173A0E)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.4
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, .45),
    );
  }

  void _tiles(Canvas canvas) {
    final shadow = Paint()
      ..color = const Color(0x4713240C)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, .45);
    final hl = Paint()
      ..color = const Color(0xD9FFFFFF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = .4
      ..strokeCap = StrokeCap.round;
    for (var y = 0; y < rows; y++) {
      for (var x = 0; x < cols; x++) {
        final r = Rect.fromLTWH(x * _u + .6, y * _u + .6, 8.8, 8.8);
        canvas.drawRRect(RRect.fromRectAndRadius(r.shift(const Offset(.7, 1)), const Radius.circular(1.9)), shadow);
        final b = (x * 3 + y * 5) % 3 == 0;
        canvas.drawRRect(
          RRect.fromRectAndRadius(r, const Radius.circular(1.9)),
          Paint()
            ..shader = RadialGradient(
              center: const Alignment(-.36, -.44),
              radius: .95,
              colors: b
                  ? const [Color(0xFFFAF6EC), Color(0xFFE6DDCB), Color(0xFFC9BCA3)]
                  : const [Color(0xFFFDFBF5), Color(0xFFEDE6D6), Color(0xFFD2C7B0)],
              stops: const [0, .55, 1],
            ).createShader(r),
        );
        canvas.drawPath(
          Path()
            ..moveTo(r.left + .6, r.top + 7.6)
            ..lineTo(r.left + .6, r.top + 1.3)
            ..quadraticBezierTo(r.left + .6, r.top + .3, r.left + 1.6, r.top + .3)
            ..lineTo(r.left + 7.2, r.top + .3),
          hl,
        );
      }
    }
    // Grass tufts where four stones meet.
    final dark = Paint()
      ..color = const Color(0xFF2F6B1E)
      ..style = PaintingStyle.stroke
      ..strokeWidth = .5
      ..strokeCap = StrokeCap.round;
    final light = Paint()
      ..color = const Color(0xFF9FD67D)
      ..style = PaintingStyle.stroke
      ..strokeWidth = .35
      ..strokeCap = StrokeCap.round;
    for (var y = 0; y <= rows; y++) {
      for (var x = 0; x <= cols; x++) {
        if ((x * 7 + y * 3).isOdd) continue;
        final bx = x * _u + .2, by = y * _u + .4;
        canvas.drawPath(
          Path()
            ..moveTo(bx - .7, by)
            ..relativeQuadraticBezierTo(.2, -1.4, -.5, -2)
            ..moveTo(bx, by)
            ..relativeQuadraticBezierTo(.1, -1.8, .6, -2.4)
            ..moveTo(bx + .6, by)
            ..relativeQuadraticBezierTo(.4, -1.2, 1.1, -1.5),
          dark,
        );
        canvas.drawPath(
          Path()
            ..moveTo(bx - .2, by - .2)
            ..relativeQuadraticBezierTo(.1, -1.2, .4, -1.7),
          light,
        );
      }
    }
  }

  void _shadows(Canvas canvas) {
    final p = Paint()
      ..color = const Color(0x6B0E1C0A)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1.05);
    final stroke = Paint()
      ..color = p.color
      ..maskFilter = p.maskFilter
      ..style = PaintingStyle.stroke
      ..strokeWidth = 7.4
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.save();
    canvas.translate(1.1, 2.1);
    for (final s in d.board.snakes.values) {
      if (d.motion?.snake.id == s.id) continue;
      final pts = s.body.map(_c).toList();
      canvas.drawPath(_poly(pts), stroke);
      canvas.drawCircle(pts.first, 4.7, p);
    }
    canvas.restore();
    for (final r in d.board.rocks.values) {
      final c = _c(r.cell);
      canvas.drawOval(Rect.fromCenter(center: c + const Offset(1, 3.4), width: 8.8, height: 5.2), p);
    }
  }

  void _rock(Canvas canvas, Cell cell) {
    final c = _c(cell);
    final x = c.dx, y = c.dy;
    if (d.hammerMode) {
      final a = .75 + .2 * math.sin(idle * 2 * math.pi);
      canvas.drawCircle(
        c,
        6.2,
        Paint()
          ..color = Colors.white.withValues(alpha: a)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1.7),
      );
    }
    final body = Path()
      ..moveTo(x - 4.3, y + 1.8)
      ..quadraticBezierTo(x - 4.8, y - 2.2, x - 1.4, y - 3.8)
      ..quadraticBezierTo(x + 2.4, y - 4.7, x + 4.2, y - .8)
      ..quadraticBezierTo(x + 5, y + 2.8, x + 1.2, y + 3.6)
      ..quadraticBezierTo(x - 3.2, y + 4, x - 4.3, y + 1.8)
      ..close();
    final box = body.getBounds();
    canvas.drawPath(
      body,
      Paint()
        ..shader = const RadialGradient(
          center: Alignment(-.32, -.44),
          radius: .9,
          colors: [Color(0xFFD3D8D4), Color(0xFF9DA6A0), Color(0xFF66706A)],
          stops: [0, .5, 1],
        ).createShader(box),
    );
    canvas.drawPath(
      body,
      Paint()
        ..color = const Color(0xFF59645D)
        ..style = PaintingStyle.stroke
        ..strokeWidth = .55
        ..strokeJoin = StrokeJoin.round,
    );
    canvas.drawPath(
      Path()
        ..moveTo(x + .6, y - 1.2)
        ..relativeLineTo(1, 1.3)
        ..relativeLineTo(-.4, 1.4)
        ..moveTo(x - 2, y + 1.6)
        ..relativeLineTo(1.2, .5),
      Paint()
        ..color = const Color(0xCC5B655F)
        ..style = PaintingStyle.stroke
        ..strokeWidth = .35
        ..strokeCap = StrokeCap.round,
    );
    canvas.drawOval(
      Rect.fromCenter(center: Offset(x - 1.6, y - 1.9), width: 3.4, height: 1.8),
      Paint()
        ..color = const Color(0x8CFFFFFF)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, .45),
    );
    final moss = Path()
      ..moveTo(x - .6, y - 3.9)
      ..relativeQuadraticBezierTo(2, -1.2, 4.2, .6)
      ..relativeQuadraticBezierTo(.4, .9, -.6, 1)
      ..relativeQuadraticBezierTo(-1.2, -.8, -2, 0)
      ..relativeQuadraticBezierTo(-1.1, -.4, -1.6, -1.6)
      ..close();
    canvas.drawPath(moss, Paint()..color = const Color(0xFF6FAE3E));
    canvas.drawPath(
      moss,
      Paint()
        ..color = const Color(0xFF3E7A22)
        ..style = PaintingStyle.stroke
        ..strokeWidth = .3,
    );
  }

  // ── snakes ──

  /// Points from head to tail plus the head direction.
  _Pose _restPose(Snake s) => _Pose(s.body.map(_c).toList(), Offset(s.dir.dx.toDouble(), s.dir.dy.toDouble()));

  _Pose _motionPose(Motion m) {
    final s = m.snake;
    final dir = Offset(s.dir.dx.toDouble(), s.dir.dy.toDouble());
    switch (m.kind) {
      case MotionKind.locked:
        final wob = math.sin(t * math.pi * 4) * .9 * (1 - t);
        final pose = _restPose(s);
        return _Pose([for (final p in pose.points) p + Offset(wob, 0)], dir);
      case MotionKind.exit:
        final travel = (m.lane.cells.length + s.length + 1) * _u;
        return _slide(s, dir, Curves.easeIn.transform(t) * travel);
      case MotionKind.bump:
        final reach = m.lane.cells.isEmpty ? .25 * _u : m.lane.cells.length * _u + .2 * _u;
        final there = t < .55 ? Curves.easeOut.transform(t / .55) : 1 - Curves.easeIn.transform((t - .55) / .45);
        return _slide(s, dir, reach * there);
    }
  }

  /// The snake slithers [dist] units along its own body and then straight
  /// ahead, so the tail follows the bends the head took.
  _Pose _slide(Snake s, Offset dir, double dist) {
    final body = s.body.map(_c).toList(); // head first
    final track = <Offset>[...body.reversed]; // tail → head
    final ahead = s.length + 40;
    for (var i = 1; i <= ahead; i++) {
      track.add(body.first + dir * (i * _u));
    }
    final cum = <double>[0];
    for (var i = 1; i < track.length; i++) {
      cum.add(cum.last + (track[i] - track[i - 1]).distance);
    }
    Offset at(double a) {
      a = a.clamp(0, cum.last);
      var i = 1;
      while (i < cum.length - 1 && cum[i] < a) {
        i++;
      }
      final f = (a - cum[i - 1]) / math.max(1e-6, cum[i] - cum[i - 1]);
      return Offset.lerp(track[i - 1], track[i], f)!;
    }

    final len = (s.length - 1) * _u;
    final pts = <Offset>[];
    for (var k = 0; k < s.length; k++) {
      pts.add(at(dist + len - k * _u)); // head first
    }
    final h = pts.length > 1 ? (pts[0] - pts[1]) : dir;
    final hd = h.distance < 1e-6 ? dir : h / h.distance;
    return _Pose(pts, hd);
  }

  Path _poly(List<Offset> pts) {
    final p = Path()..moveTo(pts.first.dx, pts.first.dy);
    for (final q in pts.skip(1)) {
      p.lineTo(q.dx, q.dy);
    }
    if (pts.length == 1) p.lineTo(pts.first.dx + .01, pts.first.dy);
    return p;
  }

  Paint _stroke(Color c, double w, {bool round = true}) => Paint()
    ..color = c
    ..style = PaintingStyle.stroke
    ..strokeWidth = w
    ..strokeCap = round ? StrokeCap.round : StrokeCap.butt
    ..strokeJoin = StrokeJoin.round;

  void _snake(Canvas canvas, _Pose pose, Snake s) {
    final pal = AppColors.snakePalette(s.color);
    final pts = pose.points;
    final head = pts.first;
    final dir = pose.dir;
    final path = _poly(pts);
    final glow = d.hammerMode || d.hintSnakeId == s.id;
    if (glow) {
      final pulse = .75 + .25 * math.sin(idle * 2 * math.pi);
      final gc = (d.hammerMode ? Colors.white : const Color(0xFFFFE066)).withValues(alpha: pulse);
      final blur = const MaskFilter.blur(BlurStyle.normal, 1.7);
      canvas.drawPath(path, _stroke(gc, 11)..maskFilter = blur);
      canvas.drawCircle(
        head,
        6.6,
        Paint()
          ..color = gc
          ..maskFilter = blur,
      );
    }
    final grad = RadialGradient(
      center: const Alignment(-.28, -.4),
      radius: .78,
      colors: [pal.light, pal.body, pal.dark],
      stops: const [0, .48, 1],
    );
    if (s.skin == SnakeSkin.caterpillar) {
      for (var i = pts.length - 1; i >= 1; i--) {
        final p = pts[i];
        final prev = pts[i - 1];
        var dv = prev - p;
        dv = dv.distance < 1e-6 ? dir : dv / dv.distance;
        final perp = Offset(-dv.dy, dv.dx);
        final feet = Paint()..color = pal.dark;
        canvas.drawCircle(p + perp * 3.9, .75, feet);
        canvas.drawCircle(p - perp * 3.9, .75, feet);
        final r = Rect.fromCircle(center: p, radius: 4.15);
        canvas.drawCircle(p, 4.15, Paint()..shader = grad.createShader(r));
        canvas.drawCircle(p, 4.15, _stroke(pal.dark, .6));
        canvas.drawOval(
          Rect.fromCenter(center: p + const Offset(-1.3, -1.7), width: 3, height: 1.8),
          Paint()
            ..color = const Color(0x99FFFFFF)
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, .45),
        );
      }
    } else {
      final pattern = d.colourBlind ? math.min(1.0, pal.patternOpacity + .15) : pal.patternOpacity;
      canvas.drawPath(path, _stroke(pal.dark, 8));
      canvas.drawPath(path, _stroke(pal.body, 6.7));
      canvas.drawPath(
        _dashed(path, pal.dash),
        _stroke(pal.dark.withValues(alpha: .22), pal.patternWidth, round: pal.roundCap),
      );
      canvas.drawPath(
        path.shift(const Offset(-.45, -.85)),
        _stroke(pal.light.withValues(alpha: .6), 3.4)..maskFilter = const MaskFilter.blur(BlurStyle.normal, .45),
      );
      canvas.drawPath(
        _dashed(path.shift(const Offset(.3, .3)), pal.dash),
        _stroke(pal.light.withValues(alpha: pattern), pal.patternWidth, round: pal.roundCap),
      );
      canvas.drawPath(
        path.shift(const Offset(-.75, -1.6)),
        _stroke(const Color(0xBFFFFFFF), .9)..maskFilter = const MaskFilter.blur(BlurStyle.normal, .45),
      );
    }
    _head(canvas, head, dir, pal, grad, s.skin == SnakeSkin.caterpillar);
    if (d.hintSnakeId == s.id) _firefly(canvas, head + Offset(3.5, 5.6 - 1.2 * math.sin(idle * 2 * math.pi)));
  }

  void _firefly(Canvas canvas, Offset c) {
    canvas.drawCircle(
      c,
      4.2,
      Paint()
        ..color = const Color(0xE6FFF59D)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1.7),
    );
    canvas.drawOval(
      Rect.fromCenter(center: c + const Offset(-.4, -1.4), width: 3.2, height: 1.8),
      Paint()..color = const Color(0xD9FFFFFF),
    );
    canvas.drawCircle(c, 1.3, Paint()..color = const Color(0xFFFFD54F));
    canvas.drawCircle(c, 1.3, _stroke(const Color(0xFFB8860B), .35));
  }

  void _head(Canvas canvas, Offset h, Offset dir, SnakePalette pal, RadialGradient grad, bool cat) {
    final perp = Offset(-dir.dy, dir.dx);
    Offset pt(double fw, double sd) => h + dir * fw + perp * sd;
    if (cat) {
      final b1 = pt(3.4, 1.2), b2 = pt(3.4, -1.2), a1 = pt(6.4, 2.6), a2 = pt(6.4, -2.6);
      final c1 = pt(5, 2.4), c2 = pt(5, -2.4);
      canvas.drawPath(
        Path()
          ..moveTo(b1.dx, b1.dy)
          ..quadraticBezierTo(c1.dx, c1.dy, a1.dx, a1.dy)
          ..moveTo(b2.dx, b2.dy)
          ..quadraticBezierTo(c2.dx, c2.dy, a2.dx, a2.dy),
        _stroke(pal.dark, .6),
      );
      for (final a in [a1, a2]) {
        canvas.drawCircle(a, .85, Paint()..shader = grad.createShader(Rect.fromCircle(center: a, radius: .85)));
        canvas.drawCircle(a, .85, _stroke(pal.dark, .35));
      }
    }
    final r = Rect.fromCircle(center: h, radius: 4.85);
    canvas.drawCircle(h, 4.85, Paint()..shader = grad.createShader(r));
    canvas.drawCircle(h, 4.85, _stroke(pal.dark, .65));
    canvas.drawOval(
      Rect.fromCenter(center: h + const Offset(-1.5, -2.1), width: 3.6, height: 2.1),
      Paint()
        ..color = const Color(0xB3FFFFFF)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, .45),
    );
    final cheek = Paint()
      ..color = const Color(0x8CFF7A70)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, .45);
    canvas.drawCircle(pt(-.9, 3), 1.05, cheek);
    canvas.drawCircle(pt(-.9, -3), 1.05, cheek);
    final nostril = Paint()..color = pal.dark;
    canvas.drawCircle(pt(3.7, .75), .28, nostril);
    canvas.drawCircle(pt(3.7, -.75), .28, nostril);
    for (final sd in [1.95, -1.95]) {
      final e = pt(1.15, sd);
      canvas.drawCircle(
        e,
        1.55,
        Paint()
          ..shader = const RadialGradient(
            center: Alignment(-.2, -.3),
            radius: .7,
            colors: [Colors.white, Color(0xFFDCE3DD)],
          ).createShader(Rect.fromCircle(center: e, radius: 1.55)),
      );
      canvas.drawCircle(e, 1.55, _stroke(pal.dark, .25));
      final p = pt(1.8, sd);
      canvas.drawCircle(p, .85, Paint()..color = const Color(0xFF14200F));
      canvas.drawCircle(p - const Offset(.3, .35), .32, Paint()..color = Colors.white);
    }
  }

  Path _dashed(Path src, List<double> pattern) {
    final out = Path();
    for (final m in src.computeMetrics()) {
      var d = 0.0;
      var on = true;
      var i = 0;
      while (d < m.length) {
        final len = pattern[i % pattern.length];
        if (on) out.addPath(m.extractPath(d, math.min(d + math.max(len, .01), m.length)), Offset.zero);
        d += len;
        on = !on;
        i++;
      }
    }
    return out;
  }

  // ── preview lane (Tongue-Flick Preview) ──
  void _lane(Canvas canvas, Snake s, LaneTrace lane) {
    final dir = Offset(s.dir.dx.toDouble(), s.dir.dy.toDouble());
    final h = _c(s.head);
    final blocked = lane.blocker != null;
    final col = blocked ? AppColors.previewBlocked : AppColors.previewClear;
    final start = h + dir * 7.6;
    Offset end;
    if (blocked) {
      end = _c(lane.blocker!) - dir * 3.4;
    } else {
      final lastCell = lane.cells.isEmpty ? s.head : lane.cells.last;
      end = _c(lastCell) + dir * 3;
    }
    if ((end - h).distance > (start - h).distance) {
      final line = Path()
        ..moveTo(start.dx, start.dy)
        ..lineTo(end.dx, end.dy);
      canvas.drawPath(_dashed(line, const [.1, 2.3]), _stroke(const Color(0xE6FFFFFF), 2));
      canvas.drawPath(_dashed(line, const [.1, 2.3]), _stroke(col, 1.25));
    }
    final t0 = h + dir * 4.6, t1 = h + dir * 6.4;
    final perp = Offset(-dir.dy, dir.dx);
    canvas.drawPath(
      Path()
        ..moveTo(t0.dx, t0.dy)
        ..lineTo(t1.dx, t1.dy)
        ..relativeLineTo(dir.dx * 1.1 + perp.dx * .9, dir.dy * 1.1 + perp.dy * .9)
        ..moveTo(t1.dx, t1.dy)
        ..relativeLineTo(dir.dx * 1.1 - perp.dx * .9, dir.dy * 1.1 - perp.dy * .9),
      _stroke(const Color(0xFFD81B3C), .75),
    );
    if (blocked) _cross(canvas, _c(lane.blocker!), 1);
  }

  void _cross(Canvas canvas, Offset c, double a) {
    if (a <= 0) return;
    canvas.drawCircle(c, 3.2, Paint()..color = Colors.white.withValues(alpha: a));
    canvas.drawCircle(c, 3.2, _stroke(AppColors.previewBlocked.withValues(alpha: a), .8));
    final x = _stroke(AppColors.previewBlocked.withValues(alpha: a), 1.1);
    canvas.drawLine(c + const Offset(-1.4, -1.4), c + const Offset(1.4, 1.4), x);
    canvas.drawLine(c + const Offset(1.4, -1.4), c + const Offset(-1.4, 1.4), x);
  }

  @override
  bool shouldRepaint(BoardPainter o) => o.t != t || o.idle != idle || o.d != d || o.g.cell != g.cell;
}

class _Pose {
  const _Pose(this.points, this.dir);

  /// Head first.
  final List<Offset> points;
  final Offset dir;
}
