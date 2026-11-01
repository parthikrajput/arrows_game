import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:puzzle_core/puzzle_core.dart';
import 'package:snakes_slither/contracts/view_models.dart' show MotionKind;
import 'package:snakes_slither/data/save_store.dart';
import 'package:snakes_slither/features/rush/rush_cubit.dart';
import 'package:snakes_slither/services/time_guard.dart';
import 'package:snakes_slither/state/rewards.dart';
import 'package:snakes_slither/state/wallet_cubit.dart';

class FakeClock implements Clock {
  DateTime t = DateTime(2026, 11, 1, 10);
  void advance(Duration d) => t = t.add(d);
  @override
  DateTime now() => t;
}

void main() {
  late WalletCubit wallet;
  late FakeClock clock;

  setUp(() async {
    final store = await SaveStore.at(Directory.systemTemp.createTempSync('rush').path);
    wallet = WalletCubit(store);
    clock = FakeClock();
  });

  RushCubit rush(int level) => RushCubit(level: level, wallet: wallet, clock: clock);

  /// Starts the round and lets the 3-2-1 run out.
  void play(RushCubit c) {
    c.start();
    clock.advance(const Duration(seconds: 3));
    c.tick();
    expect(c.state.phase, RushPhase.playing);
  }

  /// Taps exitable snakes until [n] are out (or none can move).
  void clear(RushCubit c, int n) {
    for (var i = 0; i < n; i++) {
      final ready = Engine.exitable(c.state.board);
      if (ready.isEmpty) return;
      c.tap(ready.first);
      c.motionDone(c.state.motion!.id);
    }
  }

  test('rush follows L25, L50 … L500 only', () {
    expect([for (var n = 1; n <= 500; n++) if (Rewards.rushAfter(n)) n].length, 20);
    expect(Rewards.rushAfter(25), isTrue);
    expect(Rewards.rushAfter(30), isFalse);
  });

  test('snake count per tier and every board is solvable', () {
    for (final (level, n) in [(25, 20), (125, 22), (225, 25), (325, 28), (425, 30), (500, 30)]) {
      final b = RushRules.board(level);
      expect(b.snakes.length, n, reason: 'L$level');
      expect(Solver.isSolvable(b), isTrue, reason: 'L$level');
      expect(b.snakes.values.every((s) => s.color == SnakeColor.yellow), isTrue);
      expect(b.rocks, isEmpty);
    }
  });

  test('3-2-1 countdown, then 30 s on the clock; time up pays 10 per snake', () {
    final c = rush(25);
    final before = wallet.state.coins;
    c.start();
    expect(c.state.countdown, 3);
    clock.advance(const Duration(milliseconds: 1100));
    c.tick();
    expect(c.state.countdown, 2);
    clock.advance(const Duration(milliseconds: 1900));
    c.tick();
    expect(c.state.phase, RushPhase.playing);
    clear(c, 5);
    clock.advance(const Duration(seconds: 30));
    c.tick();
    expect(c.state.phase, RushPhase.done);
    expect(wallet.state.coins, before + 50);
    expect(c.state.bonus, 0);
  });

  test('full clear pays +100 and ends the round at once', () {
    final c = rush(25);
    final before = wallet.state.coins;
    play(c);
    clear(c, 100);
    expect(c.state.phase, RushPhase.done);
    expect(c.state.cleared, 20);
    expect(wallet.state.coins, before + 200 + 100);
  });

  test('a blocked golden snake wobbles and costs nothing', () {
    final c = rush(25);
    play(c);
    final ready = Engine.exitable(c.state.board).toSet();
    final blocked = c.state.board.snakes.keys.firstWhere((s) => !ready.contains(s));
    c.tap(blocked);
    expect(c.state.motion!.kind, MotionKind.locked);
    c.motionDone(c.state.motion!.id);
    expect(c.state.cleared, 0);
    expect(c.state.board.snakes.length, 20);
  });

  test('skip keeps the coins earned so far', () {
    final c = rush(25);
    final before = wallet.state.coins;
    play(c);
    clear(c, 3);
    c.skip();
    expect(c.state.phase, RushPhase.done);
    expect(wallet.state.coins, before + 30);
  });
}
