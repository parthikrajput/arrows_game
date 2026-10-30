import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../app/routes.dart';
import '../../app/services.dart';
import '../../app/theme/text_styles.dart';
import '../../app/theme/tokens.dart';
import '../../core/widgets/bevel_button.dart';
import '../../core/widgets/common.dart';
import '../../core/widgets/game_icons.dart';
import '../../core/widgets/garden_background.dart';
import '../../core/widgets/popup.dart';
import '../../services/ads_service.dart';
import '../../services/audio_service.dart';
import '../../services/remote_config.dart';
import '../../services/store_service.dart';
import '../../state/ads_cubit.dart';
import '../../state/progress_cubit.dart';
import '../../state/shop_cubit.dart';
import '../../state/wallet_cubit.dart';
import 'starter_pack.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({super.key, this.initialTab = 0});
  final int initialTab;

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  @override
  void initState() {
    super.initState();
    context.read<ShopCubit>().loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: widget.initialTab.clamp(0, 2),
      child: Scaffold(
        body: GardenBackground(
          hillsAt: 0.9,
          child: SafeArea(
            child: Column(
              children: [
                const HubHeader(title: 'Shop'),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Space.gutter),
                  child: Container(
                    decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.75), borderRadius: BorderRadius.circular(Radii.pill)),
                    child: TabBar(
                      indicator: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(Radii.pill)),
                      indicatorSize: TabBarIndicatorSize.tab,
                      labelColor: Colors.white,
                      unselectedLabelColor: AppColors.textPrimary,
                      labelStyle: AppText.bodyBold,
                      dividerColor: Colors.transparent,
                      tabs: const [Tab(text: 'Boosters'), Tab(text: 'Coins'), Tab(text: 'Offers')],
                    ),
                  ),
                ),
                const Expanded(child: TabBarView(children: [_BoostersTab(), _CoinsTab(), _OffersTab()])),
                const _Footer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BoostersTab extends StatelessWidget {
  const _BoostersTab();

  @override
  Widget build(BuildContext context) {
    final s = context.read<AppServices>();
    final highest = context.select((ProgressCubit p) => p.state.highestCleared);
    final wallet = context.watch<WalletCubit>();
    final ads = context.watch<AdsCubit>();
    return ListView(
      padding: const EdgeInsets.all(Space.gutter),
      children: [
        GridView.count(
          crossAxisCount: MediaQuery.sizeOf(context).width > 560 ? 3 : 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: Space.md,
          crossAxisSpacing: Space.md,
          childAspectRatio: 0.92,
          children: [
            for (final t in BoosterType.values)
              for (final pack in const [false, true])
                _BoosterTile(
                  type: t,
                  count: pack ? 3 : 1,
                  price: s.config.boosterPrice(t, pack: pack),
                  owned: wallet.state.count(t),
                  // Booster unlock levels are reached when the level before is cleared.
                  lockedAt: highest + 1 < s.config.boosterUnlockLevel(t) ? s.config.boosterUnlockLevel(t) : null,
                ),
          ],
        ),
        const SizedBox(height: Space.lg),
        BevelButton(
          expand: true,
          logId: 'shop.free_coins',
          onPressed: (ads.shopAdsLeft > 0 && ads.rewardedAvailable)
              ? () async {
                  final ok = await ads.showRewarded(RewardedPlacement.shopCoins);
                  if (ok && context.mounted) {
                    context.read<WalletCubit>().earn('shop_ad', s.config.shopAdCoins);
                    s.audio.play(Sfx.coinsFly);
                  }
                }
              : null,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.movie_filter_rounded),
              const SizedBox(width: Space.sm),
              Flexible(
                child: Text(
                  !ads.rewardedAvailable
                      ? 'Ad unavailable'
                      : ads.shopAdsLeft > 0
                          ? 'Free +${s.config.shopAdCoins} coins  (${ads.shopAdsLeft} left today)'
                          : 'Free coins: come back tomorrow',
                  style: AppText.button.copyWith(color: (ads.shopAdsLeft > 0 && ads.rewardedAvailable) ? Colors.white : AppColors.textDisabled),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _BoosterTile extends StatelessWidget {
  const _BoosterTile({required this.type, required this.count, required this.price, required this.owned, this.lockedAt});
  final BoosterType type;
  final int count;
  final int price;
  final int owned;
  final int? lockedAt;

  Future<void> _buy(BuildContext context) async {
    final ok = await confirmPopup(
      context,
      title: 'Buy ${boosterShort(type)}?',
      message: '$count × ${boosterName(type)} for ${fmt(price)} coins',
      yes: 'Buy',
    );
    if (!ok || !context.mounted) return;
    final wallet = context.read<WalletCubit>();
    if (!wallet.canAfford(price)) {
      showToast(context, 'Not enough coins');
      DefaultTabController.of(context).animateTo(1);
      return;
    }
    if (wallet.buyBooster(type, count, price)) {
      context.read<AppServices>().audio.play(Sfx.coinsFly);
      showToast(context, '+$count ${boosterShort(type)}!');
    }
  }

  @override
  Widget build(BuildContext context) {
    final locked = lockedAt != null;
    return CreamCard(
      color: AppColors.surface,
      padding: const EdgeInsets.all(Space.md),
      child: Column(
        children: [
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Opacity(opacity: locked ? 0.4 : 1, child: BoosterIcon(type, size: 56)),
                if (count > 1) Positioned(right: 0, top: 0, child: Chip2('×$count', color: AppColors.coinGoldDark)),
                if (locked) const Icon(Icons.lock_rounded, color: AppColors.textSecondary, size: 32),
              ],
            ),
          ),
          Text(boosterShort(type), style: AppText.bodyBold),
          Text(locked ? 'Unlocks at L$lockedAt' : 'You have $owned', style: AppText.caption),
          const SizedBox(height: Space.sm),
          BevelButton(
            expand: true,
            height: 42,
            style: BevelStyle.gold,
            logId: 'shop.buy.${type.name}$count',
            onPressed: locked ? null : () => _buy(context),
            padding: const EdgeInsets.symmetric(horizontal: Space.sm),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [const CoinIcon(size: 20), const SizedBox(width: 4), Text(fmt(price), style: AppText.button.copyWith(color: const Color(0xFF4E3500)))],
            ),
          ),
        ],
      ),
    );
  }
}

class _CoinsTab extends StatelessWidget {
  const _CoinsTab();

  @override
  Widget build(BuildContext context) {
    final shop = context.watch<ShopCubit>().state;
    if (shop.load == StoreLoad.loading) return const Center(child: CircularProgressIndicator());
    if (shop.load == StoreLoad.unavailable) {
      return Center(child: Text('Store unavailable. Check your connection.', style: AppText.bodyBold));
    }
    final packs = shop.products.where((p) => p.sku.startsWith('coins_')).toList();
    return ListView.separated(
      padding: const EdgeInsets.all(Space.gutter),
      itemCount: packs.length,
      separatorBuilder: (_, _) => const SizedBox(height: Space.md),
      itemBuilder: (_, i) => _CoinPackTile(product: packs[i], index: i, busy: shop.busySku == packs[i].sku),
    );
  }
}

class _CoinPackTile extends StatelessWidget {
  const _CoinPackTile({required this.product, required this.index, required this.busy});
  final StoreProduct product;
  final int index;
  final bool busy;

  @override
  Widget build(BuildContext context) {
    return CreamCard(
      color: AppColors.surface,
      padding: const EdgeInsets.all(Space.md),
      child: Row(
        children: [
          SizedBox(
            width: 64,
            height: 48,
            child: Stack(
              children: [
                for (var i = 0; i <= index; i++) Positioned(left: i * 8.0, top: (index - i) * 4.0, child: const CoinIcon(size: 36)),
              ],
            ),
          ),
          const SizedBox(width: Space.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.title, style: AppText.h2),
                if (product.badge != null) Chip2(product.badge!, color: index == 3 ? AppColors.vipPurple : AppColors.danger),
              ],
            ),
          ),
          BevelButton(
            height: 46,
            logId: 'shop.iap.${product.sku}',
            onPressed: busy
                ? null
                : () async {
                    final status = await context.read<ShopCubit>().buy(product.sku);
                    if (!context.mounted) return;
                    if (status == PurchaseStatus.purchased) {
                      context.read<AppServices>().audio.play(Sfx.coinsFly);
                      showToast(context, '+${fmt(product.coins)} coins!');
                    } else if (status == PurchaseStatus.error) {
                      showToast(context, 'Purchase failed. You were not charged.');
                    }
                  },
            child: busy
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : Text(product.price, style: AppText.button),
          ),
        ],
      ),
    );
  }
}

