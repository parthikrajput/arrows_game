import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:puzzle_core/slither_engine.dart';

import '../../../app/theme/tokens.dart';
import 'game_scene.dart';

class BoardPainter extends CustomPainter {
  BoardPainter({required this.scene}) : super(repaint: scene);

  final GameScene scene;

  @override
  void paint(Canvas canvas, Size size) {
    final l = scene.layout;
    if (l == null) return;
    canvas.drawPicture(scene.staticLayer(size));

    final hint = scene.hintSnakeId ?? scene.highlightSnakeId;
    if (hint != null) {
      final s = scene.spriteById(hint);
      if (s != null) HintRenderer.draw(canvas, l, s, scene.clock, golden: scene.hintSnakeId != null);
    }

    final m = scene.motion;
    if (m != null) {
      final flash = m.blockerFlash;
      if (flash > 0 && m.blocker != null) {
        final r = Rect.fromCenter(center: l.center(m.blocker!), width: l.cell * 0.92, height: l.cell * 0.92);
        canvas.drawRRect(
          RRect.fromRectAndRadius(r, Radius.circular(l.cell * 0.18)),
          Paint()..color = AppColors.previewBlocked.withValues(alpha: 0.45 * flash),
        );
      }
      SnakeRenderer.drawMoving(canvas, l, m, scene.wigglePhase, scene.reducedMotion, scene.colourBlind);
    }

    final p = scene.preview;
    if (p != null) PreviewRenderer.draw(canvas, l, p, blocked: scene.previewBlocked);

    for (final f in scene.floaters) {
      final tp = TextPainter(
        text: TextSpan(
          text: f.text,
          style: TextStyle(
            color: f.color.withValues(alpha: 1 - f.t),
            fontSize: l.cell * 0.55,
            fontWeight: FontWeight.w800,
            shadows: const [Shadow(color: Colors.white, blurRadius: 4)],
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, f.at - Offset(tp.width / 2, tp.height / 2 + f.t * l.cell));
    }
  }

  @override
  bool shouldRepaint(covariant BoardPainter oldDelegate) => oldDelegate.scene != scene;
}

class BoardBackground {
  static void draw(Canvas canvas, BoardLayout l, {required Color tint, bool golden = false}) {
    final r = RRect.fromRectAndRadius(l.rect.inflate(6), const Radius.circular(20));
    // Soft shadow baked once into the cached picture (not per frame).
    canvas.drawRRect(
      r.shift(const Offset(0, 8)),
      Paint()
        ..color = Colors.black.withValues(alpha: 0.14)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10),
    );
    // Wooden / golden frame with bevel.
    canvas.drawRRect(
      r.inflate(3),
      Paint()..color = golden ? const Color(0xFFB8860B) : const Color(0xFF9C7A5B),
    );
    canvas.drawRRect(
      r,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: golden
              ? const [Color(0xFFFFF3C4), Color(0xFFFFE082)]
              : [Color.lerp(tint, Colors.white, 0.35)!, Color.lerp(tint, const Color(0xFF9CCC9C), 0.35)!],
        ).createShader(r.outerRect),
    );
    // Checker grass tiles.
    final tile = Paint()..color = (golden ? const Color(0xFFFFD54F) : const Color(0xFF8BC34A)).withValues(alpha: 0.10);
    for (var y = 0; y < l.rows; y++) {
      for (var x = 0; x < l.cols; x++) {
        if ((x + y).isEven) {
          canvas.drawRRect(
            RRect.fromRectAndRadius(
              Rect.fromLTWH(l.origin.dx + x * l.cell, l.origin.dy + y * l.cell, l.cell, l.cell).deflate(1),
              Radius.circular(l.cell * 0.18),
            ),
            tile,
          );
        }
      }
    }
    final dot = Paint()..color = const Color(0xFF7FAF7F).withValues(alpha: 0.55);
    for (var y = 0; y < l.rows; y++) {
      for (var x = 0; x < l.cols; x++) {
        canvas.drawCircle(l.center(Cell(x, y)), math.max(1.2, l.cell * 0.045), dot);
      }
    }
  }
}

class SnakeRenderer {
  static ui.Path _bodyPath(BoardLayout l, SnakeSprite s) {
    final path = ui.Path();
    final head = l.center(s.body.first);
    path.moveTo(head.dx, head.dy);
    for (final c in s.body.skip(1)) {
      final p = l.center(c);
      path.lineTo(p.dx, p.dy);
    }
    return path;
  }

