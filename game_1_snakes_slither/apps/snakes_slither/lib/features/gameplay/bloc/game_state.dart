import 'package:equatable/equatable.dart';
import 'package:puzzle_core/slither_engine.dart';

import '../../../services/remote_config.dart';

enum GameStatus { playing, animating, hammerTarget, secondChance, won, failed, stuck }

enum GameKind { level, daily }

class GameMode extends Equatable {
  const GameMode.level(this.level)
      : kind = GameKind.level,
        dayKey = null;

  const GameMode.daily(this.dayKey)
      : kind = GameKind.daily,
        level = 0;

  final GameKind kind;
  final int level;
  final String? dayKey;

  bool get isDaily => kind == GameKind.daily;

  /// Key for the once-per-level (or once-per-day) ad revive.
  String get reviveKey => isDaily ? 'daily:$dayKey' : '$level';

  @override
  List<Object?> get props => [kind, level, dayKey];
}

enum AnimKind { exit, bump, wobble, smash }

/// One animation the view must play before the move is committed.
class AnimRequest extends Equatable {
  const AnimRequest({required this.seq, required this.kind, required this.snakeId, this.cells = 0, this.blocker});
  final int seq;
  final AnimKind kind;
  final String snakeId;

  /// Exit: cells to edge. Bump: cells to blocker.
  final int cells;
  final Cell? blocker;

  @override
  List<Object?> get props => [seq, kind, snakeId, cells, blocker];
}

enum EffectKind {
  heartLost,
  shieldAbsorbed,
  shieldActivated,
  hintShown,
  hintFailed,
  boosterCapReached,
  needBooster,
  hammerLastSnakeBlocked,
  slithered,
}

/// One-shot feedback for the view (sound, haptics, toasts).
class GameEffect extends Equatable {
  const GameEffect(this.seq, this.kind, [this.booster]);
  final int seq;
  final EffectKind kind;
  final BoosterType? booster;

  @override
  List<Object?> get props => [seq, kind, booster];
}

class GameState extends Equatable {
  const GameState({
    required this.mode,
    required this.def,
    required this.board,
    required this.status,
    required this.hearts,
    required this.maxHearts,
    this.shieldCharges = 0,
    this.moves = 0,
    this.heartsLost = 0,
    this.usedRevive = false,
    this.refillsUsed = 0,
    this.uses = const {},
    this.hintTarget,
    this.played = const [],
    this.anim,
    this.effect,
    this.attempt = 1,
  });

  final GameMode mode;
  final LevelDef def;
  final BoardState board;
  final GameStatus status;
  final int hearts;
  final int maxHearts;
  final int shieldCharges;
  final int moves;
  final int heartsLost;

  /// Any ad revive or Heart Berry Refill this attempt (caps stars at 1).
  final bool usedRevive;
  final int refillsUsed;
  final Map<BoosterType, int> uses;
  final String? hintTarget;

  /// Snakes that left the board, in order (for the level-solution prefix).
  final List<String> played;
  final AnimRequest? anim;
  final GameEffect? effect;
  final int attempt;

  int usesOf(BoosterType t) => uses[t] ?? 0;
  bool get isBusy => status == GameStatus.animating;
  int get snakesLeft => board.snakes.length;
  int get totalSnakes => def.snakes.length;

  int get stars => starsFor(heartsLost: heartsLost, usedRevive: usedRevive, parMoves: def.parMoves, moves: moves);

  GameState copyWith({
    LevelDef? def,
    BoardState? board,
    GameStatus? status,
    int? hearts,
    int? maxHearts,
    int? shieldCharges,
    int? moves,
    int? heartsLost,
    bool? usedRevive,
    int? refillsUsed,
    Map<BoosterType, int>? uses,
    String? Function()? hintTarget,
    List<String>? played,
    AnimRequest? anim,
    GameEffect? effect,
    int? attempt,
  }) =>
      GameState(
        mode: mode,
        def: def ?? this.def,
        board: board ?? this.board,
        status: status ?? this.status,
        hearts: hearts ?? this.hearts,
        maxHearts: maxHearts ?? this.maxHearts,
        shieldCharges: shieldCharges ?? this.shieldCharges,
        moves: moves ?? this.moves,
        heartsLost: heartsLost ?? this.heartsLost,
        usedRevive: usedRevive ?? this.usedRevive,
        refillsUsed: refillsUsed ?? this.refillsUsed,
        uses: uses ?? this.uses,
        hintTarget: hintTarget != null ? hintTarget() : this.hintTarget,
        played: played ?? this.played,
        anim: anim ?? this.anim,
        effect: effect ?? this.effect,
        attempt: attempt ?? this.attempt,
      );

  @override
  List<Object?> get props => [
        mode,
        def.id,
        board,
        status,
        hearts,
        maxHearts,
        shieldCharges,
        moves,
        heartsLost,
        usedRevive,
        refillsUsed,
        uses.toString(),
        hintTarget,
        played.length,
        anim,
        effect,
        attempt,
      ];
}
