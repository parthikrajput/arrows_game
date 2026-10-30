import 'package:flutter_test/flutter_test.dart';
import 'package:puzzle_core/slither_engine.dart';
import 'package:snakes_slither/features/gameplay/bloc/game_bloc.dart';
import 'package:snakes_slither/services/remote_config.dart';

Snake _snake(String id, List<List<int>> body, Dir dir) =>
    Snake(id: id, body: [for (final c in body) Cell(c[0], c[1])], dir: dir, color: SnakeColor.green);

/// a → blocked by b; b → free. Solution: b, a.
LevelDef _level() => LevelDef(
      id: 't',
      width: 5,
      height: 5,
      snakes: [
        _snake('a', [
          [1, 2],
          [0, 2],
        ], Dir.right),
        _snake('b', [
          [3, 2],
          [3, 3],
        ], Dir.up),
      ],
      solution: const ['b', 'a'],
    );

class _Wallet {
  final Map<BoosterType, int> inv = {for (final t in BoosterType.values) t: 5};
  bool consume(BoosterType t) {
    if ((inv[t] ?? 0) <= 0) return false;
    inv[t] = inv[t]! - 1;
    return true;
  }
}

GameBloc _bloc({_Wallet? wallet, Set<String>? adUsed, int hearts = 3}) {
  final w = wallet ?? _Wallet();
  final used = adUsed ?? <String>{};
  return GameBloc(
    mode: const GameMode.level(12),
    def: _level(),
    hearts: hearts,
    deps: GameDeps(consumeBooster: w.consume, adReviveUsed: used.contains),
  );
}

/// Taps, then completes the animation the bloc asked for.
Future<GameState> _move(GameBloc b, String id) async {
  b.add(SnakeTapped(id));
  await pumpEventQueue();
  final seq = b.state.anim!.seq;
  b.add(AnimationCompleted(seq));
  await pumpEventQueue();
  return b.state;
}

