import 'dart:isolate';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:puzzle_core/puzzle_core.dart';

import '../../contracts/view_models.dart';
import '../../state/ads_cubit.dart';
import '../../state/economy.dart';
import '../../state/progress_cubit.dart';
import '../../state/rewards.dart';
import '../../state/wallet_cubit.dart';

enum GameStatus { playing, animating, hammerTarget, paused, secondChance, won, failed }

/// What the UI should react to once (sound, haptics, toasts). Not a state.
enum GameCue {
  exit,
  bump,
  locked,
  shieldCrack,
  hintNoSolution,
  hammerHit,
  hammerBlocked,
  notEnoughCoins,
  action,
  heartTimer,
}

// ---------------------------------------------------------------- events
sealed class GameEvent {
  const GameEvent();
}

class SnakeTapped extends GameEvent {
  const SnakeTapped(this.snakeId, {this.at});
  final int snakeId;

  /// Tapped cell: picks the end a Two-Headed Hydra leaves from.
  final Cell? at;
}

/// A lever, lilypad, switch, stump or gear — or a Hammer target.
class ObstacleTapped extends GameEvent {
  const ObstacleTapped(this.obstacleId, {this.at});
  final int obstacleId;

  /// Tapped cell: picks one Creeping Vine cell for the Hammer.
  final Cell? at;
}

/// A Garden Rock tapped in Hammer mode.
class RockTapped extends ObstacleTapped {
  const RockTapped(super.rockId);
}

class AnimationCompleted extends GameEvent {
  const AnimationCompleted(this.motionId);
  final int motionId;
}

class PreviewStarted extends GameEvent {
  const PreviewStarted(this.snakeId, {this.at});
  final int snakeId;
  final Cell? at;
}

class PreviewEnded extends GameEvent {
  const PreviewEnded();
}

class BoosterPressed extends GameEvent {
  const BoosterPressed(this.booster);
  final Booster booster;
}

class HammerCancelled extends GameEvent {
  const HammerCancelled();
}

class ReviveWithAd extends GameEvent {
  const ReviveWithAd();
}

class ReviveWithCoins extends GameEvent {
  const ReviveWithCoins();
}

class ReviveDeclined extends GameEvent {
  const ReviveDeclined();
}

class DoubleCoinsRequested extends GameEvent {
  const DoubleCoinsRequested();
}

class Paused extends GameEvent {
  const Paused();
}

class Resumed extends GameEvent {
  const Resumed();
}

class Restarted extends GameEvent {
  const Restarted();
}

class _HintFound extends GameEvent {
  const _HintFound(this.target, this.seq);
  final HintTarget? target;
  final int seq;
}

/// A tap waiting for the running animation (input queue of 1).
class QueuedTap extends Equatable {
  const QueuedTap({this.snakeId, this.obstacleId, this.at});
  final int? snakeId;
  final int? obstacleId;
  final Cell? at;
  @override
  List<Object?> get props => [snakeId, obstacleId, at];
}

// ----------------------------------------------------------------- state
class GameState extends Equatable {
  const GameState({
    required this.level,
    required this.attempt,
    required this.status,
    this.motion,
    this.pending,
    this.queued,
    this.hintSnakeId,
    this.hintObstacleId,
    this.hintBusy = false,
    this.litSnakeId,
    this.preview,
    this.result,
    this.cue,
    this.cueSeq = 0,
    this.resumeTo = GameStatus.playing,
    this.miniShopFor,
    this.adBusy = false,
  });

  final Level level;

  /// Committed attempt. During a move animation this is still the "before" state.
  final Attempt attempt;
  final GameStatus status;
  final Motion? motion;

  /// Result of the animating move, applied when the animation completes.
  final TapOutcome? pending;

  /// Input queue of 1: the latest tap during an animation wins.
  final QueuedTap? queued;
  final int? hintSnakeId;
  final int? hintObstacleId;

  /// The Hint solver is searching (off the stored solution).
  final bool hintBusy;

  /// Jungle Night: the last snake that moved.
  final int? litSnakeId;
  final PreviewData? preview;
  final LevelCompleteData? result;
  final GameCue? cue;

