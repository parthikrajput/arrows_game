import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../contracts/view_models.dart';
import '../../state/settings_cubit.dart';
import '../../ui/board/board_canvas.dart';
import 'board_geometry.dart';
import 'game_bloc.dart';

/// Turns finger input into game events and feeds the board canvas.
/// Owner: Claude. The look lives entirely in [BoardCanvas].
class BoardInput extends StatelessWidget {
  const BoardInput({super.key});

  static const previewHold = Duration(milliseconds: 350);

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<GameBloc>();
    final settings = context.watch<SettingsCubit>().state;
    return LayoutBuilder(
      builder: (context, box) {
        return BlocBuilder<GameBloc, GameState>(
          builder: (context, s) {
            final board = s.attempt.board;
            final geo = BoardGeometry.fit(
              columns: board.width,
              rows: board.height,
              avail: box.biggest,
            );
            final data = BoardViewData(
              board: board,
              motion: s.motion,
              hintSnakeId: s.hintSnakeId,
              preview: s.preview,
              hammerMode: s.status == GameStatus.hammerTarget,
              colourBlind: settings.colourBlind,
              reducedMotion: settings.reducedMotion,
            );
            return Center(
              child: RawGestureDetector(
                behavior: HitTestBehavior.opaque,
                gestures: {
                  TapGestureRecognizer: GestureRecognizerFactoryWithHandlers<TapGestureRecognizer>(
                    TapGestureRecognizer.new,
                    (r) => r.onTapUp = (d) => _tap(bloc, s, geo, d.localPosition),
                  ),
                  LongPressGestureRecognizer:
                      GestureRecognizerFactoryWithHandlers<LongPressGestureRecognizer>(
                        () => LongPressGestureRecognizer(duration: previewHold),
                        (r) {
                          r.onLongPressStart = (d) {
                            final id = geo.snakeAt(s.attempt.board, d.localPosition);
                            if (id != null) bloc.add(PreviewStarted(id));
                          };
                          // Releasing after a preview is never a tap.
                          r.onLongPressEnd = (_) => bloc.add(const PreviewEnded());
                          r.onLongPressCancel = () => bloc.add(const PreviewEnded());
                        },
                      ),
                },
                child: SizedBox.fromSize(
                  size: geo.size,
                  child: BoardCanvas(
                    data: data,
                    geometry: geo,
                    onMotionDone: (id) => bloc.add(AnimationCompleted(id)),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _tap(GameBloc bloc, GameState s, BoardGeometry geo, Offset p) {
    final board = s.attempt.board;
    if (s.status == GameStatus.hammerTarget) {
      final rock = geo.rockAt(board, p);
      if (rock != null) {
        bloc.add(RockTapped(rock));
        return;
      }
    }
    final id = geo.snakeAt(board, p);
    if (id != null) bloc.add(SnakeTapped(id));
  }
}
