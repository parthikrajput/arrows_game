import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../contracts/view_models.dart';
import '../../services/perf/perf.dart';
import '../../state/settings_cubit.dart';
import '../../state/tutorial_cubit.dart';
import '../../ui/board/board_canvas.dart';
import '../../ui/board/vfx.dart';
import 'board_geometry.dart';
import 'game_bloc.dart';
import 'tutorials.dart';

/// Turns finger input into game events and feeds the board canvas.
/// Owner: Claude. The look lives entirely in [BoardCanvas].
class BoardInput extends StatefulWidget {
  const BoardInput({super.key});

  static const previewHold = Duration(milliseconds: 350);

  @override
  State<BoardInput> createState() => _BoardInputState();
}

class _BoardInputState extends State<BoardInput> {
  final _vfx = VfxController(cap: 0, shakeDp: 0);
  BoardGeometry? _geo;
  Offset? _lastTap;

  @override
  void dispose() {
    _vfx.dispose();
    super.dispose();
  }

  /// Effects fire on the same cue as the sound and haptic.
  void _onCue(GameState s) {
    final geo = _geo;
    if (geo == null) return;
    final m = s.motion;
    switch (s.cue) {
      case GameCue.exit when m != null && m.snake.id >= 0:
        final end = m.lane.cells.isNotEmpty ? m.lane.cells.last : (m.lane.fromTail ? m.snake.body.last : m.snake.head);
        _vfx.play(VfxKind.exitSparkle, geo.centerOf(end));
      case GameCue.bump:
        _vfx.shake();
        final b = m?.lane.blocker;
        if (b != null) _vfx.play(VfxKind.heartBreak, geo.centerOf(b));
      case GameCue.shieldCrack when m != null && m.snake.id >= 0:
        _vfx.shake();
        _vfx.play(VfxKind.shieldPop, geo.centerOf(m.snake.head));
      case GameCue.hammerHit when _lastTap != null:
        _vfx.play(VfxKind.hammerDebris, _lastTap!);
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<GameBloc>();
    final settings = context.watch<SettingsCubit>().state;
    final tutorial = context.watch<TutorialCubit>().state;
    final profile = context.read<PerfSettings>().profile(batterySaver: settings.batterySaver);
    // Reduce Motion removes shake and particles; rules never change.
    final reduced = settings.reducedMotion || (MediaQuery.maybeDisableAnimationsOf(context) ?? false);
    _vfx
      ..cap = reduced ? 0 : profile.maxParticles
      ..shakeDp = reduced ? 0 : profile.shakeDp;
    return BlocListener<GameBloc, GameState>(
      listenWhen: (a, b) => a.cueSeq != b.cueSeq,
      listener: (_, s) => _onCue(s),
      child: LayoutBuilder(
        builder: (context, box) {
          return BlocBuilder<GameBloc, GameState>(
            builder: (context, s) {
              final board = s.attempt.board;
              final geo = BoardGeometry.fit(columns: board.width, rows: board.height, avail: box.biggest);
              _geo = geo;
              final data = BoardViewData(
                board: board,
                motion: s.motion,
                hintSnakeId: s.hintSnakeId,
                preview: s.preview,
                hammerMode: s.status == GameStatus.hammerTarget,
                colourBlind: settings.colourBlind,
                reducedMotion: settings.reducedMotion,
                hintObstacleId: s.hintObstacleId,
                litSnakeId: s.litSnakeId,
                brightNights: settings.brightNights,
                lowQuality: profile.tier == DeviceTier.low,
                guideSnakeId: Tutorials.showsHand(s.level.number, tutorial) ? s.solutionNextSnake : null,
              );
              return Center(
                // The board repaints on its own layer, so HUD changes never
                // repaint it.
                child: RepaintBoundary(
                  child: RawGestureDetector(
                    behavior: HitTestBehavior.opaque,
                    gestures: {
                      TapGestureRecognizer: GestureRecognizerFactoryWithHandlers<TapGestureRecognizer>(
                        TapGestureRecognizer.new,
                        (r) => r.onTapUp = (d) => _tap(bloc, s, geo, d.localPosition),
                      ),
                      LongPressGestureRecognizer: GestureRecognizerFactoryWithHandlers<LongPressGestureRecognizer>(
                        () => LongPressGestureRecognizer(duration: BoardInput.previewHold),
                        (r) {
                          r.onLongPressStart = (d) {
                            final id = geo.snakeAt(s.attempt.board, d.localPosition);
                            if (id != null) {
                              bloc.add(PreviewStarted(id, at: geo.cellAt(d.localPosition)));
                            }
                          };
                          // Releasing after a preview is never a tap.
                          r.onLongPressEnd = (_) => bloc.add(const PreviewEnded());
                          r.onLongPressCancel = () => bloc.add(const PreviewEnded());
                        },
                      ),
                    },
                    child: VfxLayer(
                      controller: _vfx,
                      child: SizedBox.fromSize(
                        size: geo.size,
                        child: BoardCanvas(
                          data: data,
                          geometry: geo,
                          onMotionDone: (id) => bloc.add(AnimationCompleted(id)),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _tap(GameBloc bloc, GameState s, BoardGeometry geo, Offset p) {
    final board = s.attempt.board;
    _lastTap = p;
    final at = geo.cellAt(p);
    if (s.status == GameStatus.hammerTarget) {
      final rock = geo.rockAt(board, p);
      if (rock != null) {
        bloc.add(RockTapped(rock));
        return;
      }
      final o = geo.hammerObstacleAt(board, p);
      if (o != null) {
        bloc.add(ObstacleTapped(o, at: at));
        return;
      }
    } else {
      final o = geo.interactiveAt(board, p);
      if (o != null) {
        bloc.add(ObstacleTapped(o, at: at));
        return;
      }
    }
    final id = geo.snakeAt(board, p);
    if (id != null) bloc.add(SnakeTapped(id, at: at));
  }
}