  /// Increments with every cue so the same cue twice still triggers the UI.
  final int cueSeq;
  final GameStatus resumeTo;

  /// Booster the player tapped with 0 left; UI shows the mini shop.
  final Booster? miniShopFor;

  /// A rewarded ad is showing; the Second Chance countdown pauses.
  final bool adBusy;

  bool get acceptsBoosters => status == GameStatus.playing || status == GameStatus.hammerTarget;

  /// Next snake of the stored solution while the player has followed it.
  int? get solutionNextSnake {
    final h = attempt.history, sol = level.solution;
    if (h.length >= sol.length) return null;
    for (var i = 0; i < h.length; i++) {
      if (h[i] != sol[i]) return null;
    }
    final s = attempt.play.sim.snakeIndex(sol[h.length]);
    return s >= 0 && attempt.board.snakes.containsKey(s) ? s : null;
  }

  GameState copyWith({
    Attempt? attempt,
    GameStatus? status,
    Motion? Function()? motion,
    TapOutcome? Function()? pending,
    QueuedTap? Function()? queued,
    int? Function()? hintSnakeId,
    int? Function()? hintObstacleId,
    bool? hintBusy,
    int? Function()? litSnakeId,
    PreviewData? Function()? preview,
    LevelCompleteData? Function()? result,
    GameCue? cue,
    GameStatus? resumeTo,
    Booster? Function()? miniShopFor,
    bool? adBusy,
  }) => GameState(
    level: level,
    attempt: attempt ?? this.attempt,
    status: status ?? this.status,
    motion: motion != null ? motion() : this.motion,
    pending: pending != null ? pending() : this.pending,
    queued: queued != null ? queued() : this.queued,
    hintSnakeId: hintSnakeId != null ? hintSnakeId() : this.hintSnakeId,
    hintObstacleId: hintObstacleId != null ? hintObstacleId() : this.hintObstacleId,
    hintBusy: hintBusy ?? this.hintBusy,
    litSnakeId: litSnakeId != null ? litSnakeId() : this.litSnakeId,
    preview: preview != null ? preview() : this.preview,
    result: result != null ? result() : this.result,
    cue: cue ?? this.cue,
    cueSeq: cue != null ? cueSeq + 1 : cueSeq,
    resumeTo: resumeTo ?? this.resumeTo,
    miniShopFor: miniShopFor != null ? miniShopFor() : this.miniShopFor,
    adBusy: adBusy ?? this.adBusy,
  );

  @override
  List<Object?> get props => [
    attempt.st,
    attempt.hearts,
    attempt.shieldCharges,
    attempt.moves,
    attempt.boosterUses,
    attempt.refills,
    attempt.adRevives,
    status,
    motion,
    queued,
    hintSnakeId,
    hintObstacleId,
    hintBusy,
    litSnakeId,
    preview,
    result,
    cueSeq,
    resumeTo,
    miniShopFor,
    adBusy,
  ];
}

// ------------------------------------------------------------------ bloc
class GameBloc extends Bloc<GameEvent, GameState> {
  GameBloc({
    required Level level,
    required this._wallet,
    required this._progress,
    required this._ads,
    required bool hasNextLevel,
    this.onTrack,
    this.guidedTaps = false,
  }) : _hasNext = hasNextLevel,
       super(
         GameState(level: level, attempt: Attempt.forLevel(level), status: GameStatus.playing),
       ) {
    _wallet.grantTutorialBoosters(level.number);
    on<SnakeTapped>(_onSnakeTapped);
    on<ObstacleTapped>(_onObstacleTapped);
    on<AnimationCompleted>(_onAnimationCompleted);
    on<PreviewStarted>(_onPreviewStarted);
    on<PreviewEnded>((e, emit) => emit(state.copyWith(preview: () => null)));
    on<BoosterPressed>(_onBoosterPressed);
    on<_HintFound>(_onHintFound);
    on<HammerCancelled>((e, emit) {
      if (state.status == GameStatus.hammerTarget) emit(state.copyWith(status: GameStatus.playing));
    });
    on<ReviveWithAd>(_onReviveAd);
    on<ReviveWithCoins>(_onReviveCoins);
    on<ReviveDeclined>((e, emit) {
      if (state.status == GameStatus.secondChance) {
        emit(state.copyWith(status: GameStatus.failed));
        onTrack?.call('level_fail', {'level': state.level.number, 'moves': state.attempt.moves});
      }
    });
    on<DoubleCoinsRequested>(_onDouble);
    on<Paused>(_onPaused);
    on<Resumed>((e, emit) {
      if (state.status == GameStatus.paused) emit(state.copyWith(status: state.resumeTo));
    });
    on<Restarted>(_onRestarted);
    on<_MiniShopClosed>((e, emit) => emit(state.copyWith(miniShopFor: () => null)));
    onTrack?.call('level_start', {'level': level.number});
  }

