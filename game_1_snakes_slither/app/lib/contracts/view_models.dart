// SHARED CONTRACT between logic (Claude) and UI (Antigravity).
// Screens receive these plain, read-only objects plus callbacks, and never
// talk to blocs or services directly. Owner: Claude. UI side requests changes
// through handoff/CHANGE_REQUESTS.md instead of editing this file.
import 'package:equatable/equatable.dart';
import 'package:puzzle_core/puzzle_core.dart';

export 'package:puzzle_core/puzzle_core.dart'
    show Booster, BoardState, Cell, Dir, LaneTrace, Rock, Snake, SnakeColor, SnakeSkin;

class HomeData extends Equatable {
  const HomeData({required this.coins, required this.nextLevel, required this.allCleared});
  final int coins;
  final int nextLevel;

  /// Every available level is cleared (show "More levels soon").
  final bool allCleared;
  @override
  List<Object?> get props => [coins, nextLevel, allCleared];
}

enum NodeState { locked, current, cleared }

class LevelNodeData extends Equatable {
  const LevelNodeData({
    required this.number,
    required this.state,
    required this.stars,
    required this.isHard,
  });
  final int number;
  final NodeState state;

  /// Best stars 0..3 (0 when not cleared).
  final int stars;
  final bool isHard;
  @override
  List<Object?> get props => [number, state, stars, isHard];
}

class HudData extends Equatable {
  const HudData({
    required this.level,
    required this.isHard,
    required this.hearts,
    required this.maxHearts,
    required this.shieldCharges,
    required this.moves,
    required this.coins,
  });
  final int level;
  final bool isHard;
  final int hearts;
  final int maxHearts;

  /// > 0 means Shield is active; draw the shell overlay with this number.
  final int shieldCharges;
  final int moves;
  final int coins;
  @override
  List<Object?> get props => [level, isHard, hearts, maxHearts, shieldCharges, moves, coins];
}

class BoosterButtonData extends Equatable {
  const BoosterButtonData({
    required this.booster,
    required this.count,
    required this.locked,
    required this.unlockLevel,
    required this.used,
    required this.cap,
    required this.enabled,
    required this.active,
  });
  final Booster booster;

  /// Inventory. 0 => tapping opens the mini shop.
  final int count;
  final bool locked;
  final int unlockLevel;
  final int used;
  final int cap;

  /// False while a move animates or the cap is reached (show "used/cap").
  final bool enabled;

  /// Shield running, or Hammer target mode on.
  final bool active;

  bool get capReached => used >= cap;
  @override
  List<Object?> get props => [booster, count, locked, unlockLevel, used, cap, enabled, active];
}

enum MotionKind { exit, bump, locked }

/// One animation the board must play, then report back with [id].
class Motion extends Equatable {
  const Motion({required this.id, required this.kind, required this.snake, required this.lane});

  /// Unique per motion; pass back in onMotionDone.
  final int id;
  final MotionKind kind;

  /// The snake as it was before the move.
  final Snake snake;

  /// Exit: cells travelled before leaving the edge. Bump: cells before the
  /// blocker (0 => nudge 0.25 cell) and `lane.blocker` to flash.
  final LaneTrace lane;
  @override
  List<Object?> get props => [id, kind, snake.id];
}

class PreviewData extends Equatable {
  const PreviewData({required this.snakeId, required this.lane});
  final int snakeId;

  /// Draw dotted line along lane.cells; green if lane.isClear, else red with ✕ on lane.blocker.
  final LaneTrace lane;
  @override
  List<Object?> get props => [snakeId, lane.cells, lane.blocker];
}

class BoardViewData extends Equatable {
  const BoardViewData({
    required this.board,
    required this.motion,
    required this.hintSnakeId,
    required this.preview,
    required this.hammerMode,
    required this.colourBlind,
    required this.reducedMotion,
  });
  final BoardState board;
  final Motion? motion;

  /// Glow this snake (Glow Firefly Hint) until it changes to null.
  final int? hintSnakeId;
  final PreviewData? preview;
  final bool hammerMode;
  final bool colourBlind;
  final bool reducedMotion;
  @override
  List<Object?> get props => [
    board,
    motion,
    hintSnakeId,
    preview,
    hammerMode,
    colourBlind,
    reducedMotion,
  ];
}

class SecondChanceData extends Equatable {
  const SecondChanceData({
    required this.adAvailable,
    required this.adUsedForLevel,
    required this.refillsLeft,
    required this.refillCost,
    required this.coins,
  });
  final bool adAvailable;

  /// Show "Used for this level" on the ad button.
  final bool adUsedForLevel;
  final int refillsLeft;
  final int refillCost;
  final int coins;
  bool get canWatchAd => adAvailable && !adUsedForLevel;
  bool get canRefill => refillsLeft > 0;
  @override
  List<Object?> get props => [adAvailable, adUsedForLevel, refillsLeft, refillCost, coins];
}

class LevelCompleteData extends Equatable {
  const LevelCompleteData({
    required this.level,
    required this.stars,
    required this.clearCoins,
    required this.starBonus,
    required this.canDouble,
    required this.doubled,
    required this.hasNext,
  });
  final int level;
  final int stars;

  /// 0 on replay.
  final int clearCoins;

  /// +20 the first time this level reaches ★★★.
  final int starBonus;

  /// Show "Claim 2X" (first clear only, not yet claimed).
  final bool canDouble;
  final bool doubled;
  final bool hasNext;
  int get totalCoins => clearCoins * (doubled ? 2 : 1) + starBonus;
  @override
  List<Object?> get props => [level, stars, clearCoins, starBonus, canDouble, doubled, hasNext];
}

class MiniShopData extends Equatable {
  const MiniShopData({
    required this.booster,
    required this.singlePrice,
    required this.packPrice,
    required this.coins,
  });
  final Booster booster;
  final int singlePrice;

  /// Price of the 3-pack.
  final int packPrice;
  final int coins;
  @override
  List<Object?> get props => [booster, singlePrice, packPrice, coins];
}

class SettingsData extends Equatable {
  const SettingsData({
    required this.sound,
    required this.music,
    required this.haptics,
    required this.colourBlind,
    required this.reducedMotion,
  });
  final bool sound;
  final bool music;
  final bool haptics;
  final bool colourBlind;
  final bool reducedMotion;
  @override
  List<Object?> get props => [sound, music, haptics, colourBlind, reducedMotion];
}

enum SettingKey { sound, music, haptics, colourBlind, reducedMotion }
