import 'package:flutter/material.dart';

import '../../app/theme/text_styles.dart';
import '../../app/theme/tokens.dart';
import '../../core/widgets/common.dart';
import '../../core/widgets/game_icons.dart';
import '../../core/widgets/garden_background.dart';
import '../../services/remote_config.dart';

/// Rules and tools reference. Mechanic cards are added here as each mechanic
/// unlocks once the level content ships.
class JungleGuidePage extends StatelessWidget {
  const JungleGuidePage({super.key});

  @override
  Widget build(BuildContext context) {
    final cards = <(Widget, String, String)>[
      (const Icon(Icons.touch_app_rounded, size: 36, color: AppColors.primary), 'Tap to slither', 'Tap any part of a snake. If the path in front of its head is clear, it slithers off the board.'),
      (const HeartBerryIcon(size: 36), 'Head bonk', 'If something is in the way, the snake bonks its head and slides back. You lose one heart berry. The board does not change.'),
      (const Icon(Icons.visibility_rounded, size: 36, color: AppColors.primary), 'Tongue-Flick Preview', 'Hold a snake to see its path. Green dots = clear, red ✕ = blocked. Free and never counts as a move.'),
      (const StarIcon(size: 36), 'Stars', '0 hearts lost = 3 stars, 1 lost = 2 stars, 2 or more (or any revive) = 1 star. Replays can only improve stars.'),
      (const BoosterIcon(BoosterType.hint, size: 36), 'Glow Firefly Hint', 'Shows the next safe snake. Up to 3 per try.'),
      (const BoosterIcon(BoosterType.shield, size: 36), 'Safety Shell Shield', 'Blocks the next 2 heart losses. 1 per try.'),
      (const BoosterIcon(BoosterType.hammer, size: 36), 'Magic Stone Hammer', 'Removes one snake of your choice. Up to 2 per try.'),
    ];
    return Scaffold(
      body: GardenBackground(
        hillsAt: 0.8,
        child: SafeArea(
          child: Column(
            children: [
              const HubHeader(title: 'Jungle Guide', showCoins: false),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(Space.gutter),
                  itemCount: cards.length,
                  separatorBuilder: (_, _) => const SizedBox(height: Space.md),
                  itemBuilder: (_, i) => CreamCard(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(width: 44, child: Center(child: cards[i].$1)),
                        const SizedBox(width: Space.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [Text(cards[i].$2, style: AppText.h2), Text(cards[i].$3, style: AppText.body)],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