  final WalletCubit _wallet;
  final ProgressCubit _progress;
  final AdsCubit _ads;
  final bool _hasNext;

  /// FTUE L1: only the next snake of the solution reacts to a tap.
  final bool guidedTaps;

  /// Analytics hook (event name + parameters).
  final void Function(String name, Map<String, Object> params)? onTrack;
  int _motionSeq = 0;
  int _hintSeq = 0;

  void closeMiniShop() => add(const _MiniShopClosed());

  // ---- taps
  void _onSnakeTapped(SnakeTapped e, Emitter<GameState> emit) {
    switch (state.status) {
      case GameStatus.animating:
        emit(state.copyWith(queued: () => QueuedTap(snakeId: e.snakeId, at: e.at)));
      case GameStatus.hammerTarget:
        _hammerSnake(e.snakeId, emit);
      case GameStatus.playing:
        if (guidedTaps && state.solutionNextSnake != null && e.snakeId != state.solutionNextSnake) return;
        _play(QueuedTap(snakeId: e.snakeId, at: e.at), emit);
      default:
        break;
    }
  }

  void _onObstacleTapped(ObstacleTapped e, Emitter<GameState> emit) {
    switch (state.status) {
      case GameStatus.animating:
        if (e is! RockTapped) {
          emit(state.copyWith(queued: () => QueuedTap(obstacleId: e.obstacleId, at: e.at)));
        }
      case GameStatus.hammerTarget:
        _hammerObstacle(e.obstacleId, e.at, emit);
      case GameStatus.playing:
        if (e is! RockTapped) _play(QueuedTap(obstacleId: e.obstacleId, at: e.at), emit);
      default:
        break;
    }
  }

  void _play(QueuedTap tap, Emitter<GameState> emit) {
    final a = state.attempt;
    final TapOutcome out;
    final Snake snake;
    Obstacle? obstacle;
    if (tap.snakeId != null) {
      final s = a.board.snakes[tap.snakeId];
      if (s == null) return;
      snake = s;
      out = a.tapSnake(s.id, at: tap.at);
    } else {
      obstacle = a.board.obstacles.where((o) => o.id == tap.obstacleId).firstOrNull;
      if (obstacle == null || !obstacle.interactive) return;
      snake = Snake(id: -1, body: const [], dir: Dir.up, color: SnakeColor.green);
      out = a.tapObstacle(obstacle.id);
    }
    final m = out.move;
    final moved = m.kind == MoveKind.action &&
        tap.snakeId != null &&
        out.attempt.board.snakes[snake.id]?.head != snake.head;
    final kind = switch (m.kind) {
      MoveKind.exit => MotionKind.exit,
      MoveKind.bump => MotionKind.bump,
      MoveKind.locked => MotionKind.locked,
      MoveKind.action => moved ? MotionKind.slide : MotionKind.action,
    };
    emit(
      state.copyWith(
        status: GameStatus.animating,
        motion: () => Motion(
          id: ++_motionSeq,
          kind: kind,
          snake: snake,
          lane: m.lane,
          others: [for (final p in m.parts) if (p.snake.id != snake.id) p],
          obstacle: obstacle,
          lockReason: m.lockReason,
        ),
        pending: () => out,
        preview: () => null,
        // A hint stays until the player acts on the board.
        hintSnakeId: m.countsAsMove ? () => null : null,
        hintObstacleId: m.countsAsMove ? () => null : null,
        litSnakeId: m.countsAsMove && snake.id >= 0 ? () => snake.id : null,
        cue: out.shieldAbsorbed
            ? GameCue.shieldCrack
            : out.heartLost && m.kind != MoveKind.bump
            ? GameCue.heartTimer
            : switch (kind) {
                MotionKind.exit => GameCue.exit,
                MotionKind.bump => GameCue.bump,
                MotionKind.locked => GameCue.locked,
                MotionKind.slide || MotionKind.action => GameCue.action,
              },
      ),
    );
  }

