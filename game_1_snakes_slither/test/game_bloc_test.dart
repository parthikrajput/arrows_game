import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:puzzle_core/puzzle_core.dart';
import 'package:snakes_slither/contracts/view_models.dart' show MotionKind;
import 'package:snakes_slither/data/save_store.dart';
import 'package:snakes_slither/features/gameplay/game_bloc.dart';
import 'package:snakes_slither/services/ads_service.dart';
import 'package:snakes_slither/services/time_guard.dart';
import 'package:snakes_slither/state/ads_cubit.dart';
import 'package:snakes_slither/state/progress_cubit.dart';
import 'package:snakes_slither/state/wallet_cubit.dart';

import 'helpers.dart';

class InstantAds extends AdsService {
  InstantAds({this.reward = true});
  bool reward;
  int interstitials = 0;
  @override
  bool get rewardedReady => true;
  @override
  bool get interstitialReady => true;
  @override
  Future<bool> showRewarded(String placement) async => reward;
  @override
  Future<bool> showInterstitial() async {
    interstitials++;
    return true;
  }
}

late SaveStore store;
late WalletCubit wallet;
late ProgressCubit progress;

GameBloc start(int level, {AdsService? ads}) => GameBloc(
  level: testLevels().load(level),
  wallet: wallet,
  progress: progress,
  ads: AdsCubit(store, ads ?? InstantAds(), TimeGuard(store, SystemClock())),
  hasNextLevel: true,
);

/// Tap and let the "animation" finish, like the board canvas would.
Future<void> tap(GameBloc b, int snake) async {
  b.add(SnakeTapped(snake));
  await pumpEventQueue();
  final m = b.state.motion;
  if (m != null) {
    b.add(AnimationCompleted(m.id));
    await pumpEventQueue();
  }
}

/// Level 2: snake 0 (red p1) is blocked by snake 1 (blue p2) until it leaves.
Future<void> bump(GameBloc b) => tap(b, 0);

/// A snake whose tap is a bump right now (lane blocked, not locked).
int blockedSnake(GameBloc b) {
  final a = b.state.attempt;
  return a.board.snakes.keys.firstWhere(
    (s) => a.play.sim.tapSnake(a.st, s).kind < 0 && a.play.sim.lockReason(a.st, s) == null,
  );
}

