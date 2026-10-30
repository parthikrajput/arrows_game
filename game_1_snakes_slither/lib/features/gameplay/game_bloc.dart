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
enum GameCue { exit, bump, locked, shieldCrack, hintNoSolution, hammerHit, notEnoughCoins }

// ---------------------------------------------------------------- events
sealed class GameEvent {
  const GameEvent();
}

class SnakeTapped extends GameEvent {
  const SnakeTapped(this.snakeId);
  final int snakeId;
}

class RockTapped extends GameEvent {
  const RockTapped(this.rockId);
  final int rockId;
}

class AnimationCompleted extends GameEvent {
  const AnimationCompleted(this.motionId);
  final int motionId;
}

class PreviewStarted extends GameEvent {
  const PreviewStarted(this.snakeId);
  final int snakeId;
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

// ----------------------------------------------------------------- state
class GameState extends Equatable {
  const GameState({
    required this.level,
    required this.attempt,
    required this.status,
    this.motion,
    this.pending,
    this.queuedSnake,
    this.hintSnakeId,
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
  final int? queuedSnake;
  final int? hintSnakeId;
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

  GameState copyWith({
    Attempt? attempt,
    GameStatus? status,
    Motion? Function()? motion,
    TapOutcome? Function()? pending,
    int? Function()? queuedSnake,
    int? Function()? hintSnakeId,
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
    queuedSnake: queuedSnake != null ? queuedSnake() : this.queuedSnake,
    hintSnakeId: hintSnakeId != null ? hintSnakeId() : this.hintSnakeId,
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
    attempt.board,
    attempt.hearts,
    attempt.shieldCharges,
    attempt.moves,
    attempt.boosterUses,
    attempt.refills,
    attempt.adRevives,
    status,
    motion,
    queuedSnake,
    hintSnakeId,
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
  }) : _hasNext = hasNextLevel,
       super(
         GameState(level: level, attempt: Attempt.start(level.board), status: GameStatus.playing),
       ) {
    _wallet.grantTutorialBoosters(level.number);
    on<SnakeTapped>(_onSnakeTapped);
    on<RockTapped>(_onRockTapped);
    on<AnimationCompleted>(_onAnimationCompleted);
    on<PreviewStarted>(_onPreviewStarted);
    on<PreviewEnded>((e, emit) => emit(state.copyWith(preview: () => null)));
    on<BoosterPressed>(_onBoosterPressed);
    on<HammerCancelled>((e, emit) {
      if (state.status == GameStatus.hammerTarget) emit(state.copyWith(status: GameStatus.playing));
    });
    on<ReviveWithAd>(_onReviveAd);
    on<ReviveWithCoins>(_onReviveCoins);
    on<ReviveDeclined>((e, emit) {
      if (state.status == GameStatus.secondChance) emit(state.copyWith(status: GameStatus.failed));
    });
    on<DoubleCoinsRequested>(_onDouble);
    on<Paused>(_onPaused);
    on<Resumed>((e, emit) {
      if (state.status == GameStatus.paused) emit(state.copyWith(status: state.resumeTo));
    });
    on<Restarted>(_onRestarted);
    on<_MiniShopClosed>((e, emit) => emit(state.copyWith(miniShopFor: () => null)));
  }

  final WalletCubit _wallet;
  final ProgressCubit _progress;
  final AdsCubit _ads;
  final bool _hasNext;
  int _motionSeq = 0;

  void closeMiniShop() => add(const _MiniShopClosed());

  // ---- taps
  void _onSnakeTapped(SnakeTapped e, Emitter<GameState> emit) {
    switch (state.status) {
      case GameStatus.animating:
        emit(state.copyWith(queuedSnake: () => e.snakeId));
      case GameStatus.hammerTarget:
        _hammerSnake(e.snakeId, emit);
      case GameStatus.playing:
        _play(e.snakeId, emit);
      default:
        break;
    }
  }

  void _play(int snakeId, Emitter<GameState> emit) {
    if (!state.attempt.board.snakes.containsKey(snakeId)) return;
    final out = state.attempt.tapSnake(snakeId);
    final kind = switch (out.move.kind) {
      MoveKind.exit => MotionKind.exit,
      MoveKind.bump => MotionKind.bump,
      MoveKind.locked => MotionKind.locked,
    };
    emit(
      state.copyWith(
        status: GameStatus.animating,
        motion: () => Motion(
          id: ++_motionSeq,
          kind: kind,
          snake: state.attempt.board.snakes[snakeId]!,
          lane: out.move.lane,
        ),
        pending: () => out,
        preview: () => null,
        // A hint stays until the player acts on the board.
        hintSnakeId: out.move.countsAsMove ? () => null : null,
        cue: out.shieldAbsorbed
            ? GameCue.shieldCrack
            : switch (kind) {
                MotionKind.exit => GameCue.exit,
                MotionKind.bump => GameCue.bump,
                MotionKind.locked => GameCue.locked,
              },
      ),
    );
  }

  void _onAnimationCompleted(AnimationCompleted e, Emitter<GameState> emit) {
    if (state.status != GameStatus.animating || state.motion?.id != e.motionId) return;
    final next = state.pending!.attempt;
    final queued = state.queuedSnake;
    emit(
      state.copyWith(
        attempt: next,
        status: GameStatus.playing,
        motion: () => null,
        pending: () => null,
        queuedSnake: () => null,
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
            queuedSnake: () => null,
            hintSnakeId: () => null,
          ),
        );
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
    }
    emit(
      state.copyWith(
        status: GameStatus.won,
        hintSnakeId: () => null,
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
        ),
      ),
    );
  }

