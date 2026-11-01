import 'dart:convert';
import 'dart:io';

import 'package:puzzle_core/puzzle_core.dart';
import 'package:test/test.dart';

List<Map<String, dynamic>> _levels() {
  final f = File('../../assets/levels/phase_1.json');
  return ((jsonDecode(f.readAsStringSync()) as Map)['levels'] as List).cast<Map<String, dynamic>>();
}

/// Plays one solution step through the game-screen attempt.
Attempt _step(Attempt a, String id) {
  final s = a.play.sim.snakeIndex(id);
  if (s >= 0) {
    final out = a.tapSnake(s);
    expect(out.move.kind, anyOf(MoveKind.exit, MoveKind.action), reason: 'tap $id');
    return out.attempt;
  }
  final m = a.play.sim.mechIndex(id);
  final out = a.tapObstacle(m);
  expect(out.move.kind, MoveKind.action, reason: 'tap $id');
  return out.attempt;
}

Level _lv(List<Map<String, dynamic>> all, int n) => LevelCodec.decodePlay(all[n - 1]);

/// First level using [type].
Level _with(List<Map<String, dynamic>> all, String type) =>
    LevelCodec.decodePlay(all.firstWhere((l) => (l['mechanics'] as List).any((m) => m['type'] == type)));

void main() {
  final all = _levels();

  test('every level solution wins on the game screen with ★★★', () {
    for (final raw in all) {
      final level = LevelCodec.decodePlay(raw);
      var a = Attempt.forLevel(level);
      for (final id in level.solution) {
        a = _step(a, id);
      }
      expect(a.status, AttemptStatus.won, reason: 'L${level.number}');
      expect(a.stars, 3, reason: 'L${level.number}');
      expect(a.moves, level.solution.length, reason: 'L${level.number}');
    }
  });

  test('Hint follows the level solution while the player does', () {
    for (final n in [1, 21, 91, 131, 251, 341, 500]) {
      final level = _lv(all, n);
      var a = Attempt.forLevel(level);
      for (final id in level.solution) {
        final h = a.nextHint(solution: level.solution)!;
        final hid = h.snakeId != null
            ? a.play.lv.snakes[h.snakeId!].id
            : a.play.lv.mechs[h.obstacleId!].id;
        expect(hid, id, reason: 'L$n');
        a = _step(a, id);
      }
    }
  });

  test('Hint solves from a state off the solution', () {
    final level = _lv(all, 45);
    var a = Attempt.forLevel(level);
    // Tap a snake that is free but not first in the stored solution.
    final free = [
      for (final s in a.board.snakes.keys)
        if (a.play.sim.tapSnake(a.st, s).kind == 0) s,
    ];
    final firstSol = a.play.sim.snakeIndex(level.solution.first);
    final pick = free.firstWhere((s) => s != firstSol, orElse: () => free.first);
    a = a.tapSnake(pick).attempt;
    final h = a.nextHint(solution: level.solution);
    expect(h, isNotNull);
  });

  test('a bump is a Move, ticks counters and costs one heart', () {
    final level = _with(all, 'M007');
    var a = Attempt.forLevel(level);
    final gate = a.board.obstacles.firstWhere((o) => o.type == 'M007');
    final blocked = a.board.snakes.keys.firstWhere(
      (s) => a.play.sim.tapSnake(a.st, s).kind < 0 && a.play.sim.lockReason(a.st, s) == null,
    );
    final out = a.tapSnake(blocked);
    expect(out.move.kind, MoveKind.bump);
    expect(out.attempt.moves, 1);
    expect(out.attempt.hearts, 2);
    final after = out.attempt.board.obstacles.firstWhere((o) => o.id == gate.id);
    expect(after.value, gate.value - 1);
  });

  test('locked taps (Frost Coil) cost nothing', () {
    final level = _with(all, 'M003');
    final a = Attempt.forLevel(level);
    final frozen = a.board.snakes.values.firstWhere((s) => s.marks.frozen > 0);
    final out = a.tapSnake(frozen.id);
    expect(out.move.kind, MoveKind.locked);
    expect(out.move.lockReason, 'M003');
    expect(out.attempt.moves, 0);
    expect(out.attempt.hearts, 3);
  });

  test('Shield absorbs two heart losses and keeps ★★★', () {
    final level = _lv(all, 21);
    var a = Attempt.forLevel(level).useShield();
    final blocked = a.board.snakes.keys.firstWhere((s) => a.play.sim.tapSnake(a.st, s).kind < 0);
    a = a.tapSnake(blocked).attempt;
    a = a.tapSnake(blocked).attempt;
    expect(a.hearts, 3);
    expect(a.shieldCharges, 0);
    a = a.tapSnake(blocked).attempt;
    expect(a.hearts, 2);
  });

  test('Restless Caterpillar timeout costs a heart and resets', () {
    final level = _with(all, 'M017');
    var a = Attempt.forLevel(level);
    final cat = a.board.snakes.values.firstWhere((s) => s.marks.restless > 0);
    final n = cat.marks.restless;
    final lever = a.board.snakes.keys.firstWhere(
      (s) => s != cat.id && a.play.sim.tapSnake(a.st, s).kind < 0 && a.play.sim.lockReason(a.st, s) == null,
      orElse: () => -1,
    );
    if (lever < 0) return;
    var lostByTimer = 0;
    for (var i = 0; i < n && a.hearts > 0; i++) {
      final out = a.tapSnake(lever);
      if (out.move.heartEvents > 1) lostByTimer++;
      a = out.attempt;
    }
    expect(lostByTimer, greaterThanOrEqualTo(1));
  });

  test('Hammer: rock and log smash, guardian and hedge do not', () {
    final log = _with(all, 'M002');
    var a = Attempt.forLevel(log);
    final o = a.board.obstacles.firstWhere((o) => o.type == 'M002');
    expect(o.hammerable, isTrue);
    a = a.hammerObstacle(o.id);
    expect(a.board.obstacles.where((x) => x.id == o.id), isEmpty);
    expect(a.moves, 0);

    final boss = Attempt.forLevel(_with(all, 'M049'));
    final m = boss.board.obstacles.firstWhere((o) => o.type == 'M049');
    expect(boss.canHammerObstacle(m.id), isFalse);
    final hedge = Attempt.forLevel(_with(all, 'M029'));
    final h = hedge.board.obstacles.firstWhere((o) => o.type == 'M029');
    expect(hedge.canHammerObstacle(h.id), isFalse);
  });

  test('Hammered snake counts as an exit for keys but not for gems', () {
    final key = Attempt.forLevel(_with(all, 'M004'));
    final lock = key.board.obstacles.firstWhere((o) => o.type == 'M004');
    final keySnake = key.board.snakes[key.play.lv.mechs[lock.id].keyPath]!;
    final after = key.hammerSnake(keySnake.id);
    expect(after.board.obstacles.firstWhere((o) => o.id == lock.id).open, isTrue);

    final gems = Attempt.forLevel(_with(all, 'M026'));
    final left = gems.board.gemsLeft;
    final any = gems.board.snakes.keys.firstWhere(gems.canHammerSnake);
    expect(gems.hammerSnake(any).board.gemsLeft, left);
  });

  test('Jungle Mist hides snakes from the Hammer', () {
    final a = Attempt.forLevel(_with(all, 'M010'));
    final hidden = a.board.snakes.values.where((s) => s.marks.hidden);
    expect(hidden, isNotEmpty);
    for (final s in hidden) {
      expect(a.canHammerSnake(s.id), isFalse);
    }
  });

  test('exit lanes bend through a Mushroom Bumper', () {
    final level = _with(all, 'M014');
    var a = Attempt.forLevel(level);
    var bent = false;
    for (final id in level.solution) {
      final s = a.play.sim.snakeIndex(id);
      if (s >= 0) {
        final h = a.board.snakes[s]!.head;
        final lane = a.preview(s);
        if (lane.cells.any((c) => c.x != h.x && c.y != h.y)) bent = true;
      }
      a = _step(a, id);
    }
    expect(bent, isTrue);
  });

  test('view: board lists every on-board mechanic', () {
    final a = Attempt.forLevel(_lv(all, 500));
    expect(a.board.mongooseHp, greaterThan(0));
    expect(a.board.gemsLeft, 3);
    expect(a.board.snakes.length, greaterThanOrEqualTo(24));
  });
}