class _OffersTab extends StatelessWidget {
  const _OffersTab();

  @override
  Widget build(BuildContext context) {
    final s = context.read<AppServices>();
    final shop = context.watch<ShopCubit>().state;
    final vip = context.select((AdsCubit a) => a.vipActive);
    final starter = shop.starterAvailable(s.time.now());
    return ListView(
      padding: const EdgeInsets.all(Space.gutter),
      children: [
        CreamCard(
          child: Column(
            children: [
              Row(
                children: [
                  const Icon(Icons.card_giftcard_rounded, color: AppColors.coinGoldDark, size: 32),
                  const SizedBox(width: Space.sm),
                  Expanded(child: Text('Starter Pack', style: AppText.h2)),
                  if (shop.starterPurchased) const Chip2('Owned', icon: Icons.check_rounded),
                ],
              ),
              const SizedBox(height: Space.md),
              const StarterPackContents(),
              const SizedBox(height: Space.md),
              if (starter)
                BevelButton.text('Get it for ${shop.product('starter_pack')?.price ?? ''}', expand: true, style: BevelStyle.gold, onPressed: () => buyStarter(context))
              else
                Text(
                  shop.starterPurchased ? 'Thanks for your support!' : 'Unlocks for 48 hours after you clear level 15.',
                  style: AppText.caption,
                  textAlign: TextAlign.center,
                ),
            ],
          ),
        ),
        const SizedBox(height: Space.md),
        CreamCard(
          color: const Color(0xFFF3EEFB),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.workspace_premium_rounded, color: AppColors.vipPurple, size: 32),
                  const SizedBox(width: Space.sm),
                  Expanded(child: Text('VIP No-Ads Pass', style: AppText.h2)),
                  if (vip) const Chip2('Active', color: AppColors.vipPurple),
                ],
              ),
              const SizedBox(height: Space.sm),
              Text('No interstitial or banner ads. Rewarded ads stay optional.', style: AppText.body),
              const SizedBox(height: Space.md),
              BevelButton.text(vip ? 'Manage' : 'See VIP', expand: true, style: BevelStyle.vip, onPressed: () => Navigator.of(context).pushNamed(Routes.vip)),
            ],
          ),
        ),
      ],
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Space.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
            onPressed: () async {
              showToast(context, 'Restoring purchases…');
              final ok = await context.read<ShopCubit>().restore();
              if (context.mounted) showToast(context, ok ? 'Purchases restored' : 'Nothing to restore');
            },
            child: const Text('Restore purchases'),
          ),
          Text('·', style: AppText.caption),
          TextButton(onPressed: () {}, child: const Text('Terms')),
        ],
      ),
    );
  }
}
