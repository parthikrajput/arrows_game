import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../render/board_painter.dart';
import '../render/game_scene.dart';

class BoardView extends StatefulWidget {
  const BoardView({
    super.key,
    required this.scene,
    required this.onTap,
    this.onLongPressStart,
    this.onLongPressEnd,
    this.semanticsLabel,
  });

  final GameScene scene;
  final void Function(Offset local) onTap;
  final void Function(Offset local)? onLongPressStart;
  final VoidCallback? onLongPressEnd;
  final String? semanticsLabel;

  @override
  State<BoardView> createState() => _BoardViewState();
}

class _BoardViewState extends State<BoardView> with SingleTickerProviderStateMixin {
  late final Ticker _ticker;
  Duration _last = Duration.zero;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_onTick);
    widget.scene.addListener(_syncTicker);
  }

  @override
  void didUpdateWidget(BoardView old) {
    super.didUpdateWidget(old);
    if (old.scene != widget.scene) {
      old.scene.removeListener(_syncTicker);
      widget.scene.addListener(_syncTicker);
    }
  }

  // Run the ticker only while something animates (battery).
  void _syncTicker() {
    if (widget.scene.isAnimating && !_ticker.isActive) {
      _last = Duration.zero;
      _ticker.start();
    } else if (!widget.scene.isAnimating && _ticker.isActive) {
      _ticker.stop();
    }
  }

  void _onTick(Duration elapsed) {
    final dt = elapsed - _last;
    _last = elapsed;
    widget.scene.tick(dt);
  }

  @override
  void dispose() {
    widget.scene.removeListener(_syncTicker);
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        widget.scene.updateLayout(constraints.biggest);
        return Semantics(
          label: widget.semanticsLabel,
          child: RawGestureDetector(
            behavior: HitTestBehavior.opaque,
            gestures: <Type, GestureRecognizerFactory>{
              TapGestureRecognizer: GestureRecognizerFactoryWithHandlers<TapGestureRecognizer>(
                TapGestureRecognizer.new,
                (r) => r.onTapUp = (d) => widget.onTap(d.localPosition),
              ),
              if (widget.onLongPressStart != null)
                LongPressGestureRecognizer: GestureRecognizerFactoryWithHandlers<LongPressGestureRecognizer>(
                  () => LongPressGestureRecognizer(duration: const Duration(milliseconds: 350)),
                  (r) {
                    r.onLongPressStart = (d) => widget.onLongPressStart!(d.localPosition);
                    r.onLongPressEnd = (_) => widget.onLongPressEnd?.call();
                    r.onLongPressCancel = () => widget.onLongPressEnd?.call();
                  },
                ),
            },
            child: ClipRect(
              child: RepaintBoundary(
                child: CustomPaint(size: constraints.biggest, painter: BoardPainter(scene: widget.scene)),
              ),
            ),
          ),
        );
      },
    );
  }
}
