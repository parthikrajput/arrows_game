// Bots mode: picks the next tap for the auto-player on the game screen.
import 'dart:isolate';

import 'package:puzzle_core/puzzle_core.dart';

import 'game_bloc.dart';

typedef BotTap = ({int? snake, int? obstacle});

/// The bot's next tap, or null when the board has no way out.
///
/// While the moves so far match the level's stored solution, its next step
/// is used. After the player's own moves (or a Hammer) it searches from the
/// board as it is, the same way Hint does.
Future<BotTap?> botMove(GameState s) async {
  final a = s.attempt, sol = s.level.solution;
  final onPath =
      a.boosterUses[Booster.hammer] == null &&
      sol.length > a.history.length &&
      [for (var i = 0; i < a.history.length; i++) a.history[i] == sol[i]].every((x) => x);
  if (onPath) {
    final token = sol[a.history.length];
    final snake = a.play.sim.snakeIndex(token);
    if (snake >= 0) return (snake: snake, obstacle: null);
    final obstacle = a.play.sim.mechIndex(token);
    if (obstacle >= 0) return (snake: null, obstacle: obstacle);
  }
  final HintTarget? t;
  if (GameBloc.useIsolateForHint) {
    final play = a.play, st = a.st;
    t = await Isolate.run(() => Attempt.resume(play, st).nextHint());
  } else {
    t = a.nextHint();
  }
  if (t == null) return null;
  return (snake: t.snakeId, obstacle: t.obstacleId);
}
