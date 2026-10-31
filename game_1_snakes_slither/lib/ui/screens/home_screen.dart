// OWNER: UI agent. Redesigned HomeScreen following UI canvas brand and Phase 1 doc 06 §5.3.
// Preserves constructor, contracts, and AppKeys.
import 'package:flutter/material.dart';

import '../../contracts/app_keys.dart';
import '../../contracts/view_models.dart';
import '../theme/tokens.dart';
import '../widgets/bevel_button.dart';
import '../widgets/coin_pill.dart';
import '../widgets/round_icon_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
    required this.data,
    required this.onPlay,
    required this.onOpenMap,
    required this.onOpenSettings,
    required this.onOpenShop,
    required this.onOpenWheel,
  });

  final HomeData data;
  final VoidCallback onPlay;
  final VoidCallback onOpenMap;
  final VoidCallback onOpenSettings;
  final VoidCallback onOpenShop;
  final VoidCallback onOpenWheel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: AppKeys.homeScreen,
      backgroundColor: AppColors.bgSage,
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar: Coins + Settings
            _buildTopBar(),

            // Main Content: Brand logo, Pip on platform, Big Play button
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Space.gutter),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: Space.md),

                      // Game Brand Logo
                      Image.asset(
                        'assets/images/snake_slither_logo.png',
                        height: 72,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) => Text(
                          'SNAKES SLITHER',
                          style: AppText.display.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                      const SizedBox(height: Space.lg),

                      // Pip Character on Platform
                      _buildPipPlatform(),
                      const SizedBox(height: Space.xl),

                      // Big Primary 3D Play Button
                      SizedBox(
                        width: double.infinity,
                        child: BevelButton.text(
                          data.allCleared ? 'More levels soon' : '▶  LEVEL ${data.nextLevel}',
                          key: AppKeys.homePlay,
                          onPressed: data.allCleared ? null : onPlay,
                          variant: BevelVariant.primary,
                          height: 64,
                        ),
                      ),
                      const SizedBox(height: Space.lg),
                    ],
                  ),
                ),
              ),
            ),

            // Bottom Navigation Bar
            _buildBottomBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Space.gutter, vertical: Space.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Coin Pill
          CoinPill(coins: data.coins),

          // Settings Button
          RoundIconButton(
            key: AppKeys.homeSettings,
            icon: Icons.settings_rounded,
            onPressed: onOpenSettings,
            size: 44,
            label: 'Settings',
            variant: RoundButtonVariant.cream,
          ),
        ],
      ),
    );
  }

  Widget _buildPipPlatform() {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Soft glowing circular aura
        Container(
          width: 240,
          height: 240,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                Color(0x33A8D94F),
                Color(0x00A8D94F),
              ],
            ),
          ),
        ),

        // Platform & Pip render
        Image.asset(
          'assets/images/home_platform.png',
          height: 210,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) => Container(
            width: 170,
            height: 170,
            decoration: BoxDecoration(
              color: AppColors.bgCream,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.creamEdge, width: 3),
              boxShadow: Shadows.elev1,
            ),
            child: const Center(
              child: Text('🐍🌿', style: TextStyle(fontSize: 54)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Space.gutter, vertical: Space.md),
      decoration: const BoxDecoration(
        color: AppColors.bgCream,
        borderRadius: BorderRadius.vertical(top: Radius.circular(Radii.lg)),
        border: Border(
          top: BorderSide(color: AppColors.creamEdge, width: 1.5),
        ),
        boxShadow: Shadows.elev1,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Map Button
          Expanded(
            child: BevelButton.text(
              '🗺 Map',
              key: AppKeys.homeMap,
              onPressed: onOpenMap,
              variant: BevelVariant.secondary,
              height: 48,
            ),
          ),
          const SizedBox(width: Space.md),

          // Shop Button
          Expanded(
            child: BevelButton.text(
              '🛒 Shop',
              key: AppKeys.homeShop,
              onPressed: onOpenShop,
              variant: BevelVariant.secondary,
              height: 48,
            ),
          ),

          // Lucky Lily Wheel Spin (when unlocked)
          if (data.wheelUnlocked) ...[
            const SizedBox(width: Space.md),
            Expanded(
              child: BevelButton.text(
                '🌸 Spin${data.freeSpinReady ? ' (1)' : ''}',
                key: AppKeys.homeWheel,
                onPressed: onOpenWheel,
                variant: BevelVariant.gold,
                height: 48,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