  static void drawStatic(Canvas canvas, BoardLayout l, SnakeSprite s, {required bool colourBlind, Color? outline}) {
    final path = _bodyPath(l, s);
    if (outline != null) {
      canvas.drawPath(path, _stroke(outline, l.cell * 0.82));
      canvas.drawCircle(l.center(s.body.first), l.cell * 0.47, Paint()..color = outline);
    }
    // Pre-baked soft contact shadow.
    canvas.drawPath(
      path.shift(Offset(0, l.cell * 0.09)),
      _stroke(Colors.black.withValues(alpha: 0.16), l.cell * 0.6)..maskFilter = MaskFilter.blur(BlurStyle.normal, l.cell * 0.06),
    );
    _drawBody(canvas, path, s, l.cell, colourBlind);
    _drawHead(canvas, l.center(s.body.first), s.dir.unit, s, l.cell, colourBlind: colourBlind);
  }

  static void drawMoving(Canvas canvas, BoardLayout l, SnakeMotion m, double phase, bool reducedMotion, bool colourBlind) {
    final s = m.snake;
    if (m.kind == MotionKind.wobble || m.kind == MotionKind.smash) {
      canvas.save();
      if (m.kind == MotionKind.smash) {
        final c = l.center(s.body.first);
        final k = 1 - Curves.easeInBack.transform(m.t).clamp(0.0, 1.0);
        canvas.translate(c.dx, c.dy);
        canvas.scale(1 + 0.15 * math.sin(m.t * math.pi), math.max(0.01, k));
        canvas.translate(-c.dx, -c.dy);
        _sparkles(canvas, l, s, m.t);
      } else {
        final o = m.shakeOffset(l.cell, reduced: false);
        canvas.translate(o.dx, o.dy);
      }
      final path = _bodyPath(l, s);
      _drawBody(canvas, path, s, l.cell, colourBlind);
      _drawHead(canvas, l.center(s.body.first), s.dir.unit, s, l.cell, colourBlind: colourBlind);
      canvas.restore();
      return;
    }

    final track = m.track!;
    final start = math.max(0.0, m.tailOffset);
    final end = math.min(track.length, start + m.bodyLen);
    final amp = (reducedMotion || m.kind == MotionKind.bump) ? 0.0 : l.cell * 0.09;
    final body = wigglePath(track, start, end, amp, phase, l.cell);
    final shake = m.shakeOffset(l.cell, reduced: reducedMotion);
    final fade = m.kind == MotionKind.exit && m.t > 0.7 ? (1 - m.t) / 0.3 : 1.0;
    canvas.save();
    canvas.translate(shake.dx, shake.dy);
    if (fade < 1) canvas.saveLayer(null, Paint()..color = Colors.white.withValues(alpha: fade));
    _drawBody(canvas, body, s, l.cell, colourBlind);
    final tan = track.getTangentForOffset(end);
    if (tan != null) _drawHead(canvas, tan.position, tan.vector, s, l.cell, colourBlind: colourBlind, squash: m.squash);
    if (fade < 1) canvas.restore();
    canvas.restore();
  }

  static void _sparkles(Canvas canvas, BoardLayout l, SnakeSprite s, double t) {
    final c = l.center(s.body.first);
    final p = Paint()..color = const Color(0xFFB388FF).withValues(alpha: 1 - t);
    for (var i = 0; i < 8; i++) {
      final a = i * math.pi / 4;
      canvas.drawCircle(c + Offset(math.cos(a), math.sin(a)) * (l.cell * (0.3 + t * 0.9)), l.cell * 0.07 * (1 - t), p);
    }
  }

  /// Samples the track between [start] and [end] and offsets each point along
  /// the normal by a sine wave (slither wiggle). The envelope keeps head/tail on the lane.
  static ui.Path wigglePath(ui.PathMetric track, double start, double end, double amp, double phase, double cell) {
    final out = ui.Path();
    final span = math.max(1.0, end - start);
    const step = 4.0;
    var first = true;
    for (var d = start; d <= end + 0.001; d += step) {
      final at = math.min(d, end);
      final tan = track.getTangentForOffset(at);
      if (tan == null) continue;
      final v = tan.vector;
      final len = v.distance;
      final normal = len == 0 ? Offset.zero : Offset(-v.dy / len, v.dx / len);
      final u = (at - start) / span;
      final w = math.sin((at / cell) * math.pi * 2 + phase) * amp * math.sin(u * math.pi);
      final p = tan.position + normal * w;
      if (first) {
        out.moveTo(p.dx, p.dy);
        first = false;
      } else {
        out.lineTo(p.dx, p.dy);
      }
    }
    return out;
  }

