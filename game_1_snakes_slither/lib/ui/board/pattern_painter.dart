// OWNER: UI agent. Body patterns and color-blind tag icons for snakes.
// Source of truth: phases/phase_1/06_UI_UX_SCREENS.md §2.2 & §3.
import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../contracts/view_models.dart';

class PatternPainter {
  const PatternPainter._();

  /// Draw body pattern for [color] on a cell segment centered at [center] with radius [r].
  /// [dir] is the direction along the snake body.
  /// If [bolder] is true (colour-blind mode), lines and symbols are higher contrast and thicker.
  static void drawPattern(
    Canvas canvas, {
    required SnakeColor color,
    required Offset center,
    required double r,
    required Dir dir,
    required bool bolder,
    Color? overrideColor,
  }) {
    final patternColor = overrideColor ?? (bolder ? const Color(0xCCFFFFFF) : const Color(0x66FFFFFF));
    final strokeWidth = bolder ? math.max(1.5, r * 0.16) : math.max(1.0, r * 0.11);
    final pStroke = Paint()
      ..color = patternColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final pFill = Paint()
      ..color = patternColor
      ..style = PaintingStyle.fill;

    switch (color) {
      case SnakeColor.red:
        // Polka dots: 3-4 cute round dots
        final dotR = r * (bolder ? 0.22 : 0.17);
        canvas.drawCircle(center, dotR, pFill);
        final d1 = Offset(r * 0.45, 0);
        final d2 = Offset(-r * 0.45, 0);
        canvas.drawCircle(center + d1, dotR * 0.75, pFill);
        canvas.drawCircle(center + d2, dotR * 0.75, pFill);

      case SnakeColor.green:
        // Leaf veins: central stem with 2 angled branching veins
        final isHoriz = dir == Dir.left || dir == Dir.right;
        final stemStart = isHoriz ? center - Offset(r * 0.6, 0) : center - Offset(0, r * 0.6);
        final stemEnd = isHoriz ? center + Offset(r * 0.6, 0) : center + Offset(0, r * 0.6);
        canvas.drawLine(stemStart, stemEnd, pStroke);
        final branchOffset = r * 0.35;
        if (isHoriz) {
          canvas.drawLine(center, center + Offset(branchOffset * 0.8, -branchOffset), pStroke);
          canvas.drawLine(center, center + Offset(branchOffset * 0.8, branchOffset), pStroke);
        } else {
          canvas.drawLine(center, center + Offset(-branchOffset, branchOffset * 0.8), pStroke);
          canvas.drawLine(center, center + Offset(branchOffset, branchOffset * 0.8), pStroke);
        }

      case SnakeColor.blue:
        // Cross stripes: 2-3 parallel lines across body
        final isHoriz = dir == Dir.left || dir == Dir.right;
        final half = r * 0.55;
        for (final offset in [-r * 0.35, 0.0, r * 0.35]) {
          if (isHoriz) {
            canvas.drawLine(center + Offset(offset, -half), center + Offset(offset, half), pStroke);
          } else {
            canvas.drawLine(center + Offset(-half, offset), center + Offset(half, offset), pStroke);
          }
        }

      case SnakeColor.yellow:
        // Zigzag: lightning/sawtooth path along movement
        final isHoriz = dir == Dir.left || dir == Dir.right;
        final path = Path();
        final span = r * 0.7;
        final amp = r * 0.38;
        if (isHoriz) {
          path.moveTo(center.dx - span, center.dy);
          path.lineTo(center.dx - span * 0.5, center.dy - amp);
          path.lineTo(center.dx, center.dy + amp);
          path.lineTo(center.dx + span * 0.5, center.dy - amp);
          path.lineTo(center.dx + span, center.dy);
        } else {
          path.moveTo(center.dx, center.dy - span);
          path.lineTo(center.dx - amp, center.dy - span * 0.5);
          path.lineTo(center.dx + amp, center.dy);
          path.lineTo(center.dx - amp, center.dy + span * 0.5);
          path.lineTo(center.dx, center.dy + span);
        }
        canvas.drawPath(path, pStroke);

      case SnakeColor.purple:
        // Diamonds: rhombus along segment
        final path = Path();
        final dw = r * (bolder ? 0.45 : 0.38);
        final dh = r * (bolder ? 0.55 : 0.48);
        path.moveTo(center.dx, center.dy - dh);
        path.lineTo(center.dx + dw, center.dy);
        path.lineTo(center.dx, center.dy + dh);
        path.lineTo(center.dx - dw, center.dy);
        path.close();
        if (bolder) {
          canvas.drawPath(path, pFill);
        } else {
          canvas.drawPath(path, pStroke);
        }

      case SnakeColor.orange:
        // Rings: concentric circles
        final outerR = r * (bolder ? 0.45 : 0.42);
        canvas.drawCircle(center, outerR, pStroke);
        canvas.drawCircle(center, outerR * 0.45, pFill);

      case SnakeColor.pink:
        // Tiny hearts: vector heart shape
        final hw = r * (bolder ? 0.45 : 0.38);
        final hh = r * (bolder ? 0.45 : 0.38);
        final heart = Path();
        heart.moveTo(center.dx, center.dy + hh * 0.6);
        heart.cubicTo(
          center.dx - hw * 1.1, center.dy - hh * 0.1,
          center.dx - hw * 0.7, center.dy - hh * 0.9,
          center.dx, center.dy - hh * 0.4,
        );
        heart.cubicTo(
          center.dx + hw * 0.7, center.dy - hh * 0.9,
          center.dx + hw * 1.1, center.dy - hh * 0.1,
          center.dx, center.dy + hh * 0.6,
        );
        heart.close();
        canvas.drawPath(heart, pFill);

      case SnakeColor.teal:
        // Chevrons: arrowheads pointing in snake.dir
        final isHoriz = dir == Dir.left || dir == Dir.right;
        final step = dir == Dir.right || dir == Dir.down ? 1.0 : -1.0;
        final path = Path();
        final chW = r * 0.4;
        final chH = r * 0.45;
        for (final pos in [-r * 0.25, r * 0.25]) {
          path.reset();
          if (isHoriz) {
            final x = center.dx + pos;
            path.moveTo(x - step * chW, center.dy - chH);
            path.lineTo(x, center.dy);
            path.lineTo(x - step * chW, center.dy + chH);
          } else {
            final y = center.dy + pos;
            path.moveTo(center.dx - chH, y - step * chW);
            path.lineTo(center.dx, y);
            path.lineTo(center.dx + chH, y - step * chW);
          }
          canvas.drawPath(path, pStroke);
        }
    }
  }

  /// Get the Unicode head tag icon for colour-blind mode (doc 06 §2.2).
  static String headTagIcon(SnakeColor c) => switch (c) {
    SnakeColor.red => '●',
    SnakeColor.green => '🍃',
    SnakeColor.blue => '≡',
    SnakeColor.yellow => '⚡',
    SnakeColor.purple => '◆',
    SnakeColor.orange => '◎',
    SnakeColor.pink => '♥',
    SnakeColor.teal => '➤',
  };
}
