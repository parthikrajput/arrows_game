import 'package:puzzle_core/puzzle_core.dart';

/// Jungle Gift Basket (every 10th level) and the L500 Jungle Treasure Chest.
class GiftBasket {
  const GiftBasket({required this.level, required this.coins, required this.boosters});
  final int level;
  final int coins;
  final Map<Booster, int> boosters;
  bool get isChest => level == Rewards.phaseFinale;
}

class Rewards {
  const Rewards._();
  static const phaseFinale = 500;

  /// Null for levels without a basket.
  static GiftBasket? basketFor(int level) {
    if (level == phaseFinale) {
      return const GiftBasket(
        level: phaseFinale,
        coins: 1000,
        boosters: {Booster.hint: 2, Booster.shield: 2, Booster.hammer: 2},
      );
    }
    if (level <= 0 || level % 10 != 0 || level > 490) return null;
    final coins = level <= 100
        ? 150
        : level <= 200
        ? 180
        : level <= 300
        ? 210
        : level <= 400
        ? 250
        : 300;
    // L10 Hint, L20 Hammer, L30 Shield, then repeat.
    final booster = switch ((level ~/ 10) % 3) {
      1 => Booster.hint,
      2 => Booster.hammer,
      _ => Booster.shield,
    };
    return GiftBasket(level: level, coins: coins, boosters: {booster: 1});
  }
}

/// One Lucky Lily Wheel segment. Exactly one of [coins] / [booster] is set.
class WheelPrize {
  const WheelPrize({required this.label, required this.weight, this.coins = 0, this.booster});
  final String label;

  /// Out of 1000 (per-mille), so 0.5% stays exact.
  final int weight;
  final int coins;
  final Booster? booster;
  double get odds => weight / 1000;
}

class LuckyWheel {
  const LuckyWheel._();

  /// Segment order on the wheel. Weights must total 1000.
  static const prizes = <WheelPrize>[
    WheelPrize(label: '20', weight: 300, coins: 20),
    WheelPrize(label: '50', weight: 250, coins: 50),
    WheelPrize(label: '100', weight: 150, coins: 100),
    WheelPrize(label: '75', weight: 120, coins: 75),
    WheelPrize(label: 'Hint', weight: 100, booster: Booster.hint),
    WheelPrize(label: 'Shield', weight: 50, booster: Booster.shield),
    WheelPrize(label: 'Hammer', weight: 25, booster: Booster.hammer),
    WheelPrize(label: '500', weight: 5, coins: 500),
  ];

  /// Decided before the wheel animates; the spin is only decoration.
  static int resultIndex({
    required String installId,
    required String dayKey,
    required int spinIndex,
  }) {
    final roll = Xoshiro128(stableHash([installId, dayKey, spinIndex])).nextInt(1000);
    var acc = 0;
    for (var i = 0; i < prizes.length; i++) {
      acc += prizes[i].weight;
      if (roll < acc) return i;
    }
    return 0;
  }
}
