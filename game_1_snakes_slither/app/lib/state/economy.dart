import 'package:flutter/foundation.dart';
import 'package:puzzle_core/puzzle_core.dart';

/// Economy numbers. Later these come from Remote Config with these defaults.
class Economy {
  const Economy._();

  static const startingCoins = 200;
  static const threeStarBonus = 20;

  static int clearCoins(LevelTag tag) => switch (tag) {
    LevelTag.easy => 15,
    LevelTag.normal => 20,
    LevelTag.hard => 30,
    LevelTag.finale => 50,
  };

  static const unlockLevel = {Booster.hint: 3, Booster.shield: 15, Booster.hammer: 25};

  /// Free grant given the first time the unlock level starts (booster tutorial).
  static const tutorialGrant = {Booster.hint: 3, Booster.shield: 1, Booster.hammer: 1};

  static const singlePrice = {Booster.hint: 60, Booster.shield: 80, Booster.hammer: 100};
  static const packPrice = {Booster.hint: 150, Booster.shield: 200, Booster.hammer: 250};

  /// Only test boards 1–5 exist right now, so Shield (L15) and Hammer (L25)
  /// could never be tried. Debug builds unlock everything for testing.
  static bool get unlockAllBoosters => kDebugMode;

  static bool isUnlocked(Booster b, int level) => unlockAllBoosters || level >= unlockLevel[b]!;
}
