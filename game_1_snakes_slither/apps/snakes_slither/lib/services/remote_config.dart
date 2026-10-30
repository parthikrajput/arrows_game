import 'package:puzzle_core/slither_engine.dart';

enum BoosterType { hint, shield, hammer }

/// Launch defaults of every economy number. Firebase Remote Config overrides
/// these when it is wired in; nothing else in the app hard-codes them.
class EconomyConfig {
  const EconomyConfig();

  static const String gameId = 'snakes_slither';

  final int startingCoins = 200;
  final int heartsPerAttempt = 3;
  final int heartRefillPrice = 120;
  final int heartRefillMaxPerAttempt = 2;
  final int firstThreeStarBonus = 20;
  final List<int> giftCoinsTiers = const [150, 180, 210, 250, 300];
  final int chestCoins = 1000;
  final int rushSeconds = 30;
  final int rushCoinsPerSnake = 10;
  final int rushFullClearBonus = 100;
  final List<int> rushSnakesByTier = const [20, 22, 25, 28, 30];
  final int dailyClearCoins = 100;
  final int shopAdCoins = 50;
  final int shopAdDailyMax = 5;
  final int interstitialEveryWins = 5;
  final int interstitialCooldownS = 120;
  final int interstitialDailyCap = 20;
  final int interstitialMinLevel = 11;
  final int streakSaverCoins = 200;
  final int starterWindowHours = 48;
  final int maxPhase = 1;
  final int phaseLastLevel = 500;
  final int spinUnlockLevel = 10;
  final int dailyUnlockLevel = 15;

  int clearCoins(LevelTag tag) => switch (tag) {
        LevelTag.easy => 15,
        LevelTag.normal => 20,
        LevelTag.hard => 30,
        LevelTag.finale => 50,
      };

  int boosterPrice(BoosterType t, {bool pack = false}) => switch (t) {
        BoosterType.hint => pack ? 150 : 60,
        BoosterType.shield => pack ? 200 : 80,
        BoosterType.hammer => pack ? 250 : 100,
      };

  int boosterCap(BoosterType t) => switch (t) {
        BoosterType.hint => 3,
        BoosterType.shield => 1,
        BoosterType.hammer => 2,
      };

  int boosterUnlockLevel(BoosterType t) => switch (t) {
        BoosterType.hint => 3,
        BoosterType.shield => 15,
        BoosterType.hammer => 25,
      };

  int tierOf(int level) {
    if (level <= 100) return 1;
    if (level <= 200) return 2;
    if (level <= 300) return 3;
    if (level <= 400) return 4;
    return 5;
  }

  int giftCoins(int level) => giftCoinsTiers[tierOf(level) - 1];

  /// L10 Hint, L20 Hammer, L30 Shield, then repeat.
  BoosterType giftBooster(int level) => switch ((level ~/ 10) % 3) {
        1 => BoosterType.hint,
        2 => BoosterType.hammer,
        _ => BoosterType.shield,
      };

  int rushSnakes(int level) => rushSnakesByTier[(tierOf(level) - 1).clamp(0, rushSnakesByTier.length - 1)];
}

/// One Lucky Lily Wheel segment.
class SpinPrize {
  const SpinPrize({required this.label, required this.weight, this.coins = 0, this.booster});
  final String label;

  /// Probability in tenths of a percent (sums to 1000).
  final int weight;
  final int coins;
  final BoosterType? booster;
}

const spinPrizes = <SpinPrize>[
  SpinPrize(label: '20', weight: 300, coins: 20),
  SpinPrize(label: '50', weight: 250, coins: 50),
  SpinPrize(label: '100', weight: 150, coins: 100),
  SpinPrize(label: '75', weight: 120, coins: 75),
  SpinPrize(label: 'Hint', weight: 100, booster: BoosterType.hint),
  SpinPrize(label: 'Shield', weight: 50, booster: BoosterType.shield),
  SpinPrize(label: 'Hammer', weight: 25, booster: BoosterType.hammer),
  SpinPrize(label: '500', weight: 5, coins: 500),
];

/// Streak ladder rewards, Day 1..7.
class StreakReward {
  const StreakReward(this.coins, [this.boosters = const []]);
  final int coins;
  final List<BoosterType> boosters;
}

const streakLadder = <StreakReward>[
  StreakReward(50),
  StreakReward(75),
  StreakReward(100, [BoosterType.hint]),
  StreakReward(150),
  StreakReward(150, [BoosterType.shield]),
  StreakReward(200, [BoosterType.hammer]),
  StreakReward(450, [BoosterType.hint, BoosterType.shield, BoosterType.hammer]),
];

const trophyTiers = ['None', 'Bronze', 'Silver', 'Gold', 'Platinum', 'Diamond'];
