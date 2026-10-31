// OWNER: UI agent. Snake renderer with soft 3D clay look, eyes, cheeks,
// patterns, caterpillar skin, and motion effects.
import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../contracts/view_models.dart';
import '../../features/gameplay/board_geometry.dart';
import '../theme/tokens.dart';
import 'pattern_painter.dart';

class SnakePainter {
  const SnakePainter._();

  /// Draw one snake with all visual styling, face, pattern, and motion transforms.
  static void drawSnake(
    Canvas canvas, {
    required Snake snake,
    required BoardGeometry geometry,
    required bool colourBlind,
    required bool hammerMode,
    required bool isHinted,
    required bool isTongueOut,
    required double blink, // 0.0 open, 1.0 closed
    required double pulse, // 0.0 .. 1.0 for ambient glow
    Offset shift = Offset.zero,
    double squash = 1.0,
    double wobble = 0.0,
    double wiggleAmp = 0.0,
    double wigglePhase = 0.0,
  }) {
    final cell = geometry.cell;
    final baseColor = AppColors.snake(snake.color);
    final isCaterpillar = snake.skin == SnakeSkin.caterpillar;

    // Calculate transformed positions for all body segments
    final List<Offset> positions = [];
    final dirVec = Offset(snake.dir.dx.toDouble(), snake.dir.dy.toDouble());
    final normalVec = Offset(-dirVec.dy, dirVec.dx);

    for (var i = 0; i < snake.body.length; i++) {
      var pt = geometry.centerOf(snake.body[i]) + shift;

      // Apply locked side wobble
      if (wobble != 0.0) {
        pt += normalVec * wobble;
      }

      // Apply exit sine wiggle (perpendicular to direction)
      if (wiggleAmp > 0.0) {
        final wave = math.sin(wigglePhase + i * 1.5) * wiggleAmp;
        pt += normalVec * wave;
      }

      // Apply bump squash (head compresses toward neck)
      if (squash != 1.0 && i == 0) {
        pt -= dirVec * ((1.0 - squash) * cell * 0.25);
      }

      positions.add(pt);
    }

    if (positions.isEmpty) return;

    // Draw snake body shadow (soft pre-baked clay shadow)
    final shadowPaint = Paint()
      ..color = const Color(0x18000000)
      ..style = PaintingStyle.fill;
    final shadowOffset = const Offset(0, 3.5);

    for (final pt in positions) {
      canvas.drawCircle(pt + shadowOffset, cell * 0.36, shadowPaint);
    }

    // 1. Draw Body Segments (from tail to neck)
    final bodyRadius = cell * (isCaterpillar ? 0.34 : 0.37);
    final bodyPaint = Paint()
      ..color = baseColor
      ..style = PaintingStyle.fill;

    // Draw tube connections between adjacent segments (tail to head)
    for (var i = positions.length - 1; i > 0; i--) {
      final p1 = positions[i];
      final p2 = positions[i - 1];
      _drawSegmentConnection(canvas, p1, p2, bodyRadius, bodyPaint, baseColor, cell);
    }

    // Draw segments beads / joints with soft clay highlight
    for (var i = positions.length - 1; i >= 1; i--) {
      final pt = positions[i];
      final r = bodyRadius * (i == positions.length - 1 ? 0.88 : 1.0); // tapered tail

      if (isCaterpillar) {
        _drawCaterpillarBead(canvas, pt, r, baseColor, snake.dir, cell);
      } else {
        _drawClaySphericalSegment(canvas, pt, r, baseColor);
      }

      // Draw pattern on body segments
      final segDir = i > 0
          ? _dirBetween(snake.body[i], snake.body[i - 1], snake.dir)
          : snake.dir;
      PatternPainter.drawPattern(
        canvas,
        color: snake.color,
        center: pt,
        r: r,
        dir: segDir,
        bolder: colourBlind,
      );
    }

    // 2. Draw Head
    final headPt = positions.first;
    final headRadius = cell * (isCaterpillar ? 0.40 : 0.43);

    // Head base clay sphere
    _drawClayHead(canvas, headPt, headRadius, baseColor, snake.dir, squash);

    // If caterpillar, draw cute little antennae
    if (isCaterpillar) {
      _drawCaterpillarAntennae(canvas, headPt, headRadius, snake.dir, baseColor);
    }

    // Draw face: cheeks, eyes, pupils, blink, tongue
    _drawFace(
      canvas,
      headPt: headPt,
      headRadius: headRadius,
      dir: snake.dir,
      blink: blink,
      isTongueOut: isTongueOut,
      cell: cell,
    );

    // 3. Colour-blind head tag icon badge
    if (colourBlind) {
      _drawColourBlindTag(canvas, headPt, headRadius, snake.color, snake.dir);
    }

    // 4. Hammer mode target indicator
    if (hammerMode) {
      _drawHammerTarget(canvas, headPt, headRadius, pulse);
    }

    // 5. Firefly Hint overlay
    if (isHinted) {
      _drawHintFirefly(canvas, headPt, headRadius, pulse);
    }
  }

