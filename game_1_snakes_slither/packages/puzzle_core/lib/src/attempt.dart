import 'engine.dart';
import 'full_rules/rules.dart' as fr;
import 'model.dart';
import 'play.dart';

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

  /// On-device Hint search budget.
  static const hintNodeLimit = 50000;
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

/// Where the Glow Firefly Hint points: a snake or an interactive obstacle.
class HintTarget {
  const HintTarget({this.snakeId, this.obstacleId});
  final int? snakeId;
  final int? obstacleId;
}

/// One try at a level under the full Phase 1 rules: hearts, Shield, moves,
/// revives and booster use. Immutable; every action returns a new Attempt.
class Attempt {
  Attempt._({
    required this.play,
    required this.st,
    this.hearts = AttemptRules.startHearts,
    this.shieldCharges = 0,
    this.heartsLost = 0,
    this.adRevives = 0,
    this.refills = 0,
    this.boosterUses = const {},
    this.history = const [],
  });

  factory Attempt.forLevel(Level level) {
    final p = PlayLevel.of(level);
    return Attempt._(play: p, st: p.initial());
  }

  /// Continues from an engine state (used to run the Hint solver elsewhere).
  factory Attempt.resume(PlayLevel play, fr.St st) => Attempt._(play: play, st: st);

  /// A board with only snakes and rocks.
  factory Attempt.start(BoardState board) {
    final p = PlayLevel.fromBoard(board);
    return Attempt._(play: p, st: p.initial());
  }

  final PlayLevel play;
  final fr.St st;
  final int hearts;
  final int shieldCharges;
  final int heartsLost;
  final int adRevives;
  final int refills;
  final Map<Booster, int> boosterUses;

  /// Action ids played so far (snake and obstacle ids from the level file).
  final List<String> history;

  late final BoardState board = play.view(st);

  int get moves => st.moves;

