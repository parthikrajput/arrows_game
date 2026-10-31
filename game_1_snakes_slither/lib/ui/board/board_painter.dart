// OWNER: UI agent. Real board custom painter with cached static background,
// Garden Rocks, motion transforms, preview overlays, and hammer/hint visual effects.
import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../../contracts/view_models.dart';
import '../../features/gameplay/board_geometry.dart';
import '../theme/tokens.dart';
import 'snake_painter.dart';

class BoardPainter extends CustomPainter {
  BoardPainter({
    required this.data,
    required this.geometry,
    required this.motionT,
    required this.staticPicture,
  });

  final BoardViewData data;
  final BoardGeometry geometry;
  final double motionT; // 0.0 .. 1.0 from motion controller
  final ui.Picture? staticPicture;

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Draw cached static board (garden grass, grid, rocks)
    if (staticPicture != null) {
      canvas.drawPicture(staticPicture!);
    } else {
      // Fallback if picture is not ready
      drawStaticContent(canvas, geometry, data.board);
    }

    final cell = geometry.cell;
    final m = data.motion;
    final isReduced = data.reducedMotion;

    // Ambient variables (stable without continuous ticking)
    const blink = 0.0;
    const pulse = 0.5;

    // Motion variables for active snake
    Offset movingShift = Offset.zero;
    double movingSquash = 1.0;
    double movingWobble = 0.0;
    double movingWiggleAmp = 0.0;
    double movingWigglePhase = 0.0;
    Cell? blockerToFlash;

    if (m != null) {
      final dirVec = Offset(m.snake.dir.dx.toDouble(), m.snake.dir.dy.toDouble());

      switch (m.kind) {
        case MotionKind.exit:
          final dist = m.lane.cells.length + m.snake.length;
          final tCurved = Curves.easeInOutCubic.transform(motionT);
          movingShift = dirVec * (cell * dist * tCurved);
          if (!isReduced) {
            movingWiggleAmp = math.sin(motionT * math.pi) * (cell * 0.12);
            movingWigglePhase = motionT * math.pi * 6;
          }

        case MotionKind.bump:
          final reach = m.lane.cells.isEmpty ? 0.25 : m.lane.cells.length.toDouble();
          if (motionT < 0.45) {
            // Forward easeOut
            final tNorm = motionT / 0.45;
            final tFwd = Curves.easeOut.transform(tNorm);
            movingShift = dirVec * (cell * reach * tFwd);
          } else {
            // Backward elasticOut
            final tNorm = (motionT - 0.45) / 0.55;
            final tBack = Curves.elasticOut.transform(tNorm);
            movingShift = dirVec * (cell * reach * (1.0 - tBack));
          }

          // Apex impact squash and shake
          if (motionT >= 0.35 && motionT <= 0.65) {
            final apexNorm = (motionT - 0.35) / 0.30;
            final apexWindow = math.sin(apexNorm * math.pi);
            if (!isReduced) {
              movingSquash = 1.0 - 0.30 * apexWindow;
              final shake = math.sin(motionT * math.pi * 10) * 3.5 * apexWindow;
              final normalVec = Offset(-dirVec.dy, dirVec.dx);
              movingShift += normalVec * shake;
            }
            if (m.lane.blocker != null) {
              blockerToFlash = m.lane.blocker;
            }
          }

        case MotionKind.locked:
          if (!isReduced) {
            movingWobble = math.sin(motionT * math.pi * 3.0) * 4.0;
          } else {
            movingWobble = math.sin(motionT * math.pi) * 1.5;
          }
      }
    }

    // 2. Draw Blocker Flash on impact
    if (blockerToFlash != null) {
      final bRect = geometry.rectOf(blockerToFlash).deflate(2);
      final r = Radius.circular(geometry.cornerRadius);
      canvas.drawRRect(
        RRect.fromRectAndRadius(bRect, r),
        Paint()..color = const Color(0x66D32F2F),
      );
    }

    // 3. Draw Snakes
    final previewSnakeId = data.preview?.snakeId;
    for (final s in data.board.snakes.values) {
      final isMoving = m != null && m.snake.id == s.id;
      final isTongueOut = previewSnakeId == s.id;
      final isHinted = data.hintSnakeId == s.id;

      SnakePainter.drawSnake(
        canvas,
        snake: s,
        geometry: geometry,
        colourBlind: data.colourBlind,
        hammerMode: data.hammerMode,
        isHinted: isHinted,
        isTongueOut: isTongueOut,
        blink: isMoving ? 0.0 : blink,
        pulse: pulse,
        shift: isMoving ? movingShift : Offset.zero,
        squash: isMoving ? movingSquash : 1.0,
        wobble: isMoving ? movingWobble : 0.0,
        wiggleAmp: isMoving ? movingWiggleAmp : 0.0,
        wigglePhase: isMoving ? movingWigglePhase : 0.0,
      );
    }

    // 4. Draw Preview Overlay
    final pv = data.preview;
    if (pv != null) {
      final col = pv.lane.isClear ? AppColors.previewClear : AppColors.previewBlocked;
      final dotRadius = math.max(3.0, cell * 0.12);
      final dotPaint = Paint()..color = col;

      for (final c in pv.lane.cells) {
        canvas.drawCircle(geometry.centerOf(c), dotRadius, dotPaint);
      }

      // Draw ✕ on blocker cell
      final b = pv.lane.blocker;
      if (b != null) {
        final c = geometry.centerOf(b);
        final k = cell * 0.28;
        final xPaint = Paint()
          ..color = col
          ..strokeWidth = math.max(3.0, cell * 0.09)
          ..strokeCap = StrokeCap.round;
        canvas.drawLine(c - Offset(k, k), c + Offset(k, k), xPaint);
        canvas.drawLine(c + Offset(-k, k), c + Offset(k, -k), xPaint);
      }
    }

