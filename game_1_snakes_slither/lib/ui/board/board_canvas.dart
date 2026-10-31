// OWNER: UI agent. Real BoardCanvas implementation with soft 3D clay snakes,
// Garden Rocks, cached static Picture, and motion animations.
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

import '../../contracts/view_models.dart';
import '../../features/gameplay/board_geometry.dart';
import '../theme/tokens.dart';
import 'board_painter.dart';

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
  late final AnimationController _motionController = AnimationController(vsync: this);

  int? _playing;
  ui.Picture? _staticBoardPicture;
  BoardGeometry? _cachedGeometry;
  BoardState? _cachedBoard;

  @override
  void initState() {
    super.initState();
    _updateStaticPicture();
    _maybePlay();
  }

  @override
  void didUpdateWidget(BoardCanvas old) {
    super.didUpdateWidget(old);
    if (_cachedGeometry != widget.geometry || _cachedBoard != widget.data.board) {
      _updateStaticPicture();
    }
    _maybePlay();
  }

  void _updateStaticPicture() {
    _staticBoardPicture?.dispose();
    _staticBoardPicture = null;

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder, Offset.zero & widget.geometry.size);
    BoardPainter.drawStaticContent(canvas, widget.geometry, widget.data.board);
    _staticBoardPicture = recorder.endRecording();

    _cachedGeometry = widget.geometry;
    _cachedBoard = widget.data.board;
  }

  void _maybePlay() {
    final m = widget.data.motion;
    if (m == null || m.id == _playing) return;
    _playing = m.id;

    final isReduced = widget.data.reducedMotion;

    _motionController.duration = switch (m.kind) {
      MotionKind.exit => isReduced
          ? Duration(milliseconds: (AppMotion.exitFor(m.lane.cells.length + m.snake.length).inMilliseconds * 0.6).round().clamp(180, 300))
          : AppMotion.exitFor(m.lane.cells.length + m.snake.length),
      MotionKind.bump => isReduced ? const Duration(milliseconds: 220) : AppMotion.bonk,
      MotionKind.locked => isReduced ? const Duration(milliseconds: 120) : AppMotion.locked,
    };

    _motionController.forward(from: 0).whenComplete(() {
      if (mounted && _playing == m.id) {
        widget.onMotionDone(m.id);
      }
    });
  }

  @override
  void dispose() {
    _motionController.dispose();
    _staticBoardPicture?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _motionController,
    builder: (_, _) => CustomPaint(
      size: widget.geometry.size,
      painter: BoardPainter(
        data: widget.data,
        geometry: widget.geometry,
        motionT: _motionController.value,
        staticPicture: _staticBoardPicture,
      ),
    ),
  );
}