  AttemptStatus get status {
    if (play.sim.won(st)) return AttemptStatus.won;
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
    fr.St? st,
    int? hearts,
    int? shieldCharges,
    int? heartsLost,
    int? adRevives,
    int? refills,
    Map<Booster, int>? boosterUses,
    List<String>? history,
  }) => Attempt._(
    play: play,
    st: st ?? this.st,
    hearts: hearts ?? this.hearts,
    shieldCharges: shieldCharges ?? this.shieldCharges,
    heartsLost: heartsLost ?? this.heartsLost,
    adRevives: adRevives ?? this.adRevives,
    refills: refills ?? this.refills,
    boosterUses: boosterUses ?? this.boosterUses,
    history: history ?? this.history,
  );

  Attempt _used(Booster b) => copyWith(boosterUses: {...boosterUses, b: usesOf(b) + 1});

  void _requirePlaying() {
    if (status != AttemptStatus.playing) {
      throw StateError('Attempt is not in play ($status)');
    }
  }

  /// Applies [events] heart losses; the Shield absorbs first.
  (Attempt, bool lost, bool absorbed) _loseHearts(Attempt a, int events) {
    var next = a;
    var lost = false, absorbed = false;
    for (var i = 0; i < events && next.hearts > 0; i++) {
      if (next.shieldActive) {
        next = next.copyWith(shieldCharges: next.shieldCharges - 1);
        absorbed = true;
      } else {
        next = next.copyWith(hearts: next.hearts - 1, heartsLost: next.heartsLost + 1);
        lost = true;
      }
    }
    return (next, lost, absorbed);
  }

  /// Taps snake [snakeId]; [at] is the tapped cell (decides a Hydra's end).
  TapOutcome tapSnake(int snakeId, {Cell? at}) {
    _requirePlaying();
    if (snakeId < 0 || snakeId >= play.snakeCount() || st.status[snakeId] != 1) {
      throw ArgumentError('No snake $snakeId on the board');
    }
    final before = board.snakes[snakeId]!;
    final tail = play.hydraTail(st, snakeId, at);
    final o = play.sim.tapSnake(st, snakeId, tail: tail);
    final id = play.lv.snakes[snakeId].id;
    List<SnakeLane> parts(fr.St from) => [
      for (final e in o.traces.entries)
        if (board.snakes[e.key] != null)
          SnakeLane(board.snakes[e.key]!, play.lane(from, e.key, e.value, tail: tail && e.key == snakeId)),
    ]..sort((a, b) => a.snake.id == snakeId ? -1 : (b.snake.id == snakeId ? 1 : 0));
    if (o.kind < 0) {
      if (o.fail == fr.Fail.locked || o.fail == fr.Fail.notInteractive) {
        final lane = o.traces[snakeId] != null
            ? play.lane(st, snakeId, o.traces[snakeId]!, tail: tail)
            : const LaneTrace(cells: [], blocker: null);
        return TapOutcome(
          move: MoveResult(
            kind: MoveKind.locked,
            snakeId: snakeId,
            next: board,
            lane: lane,
            lockReason: play.sim.lockReason(st, snakeId) ?? _groupLock(snakeId),
          ),
          attempt: this,
          heartLost: false,
          shieldAbsorbed: false,
        );
      }
      // Blocked lane or a Hungry Caterpillar without food: a bump.
      final b = play.sim.bump(st);
      final ps = parts(st);
      final primary = ps.isEmpty ? const LaneTrace(cells: [], blocker: null) : ps.first.lane;
      final (a, lost, absorbed) = _loseHearts(
        copyWith(st: b.next, history: [...history, id]),
        1 + b.heartEvents,
      );
      return TapOutcome(
        move: MoveResult(
          kind: MoveKind.bump,
          snakeId: snakeId,
          next: a.board,
          lane: primary,
          parts: ps,
          heartEvents: 1 + b.heartEvents,
        ),
        attempt: a,
        heartLost: lost,
        shieldAbsorbed: absorbed,
      );
    }
    final ps = parts(st);
    final (a, lost, absorbed) = _loseHearts(copyWith(st: o.next, history: [...history, id]), o.heartEvents);
    final exit = o.kind == 0;
    return TapOutcome(
      move: MoveResult(
        kind: exit ? MoveKind.exit : MoveKind.action,
        snakeId: snakeId,
        next: a.board,
        lane: ps.isEmpty ? LaneTrace(cells: const [], blocker: null, exitDir: before.dir) : ps.first.lane,
        parts: exit ? ps : const [],
        heartEvents: o.heartEvents,
      ),
      attempt: a,
      heartLost: lost,
      shieldAbsorbed: absorbed,
    );
  }

  String? _groupLock(int s) {
    final g = play.sim.r.groupOf[s];
    if (g == null) return null;
    for (final p in play.lv.mechs[g].paths) {
      final r = play.sim.lockReason(st, p);
      if (r != null && r != 'gone') return r;
    }
    return play.lv.mechs[g].type;
  }

  /// Taps an interactive obstacle (lever, lilypad, switch, stump, gear).
  TapOutcome tapObstacle(int obstacleId) {
    _requirePlaying();
    final o = play.sim.tapMech(st, obstacleId);
    if (o.kind < 0) {
      return TapOutcome(
        move: MoveResult(
          kind: MoveKind.locked,
          snakeId: -1,
          obstacleId: obstacleId,
          next: board,
          lane: const LaneTrace(cells: [], blocker: null),
          lockReason: play.lv.mechs[obstacleId].type,
        ),
        attempt: this,
        heartLost: false,
        shieldAbsorbed: false,
      );
    }
    final (a, lost, absorbed) = _loseHearts(
      copyWith(st: o.next, history: [...history, play.lv.mechs[obstacleId].id]),
      o.heartEvents,
    );
    return TapOutcome(
      move: MoveResult(
        kind: MoveKind.action,
        snakeId: -1,
        obstacleId: obstacleId,
        next: a.board,
        lane: const LaneTrace(cells: [], blocker: null),
        heartEvents: o.heartEvents,
      ),
      attempt: a,
      heartLost: lost,
      shieldAbsorbed: absorbed,
    );
  }

  /// Tongue-Flick Preview lane. Free: changes nothing.
  LaneTrace preview(int snakeId, {Cell? at}) {
    final tail = play.hydraTail(st, snakeId, at);
    final t = play.sim.laneOf(st, snakeId, tail: tail);
    return play.lane(st, snakeId, t, tail: tail);
  }

  /// Next correct action from here, or null when the board can't be solved
  /// within the search budget. Uses the level's own solution while the
  /// player has followed it exactly.
  HintTarget? nextHint({List<String> solution = const []}) {
    String? next;
    if (solution.length > history.length &&
        boosterUses[Booster.hammer] == null &&
        _isPrefix(history, solution)) {
      next = solution[history.length];
    } else {
      final solver = fr.Solver(play.strict, nodeLimit: AttemptRules.hintNodeLimit);
      final path = solver.solve(from: st);
      if (path != null && path.isNotEmpty) next = path.first;
    }
    if (next == null) return null;
    final s = play.sim.snakeIndex(next);
    if (s >= 0) return HintTarget(snakeId: s);
    final m = play.sim.mechIndex(next);
    if (m >= 0) return HintTarget(obstacleId: m);
    return null;
  }

  static bool _isPrefix(List<String> a, List<String> b) {
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  /// Returns the attempt with the Hint counted only when a target exists.
  (Attempt, HintTarget?) useHint({List<String> solution = const []}) {
    _requirePlaying();
    if (capReached(Booster.hint)) throw StateError('Hint cap reached');
    final target = nextHint(solution: solution);
    return (target == null ? this : _used(Booster.hint), target);
  }

  /// Counts a Hint whose target was found elsewhere (e.g. on an isolate).
  Attempt hintUsed() => _used(Booster.hint);

  Attempt useShield() {
    _requirePlaying();
    if (capReached(Booster.shield)) throw StateError('Shield cap reached');
    return _used(Booster.shield).copyWith(shieldCharges: AttemptRules.shieldChargesPerUse);
  }

  bool canHammerSnake(int snakeId) =>
      snakeId >= 0 && snakeId < play.snakeCount() && play.sim.canHammerSnake(st, snakeId);

  bool canHammerObstacle(int obstacleId, {Cell? cell}) =>
      obstacleId >= 0 &&
      obstacleId < play.lv.mechs.length &&
      play.sim.canHammerMech(st, obstacleId, cell: cell == null ? -1 : play.lv.cell(cell.x, cell.y));

  /// Removing a snake counts as its exit. Irreversible.
  Attempt hammerSnake(int snakeId) {
    _requirePlaying();
    if (capReached(Booster.hammer)) throw StateError('Hammer cap reached');
    if (!canHammerSnake(snakeId)) throw ArgumentError('Snake $snakeId cannot be hammered');
    return _used(Booster.hammer).copyWith(st: play.sim.hammerSnake(st, snakeId).next);
  }

  /// Smashes a hammerable obstacle; [cell] picks one Creeping Vine cell.
  Attempt hammerObstacle(int obstacleId, {Cell? cell}) {
    _requirePlaying();
    if (capReached(Booster.hammer)) throw StateError('Hammer cap reached');
    // A vine is smashed cell by cell, so it needs the tapped cell.
    final m = play.lv.mechs[obstacleId];
    final c = cell ?? (m.type == 'M027' && st.mlist[obstacleId].isNotEmpty
        ? play.cellOf(st.mlist[obstacleId].first)
        : null);
    if (!canHammerObstacle(obstacleId, cell: c)) {
      throw ArgumentError('Obstacle $obstacleId cannot be hammered');
    }
    final at = c == null ? -1 : play.lv.cell(c.x, c.y);
    return _used(Booster.hammer).copyWith(st: play.sim.hammerMech(st, obstacleId, cell: at).next);
  }

  Attempt hammerRock(int rockId) => hammerObstacle(rockId);

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