    // 5. Draw Hammer Mode Overlays
    if (data.hammerMode) {
      // Subtle board tint
      final r = Radius.circular(geometry.cornerRadius);
      canvas.drawRRect(
        RRect.fromRectAndRadius(Offset.zero & size, r),
        Paint()..color = const Color(0x18FF9800),
      );

      // Rocks highlight in Hammer mode
      for (final rock in data.board.rocks.values) {
        final center = geometry.centerOf(rock.cell);
        final ringRadius = (cell * 0.42) * (1.1 + pulse * 0.2);
        canvas.drawCircle(
          center,
          ringRadius,
          Paint()
            ..color = const Color(0xFFFF9800).withValues(alpha: 0.65 - pulse * 0.3)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2.5,
        );
      }
    }
  }

  /// Render static background, lawn grid, borders, and rocks into a canvas.
  static void drawStaticContent(Canvas canvas, BoardGeometry geometry, BoardState board) {
    final size = geometry.size;
    final r = Radius.circular(geometry.cornerRadius);
    final boardRRect = RRect.fromRectAndRadius(Offset.zero & size, r);

    // 1. Garden patch base & soft shadow
    canvas.drawRRect(
      boardRRect.shift(const Offset(0, 5)),
      Paint()..color = const Color(0x1F163B28),
    );

    // 2. Soft pastel grass lawn patch
    final grassPaint = Paint()..color = const Color(0xFFD7ECD4);
    canvas.drawRRect(boardRRect, grassPaint);

    // Subtle lawn checker tiles
    final altGrassPaint = Paint()..color = const Color(0xFFDFF2DC);
    for (var x = 0; x < geometry.columns; x++) {
      for (var y = 0; y < geometry.rows; y++) {
        if ((x + y) % 2 == 0) {
          final cRect = geometry.rectOf(Cell(x, y));
          canvas.drawRRect(
            RRect.fromRectAndRadius(cRect.deflate(1.5), Radius.circular(geometry.cornerRadius * 0.6)),
            altGrassPaint,
          );
        }
      }
    }

    // 3. Subtle inner border / bevel rim
    canvas.drawRRect(
      boardRRect,
      Paint()
        ..color = const Color(0x33075B35)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0,
    );

    // 4. Dotted grid at cell intersections
    final dotPaint = Paint()..color = const Color(0x28075B35);
    for (var x = 0; x <= geometry.columns; x++) {
      for (var y = 0; y <= geometry.rows; y++) {
        final pt = Offset(x * geometry.cell, y * geometry.cell);
        canvas.drawCircle(pt, 1.8, dotPaint);
      }
    }

    // 5. Garden Rocks (rounded grey stone with clay lighting & moss)
    for (final rock in board.rocks.values) {
      _drawGardenRock(canvas, geometry, rock.cell);
    }
  }

  static void _drawGardenRock(Canvas canvas, BoardGeometry geometry, Cell cellPos) {
    final center = geometry.centerOf(cellPos);
    final cell = geometry.cell;
    final radius = cell * 0.40;

    // Rock shadow
    canvas.drawOval(
      Rect.fromCenter(
        center: center + const Offset(0, 3.5),
        width: radius * 2.1,
        height: radius * 1.8,
      ),
      Paint()..color = const Color(0x22000000),
    );

    // Rock main body (natural rounded stone)
    final stoneRect = Rect.fromCenter(
      center: center,
      width: radius * 2.0,
      height: radius * 1.9,
    );
    final stoneRRect = RRect.fromRectAndRadius(stoneRect, Radius.circular(radius * 0.85));
    canvas.drawRRect(stoneRRect, Paint()..color = const Color(0xFF90A4AE));

    // Stone soft highlight (top-left)
    final hlRect = Rect.fromCenter(
      center: center - Offset(radius * 0.28, radius * 0.28),
      width: radius * 1.1,
      height: radius * 0.9,
    );
    canvas.drawOval(hlRect, Paint()..color = const Color(0x40FFFFFF));

    // Stone underside shadow
    final shadePaint = Paint()
      ..color = const Color(0x2E263238)
      ..style = PaintingStyle.stroke
      ..strokeWidth = radius * 0.25;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius * 0.85),
      math.pi * 0.15,
      math.pi * 0.75,
      false,
      shadePaint,
    );

    // Cute moss speckle
    final mossPaint = Paint()..color = const Color(0x887CB342);
    canvas.drawCircle(center + Offset(radius * 0.32, -radius * 0.25), radius * 0.18, mossPaint);
    canvas.drawCircle(center + Offset(radius * 0.42, -radius * 0.12), radius * 0.12, mossPaint);
  }

  @override
  bool shouldRepaint(BoardPainter oldDelegate) =>
      oldDelegate.motionT != motionT ||
      oldDelegate.data != data ||
      oldDelegate.geometry != geometry ||
      oldDelegate.staticPicture != staticPicture;
}