  static Dir _dirBetween(Cell from, Cell to, Dir fallback) {
    if (to.x > from.x) return Dir.right;
    if (to.x < from.x) return Dir.left;
    if (to.y > from.y) return Dir.down;
    if (to.y < from.y) return Dir.up;
    return fallback;
  }

  static void _drawSegmentConnection(
    Canvas canvas,
    Offset p1,
    Offset p2,
    double r,
    Paint p,
    Color baseColor,
    double cell,
  ) {
    final diff = p2 - p1;
    final dist = diff.distance;
    if (dist < 0.1) return;
    final normal = Offset(-diff.dy / dist, diff.dx / dist) * r;

    final path = Path()
      ..moveTo(p1.dx + normal.dx, p1.dy + normal.dy)
      ..lineTo(p2.dx + normal.dx, p2.dy + normal.dy)
      ..lineTo(p2.dx - normal.dx, p2.dy - normal.dy)
      ..lineTo(p1.dx - normal.dx, p1.dy - normal.dy)
      ..close();

    canvas.drawPath(path, p);

    // Soft 3D bevel stroke on top edge
    final highlightPaint = Paint()
      ..color = const Color(0x33FFFFFF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = r * 0.3
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      p1 + normal * 0.5,
      p2 + normal * 0.5,
      highlightPaint,
    );
  }

  static void _drawClaySphericalSegment(
    Canvas canvas,
    Offset pt,
    double r,
    Color baseColor,
  ) {
    // Base circle
    canvas.drawCircle(pt, r, Paint()..color = baseColor);

    // Clay soft highlight
    final hlPaint = Paint()
      ..color = const Color(0x40FFFFFF)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(pt - Offset(r * 0.28, r * 0.28), r * 0.42, hlPaint);

    // Subtle dark underside
    final shadePaint = Paint()
      ..color = const Color(0x24000000)
      ..style = PaintingStyle.stroke
      ..strokeWidth = r * 0.22;
    canvas.drawArc(
      Rect.fromCircle(center: pt, radius: r * 0.9),
      math.pi * 0.15,
      math.pi * 0.7,
      false,
      shadePaint,
    );
  }

  static void _drawCaterpillarBead(
    Canvas canvas,
    Offset pt,
    double r,
    Color baseColor,
    Dir dir,
    double cell,
  ) {
    // Caterpillar has tiny cute feet
    final feetDir = dir == Dir.left || dir == Dir.right
        ? const [Offset(0, -1), Offset(0, 1)]
        : const [Offset(-1, 0), Offset(1, 0)];
    final feetPaint = Paint()..color = Color.lerp(baseColor, Colors.black, 0.2)!;

    for (final fd in feetDir) {
      canvas.drawCircle(pt + fd * (r * 0.95), r * 0.28, feetPaint);
    }

    _drawClaySphericalSegment(canvas, pt, r, baseColor);
  }

