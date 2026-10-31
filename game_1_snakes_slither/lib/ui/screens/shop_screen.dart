// OWNER: UI agent. Redesigned ShopScreen per Phase 1 doc 06 §5.11 & 04 §6.
// Keeps constructor, contracts, and AppKeys intact.
import 'package:flutter/material.dart';

import '../../contracts/app_keys.dart';
import '../../contracts/view_models.dart';
import '../theme/tokens.dart';
import '../widgets/bevel_button.dart';
import '../widgets/coin_pill.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({
    super.key,
    required this.data,
    required this.onBuy,
    required this.onFreeCoins,
    required this.onBack,
  });

  final ShopData data;
  final void Function(ShopTileData tile) onBuy;
  final VoidCallback onFreeCoins;
  final VoidCallback onBack;

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> with SingleTickerProviderStateMixin {
  late final TabController _tabController = TabController(length: 3, vsync: this);

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: AppKeys.shopScreen,
      backgroundColor: AppColors.bgSage,
      appBar: AppBar(
        backgroundColor: AppColors.bgSage,
        elevation: 0,
        leading: BackButton(
          onPressed: widget.onBack,
          color: AppColors.textPrimary,
        ),
        title: Text(
          'Jungle Shop',
          style: AppText.h1.copyWith(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: Space.gutter),
            child: CoinPill(coins: widget.data.coins),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          indicatorColor: AppColors.primary,
          indicatorWeight: 3,
          labelStyle: AppText.button.copyWith(fontSize: 15, fontWeight: FontWeight.w700),
          tabs: const [
            Tab(text: 'Boosters'),
            Tab(text: 'Coins'),
            Tab(text: 'Offers'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // 1. Boosters Tab
          _buildBoostersTab(),

          // 2. Coins Tab
          _buildStoreUnavailableTab('Coins'),

          // 3. Offers Tab
          _buildStoreUnavailableTab('Offers'),
        ],
      ),
    );
  }

  Widget _buildBoostersTab() {
    final d = widget.data;
    final canFreeCoins = d.freeCoinsLeft > 0 && d.adAvailable && !d.busy;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(Space.gutter),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Daily Free Coins Card
          _buildFreeCoinsTile(canFreeCoins),
          const SizedBox(height: Space.lg),

          // Boosters Grid Header
          Text(
            'Power-Up Boosters',
            style: AppText.h2.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: Space.md),

          // Boosters Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: d.tiles.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: Space.md,
              crossAxisSpacing: Space.md,
              childAspectRatio: 0.95,
            ),
            itemBuilder: (context, index) {
              final tile = d.tiles[index];
              return _ShopBoosterCard(
                tile: tile,
                onBuy: () => widget.onBuy(tile),
              );
            },
          ),
          const SizedBox(height: Space.xl),

          // Footer
          Center(
            child: Text(
              'Restore purchases · Terms & Privacy',
              style: AppText.caption.copyWith(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          const SizedBox(height: Space.md),
        ],
      ),
    );
  }

  Widget _buildFreeCoinsTile(bool enabled) {
    final d = widget.data;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.bgCream,
        borderRadius: BorderRadius.circular(Radii.md),
        border: Border.all(color: const Color(0xFFFFD54F), width: 2),
        boxShadow: Shadows.elev1,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          key: AppKeys.shopFreeCoins,
          borderRadius: BorderRadius.circular(Radii.md),
          onTap: enabled ? widget.onFreeCoins : null,
          child: Padding(
            padding: const EdgeInsets.all(Space.lg),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFFFF9C4),
                  ),
                  child: const Center(
                    child: Text('🎬', style: TextStyle(fontSize: 28)),
                  ),
                ),
                const SizedBox(width: Space.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Free +${d.freeCoinsAmount} Coins',
                        style: AppText.h2.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        d.freeCoinsLeft > 0
                            ? 'Watch a quick ad (${d.freeCoinsLeft} left today)'
                            : 'Come back tomorrow',
                        style: AppText.caption.copyWith(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                BevelButton.text(
                  'Claim',
                  onPressed: enabled ? widget.onFreeCoins : null,
                  variant: BevelVariant.gold,
                  height: 40,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStoreUnavailableTab(String tabName) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(Space.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🛍', style: TextStyle(fontSize: 54)),
            const SizedBox(height: Space.md),
            Text(
              '$tabName: Store unavailable',
              style: AppText.h2.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: Space.sm),
            Text(
              'In-app purchases will arrive in an upcoming jungle update.',
              style: AppText.body.copyWith(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _ShopBoosterCard extends StatelessWidget {
  const _ShopBoosterCard({
    required this.tile,
    required this.onBuy,
  });

  final ShopTileData tile;
  final VoidCallback onBuy;

  static const _emoji = {
    Booster.hint: '🪲✨',
    Booster.shield: '🐚',
    Booster.hammer: '🔨',
  };

  @override
  Widget build(BuildContext context) {
    final isLocked = tile.locked;
    final isAffordable = tile.affordable;
    final isEnabled = !isLocked && isAffordable;

    final emoji = _emoji[tile.booster] ?? '✨';

    return Container(
      key: AppKeys.shopTile(tile.booster.name, tile.quantity),
      decoration: BoxDecoration(
        color: AppColors.bgCream,
        borderRadius: BorderRadius.circular(Radii.md),
        border: Border.all(
          color: isEnabled ? AppColors.creamEdge : const Color(0xFFECEFF1),
          width: 2,
        ),
        boxShadow: isEnabled ? Shadows.elev1 : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(Radii.md),
          onTap: isEnabled ? onBuy : null,
          child: Padding(
            padding: const EdgeInsets.all(Space.md),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Booster icon with quantity tag
                Stack(
                  alignment: Alignment.topRight,
                  children: [
                    Text(
                      isLocked ? '🔒' : emoji,
                      style: const TextStyle(fontSize: 34),
                    ),
                    if (!isLocked)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(Radii.pill),
                        ),
                        child: Text(
                          '×${tile.quantity}',
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                  ],
                ),

                // Title
                Text(
                  '${tile.quantity} × ${tile.booster.name.toUpperCase()}',
                  style: AppText.button.copyWith(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: isLocked ? AppColors.textDisabled : AppColors.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

                // Price or Unlock badge
                if (isLocked)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFECEFF1),
                      borderRadius: BorderRadius.circular(Radii.pill),
                    ),
                    child: Text(
                      'Unlocks at L${tile.unlockLevel}',
                      style: AppText.caption.copyWith(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF78909C),
                      ),
                    ),
                  )
                else
                  BevelButton.text(
                    '${tile.price} 🪙',
                    onPressed: isAffordable ? onBuy : null,
                    variant: isAffordable ? BevelVariant.primary : BevelVariant.secondary,
                    height: 38,
                    expand: true,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