void main() {
  test('exit counts a move and removes the snake; hearts unchanged', () async {
    final b = _bloc();
    final s = await _move(b, 'b');
    expect(s.moves, 1);
    expect(s.hearts, 3);
    expect(s.board.snakeById('b'), isNull);
  });

  test('bump costs a heart, counts a move and leaves the board unchanged', () async {
    final b = _bloc();
    final s = await _move(b, 'a');
    expect(s.moves, 1);
    expect(s.hearts, 2);
    expect(s.heartsLost, 1);
    expect(s.board.snakes.length, 2);
  });

  test('taps during an animation queue only the last one', () async {
    final b = _bloc();
    b.add(const SnakeTapped('b'));
    await pumpEventQueue();
    b.add(const SnakeTapped('a'));
    b.add(const SnakeTapped('a'));
    await pumpEventQueue();
    expect(b.state.status, GameStatus.animating);
    b.add(AnimationCompleted(b.state.anim!.seq));
    await pumpEventQueue();
    // The queued tap on "a" started as soon as "b" was committed.
    expect(b.state.status, GameStatus.animating);
    expect(b.state.anim!.snakeId, 'a');
    b.add(AnimationCompleted(b.state.anim!.seq));
    await pumpEventQueue();
    expect(b.state.status, GameStatus.won);
    expect(b.state.moves, 2);
  });

  test('win gives stars by hearts lost', () async {
    final b = _bloc();
    await _move(b, 'a'); // bump
    await _move(b, 'b');
    final s = await _move(b, 'a');
    expect(s.status, GameStatus.won);
    expect(s.stars, 2);
  });

  test('shield absorbs two heart losses and keeps 3 stars', () async {
    final b = _bloc();
    b.add(const ShieldActivated());
    await pumpEventQueue();
    expect(b.state.shieldCharges, 2);
    await _move(b, 'a');
    await _move(b, 'a');
    expect(b.state.hearts, 3);
    var s = await _move(b, 'a');
    expect(s.hearts, 2);
    // Second shield in the same attempt is blocked by the cap.
    b.add(const ShieldActivated());
    await pumpEventQueue();
    expect(b.state.usesOf(BoosterType.shield), 1);
    await _move(b, 'b');
    s = await _move(b, 'a');
    expect(s.stars, 2);
  });

  test('hint follows the solution and is capped at 3 per attempt', () async {
    final w = _Wallet();
    final b = _bloc(wallet: w);
    b.add(const HintRequested());
    await pumpEventQueue();
    expect(b.state.hintTarget, 'b');
    expect(b.state.moves, 0);
    expect(w.inv[BoosterType.hint], 4);
    // Glow active ⇒ second tap ignored (no double spend).
    b.add(const HintRequested());
    await pumpEventQueue();
    expect(w.inv[BoosterType.hint], 4);
  });

  test('hammer removes a snake without a move and can win', () async {
    final w = _Wallet();
    final b = _bloc(wallet: w);
    b.add(const HammerModeToggled());
    await pumpEventQueue();
    expect(b.state.status, GameStatus.hammerTarget);
    final s1 = await _move(b, 'a');
    expect(s1.moves, 0);
    expect(s1.board.snakeById('a'), isNull);
    expect(w.inv[BoosterType.hammer], 4);
    final s2 = await _move(b, 'b');
    expect(s2.status, GameStatus.won);
  });

  test('cancelling hammer mode does not consume it', () async {
    final w = _Wallet();
    final b = _bloc(wallet: w);
    b.add(const HammerModeToggled());
    b.add(const HammerModeToggled());
    await pumpEventQueue();
    expect(b.state.status, GameStatus.playing);
    expect(w.inv[BoosterType.hammer], 5);
  });

  test('hearts 0 opens second chance; revive keeps the board and caps stars at 1', () async {
    final b = _bloc(hearts: 1);
    final s = await _move(b, 'a');
    expect(s.status, GameStatus.secondChance);
    b.add(const ReviveGranted(viaAd: false));
    await pumpEventQueue();
    expect(b.state.status, GameStatus.playing);
    expect(b.state.hearts, 1);
    expect(b.state.refillsUsed, 1);
    expect(b.state.board.snakes.length, 2);
    await _move(b, 'b');
    final won = await _move(b, 'a');
    expect(won.stars, 1);
  });

  test('no revive options left ⇒ straight to failed', () async {
    final b = _bloc(hearts: 1, adUsed: {'12'});
    // Two refills already used this attempt.
    await _move(b, 'a');
    b.add(const ReviveGranted(viaAd: false));
    await pumpEventQueue();
    await _move(b, 'a');
    b.add(const ReviveGranted(viaAd: false));
    await pumpEventQueue();
    final s = await _move(b, 'a');
    expect(s.status, GameStatus.failed);
  });

  test('restart resets hearts and board; shield lapses', () async {
    final b = _bloc();
    b.add(const ShieldActivated());
    await _move(b, 'b');
    b.add(const Restarted());
    await pumpEventQueue();
    expect(b.state.hearts, 3);
    expect(b.state.shieldCharges, 0);
    expect(b.state.board.snakes.length, 2);
    expect(b.state.moves, 0);
    expect(b.state.attempt, 2);
  });

  test('economy config matches the spec defaults', () {
    const c = EconomyConfig();
    expect(c.giftBooster(10), BoosterType.hint);
    expect(c.giftBooster(20), BoosterType.hammer);
    expect(c.giftBooster(30), BoosterType.shield);
    expect([c.giftCoins(10), c.giftCoins(110), c.giftCoins(210), c.giftCoins(310), c.giftCoins(410)], [150, 180, 210, 250, 300]);
    expect([25, 125, 225, 325, 425].map(c.rushSnakes), [20, 22, 25, 28, 30]);
    expect(spinPrizes.fold<int>(0, (a, p) => a + p.weight), 1000);
    expect([for (final r in streakLadder) r.coins], [50, 75, 100, 150, 150, 200, 450]);
  });
}