  static void _drawClayHead(
    Canvas canvas,
    Offset pt,
    double r,
    Color baseColor,
    Dir dir,
    double squash,
  ) {
    final headPaint = Paint()..color = baseColor;
    if (squash == 1.0) {
      canvas.drawCircle(pt, r, headPaint);
    } else {
      // Squashed oval
      final ovalRect = Rect.fromCenter(
        center: pt,
        width: r * 2 * (1.15 / squash.clamp(0.5, 1.2)),
        height: r * 2 * squash.clamp(0.5, 1.0),
      );
      canvas.drawOval(ovalRect, headPaint);
    }

    // Soft top-left specular highlight
    final hlPaint = Paint()
      ..color = const Color(0x50FFFFFF)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(pt - Offset(r * 0.25, r * 0.25), r * 0.38, hlPaint);
  }

  static void _drawCaterpillarAntennae(
    Canvas canvas,
    Offset pt,
    double r,
    Dir dir,
    Color baseColor,
  ) {
    final stroke = Paint()
      ..color = Color.lerp(baseColor, Colors.black, 0.25)!
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;
    final tipPaint = Paint()
      ..color = const Color(0xFFFFCA28)
      ..style = PaintingStyle.fill;

    final dirVec = Offset(dir.dx.toDouble(), dir.dy.toDouble());
    final normal = Offset(-dirVec.dy, dirVec.dx);

    for (final side in [-1.0, 1.0]) {
      final start = pt + dirVec * (r * 0.6) + normal * (side * r * 0.4);
      final tip = start + dirVec * (r * 0.5) + normal * (side * r * 0.35);
      canvas.drawLine(start, tip, stroke);
      canvas.drawCircle(tip, 2.8, tipPaint);
    }
  }

  static void _drawFace(
    Canvas canvas, {
    required Offset headPt,
    required double headRadius,
    required Dir dir,
    required double blink,
    required bool isTongueOut,
    required double cell,
  }) {
    final dirVec = Offset(dir.dx.toDouble(), dir.dy.toDouble());
    final normal = Offset(-dirVec.dy, dirVec.dx);

    // Cheeks: cute rosy blush
    final cheekOffset = headRadius * 0.55;
    final cheekPaint = Paint()
      ..color = const Color(0x55FF5252)
      ..style = PaintingStyle.fill;
    for (final side in [-1.0, 1.0]) {
      final cPt = headPt + dirVec * (headRadius * 0.1) + normal * (side * cheekOffset);
      canvas.drawCircle(cPt, headRadius * 0.22, cheekPaint);
    }

    // Tongue flick during preview
    if (isTongueOut) {
      final tongueStart = headPt + dirVec * (headRadius * 0.75);
      final tongueEnd = headPt + dirVec * (headRadius * 1.45);
      final tonguePaint = Paint()
        ..color = const Color(0xFFFF3D00)
        ..style = PaintingStyle.stroke
        ..strokeWidth = math.max(2.0, cell * 0.07)
        ..strokeCap = StrokeCap.round;
      canvas.drawLine(tongueStart, tongueEnd, tonguePaint);
      // Forked tip
      final tipFork1 = tongueEnd + dirVec * (headRadius * 0.2) + normal * (headRadius * 0.15);
      final tipFork2 = tongueEnd + dirVec * (headRadius * 0.2) - normal * (headRadius * 0.15);
      canvas.drawLine(tongueEnd, tipFork1, tonguePaint);
      canvas.drawLine(tongueEnd, tipFork2, tonguePaint);
    }

    // Eyes
    final eyeSpacing = headRadius * 0.40;
    final eyeForward = headRadius * 0.32;
    final eyeRadius = headRadius * 0.24;

    for (final side in [-1.0, 1.0]) {
      final eyeCenter = headPt + dirVec * eyeForward + normal * (side * eyeSpacing);

      if (blink > 0.5) {
        // Closed / sleepy / blinking eyes: happy arc ⌒
        final arcPaint = Paint()
          ..color = const Color(0xFF1B2B1F)
          ..style = PaintingStyle.stroke
          ..strokeWidth = math.max(1.5, cell * 0.05)
          ..strokeCap = StrokeCap.round;
        final arcRect = Rect.fromCircle(center: eyeCenter, radius: eyeRadius * 0.9);
        canvas.drawArc(arcRect, math.pi * 1.1, math.pi * 0.8, false, arcPaint);
      } else {
        // Open eyes: white sclera + black pupil + glint
        canvas.drawCircle(eyeCenter, eyeRadius, Paint()..color = const Color(0xFFFFFFFC));
        // Pupil looking toward dir
        final pupilOffset = dirVec * (eyeRadius * 0.35);
        final pupilRadius = eyeRadius * 0.58;
        canvas.drawCircle(
          eyeCenter + pupilOffset,
          pupilRadius,
          Paint()..color = const Color(0xFF1B2B1F),
        );
        // Specular white glint
        canvas.drawCircle(
          eyeCenter + pupilOffset - const Offset(1.2, 1.2),
          pupilRadius * 0.38,
          Paint()..color = Colors.white,
        );
      }
    }
  }