  static Paint _stroke(Color c, double width) => Paint()
    ..color = c
    ..style = PaintingStyle.stroke
    ..strokeWidth = width
    ..strokeCap = StrokeCap.round
    ..strokeJoin = StrokeJoin.round;

  static void _drawBody(Canvas canvas, ui.Path path, SnakeSprite s, double cell, bool colourBlind) {
    if (s.caterpillar) {
      _drawBeads(canvas, path, s, cell);
    } else {
      final w = cell * 0.62;
      canvas.save();
      canvas.translate(0, cell * 0.05);
      canvas.drawPath(path, _stroke(Color.lerp(s.color, Colors.black, 0.22)!, w)); // bevel lip
      canvas.restore();
      canvas.drawPath(path, _stroke(s.color, w));
      canvas.save();
      canvas.translate(-cell * 0.04, -cell * 0.07);
      canvas.drawPath(path, _stroke(Colors.white.withValues(alpha: 0.32), cell * 0.15)); // highlight
      canvas.restore();
    }
    _drawPattern(canvas, path, s, cell, colourBlind);
  }

  static void _drawBeads(Canvas canvas, ui.Path path, SnakeSprite s, double cell) {
    final r = cell * 0.3;
    final dark = Paint()..color = Color.lerp(s.color, Colors.black, 0.22)!;
    final legs = Paint()
      ..color = Color.lerp(s.color, Colors.black, 0.4)!
      ..strokeWidth = cell * 0.05
      ..strokeCap = StrokeCap.round;
    for (final metric in path.computeMetrics()) {
      final step = cell * 0.36;
      final positions = <ui.Tangent>[];
      for (var d = metric.length; d >= 0; d -= step) {
        final t = metric.getTangentForOffset(d);
        if (t != null) positions.add(t);
      }
      for (final t in positions) {
        final n = Offset(-t.vector.dy, t.vector.dx);
        canvas.drawLine(t.position + n * r * 0.7, t.position + n * r * 1.15, legs);
        canvas.drawLine(t.position - n * r * 0.7, t.position - n * r * 1.15, legs);
      }
      for (final t in positions) {
        canvas.drawCircle(t.position + Offset(0, cell * 0.05), r, dark);
        canvas.drawCircle(
          t.position,
          r,
          Paint()
            ..shader = RadialGradient(
              center: const Alignment(-0.35, -0.45),
              colors: [Color.lerp(s.color, Colors.white, 0.45)!, s.color],
            ).createShader(Rect.fromCircle(center: t.position, radius: r)),
        );
      }
    }
  }