  void _onAnimationCompleted(AnimationCompleted e, Emitter<GameState> emit) {
    if (state.status != GameStatus.animating || state.motion?.id != e.motionId) return;
    final next = state.pending!.attempt;
    final queued = state.queued;
    emit(
      state.copyWith(
        attempt: next,
        status: GameStatus.playing,
        motion: () => null,
        pending: () => null,
        queued: () => null,
      ),
    );
    if (_settle(emit)) return;
    if (queued != null) _play(queued, emit);
  }

  /// Win check first, then hearts. Returns true when play stopped.
  bool _settle(Emitter<GameState> emit) {
    switch (state.attempt.status) {
      case AttemptStatus.won:
        _win(emit);
        return true;
      case AttemptStatus.outOfHearts:
        final canAd = !_progress.state.adReviveUsed.contains(state.level.number);
        final canRefill = state.attempt.refillsLeft > 0;
        emit(
          state.copyWith(
            status: (canAd || canRefill) ? GameStatus.secondChance : GameStatus.failed,
            queued: () => null,
            hintSnakeId: () => null,
            hintObstacleId: () => null,
          ),
        );
        if (!canAd && !canRefill) {
          onTrack?.call('level_fail', {'level': state.level.number, 'moves': state.attempt.moves});
        }
        return true;
      case AttemptStatus.playing:
        return false;
    }
  }

  void _win(Emitter<GameState> emit) {
    final lv = state.level;
    final stars = state.attempt.stars;
    final rec = _progress.levelWon(lv.number, stars);
    final clear = rec.firstClear ? Economy.clearCoins(lv.tag) : 0;
    final bonus = rec.firstThreeStar ? Economy.threeStarBonus : 0;
    _wallet.earn(clear + bonus);
    // Baskets come with the first clear only, so a replay can't pay twice.
    final basket = rec.firstClear ? Rewards.basketFor(lv.number) : null;
    if (basket != null) {
      _wallet.earn(basket.coins);
      basket.boosters.forEach(_wallet.grantBooster);
      onTrack?.call(basket.isChest ? 'chest_open' : 'gift_open', {
        'level': lv.number,
        'coins': basket.coins,
      });
    }
    onTrack?.call('level_win', {
      'level': lv.number,
      'stars': stars,
      'moves': state.attempt.moves,
      'hearts_lost': state.attempt.heartsLost,
    });
    if (clear + bonus > 0) {
      onTrack?.call('coins_earn', {'source': 'level_clear', 'amount': clear + bonus});
    }
    emit(
      state.copyWith(
        status: GameStatus.won,
        hintSnakeId: () => null,
        hintObstacleId: () => null,
        result: () => LevelCompleteData(
          level: lv.number,
          stars: stars,
          clearCoins: clear,
          starBonus: bonus,
          canDouble: clear > 0,
          doubled: false,
          hasNext: _hasNext,
          gift: basket == null
              ? null
              : GiftBasketData(
                  level: basket.level,
                  coins: basket.coins,
                  boosters: basket.boosters,
                  isChest: basket.isChest,
                ),
          rushNext: rec.firstClear && Rewards.rushAfter(lv.number),
        ),
      ),
    );
  }