  static void _drawColourBlindTag(
    Canvas canvas,
    Offset headPt,
    double headRadius,
    SnakeColor color,
    Dir dir,
  ) {
    // Draw badge pill/circle on top of head with tag icon
    final dirVec = Offset(dir.dx.toDouble(), dir.dy.toDouble());
    final badgeCenter = headPt - dirVec * (headRadius * 0.35);
    final badgeRadius = headRadius * 0.34;

    canvas.drawCircle(
      badgeCenter,
      badgeRadius,
      Paint()..color = const Color(0xE6FFFFFF),
    );
    canvas.drawCircle(
      badgeCenter,
      badgeRadius,
      Paint()
        ..color = const Color(0x33000000)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0,
    );

    final icon = PatternPainter.headTagIcon(color);
    final painter = TextPainter(
      text: TextSpan(
        text: icon,
        style: TextStyle(
          color: const Color(0xFF163B28),
          fontSize: badgeRadius * 1.3,
          fontWeight: FontWeight.w900,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    painter.paint(
      canvas,
      badgeCenter - Offset(painter.width * 0.5, painter.height * 0.5),
    );
  }

  static void _drawHammerTarget(
    Canvas canvas,
    Offset headPt,
    double headRadius,
    double pulse,
  ) {
    // Pulsing golden target ring
    final r = headRadius * (1.15 + pulse * 0.25);
    final alpha = (0.75 - pulse * 0.4).clamp(0.0, 1.0);
    final p = Paint()
      ..color = const Color(0xFFFF9800).withValues(alpha: alpha)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;
    canvas.drawCircle(headPt, r, p);
  }

  static void _drawHintFirefly(
    Canvas canvas,
    Offset headPt,
    double headRadius,
    double pulse,
  ) {
    // Expanding halo
    final haloRadius = headRadius * (1.2 + pulse * 0.4);
    final haloPaint = Paint()
      ..color = AppColors.coinGold.withValues(alpha: (0.6 - pulse * 0.4).clamp(0.0, 0.6))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5;
    canvas.drawCircle(headPt, haloRadius, haloPaint);

    // Glowing firefly landing on head
    final flyPt = headPt - Offset(headRadius * 0.45, headRadius * 0.65);

    // Firefly glow
    canvas.drawCircle(
      flyPt,
      headRadius * 0.35,
      Paint()..color = const Color(0x66FFD54F),
    );

    // Firefly wings
    final wingPaint = Paint()..color = const Color(0xCCFFFFFF);
    canvas.drawOval(
      Rect.fromCenter(center: flyPt + const Offset(-3, -3), width: 6, height: 4),
      wingPaint,
    );
    canvas.drawOval(
      Rect.fromCenter(center: flyPt + const Offset(3, -3), width: 6, height: 4),
      wingPaint,
    );

    // Firefly abdomen (gold bulb)
    canvas.drawCircle(flyPt, 3.5, Paint()..color = const Color(0xFFFFCA28));
  }
}
