import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:puzzle_core/puzzle_core.dart';
import 'package:puzzle_core/slither_engine.dart' as se;

import '../../contracts/view_models.dart';
import '../../services/time_guard.dart';
import '../../state/wallet_cubit.dart';

enum RushPhase { intro, countdown, playing, done }

/// Numbers of the Golden Slither Rush bonus round.
class RushRules {
  const RushRules._();
  static const seconds = 30;
  static const coinsPerSnake = 10;
  static const fullClearBonus = 100;
  static const countdownSeconds = 3;

  /// Snakes per tier: T1 20, T2 22, T3 25, T4 28, T5 30.
  static int snakesFor(int level) => switch (level) {
    <= 100 => 20,
    <= 200 => 22,
    <= 300 => 25,
    <= 400 => 28,
    _ => 30,
  };

  /// Smallest square board that fits the snakes with room to slither.
  static int sizeFor(int snakes) => switch (snakes) {
    <= 20 => 8,
    <= 25 => 9,
    <= 28 => 10,
    _ => 11,
  };

  /// Golden boards only (no obstacles); solvable by construction, the same
  /// for everyone after the same level.
  static BoardState board(int level) {
    final n = snakesFor(level);
    final size = sizeFor(n);
    final params = se.GeneratorParams(
      width: size,
      height: size,
      snakeCount: n,
      maxLength: 3,
      tangle: .35,
      caterpillarRatio: 0,
      palette: const [se.SnakeColor.yellow],
    );
    // The generator may fall a snake short on a crowded board; the next
    // seed is tried, so the board stays the same for every player.
    var def = se.BoardGenerator.generate('rush_$level', params, level * 7919);
    for (var k = 1; k < 64 && def.snakes.length < n; k++) {
      def = se.BoardGenerator.generate('rush_$level', params, level * 7919 + k);
    }
    return BoardState(
      width: def.width,
      height: def.height,
      snakes: {
        for (var i = 0; i < def.snakes.length; i++)
          i: Snake(
            id: i,
            ref: def.snakes[i].id,
            body: [for (final c in def.snakes[i].body) Cell(c.x, c.y)],
            dir: Dir.parse(def.snakes[i].dir.name[0]),
            color: SnakeColor.yellow,
          ),
      },
      rocks: const {},
    );
  }
}

class RushState extends Equatable {
  const RushState({
    required this.level,
    required this.phase,
    required this.board,
    required this.total,
    this.cleared = 0,
    this.msLeft = RushRules.seconds * 1000,
    this.countdown = RushRules.countdownSeconds,
    this.motion,
    this.paid = 0,
    this.skipped = false,
  });
  final int level;
  final RushPhase phase;
  final BoardState board;
  final int total;
  final int cleared;
  final int msLeft;
  final int countdown;
  final Motion? motion;

  /// Coins put in the wallet when the round ended.
  final int paid;
  final bool skipped;

  int get coins => cleared * RushRules.coinsPerSnake;
  bool get fullClear => cleared == total;
  int get bonus => fullClear ? RushRules.fullClearBonus : 0;

  RushState copyWith({
    RushPhase? phase,
    BoardState? board,
    int? cleared,
    int? msLeft,
    int? countdown,
    Motion? Function()? motion,
    int? paid,
    bool? skipped,
  }) => RushState(
    level: level,
    phase: phase ?? this.phase,
    board: board ?? this.board,
    total: total,
    cleared: cleared ?? this.cleared,
    msLeft: msLeft ?? this.msLeft,
    countdown: countdown ?? this.countdown,
    motion: motion != null ? motion() : this.motion,
    paid: paid ?? this.paid,
    skipped: skipped ?? this.skipped,
  );

  @override
  List<Object?> get props => [level, phase, board, cleared, msLeft, countdown, motion, paid, skipped];
}

/// The only wall-clock round in the game: 30 s, golden snakes, no hearts.
/// A blocked tap is a soft wobble and costs nothing. The round is timed
/// from the clock, so a slow frame never adds time.
class RushCubit extends Cubit<RushState> {
  RushCubit({required int level, required this.wallet, required this.clock, this.onTrack})
    : super(_start(level));

  static RushState _start(int level) {
    final b = RushRules.board(level);
    return RushState(level: level, phase: RushPhase.intro, board: b, total: b.snakes.length);
  }

  final WalletCubit wallet;
  final Clock clock;
  final void Function(String name, Map<String, Object> params)? onTrack;
  DateTime? _countdownAt;
  DateTime? _startedAt;
  int _motionSeq = 0;

  /// "START" on the intro: 3-2-1, then the clock runs.
  void start() {
    if (state.phase != RushPhase.intro) return;
    _countdownAt = clock.now();
    emit(state.copyWith(phase: RushPhase.countdown, countdown: RushRules.countdownSeconds));
  }

  /// Called every frame or so by the screen.
  void tick() {
    final now = clock.now();
    switch (state.phase) {
      case RushPhase.countdown:
        final left = RushRules.countdownSeconds - now.difference(_countdownAt!).inMilliseconds ~/ 1000;
        if (left <= 0) {
          _startedAt = now;
          emit(state.copyWith(phase: RushPhase.playing, countdown: 0));
        } else if (left != state.countdown) {
          emit(state.copyWith(countdown: left));
        }
      case RushPhase.playing:
        final left = RushRules.seconds * 1000 - now.difference(_startedAt!).inMilliseconds;
        if (left <= 0) {
          _finish(msLeft: 0);
        } else {
          emit(state.copyWith(msLeft: left));
        }
      default:
        break;
    }
  }

  void tap(int snakeId) {
    if (state.phase != RushPhase.playing || state.motion != null) return;
    final s = state.board.snakes[snakeId];
    if (s == null) return;
    final m = Engine.tapSnake(state.board, snakeId);
    final exit = m.kind == MoveKind.exit;
    emit(
      state.copyWith(
        motion: () => Motion(
          id: ++_motionSeq,
          kind: exit ? MotionKind.exit : MotionKind.locked,
          snake: s,
          lane: m.lane,
        ),
        board: state.board,
        cleared: exit ? state.cleared + 1 : state.cleared,
      ),
    );
  }

  void motionDone(int id) {
    final m = state.motion;
    if (m == null || m.id != id) return;
    final board = m.kind == MotionKind.exit ? state.board.withoutSnake(m.snake.id) : state.board;
    emit(state.copyWith(board: board, motion: () => null));
    if (board.isEmpty && state.phase == RushPhase.playing) _finish(msLeft: state.msLeft);
  }

  /// "Skip" keeps the coins earned so far; on the intro it skips the round.
  void skip() {
    if (state.phase == RushPhase.done) return;
    _finish(msLeft: state.msLeft, skipped: true);
  }

  void _finish({required int msLeft, bool skipped = false}) {
    final pay = state.coins + (state.fullClear ? RushRules.fullClearBonus : 0);
    if (pay > 0) wallet.earn(pay);
    onTrack?.call('rush_end', {
      'level': state.level,
      'cleared': state.cleared,
      'total': state.total,
      'coins': pay,
      'skipped': skipped ? 1 : 0,
    });
    if (pay > 0) onTrack?.call('coins_earn', {'source': 'rush', 'amount': pay});
    emit(state.copyWith(phase: RushPhase.done, msLeft: msLeft, paid: pay, skipped: skipped, motion: () => null));
  }
}
