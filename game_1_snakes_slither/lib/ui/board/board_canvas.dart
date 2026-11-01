// OWNER: UI agent. Canvas: Board.dc.html (garden board), Preview.dc.html,
// Hint.dc.html, Hammer.dc.html. Keeps the contract:
//  - constructor (data, geometry, onMotionDone),
//  - cells drawn via the geometry (one board unit = cell / 10, so cell x
//    spans x*10 .. x*10+10 exactly like geometry.rectOf),
//  - onMotionDone(motion.id) called exactly once per motion.
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../../contracts/view_models.dart';
import '../../features/gameplay/board_geometry.dart';
import '../theme/tokens.dart';
import 'mechanic_art.dart';

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
    final wantIdle =
        !_reduced && (d.hintSnakeId != null || d.hintObstacleId != null || d.hammerMode || d.guideSnakeId != null);
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
            MotionKind.slide => AppMotion.exitFor(m.lane.cells.length),
            MotionKind.action => const Duration(milliseconds: 220),
          };
    // The lock-reason icon stays up for 600 ms.
    if (m.kind == MotionKind.locked && m.lockReason != null && !_reduced) {
      _c.duration = const Duration(milliseconds: 600);
    }
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

/// Pictures of the parts of the board that don't move between Moves. Each
/// is recorded once and replayed every frame, so an animating frame only
/// paints what moves (and blurs are never recomputed per frame).
class _StaticLayers {
  static String? _bgKey;
  static ui.Picture? _bg;
  static Object? _restKey;
  static ui.Picture? _rest;

  static ui.Picture background(String key, void Function(Canvas) paint) {
    if (_bgKey == key && _bg != null) return _bg!;
    _bg?.dispose();
    _bgKey = key;
    return _bg = _record(paint);
  }

  static ui.Picture resting(Object key, void Function(Canvas) paint) {
    if (_restKey == key && _rest != null) return _rest!;
    _rest?.dispose();
    _restKey = key;
    return _rest = _record(paint);
  }

  static ui.Picture _record(void Function(Canvas) paint) {
    final rec = ui.PictureRecorder();
    paint(Canvas(rec));
    return rec.endRecording();
  }
}