  /// Every colour has its own body pattern, so colour is never the only cue.
  static void _drawPattern(Canvas canvas, ui.Path path, SnakeSprite s, double cell, bool bold) {
    final alpha = bold ? 0.95 : 0.6;
    final light = Color.lerp(s.color, Colors.white, 0.55)!.withValues(alpha: alpha);
    final dark = Color.lerp(s.color, Colors.black, 0.35)!.withValues(alpha: alpha);
    final scale = bold ? 1.25 : 1.0;
    final gap = cell * 0.48;
    final stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = cell * 0.045 * scale;
    for (final metric in path.computeMetrics()) {
      for (var d = cell * 0.55; d < metric.length - cell * 0.15; d += gap) {
        final t = metric.getTangentForOffset(d);
        if (t == null) continue;
        final v = t.vector.distance == 0 ? const Offset(1, 0) : t.vector / t.vector.distance;
        final n = Offset(-v.dy, v.dx);
        final p = t.position;
        final k = cell * 0.13 * scale;
        switch (s.palette) {
          case SnakeColor.red:
            canvas.drawCircle(p + n * k * 0.6, k * 0.55, Paint()..color = light);
            canvas.drawCircle(p - n * k * 0.6, k * 0.4, Paint()..color = light);
          case SnakeColor.green:
            canvas.drawLine(p - v * k, p + v * k, stroke..color = dark);
            canvas.drawLine(p, p + (n + v) * k * 0.8, stroke);
            canvas.drawLine(p, p + (-n + v) * k * 0.8, stroke);
          case SnakeColor.blue:
            canvas.drawLine(p + n * k * 1.4, p - n * k * 1.4, stroke..color = dark);
            canvas.drawLine(p + n * k * 1.4 + v * k * 0.6, p - n * k * 1.4 + v * k * 0.6, stroke);
          case SnakeColor.yellow:
            final z = Path()
              ..moveTo((p - v * k + n * k).dx, (p - v * k + n * k).dy)
              ..lineTo((p - n * k).dx, (p - n * k).dy)
              ..lineTo((p + v * k + n * k).dx, (p + v * k + n * k).dy);
            canvas.drawPath(z, stroke..color = dark);
          case SnakeColor.purple:
            final dPath = Path()
              ..moveTo((p + v * k).dx, (p + v * k).dy)
              ..lineTo((p + n * k * 0.8).dx, (p + n * k * 0.8).dy)
              ..lineTo((p - v * k).dx, (p - v * k).dy)
              ..lineTo((p - n * k * 0.8).dx, (p - n * k * 0.8).dy)
              ..close();
            canvas.drawPath(dPath, Paint()..color = light);
          case SnakeColor.orange:
            canvas.drawCircle(p, k * 0.9, stroke..color = light);
          case SnakeColor.pink:
            canvas.drawCircle(p + n * k * 0.35, k * 0.42, Paint()..color = light);
            canvas.drawCircle(p - n * k * 0.35, k * 0.42, Paint()..color = light);
            final tip = Path()
              ..moveTo((p + n * k * 0.75).dx, (p + n * k * 0.75).dy)
              ..lineTo((p - v * k).dx, (p - v * k).dy)
              ..lineTo((p - n * k * 0.75).dx, (p - n * k * 0.75).dy)
              ..close();
            canvas.drawPath(tip, Paint()..color = light);
          case SnakeColor.teal:
            final ch = Path()
              ..moveTo((p - v * k * 0.5 + n * k).dx, (p - v * k * 0.5 + n * k).dy)
              ..lineTo((p + v * k * 0.5).dx, (p + v * k * 0.5).dy)
              ..lineTo((p - v * k * 0.5 - n * k).dx, (p - v * k * 0.5 - n * k).dy);
            canvas.drawPath(ch, stroke..color = light);
          case SnakeColor.gold:
            canvas.drawCircle(p, k * 0.45, Paint()..color = Colors.white.withValues(alpha: 0.7));
        }
      }
    }
  }

  static const _tags = {
    SnakeColor.red: '●',
    SnakeColor.green: '♣',
    SnakeColor.blue: '≡',
    SnakeColor.yellow: 'ϟ',
    SnakeColor.purple: '◆',
    SnakeColor.orange: '◎',
    SnakeColor.pink: '♥',
    SnakeColor.teal: '➤',
    SnakeColor.gold: '★',
  };

