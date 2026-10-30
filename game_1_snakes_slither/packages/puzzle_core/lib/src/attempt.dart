import 'engine.dart';
import 'model.dart';
import 'solver.dart';

enum Booster { hint, shield, hammer }

/// Shared rule numbers for one attempt. Must match the shared core standard.
class AttemptRules {
  const AttemptRules._();
  static const startHearts = 3;
  static const maxHearts = 3;
  static const shieldChargesPerUse = 2;
  static const refillCost = 120;
  static const maxRefillsPerAttempt = 2;
  static const boosterCap = {Booster.hint: 3, Booster.shield: 1, Booster.hammer: 2};
}

enum AttemptStatus { playing, outOfHearts, won }

/// What a single tap did to the attempt (for animation + feedback).
class TapOutcome {
  const TapOutcome({
    required this.move,
    required this.attempt,
    required this.heartLost,
    required this.shieldAbsorbed,
  });
  final MoveResult move;
  final Attempt attempt;
  final bool heartLost;
  final bool shieldAbsorbed;
}

/// One try at a level: hearts, Shield, moves, revives and booster use.
/// Immutable; every action returns a new Attempt.
class Attempt {
  const Attempt({
    required this.board,
    this.hearts = AttemptRules.startHearts,
    this.shieldCharges = 0,
    this.moves = 0,
    this.heartsLost = 0,
    this.adRevives = 0,
    this.refills = 0,
    this.boosterUses = const {},
  });

  factory Attempt.start(BoardState board) => Attempt(board: board);

  final BoardState board;
  final int hearts;
  final int shieldCharges;
  final int moves;
  final int heartsLost;
  final int adRevives;
  final int refills;
  final Map<Booster, int> boosterUses;

  AttemptStatus get status {
    if (board.isEmpty) return AttemptStatus.won;
    if (hearts <= 0) return AttemptStatus.outOfHearts;
    return AttemptStatus.playing;
  }

  bool get shieldActive => shieldCharges > 0;

  /// ★★★ = no heart lost; ★★ = one lost; ★ = 2+ lost or any revive/refill.
  /// Hearts saved by the Shield are not "lost".
  int get stars {
    if (adRevives > 0 || refills > 0 || heartsLost >= 2) return 1;
    return heartsLost == 1 ? 2 : 3;
  }

  int usesOf(Booster b) => boosterUses[b] ?? 0;
  bool capReached(Booster b) => usesOf(b) >= AttemptRules.boosterCap[b]!;
  int get refillsLeft => AttemptRules.maxRefillsPerAttempt - refills;

  Attempt copyWith({
    BoardState? board,
    int? hearts,
    int? shieldCharges,
    int? moves,
    int? heartsLost,
    int? adRevives,
    int? refills,
    Map<Booster, int>? boosterUses,
  }) => Attempt(
    board: board ?? this.board,
    hearts: hearts ?? this.hearts,
    shieldCharges: shieldCharges ?? this.shieldCharges,
    moves: moves ?? this.moves,
    heartsLost: heartsLost ?? this.heartsLost,
    adRevives: adRevives ?? this.adRevives,
    refills: refills ?? this.refills,
    boosterUses: boosterUses ?? this.boosterUses,
  );

  Attempt _used(Booster b) => copyWith(boosterUses: {...boosterUses, b: usesOf(b) + 1});

  void _requirePlaying() {
    if (status != AttemptStatus.playing) {
      throw StateError('Attempt is not in play ($status)');
    }
  }

  TapOutcome tapSnake(int snakeId) {
    _requirePlaying();
    final move = Engine.tapSnake(board, snakeId);
    if (!move.countsAsMove) {
      return TapOutcome(move: move, attempt: this, heartLost: false, shieldAbsorbed: false);
    }
    var next = copyWith(board: move.next, moves: moves + 1);
    var heartLost = false;
    var absorbed = false;
    if (move.causesHeartLoss) {
      if (next.shieldActive) {
        next = next.copyWith(shieldCharges: next.shieldCharges - 1);
        absorbed = true;
      } else {
        next = next.copyWith(hearts: next.hearts - 1, heartsLost: next.heartsLost + 1);
        heartLost = true;
      }
    }
    return TapOutcome(move: move, attempt: next, heartLost: heartLost, shieldAbsorbed: absorbed);
  }

  /// Next correct snake, or null when the board can't be solved from here.
  /// Returns the attempt with the Hint counted only when a target exists.
  (Attempt, int?) useHint() {
    _requirePlaying();
    if (capReached(Booster.hint)) throw StateError('Hint cap reached');
    final target = Solver.nextMove(board);
    return (target == null ? this : _used(Booster.hint), target);
  }

  Attempt useShield() {
    _requirePlaying();
    if (capReached(Booster.shield)) throw StateError('Shield cap reached');
    return _used(Booster.shield).copyWith(shieldCharges: AttemptRules.shieldChargesPerUse);
  }

  /// Removing a snake counts as its exit. Irreversible.
  Attempt hammerSnake(int snakeId) {
    _requirePlaying();
    if (capReached(Booster.hammer)) throw StateError('Hammer cap reached');
    if (!board.snakes.containsKey(snakeId)) throw ArgumentError('No snake $snakeId');
    return _used(Booster.hammer).copyWith(board: board.withoutSnake(snakeId));
  }

  Attempt hammerRock(int rockId) {
    _requirePlaying();
    if (capReached(Booster.hammer)) throw StateError('Hammer cap reached');
    if (!board.rocks.containsKey(rockId)) throw ArgumentError('No rock $rockId');
    return _used(Booster.hammer).copyWith(board: board.withoutRock(rockId));
  }

  Attempt reviveWithAd() {
    if (status != AttemptStatus.outOfHearts) throw StateError('Not out of hearts');
    return copyWith(hearts: hearts + 1, adRevives: adRevives + 1);
  }

  /// Caller is responsible for charging [AttemptRules.refillCost] coins.
  Attempt refillHeart() {
    if (status != AttemptStatus.outOfHearts) throw StateError('Not out of hearts');
    if (refillsLeft <= 0) throw StateError('No refills left this attempt');
    return copyWith(hearts: hearts + 1, refills: refills + 1);
  }
}