  // ---- Magic Stone Hammer
  void _hammerObstacle(int id, Cell? at, Emitter<GameState> emit) {
    final a = state.attempt;
    if (!a.canHammerObstacle(id, cell: at)) {
      emit(state.copyWith(cue: GameCue.hammerBlocked));
      return;
    }
    // Paid when it lands, so cancelling target mode is free.
    _wallet.consumeBooster(Booster.hammer);
    onTrack?.call('booster_use', {'booster': 'hammer', 'level': state.level.number});
    emit(
      state.copyWith(
        attempt: a.hammerObstacle(id, cell: at),
        status: GameStatus.playing,
        cue: GameCue.hammerHit,
        hintSnakeId: () => null,
        hintObstacleId: () => null,
      ),
    );
    _settle(emit);
  }

  void _hammerSnake(int snakeId, Emitter<GameState> emit) {
    final a = state.attempt;
    if (!a.board.snakes.containsKey(snakeId)) return;
    if (!a.canHammerSnake(snakeId)) {
      emit(state.copyWith(cue: GameCue.hammerBlocked));
      return;
    }
    _wallet.consumeBooster(Booster.hammer);
    onTrack?.call('booster_use', {'booster': 'hammer', 'level': state.level.number});
    emit(
      state.copyWith(
        attempt: a.hammerSnake(snakeId),
        status: GameStatus.playing,
        cue: GameCue.hammerHit,
        hintSnakeId: () => null,
        hintObstacleId: () => null,
      ),
    );
    _settle(emit);
  }

  // ---- preview
  void _onPreviewStarted(PreviewStarted e, Emitter<GameState> emit) {
    if (state.status != GameStatus.playing) return;
    final s = state.attempt.board.snakes[e.snakeId];
    if (s == null) return;
    emit(
      state.copyWith(
        preview: () => PreviewData(snakeId: s.id, lane: state.attempt.preview(s.id, at: e.at)),
        litSnakeId: () => s.id,
      ),
    );
  }

  // ---- boosters
  void _onBoosterPressed(BoosterPressed e, Emitter<GameState> emit) {
    final b = e.booster;
    if (b == Booster.hammer && state.status == GameStatus.hammerTarget) {
      emit(state.copyWith(status: GameStatus.playing));
      return;
    }
    if (!state.acceptsBoosters || state.hintBusy) return;
    if (!Economy.isUnlocked(b, state.level.number)) return;
    if (state.attempt.capReached(b)) return;
    if (b == Booster.shield && state.attempt.shieldActive) return;
    if (_wallet.state.count(b) <= 0) {
      emit(state.copyWith(miniShopFor: () => b));
      return;
    }
    switch (b) {
      case Booster.hint:
        _startHint(emit);
      case Booster.shield:
        _wallet.consumeBooster(b);
        onTrack?.call('booster_use', {'booster': 'shield', 'level': state.level.number});
        emit(state.copyWith(attempt: state.attempt.useShield()));
      case Booster.hammer:
        // Charged when a target is picked, so cancelling is free.
        emit(state.copyWith(status: GameStatus.hammerTarget));
    }
  }

  void _startHint(Emitter<GameState> emit) {
    final a = state.attempt;
    final sol = state.level.solution;
    final seq = ++_hintSeq;
    // On the stored solution the answer is instant; otherwise search off the
    // UI isolate so a hard board never drops frames.
    final onPath = a.boosterUses[Booster.hammer] == null &&
        sol.length > a.history.length &&
        [for (var i = 0; i < a.history.length; i++) a.history[i] == sol[i]].every((x) => x);
    if (onPath || !useIsolateForHint) {
      add(_HintFound(a.nextHint(solution: sol), seq));
      return;
    }
    emit(state.copyWith(hintBusy: true));
    final play = a.play;
    final st = a.st;
    Isolate.run(() => Attempt.resume(play, st).nextHint())
        .then((t) => add(_HintFound(t, seq)))
        .catchError((Object _) => add(_HintFound(null, seq)));
  }

  /// Tests run the solver inline (no isolates in fake async).
  static bool useIsolateForHint = true;