/// Identity of the resting layer: rebuilt when the board, the set of moving
/// snakes or a display option changes.
class _RestKey {
  _RestKey(this.board, this.moving, this.colourBlind, this.cell);
  final BoardState board;
  final Set<int> moving;
  final bool colourBlind;
  final double cell;
  @override
  bool operator ==(Object o) =>
      o is _RestKey &&
      identical(o.board, board) &&
      o.colourBlind == colourBlind &&
      o.cell == cell &&
      o.moving.length == moving.length &&
      o.moving.containsAll(moving);
  @override
  int get hashCode => Object.hash(identityHashCode(board), colourBlind, cell, moving.length);
}

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
    canvas.drawPicture(
      _StaticLayers.background('$cols x $rows @ $m', (c) {
        _frame(c, m);
        _lawn(c);
        _tiles(c);
      }),
    );
    if (d.hammerMode) {
      canvas.drawRRect(_lawnRect(), Paint()..color = const Color(0x800F1D0B));
    }
    final motion = d.motion;
    final pulse = motion?.kind == MotionKind.action ? math.sin(t * math.pi) : 0.0;
    final moving = motion?.snakeIds.toSet() ?? const <int>{};
    // Glows (Hint, Hammer, tutorial) and pulses animate every frame, so
    // those boards are painted live; every other board replays one picture.
    final live = d.hammerMode || d.hintSnakeId != null || d.hintObstacleId != null || pulse > 0;
    void resting(Canvas c) {
      for (final o in d.board.obstacles) {
        _obstacle(c, o, top: false, pulse: motion?.obstacle?.id == o.id ? pulse : 0);
      }
      _shadows(c);
      for (final r in d.board.rocks.values) {
        _rock(c, r.cell);
      }
      c.save();
      c.clipRRect(_lawnRect().inflate(.4));
      // Ground layer first, Canopy (layer 1) on top.
      for (final layer in [0, 1]) {
        for (final s in d.board.snakes.values) {
          if (s.marks.layer != layer || moving.contains(s.id) || s.marks.hidden) continue;
          _drawSnake(c, _restPose(s), s);
        }
      }
      c.restore();
    }

    if (live) {
      resting(canvas);
    } else {
      canvas.drawPicture(_StaticLayers.resting(_RestKey(d.board, moving, d.colourBlind, g.cell), resting));
    }
    canvas.save();
    canvas.clipRRect(_lawnRect().inflate(.4));
    if (motion != null) {
      if (motion.snake.id >= 0) _drawSnake(canvas, _motionPose(motion, motion.snake, motion.lane), motion.snake);
      for (final o in motion.others) {
        _drawSnake(canvas, _motionPose(motion, o.snake, o.lane), o.snake);
      }
    }
    canvas.restore();
    for (final o in d.board.obstacles) {
      _obstacle(canvas, o, top: true, pulse: 0);
    }
    if (d.board.night) _night(canvas);
    if (motion != null && motion.kind == MotionKind.bump) {
      final flash = t < .5 ? t * 2 : (1 - t) * 2;
      for (final l in [motion.lane, for (final o in motion.others) o.lane]) {
        if (l.blocker != null) _cross(canvas, _c(l.blocker!), flash);
      }
    }
    if (motion != null && motion.kind == MotionKind.locked && motion.snake.id >= 0) {
      final a = t < .15 ? t / .15 : (t > .85 ? (1 - t) / .15 : 1.0);
      paintLockIcon(canvas, _c(motion.snake.head) + const Offset(0, -6.5), motion.lockReason, a.clamp(0, 1));
    }
    final pv = d.preview;
    if (pv != null) {
      final s = d.board.snakes[pv.snakeId];
      if (s != null) _lane(canvas, s, pv.lane);
    }
    final guide = d.guideSnakeId == null || motion != null ? null : d.board.snakes[d.guideSnakeId];
    if (guide != null) _hand(canvas, _c(guide.body[guide.body.length ~/ 2]));
    canvas.restore();
  }

  /// Tutorial hand tapping the guided snake.
  void _hand(Canvas canvas, Offset at) {
    final press = (math.sin(idle * 2 * math.pi) + 1) / 2;
    canvas.drawCircle(at, 3 + press * 3, Paint()..color = Colors.white.withValues(alpha: .55 * (1 - press)));
    final tip = at + Offset(1.2, 1.2 + press * 1.4);
    final palm = Paint()..color = const Color(0xFFFFE0C2);
    final edge = _stroke(const Color(0xFF8D5524), .45);
    final finger = RRect.fromRectAndRadius(Rect.fromLTWH(tip.dx - 1.1, tip.dy, 2.2, 5.6), const Radius.circular(1.1));
    final hand = RRect.fromRectAndRadius(Rect.fromLTWH(tip.dx - 1.6, tip.dy + 4, 5.6, 5), const Radius.circular(1.8));
    canvas.drawRRect(hand, palm);
    canvas.drawRRect(hand, edge);
    canvas.drawRRect(finger, palm);
    canvas.drawRRect(finger, edge);
  }

  void _obstacle(Canvas canvas, Obstacle o, {required bool top, required double pulse}) {
    if (pulse > 0) {
      for (final c in o.cells) {
        canvas.drawCircle(_c(c), 5 + pulse * 1.5, Paint()..color = Colors.white.withValues(alpha: .5 * pulse));
      }
    }
    paintObstacle(canvas, o, top: top, idle: idle, hammerMode: d.hammerMode, hint: d.hintObstacleId == o.id);
  }

  /// Jungle Night: dark board with light around the last moved snake and
  /// the preview lane.
  void _night(Canvas canvas) {
    final rr = _lawnRect();
    final lit = <Offset>[];
    final s = d.litSnakeId == null ? null : d.board.snakes[d.litSnakeId];
    if (s != null) lit.addAll(s.body.map(_c));
    final pv = d.preview;
    if (pv != null) lit.addAll(pv.lane.cells.map(_c));
    final m = d.motion;
    if (m != null && m.snake.id >= 0) lit.addAll(m.snake.body.map(_c));
    canvas.saveLayer(rr.outerRect.inflate(2), Paint());
    canvas.drawRRect(rr, Paint()..color = (d.brightNights ? const Color(0x99101A2E) : const Color(0xD9101A2E)));
    final hole = Paint()
      ..blendMode = BlendMode.dstOut
      ..color = const Color(0xCC000000);
    for (final p in lit) {
      canvas.drawCircle(p, 9, hole);
    }
    canvas.restore();
  }

  void _drawSnake(Canvas canvas, _Pose pose, Snake s) {
    final m = s.marks;
    final ghost = m.ghost;
    if (ghost) canvas.saveLayer(null, Paint()..color = Colors.white.withValues(alpha: .35));
    final covered = m.layer == 0 && m.lock == 'M032';
    if (covered) canvas.saveLayer(null, Paint()..color = Colors.white.withValues(alpha: .6));
    if (m.wideSide != null) {
      final side = Offset(m.wideSide!.dx.toDouble(), m.wideSide!.dy.toDouble()) * _u;
      _snake(canvas, _Pose([for (final p in pose.points) p + side], pose.dir), s, headOn: false);
    }
    _snake(canvas, pose, s);
    if (m.hydra && pose.points.length > 1) {
      final n = pose.points.length;
      final back = pose.points[n - 1] - pose.points[n - 2];
      final dir = back.distance < 1e-6 ? -pose.dir : back / back.distance;
      final pal = AppColors.snakePalette(s.color);
      _head(canvas, pose.points.last, dir, pal, _grad(pal), false);
    }
    paintSnakeMarks(canvas, s, pose.points, pose.dir, idle: idle);
    if (covered) canvas.restore();
    if (ghost) canvas.restore();
  }

  RadialGradient _grad(SnakePalette pal) => RadialGradient(
    center: const Alignment(-.28, -.4),
    radius: .78,
    colors: [pal.light, pal.body, pal.dark],
    stops: const [0, .48, 1],
  );

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
    final moving = d.motion?.snakeIds.toSet() ?? const <int>{};
    for (final s in d.board.snakes.values) {
      if (moving.contains(s.id) || s.marks.hidden) continue;
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

  _Pose _motionPose(Motion m, Snake s, LaneTrace lane) {
    final dir = Offset(s.dir.dx.toDouble(), s.dir.dy.toDouble());
    switch (m.kind) {
      case MotionKind.locked || MotionKind.action:
        final wob = m.kind == MotionKind.locked ? math.sin(t * math.pi * 4) * .9 * (1 - t) : 0.0;
        final pose = _restPose(s);
        return _Pose([for (final p in pose.points) p + Offset(wob, 0)], dir);
      case MotionKind.exit:
        final travel = (lane.cells.length + s.length + 1) * _u;
        return _slide(s, lane, Curves.easeIn.transform(t) * travel);
      case MotionKind.slide:
        return _slide(s, lane, Curves.easeInOut.transform(t) * lane.cells.length * _u, endHere: true);
      case MotionKind.bump:
        final reach = lane.cells.isEmpty ? .25 * _u : lane.cells.length * _u + .2 * _u;
        final there = t < .55 ? Curves.easeOut.transform(t / .55) : 1 - Curves.easeIn.transform((t - .55) / .45);
        return _slide(s, lane, reach * there);
    }
  }

  /// The snake slithers [dist] units along its own body, then along the
  /// lane (which may bend or jump through burrows), then straight on, so
  /// the tail follows every bend the head took. A tail-first lane runs the
  /// track the other way round.
  _Pose _slide(Snake s, LaneTrace lane, double dist, {bool endHere = false}) {
    final fwd = s.body.map(_c).toList(); // head first
    final body = lane.fromTail ? fwd.reversed.toList() : fwd; // leading end first
    final track = <Offset>[...body.reversed];
    for (final c in lane.cells) {
      track.add(_c(c));
    }
    final last = track.last;
    final sd = Offset(s.dir.dx.toDouble(), s.dir.dy.toDouble());
    final ed = lane.exitDir ?? (lane.fromTail ? null : s.dir);
    Offset dir;
    if (ed != null) {
      dir = Offset(ed.dx.toDouble(), ed.dy.toDouble());
    } else {
      final v = track.length > 1 ? track.last - track[track.length - 2] : sd;
      dir = v.distance < 1e-6 ? sd : v / v.distance;
    }
    if (!endHere) {
      for (var i = 1; i <= s.length + 40; i++) {
        track.add(last + dir * (i * _u));
      }
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
      pts.add(at(dist + len - k * _u)); // leading end first
    }
    final ordered = lane.fromTail ? pts.reversed.toList() : pts; // head first again
    final h = ordered.length > 1 ? (ordered[0] - ordered[1]) : dir;
    final hd = h.distance < 1e-6 ? sd : h / h.distance;
    return _Pose(ordered, hd);
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

  void _snake(Canvas canvas, _Pose pose, Snake s, {bool headOn = true}) {
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
    if (!headOn) return;
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
    final startCell = lane.fromTail ? s.body.last : s.head;
    final h = _c(startCell);
    Offset dir;
    if (lane.fromTail && s.body.length > 1) {
      final v = _c(s.body.last) - _c(s.body[s.body.length - 2]);
      dir = v / v.distance;
    } else {
      dir = Offset(s.dir.dx.toDouble(), s.dir.dy.toDouble());
    }
    final blocked = lane.blocker != null;
    final col = lane.unknown
        ? const Color(0xFF90A4AE)
        : blocked
        ? AppColors.previewBlocked
        : AppColors.previewClear;
    // Polyline through every lane cell; a burrow jump starts a new piece.
    final pts = <Offset>[h + dir * 7.6, for (final c in lane.cells) _c(c)];
    if (blocked) {
      final bc = _c(lane.blocker!);
      final from = pts.length > 1 ? pts.last : h;
      final v = bc - from;
      pts.add(v.distance < 1e-6 ? bc : bc - v / v.distance * 3.4);
    } else if (!lane.unknown) {
      final ed = lane.exitDir;
      final out = ed == null ? dir : Offset(ed.dx.toDouble(), ed.dy.toDouble());
      pts.add((pts.length > 1 ? pts.last : h) + out * 3);
    }
    if (pts.length > 1) {
      final line = Path()..moveTo(pts.first.dx, pts.first.dy);
      for (var i = 1; i < pts.length; i++) {
        if ((pts[i] - pts[i - 1]).distance > _u * 1.6) {
          line.moveTo(pts[i].dx, pts[i].dy);
        } else {
          line.lineTo(pts[i].dx, pts[i].dy);
        }
      }
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
    if (lane.unknown) {
      final end = pts.last;
      canvas.drawCircle(end, 2.6, Paint()..color = Colors.white);
      canvas.drawCircle(end, 2.6, _stroke(const Color(0xFF90A4AE), .6));
      final tp = TextPainter(
        text: const TextSpan(
          text: '?',
          style: TextStyle(fontFamily: 'Fredoka', fontSize: 3.6, color: Color(0xFF607D8B), fontWeight: FontWeight.w700),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, end - Offset(tp.width / 2, tp.height / 2));
    }
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
