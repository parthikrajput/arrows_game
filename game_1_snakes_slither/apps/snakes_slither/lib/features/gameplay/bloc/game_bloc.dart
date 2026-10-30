import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:puzzle_core/slither_engine.dart';

import '../../../core/logging/app_logger.dart';
import '../../../services/remote_config.dart';
import 'game_event.dart';
import 'game_state.dart';

export 'game_event.dart';
export 'game_state.dart';

/// Wallet and progress hooks the attempt needs, kept as functions so the bloc
/// stays testable without the app's cubits.
class GameDeps {
  const GameDeps({
    required this.consumeBooster,
    required this.adReviveUsed,
    this.config = const EconomyConfig(),
  });

  final bool Function(BoosterType type) consumeBooster;
  final bool Function(String reviveKey) adReviveUsed;
  final EconomyConfig config;
}

class _Pending {
  const _Pending({this.next, this.exitedId, this.heartLoss = false, this.countsMove = true});
  final BoardState? next;
  final String? exitedId;
  final bool heartLoss;
  final bool countsMove;
}

/// One attempt at one board. The engine resolves each Move up front; the view
/// animates it; [AnimationCompleted] commits it. Only one Move resolves at a
/// time and the last tap during an animation is queued.
class GameBloc extends Bloc<GameEvent, GameState> {
  GameBloc({required GameMode mode, required LevelDef def, required int hearts, required this.deps})
      : super(GameState(
          mode: mode,
          def: def,
          board: def.toBoard(),
          status: GameStatus.playing,
          hearts: hearts,
          maxHearts: hearts,
        )) {
    on<SnakeTapped>(_onTap);
    on<AnimationCompleted>(_onAnimDone);
    on<HintRequested>(_onHint);
    on<ShieldActivated>(_onShield);
    on<HammerModeToggled>(_onHammerToggle);
    on<ReviveGranted>(_onRevive);
    on<ReviveDeclined>((_, emit) => emit(state.copyWith(status: GameStatus.failed)));
    on<Restarted>(_onRestart);
  }

  final GameDeps deps;
  _Pending? _pending;
  String? _queuedTap;
  int _seq = 0;

  bool get canReviveWithAd => !deps.adReviveUsed(state.mode.reviveKey);
  int get refillsLeft => deps.config.heartRefillMaxPerAttempt - state.refillsUsed;
  bool get anyReviveLeft => canReviveWithAd || refillsLeft > 0;

  GameEffect _fx(EffectKind k, [BoosterType? b]) => GameEffect(++_seq, k, b);

  void _onTap(SnakeTapped e, Emitter<GameState> emit) {
    switch (state.status) {
      case GameStatus.animating:
        _queuedTap = e.snakeId; // queue of 1: last tap wins
      case GameStatus.hammerTarget:
        _hammer(e.snakeId, emit);
      case GameStatus.playing:
        _resolve(e.snakeId, emit);
      default:
        break;
    }
  }

  void _resolve(String snakeId, Emitter<GameState> emit) {
    final outcome = Engine.apply(state.board, snakeId);
    switch (outcome) {
      case null:
        return; // snake already gone (double tap)
      case ExitOutcome(:final cellsToEdge, :final next):
        _pending = _Pending(next: next, exitedId: snakeId);
        emit(state.copyWith(
          status: GameStatus.animating,
          moves: state.moves + 1,
          hintTarget: () => null,
          anim: AnimRequest(seq: ++_seq, kind: AnimKind.exit, snakeId: snakeId, cells: cellsToEdge),
        ));
      case BumpOutcome(:final cellsToBlocker, :final blockerCell):
        _pending = const _Pending(heartLoss: true);
        emit(state.copyWith(
          status: GameStatus.animating,
          moves: state.moves + 1,
          hintTarget: () => null,
          anim: AnimRequest(seq: ++_seq, kind: AnimKind.bump, snakeId: snakeId, cells: cellsToBlocker, blocker: blockerCell),
        ));
      case LockedOutcome():
        _pending = const _Pending(countsMove: false);
        emit(state.copyWith(
          status: GameStatus.animating,
          anim: AnimRequest(seq: ++_seq, kind: AnimKind.wobble, snakeId: snakeId),
        ));
    }
  }