  void _onHintFound(_HintFound e, Emitter<GameState> emit) {
    if (e.seq != _hintSeq) return;
    if (!state.acceptsBoosters) {
      emit(state.copyWith(hintBusy: false));
      return;
    }
    final t = e.target;
    if (t == null) {
      // No solution from here: tell the player, keep the Hint.
      onTrack?.call('hint_fail', {'level': state.level.number});
      emit(state.copyWith(hintBusy: false, cue: GameCue.hintNoSolution));
      return;
    }
    _wallet.consumeBooster(Booster.hint);
    onTrack?.call('booster_use', {'booster': 'hint', 'level': state.level.number});
    emit(
      state.copyWith(
        attempt: state.attempt.hintUsed(),
        hintBusy: false,
        hintSnakeId: () => t.snakeId,
        hintObstacleId: () => t.obstacleId,
      ),
    );
  }

  // ---- second chance
  Future<void> _onReviveAd(ReviveWithAd e, Emitter<GameState> emit) async {
    if (state.status != GameStatus.secondChance || state.adBusy) return;
    if (_progress.state.adReviveUsed.contains(state.level.number)) return;
    emit(state.copyWith(adBusy: true));
    final rewarded = await _ads.showRewarded('revive');
    if (!rewarded) {
      emit(state.copyWith(adBusy: false));
      return;
    }
    _progress.markAdRevive(state.level.number);
    onTrack?.call('revive', {'level': state.level.number, 'type': 'ad'});
    emit(
      state.copyWith(
        attempt: state.attempt.reviveWithAd(),
        status: GameStatus.playing,
        adBusy: false,
      ),
    );
  }

  void _onReviveCoins(ReviveWithCoins e, Emitter<GameState> emit) {
    if (state.status != GameStatus.secondChance || state.attempt.refillsLeft <= 0) return;
    if (!_wallet.spend(AttemptRules.refillCost)) {
      emit(state.copyWith(cue: GameCue.notEnoughCoins));
      return;
    }
    onTrack?.call('revive', {'level': state.level.number, 'type': 'coins'});
    onTrack?.call('coins_spend', {'sink': 'heart_refill', 'amount': AttemptRules.refillCost});
    emit(state.copyWith(attempt: state.attempt.refillHeart(), status: GameStatus.playing));
  }

  Future<void> _onDouble(DoubleCoinsRequested e, Emitter<GameState> emit) async {
    final r = state.result;
    if (state.status != GameStatus.won || r == null || !r.canDouble || state.adBusy) return;
    emit(state.copyWith(adBusy: true));
    final rewarded = await _ads.showRewarded('win_2x');
    if (rewarded) {
      _wallet.earn(r.clearCoins);
      onTrack?.call('coins_earn', {'source': 'win_2x', 'amount': r.clearCoins});
    }
    emit(
      state.copyWith(
        adBusy: false,
        result: () => rewarded ? r.copyWith(canDouble: false, doubled: true) : r,
      ),
    );
  }

  // ---- pause / restart
  void _onPaused(Paused e, Emitter<GameState> emit) {
    final s = state.status;
    if (s != GameStatus.playing && s != GameStatus.hammerTarget && s != GameStatus.animating) {
      return;
    }
    // An animating move is finished first so pause never leaves a half-move.
    if (s == GameStatus.animating) {
      emit(
        state.copyWith(
          attempt: state.pending!.attempt,
          motion: () => null,
          pending: () => null,
          queued: () => null,
          status: GameStatus.playing,
        ),
      );
      if (_settle(emit)) return;
    }
    emit(
      state.copyWith(status: GameStatus.paused, resumeTo: GameStatus.playing, preview: () => null),
    );
  }

  void _onRestarted(Restarted e, Emitter<GameState> emit) {
    // New attempt; the per-level ad revive flag deliberately survives restarts.
    _hintSeq++;
    emit(
      GameState(
        level: state.level,
        attempt: Attempt.forLevel(state.level),
        status: GameStatus.playing,
        cueSeq: state.cueSeq,
      ),
    );
    onTrack?.call('level_start', {'level': state.level.number, 'retry': 1});
  }
}

class _MiniShopClosed extends GameEvent {
  const _MiniShopClosed();
}