void main() {
  // Fresh save per test so progress never leaks between tests.
  setUpAll(() => GameBloc.useIsolateForHint = false);
  setUp(() async {
    store = await SaveStore.at(Directory.systemTemp.createTempSync('ss').path);
    wallet = WalletCubit(store);
    progress = ProgressCubit(store);
  });

  test('all 500 levels load and their solution wins under the game rules', () {
    final repo = testLevels();
    expect(repo.count, 500);
    for (var n = 1; n <= repo.count; n++) {
      final level = repo.load(n);
      var a = Attempt.forLevel(level);
      for (final id in level.solution) {
        final s = a.play.sim.snakeIndex(id);
        a = s >= 0 ? a.tapSnake(s).attempt : a.tapObstacle(a.play.sim.mechIndex(id)).attempt;
      }
      expect(a.status, AttemptStatus.won, reason: 'L$n');
    }
  });

  test('a move animates first, then commits; bump costs a heart', () async {
    final b = start(2);
    b.add(const SnakeTapped(0));
    await pumpEventQueue();
    expect(b.state.status, GameStatus.animating);
    expect(b.state.attempt.hearts, 3, reason: 'not committed until animation ends');
    b.add(AnimationCompleted(b.state.motion!.id));
    await pumpEventQueue();
    expect((b.state.attempt.hearts, b.state.attempt.moves), (2, 1));
  });

  test('input queue keeps only the latest tap during an animation', () async {
    final b = start(2);
    b.add(const SnakeTapped(1));
    b.add(const SnakeTapped(0)); // overwritten
    b.add(const SnakeTapped(2));
    await pumpEventQueue();
    expect(b.state.queued?.snakeId, 2);
    b.add(AnimationCompleted(b.state.motion!.id));
    await pumpEventQueue();
    expect(b.state.motion!.snake.id, 2);
  });

  test('win pays first-clear coins + ★★★ bonus once, saves progress', () async {
    final before = wallet.state.coins;
    var b = start(1);
    await tap(b, 0);
    await tap(b, 1);
    expect(b.state.status, GameStatus.won);
    expect(b.state.result!.stars, 3);
    expect(wallet.state.coins, before + 20 + 20);
    expect(progress.state.highestCleared, 1);

    b = start(1); // replay pays nothing
    await tap(b, 0);
    await tap(b, 1);
    expect(b.state.result!.clearCoins + b.state.result!.starBonus, 0);
    expect(b.state.result!.canDouble, isFalse);
  });

  test('2X doubles only the clear coins', () async {
    final b = start(2);
    for (final id in [1, 0, 2]) {
      await tap(b, id);
    }
    final coins = wallet.state.coins;
    b.add(const DoubleCoinsRequested());
    await pumpEventQueue();
    expect(wallet.state.coins, coins + 20);
    expect(b.state.result!.doubled, isTrue);
  });

  test('out of hearts → Second Chance; refill 120; decline → failed', () async {
    wallet.earn(500);
    final b = start(2);
    for (var i = 0; i < 3; i++) {
      await bump(b);
    }
    expect(b.state.status, GameStatus.secondChance);
    final coins = wallet.state.coins;
    b.add(const ReviveWithCoins());
    await pumpEventQueue();
    expect(wallet.state.coins, coins - 120);
    expect((b.state.status, b.state.attempt.hearts), (GameStatus.playing, 1));
    await bump(b);
    b.add(const ReviveDeclined());
    await pumpEventQueue();
    expect(b.state.status, GameStatus.failed);
  });

  test('ad revive is once per level and survives restart', () async {
    final b = start(2);
    for (var i = 0; i < 3; i++) {
      await bump(b);
    }
    b.add(const ReviveWithAd());
    await pumpEventQueue();
    expect(b.state.attempt.hearts, 1);
    expect(progress.state.adReviveUsed, contains(2));
    b.add(const Restarted());
    await pumpEventQueue();
    for (var i = 0; i < 3; i++) {
      await bump(b);
    }
    b.add(const ReviveWithAd());
    await pumpEventQueue();
    expect(b.state.status, GameStatus.secondChance, reason: 'ad already used');
  });

  test('no coins and no ad left → straight to failed', () async {
    final b = start(2);
    b.add(const ReviveWithAd()); // ignored, not in second chance
    for (var i = 0; i < 3; i++) {
      await bump(b);
    }
    b.add(const ReviveWithAd());
    await pumpEventQueue();
    for (final _ in [1, 2]) {
      await bump(b);
      wallet.earn(120);
      b.add(const ReviveWithCoins());
      await pumpEventQueue();
    }
    await bump(b);
    expect(b.state.status, GameStatus.failed);
  });

  test('Hint uses inventory and marks a correct snake', () async {
    final b = start(4); // the L3 tutorial grant arrives here
    wallet.grantBooster(Booster.hint, 1 - wallet.state.count(Booster.hint));
    b.add(const BoosterPressed(Booster.hint));
    await pumpEventQueue();
    expect(wallet.state.count(Booster.hint), 0);
    expect(b.state.hintSnakeId, isNotNull);
    expect(b.state.attempt.tapSnake(b.state.hintSnakeId!).move.kind, MoveKind.exit);
    b.add(const BoosterPressed(Booster.hint)); // none left → mini shop
    await pumpEventQueue();
    expect(b.state.miniShopFor, Booster.hint);
  });

  test('Hint is locked before L3', () async {
    wallet.grantBooster(Booster.hint, 1);
    final b = start(2);
    b.add(const BoosterPressed(Booster.hint));
    await pumpEventQueue();
    expect(b.state.hintSnakeId, isNull);
    expect(wallet.state.count(Booster.hint), 1);
  });

  test('Hammer is charged only when it lands; cancelling is free', () async {
    final b = start(26);
    wallet.grantBooster(Booster.hammer, 1 - wallet.state.count(Booster.hammer));
    b.add(const BoosterPressed(Booster.hammer));
    await pumpEventQueue();
    expect(b.state.status, GameStatus.hammerTarget);
    b.add(const HammerCancelled());
    await pumpEventQueue();
    expect(wallet.state.count(Booster.hammer), 1);
    b.add(const BoosterPressed(Booster.hammer));
    final target = b.state.attempt.board.snakes.keys.first;
    b.add(SnakeTapped(target));
    await pumpEventQueue();
    expect(wallet.state.count(Booster.hammer), 0);
    expect(b.state.attempt.board.snakes.containsKey(target), isFalse);
    expect(b.state.attempt.moves, 0);
  });

  test('Hammer smashes a Fallen Log but never the Grumpy Mongoose', () async {
    final b = start(26);
    wallet.grantBooster(Booster.hammer, 2);
    final log = b.state.attempt.board.obstacles.firstWhere((o) => o.type == 'M002');
    b.add(const BoosterPressed(Booster.hammer));
    b.add(ObstacleTapped(log.id, at: log.cells.first));
    await pumpEventQueue();
    expect(b.state.attempt.board.obstacles.where((o) => o.id == log.id), isEmpty);

    final boss = start(491);
    final m = boss.state.attempt.board.obstacles.firstWhere((o) => o.type == 'M049');
    final before = wallet.state.count(Booster.hammer);
    boss.add(const BoosterPressed(Booster.hammer));
    boss.add(ObstacleTapped(m.id, at: m.cells.first));
    await pumpEventQueue();
    expect(boss.state.status, GameStatus.hammerTarget, reason: 'still choosing a target');
    expect(wallet.state.count(Booster.hammer), before);
  });

  test('Shield absorbs two bumps', () async {
    final b = start(21);
    wallet.grantBooster(Booster.shield, 1);
    b.add(const BoosterPressed(Booster.shield));
    await pumpEventQueue();
    final s = blockedSnake(b);
    await tap(b, s);
    await tap(b, s);
    expect(b.state.attempt.hearts, 3);
    await tap(b, s);
    expect(b.state.attempt.hearts, 2);
  });

  test('a lever tap is a Move and animates as an action', () async {
    final b = start(91);
    final lever = b.state.attempt.board.obstacles.firstWhere((o) => o.type == 'M009');
    b.add(ObstacleTapped(lever.id));
    await pumpEventQueue();
    expect(b.state.motion?.kind, MotionKind.action);
    b.add(AnimationCompleted(b.state.motion!.id));
    await pumpEventQueue();
    expect(b.state.attempt.moves, 1);
    expect(b.state.attempt.hearts, 3);
  });

  test('a frozen snake gives a locked tap with its reason', () async {
    final b = start(31);
    final frozen = b.state.attempt.board.snakes.values.firstWhere((s) => s.marks.frozen > 0);
    b.add(SnakeTapped(frozen.id));
    await pumpEventQueue();
    expect(b.state.motion?.kind, MotionKind.locked);
    expect(b.state.motion?.lockReason, 'M003');
  });

  test('Hint off the stored solution still finds a move', () async {
    final b = start(45);
    wallet.grantBooster(Booster.hint, 1);
    final a = b.state.attempt;
    final firstSol = a.play.sim.snakeIndex(b.state.level.solution.first);
    final other = a.board.snakes.keys.firstWhere(
      (s) => s != firstSol && a.play.sim.tapSnake(a.st, s).kind == 0,
    );
    await tap(b, other);
    b.add(const BoosterPressed(Booster.hint));
    await pumpEventQueue();
    expect(b.state.hintSnakeId != null || b.state.hintObstacleId != null, isTrue);
  });
}