  static void _drawHead(Canvas canvas, Offset c, Offset dirVec, SnakeSprite s, double cell, {required bool colourBlind, double squash = 1}) {
    final len = dirVec.distance;
    final f = len == 0 ? const Offset(1, 0) : dirVec / len;
    final side = Offset(-f.dy, f.dx);
    final r = cell * 0.4;
    canvas.save();
    canvas.translate(c.dx, c.dy);
    canvas.rotate(math.atan2(f.dy, f.dx));
    canvas.scale(squash, 2 - squash);
    final head = Rect.fromCenter(center: Offset.zero, width: r * 2.1, height: r * 2);
    canvas.drawOval(head.shift(Offset(0, cell * 0.04)), Paint()..color = Color.lerp(s.color, Colors.black, 0.22)!);
    canvas.drawOval(
      head,
      Paint()
        ..shader = RadialGradient(
          center: const Alignment(-0.2, -0.5),
          colors: [Color.lerp(s.color, Colors.white, 0.4)!, s.color],
        ).createShader(head),
    );
    canvas.restore();

    // Cheeks.
    final cheek = Paint()..color = const Color(0xFFFF8A80).withValues(alpha: 0.5);
    canvas.drawCircle(c + side * r * 0.62 + f * r * 0.05, r * 0.17, cheek);
    canvas.drawCircle(c - side * r * 0.62 + f * r * 0.05, r * 0.17, cheek);

    // Eyes look in the head direction.
    final white = Paint()..color = Colors.white;
    final pupil = Paint()..color = const Color(0xFF1B2B1F);
    final eyeBase = c + f * (r * 0.32);
    for (final sign in const [-1.0, 1.0]) {
      final e = eyeBase + side * (r * 0.4 * sign);
      canvas.drawCircle(e, r * 0.27, white);
      canvas.drawCircle(e + f * (r * 0.1), r * 0.14, pupil);
      canvas.drawCircle(e + f * (r * 0.04) - side * r * 0.05 - Offset(0, r * 0.05), r * 0.05, white);
    }

    if (s.caterpillar) {
      final ant = Paint()
        ..color = Color.lerp(s.color, Colors.black, 0.45)!
        ..strokeWidth = cell * 0.04
        ..strokeCap = StrokeCap.round;
      for (final sign in const [-1.0, 1.0]) {
        final a = c + f * r * 0.7 + side * r * 0.3 * sign;
        final b = a + f * r * 0.45 + side * r * 0.35 * sign;
        canvas.drawLine(a, b, ant);
        canvas.drawCircle(b, cell * 0.045, ant);
      }
    }

    if (colourBlind) {
      final tp = TextPainter(
        text: TextSpan(
          text: _tags[s.palette],
          style: TextStyle(color: Colors.white, fontSize: cell * 0.26, fontWeight: FontWeight.w900, shadows: const [Shadow(color: Colors.black54, blurRadius: 2)]),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      final at = c - f * r * 0.45;
      tp.paint(canvas, at - Offset(tp.width / 2, tp.height / 2));
    }
  }
}

class HintRenderer {
  /// Pulsing gold ring around the hinted snake (or a soft highlight for tutorials).
  static void draw(Canvas canvas, BoardLayout l, SnakeSprite s, double clock, {bool golden = true}) {
    final pulse = 0.5 + 0.5 * math.sin(clock * math.pi * 2.2);
    final color = golden ? const Color(0xFFFFD54F) : Colors.white;
    final path = ui.Path()..moveTo(l.center(s.body.first).dx, l.center(s.body.first).dy);
    for (final c in s.body.skip(1)) {
      path.lineTo(l.center(c).dx, l.center(c).dy);
    }
    canvas.drawPath(
      path,
      Paint()
        ..color = color.withValues(alpha: 0.35 + 0.35 * pulse)
        ..style = PaintingStyle.stroke
        ..strokeWidth = l.cell * (0.86 + 0.12 * pulse)
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
    final head = l.center(s.body.first);
    canvas.drawCircle(
      head,
      l.cell * (0.55 + 0.15 * pulse),
      Paint()
        ..color = color.withValues(alpha: 0.8 * (1 - pulse))
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
    );
    SnakeRenderer.drawStatic(canvas, l, s, colourBlind: false);
    if (golden) {
      // Firefly perched on the head.
      final f = head + Offset(l.cell * 0.32, -l.cell * 0.42 - pulse * l.cell * 0.06);
      canvas.drawCircle(f, l.cell * 0.18, Paint()..color = const Color(0xFFFFF59D).withValues(alpha: 0.6));
      canvas.drawCircle(f, l.cell * 0.08, Paint()..color = const Color(0xFFFFEB3B));
    }
  }
}

class PreviewRenderer {
  static void draw(Canvas canvas, BoardLayout l, List<Offset> points, {required bool blocked}) {
    if (points.length < 2) return;
    final paint = Paint()
      ..color = blocked ? AppColors.previewBlocked : AppColors.previewClear
      ..style = PaintingStyle.fill;
    final halo = Paint()..color = Colors.white.withValues(alpha: 0.9);
    final path = ui.Path()..moveTo(points.first.dx, points.first.dy);
    for (final p in points.skip(1)) {
      path.lineTo(p.dx, p.dy);
    }
    for (final metric in path.computeMetrics()) {
      for (var d = l.cell * 0.55; d < metric.length; d += l.cell * 0.3) {
        final tan = metric.getTangentForOffset(d);
        if (tan == null) continue;
        canvas.drawCircle(tan.position, l.cell * 0.09, halo);
        canvas.drawCircle(tan.position, l.cell * 0.06, paint);
      }
    }
    if (blocked) {
      final x = points.last;
      final k = l.cell * 0.2;
      final cross = Paint()
        ..color = AppColors.previewBlocked
        ..strokeWidth = math.max(3, l.cell * 0.1)
        ..strokeCap = StrokeCap.round;
      canvas.drawCircle(x, k * 1.6, Paint()..color = Colors.white.withValues(alpha: 0.85));
      canvas.drawLine(x + Offset(-k, -k), x + Offset(k, k), cross);
      canvas.drawLine(x + Offset(-k, k), x + Offset(k, -k), cross);
    }
  }
}