  void _onAnimDone(AnimationCompleted e, Emitter<GameState> emit) {
    if (state.status != GameStatus.animating || e.seq != state.anim?.seq) return;
    final p = _pending ?? const _Pending(countsMove: false);
    _pending = null;
    var next = state.copyWith(status: GameStatus.playing);
    if (p.next != null) {
      next = next.copyWith(
        board: p.next,
        played: p.exitedId == null ? null : [...state.played, p.exitedId!],
        effect: _fx(EffectKind.slithered),
      );
    }
    if (p.heartLoss) {
      if (next.shieldCharges > 0) {
        next = next.copyWith(shieldCharges: next.shieldCharges - 1, effect: _fx(EffectKind.shieldAbsorbed));
      } else {
        next = next.copyWith(hearts: next.hearts - 1, heartsLost: next.heartsLost + 1, effect: _fx(EffectKind.heartLost));
      }
    }
    if (next.hearts < 0) {
      log.e('E-GAME-001', 'Hearts below zero, clamped');
      next = next.copyWith(hearts: 0);
    }
    // Win before hearts: the last snake out wins even on the last heart.
    if (Engine.isWon(next.board)) {
      _queuedTap = null;
      emit(next.copyWith(status: GameStatus.won, shieldCharges: 0));
      return;
    }
    if (next.hearts <= 0) {
      _queuedTap = null;
      emit(next.copyWith(status: anyReviveLeft ? GameStatus.secondChance : GameStatus.failed));
      return;
    }
    if (p.next != null && Solver.isSoftLocked(next.board)) {
      log.e('E-GAME-004', 'Soft-lock on ${state.def.id}');
      _queuedTap = null;
      emit(next.copyWith(status: GameStatus.stuck));
      return;
    }
    emit(next);
    final queued = _queuedTap;
    _queuedTap = null;
    if (queued != null) _resolve(queued, emit);
  }

  void _onHint(HintRequested e, Emitter<GameState> emit) {
    if (state.status != GameStatus.playing || state.hintTarget != null) return;
    if (state.usesOf(BoosterType.hint) >= deps.config.boosterCap(BoosterType.hint)) {
      emit(state.copyWith(effect: _fx(EffectKind.boosterCapReached, BoosterType.hint)));
      return;
    }
    final target = Solver.nextMove(state.board, solution: state.def.solution, played: state.played);
    if (target == null) {
      log.w('E-LVL-004', 'Hint found no move on ${state.def.id}');
      emit(state.copyWith(effect: _fx(EffectKind.hintFailed)));
      return;
    }
    if (!deps.consumeBooster(BoosterType.hint)) {
      emit(state.copyWith(effect: _fx(EffectKind.needBooster, BoosterType.hint)));
      return;
    }
    emit(state.copyWith(
      hintTarget: () => target,
      uses: {...state.uses, BoosterType.hint: state.usesOf(BoosterType.hint) + 1},
      effect: _fx(EffectKind.hintShown),
    ));
  }

  void _onShield(ShieldActivated e, Emitter<GameState> emit) {
    if (state.status != GameStatus.playing || state.shieldCharges > 0) return;
    if (state.usesOf(BoosterType.shield) >= deps.config.boosterCap(BoosterType.shield)) {
      emit(state.copyWith(effect: _fx(EffectKind.boosterCapReached, BoosterType.shield)));
      return;
    }
    if (!deps.consumeBooster(BoosterType.shield)) {
      emit(state.copyWith(effect: _fx(EffectKind.needBooster, BoosterType.shield)));
      return;
    }
    emit(state.copyWith(
      shieldCharges: 2,
      uses: {...state.uses, BoosterType.shield: 1},
      effect: _fx(EffectKind.shieldActivated),
    ));
  }

  void _onHammerToggle(HammerModeToggled e, Emitter<GameState> emit) {
    if (state.status == GameStatus.hammerTarget) {
      emit(state.copyWith(status: GameStatus.playing)); // cancel: nothing consumed
      return;
    }
    if (state.status != GameStatus.playing) return;
    if (state.usesOf(BoosterType.hammer) >= deps.config.boosterCap(BoosterType.hammer)) {
      emit(state.copyWith(effect: _fx(EffectKind.boosterCapReached, BoosterType.hammer)));
      return;
    }
    emit(state.copyWith(status: GameStatus.hammerTarget));
  }

  void _hammer(String snakeId, Emitter<GameState> emit) {
    if (state.board.snakeById(snakeId) == null) return;
    if (!deps.consumeBooster(BoosterType.hammer)) {
      emit(state.copyWith(status: GameStatus.playing, effect: _fx(EffectKind.needBooster, BoosterType.hammer)));
      return;
    }
    // Irreversible; counts as an exit but not as a Move.
    _pending = _Pending(next: Engine.hammer(state.board, snakeId), exitedId: snakeId, countsMove: false);
    emit(state.copyWith(
      status: GameStatus.animating,
      hintTarget: () => null,
      uses: {...state.uses, BoosterType.hammer: state.usesOf(BoosterType.hammer) + 1},
      anim: AnimRequest(seq: ++_seq, kind: AnimKind.smash, snakeId: snakeId),
    ));
  }

  void _onRevive(ReviveGranted e, Emitter<GameState> emit) {
    if (state.status != GameStatus.secondChance) return;
    emit(state.copyWith(
      status: GameStatus.playing,
      hearts: 1,
      usedRevive: true,
      refillsUsed: e.viaAd ? state.refillsUsed : state.refillsUsed + 1,
    ));
  }

  void _onRestart(Restarted e, Emitter<GameState> emit) {
    _pending = null;
    _queuedTap = null;
    // Shield charges lapse; the ad revive used for this level stays used.
    emit(GameState(
      mode: state.mode,
      def: state.def,
      board: state.def.toBoard(),
      status: GameStatus.playing,
      hearts: state.maxHearts,
      maxHearts: state.maxHearts,
      attempt: state.attempt + 1,
      anim: state.anim,
    ));
  }
}
