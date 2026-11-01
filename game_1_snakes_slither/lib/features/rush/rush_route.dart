import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../contracts/view_models.dart';
import '../../data/level_repository.dart';
import '../../services/analytics.dart';
import '../../services/time_guard.dart';
import '../../state/settings_cubit.dart';
import '../../state/wallet_cubit.dart';
import '../../ui/board/board_canvas.dart';
import '../../ui/screens/rush_screen.dart';
import '../../ui/theme/tokens.dart';
import '../gameplay/board_geometry.dart';
import 'rush_cubit.dart';

/// Golden Slither Rush after a level (L25, L50 … L500). No ads before or
/// after it. When it ends the player goes on to the next level (or the
/// Phase Complete screen after L500).
class RushRoute extends StatelessWidget {
  const RushRoute({super.key, required this.afterLevel});
  final int afterLevel;

  @override
  Widget build(BuildContext context) => BlocProvider(
    key: ValueKey('rush$afterLevel'),
    create: (c) => RushCubit(
      level: afterLevel,
      wallet: c.read<WalletCubit>(),
      clock: c.read<TimeGuard>().clock,
      onTrack: c.read<Analytics>().log,
    ),
    child: const _RushView(),
  );
}

class _RushView extends StatefulWidget {
  const _RushView();
  @override
  State<_RushView> createState() => _RushViewState();
}

class _RushViewState extends State<_RushView> with SingleTickerProviderStateMixin {
  late final Ticker _ticker = createTicker((_) => context.read<RushCubit>().tick());

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  void _syncTicker(RushPhase p) {
    final run = p == RushPhase.countdown || p == RushPhase.playing;
    if (run && !_ticker.isActive) _ticker.start();
    if (!run && _ticker.isActive) _ticker.stop();
  }

  void _leave(BuildContext context, int afterLevel, {bool map = false}) {
    final repo = context.read<LevelRepository>();
    final router = GoRouter.of(context);
    if (afterLevel >= 500) {
      router.go('/phase-complete');
    } else if (map || !repo.exists(afterLevel + 1)) {
      router.go('/map');
    } else {
      router.go('/play/${afterLevel + 1}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<RushCubit>();
    final settings = context.watch<SettingsCubit>().state;
    return BlocConsumer<RushCubit, RushState>(
      listenWhen: (a, b) => a.phase != b.phase,
      listener: (_, s) => _syncTicker(s.phase),
      builder: (context, s) {
        final data = RushData(
          afterLevel: s.level,
          total: s.total,
          cleared: s.cleared,
          coins: s.coins,
          msLeft: s.msLeft,
          seconds: RushRules.seconds,
          countdown: s.countdown,
          playing: s.phase == RushPhase.playing,
          perSnake: RushRules.coinsPerSnake,
          fullClearBonus: RushRules.fullClearBonus,
        );
        final board = LayoutBuilder(
          builder: (_, box) {
            final geo = BoardGeometry.fit(columns: s.board.width, rows: s.board.height, avail: box.biggest);
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTapUp: (d) {
                final id = geo.snakeAt(s.board, d.localPosition);
                if (id != null) cubit.tap(id);
              },
              child: SizedBox.fromSize(
                size: geo.size,
                child: BoardCanvas(
                  data: BoardViewData(
                    board: s.board,
                    motion: s.motion,
                    hintSnakeId: null,
                    preview: null,
                    hammerMode: false,
                    colourBlind: settings.colourBlind,
                    reducedMotion: settings.reducedMotion,
                  ),
                  geometry: geo,
                  onMotionDone: cubit.motionDone,
                ),
              ),
            );
          },
        );
        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, _) {
            if (!didPop) cubit.skip();
          },
          child: Stack(
            children: [
              RushScreen(data: data, board: board, onSkip: cubit.skip),
              if (s.phase == RushPhase.intro || s.phase == RushPhase.done) ...[
                const ModalBarrier(color: AppColors.scrim, dismissible: false),
                if (s.phase == RushPhase.intro)
                  RushIntroPopup(data: data, onStart: cubit.start, onSkip: () => _leave(context, s.level))
                else
                  RushResultsPopup(
                    data: RushResultData(
                      cleared: s.cleared,
                      total: s.total,
                      snakeCoins: s.coins,
                      bonus: s.bonus,
                      msLeft: s.msLeft,
                      nextLevel: s.level >= 500 ? null : s.level + 1,
                    ),
                    onContinue: () => _leave(context, s.level),
                    onMap: () => _leave(context, s.level, map: true),
                  ),
              ],
            ],
          ),
        );
      },
    );
  }
}