  void _onRockTapped(RockTapped e, Emitter<GameState> emit) {
    if (state.status != GameStatus.hammerTarget) return;
    if (!state.attempt.board.rocks.containsKey(e.rockId)) return;
    final a = state.attempt.hammerRock(e.rockId);
    _wallet.consumeBooster(Booster.hammer);
    emit(
      state.copyWith(
        attempt: a,
        status: GameStatus.playing,
        cue: GameCue.hammerHit,
        hintSnakeId: () => null,
      ),
    );
  }

  void _hammerSnake(int snakeId, Emitter<GameState> emit) {
    if (!state.attempt.board.snakes.containsKey(snakeId)) return;
    final a = state.attempt.hammerSnake(snakeId);
    // Paid when it lands, so cancelling target mode is free.
    _wallet.consumeBooster(Booster.hammer);
    emit(
      state.copyWith(
        attempt: a,
        status: GameStatus.playing,
        cue: GameCue.hammerHit,
        hintSnakeId: () => null,
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
        preview: () => PreviewData(snakeId: s.id, lane: Engine.trace(state.attempt.board, s)),
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
    if (!state.acceptsBoosters) return;
    if (!Economy.isUnlocked(b, state.level.number)) return;
    if (state.attempt.capReached(b)) return;
    if (b == Booster.shield && state.attempt.shieldActive) return;
    if (_wallet.state.count(b) <= 0) {
      emit(state.copyWith(miniShopFor: () => b));
      return;
    }
    switch (b) {
      case Booster.hint:
        final (next, target) = state.attempt.useHint();
        if (target == null) {
          // No solution from here: tell the player, keep the Hint.
          emit(state.copyWith(cue: GameCue.hintNoSolution));
          return;
        }
        _wallet.consumeBooster(b);
        emit(state.copyWith(attempt: next, hintSnakeId: () => target));
      case Booster.shield:
        _wallet.consumeBooster(b);
        emit(state.copyWith(attempt: state.attempt.useShield()));
      case Booster.hammer:
        // Charged when a target is picked, so cancelling is free.
        emit(state.copyWith(status: GameStatus.hammerTarget));
    }
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
    emit(state.copyWith(attempt: state.attempt.refillHeart(), status: GameStatus.playing));
  }

  Future<void> _onDouble(DoubleCoinsRequested e, Emitter<GameState> emit) async {
    final r = state.result;
    if (state.status != GameStatus.won || r == null || !r.canDouble || state.adBusy) return;
    emit(state.copyWith(adBusy: true));
    final rewarded = await _ads.showRewarded('win_2x');
    if (rewarded) _wallet.earn(r.clearCoins);
    emit(
      state.copyWith(
        adBusy: false,
        result: () => rewarded
            ? LevelCompleteData(
                level: r.level,
                stars: r.stars,
                clearCoins: r.clearCoins,
                starBonus: r.starBonus,
                canDouble: false,
                doubled: true,
                hasNext: r.hasNext,
                gift: r.gift,
              )
            : r,
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
          queuedSnake: () => null,
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
    emit(
      GameState(
        level: state.level,
        attempt: Attempt.start(state.level.board),
        status: GameStatus.playing,
        cueSeq: state.cueSeq,
      ),
    );
  }
}

class _MiniShopClosed extends GameEvent {
  const _MiniShopClosed();
}
