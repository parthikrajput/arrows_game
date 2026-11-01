import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../contracts/view_models.dart';
import '../../services/store_service.dart';
import '../../state/ads_cubit.dart';
import '../../state/economy.dart';
import '../../state/iap_cubit.dart';
import '../../state/shop_cubit.dart';
import '../../state/wallet_cubit.dart';
import '../../ui/screens/shop_screen.dart';
import '../../ui/screens/vip_screen.dart';

String hms(Duration d) =>
    '${d.inHours}:${(d.inMinutes % 60).toString().padLeft(2, '0')}:${(d.inSeconds % 60).toString().padLeft(2, '0')}';

/// Starter Pack offer for the Shop and the one-time popup, or null.
StarterOfferData? starterOffer(IapCubit iap) {
  final left = iap.starterLeft();
  final price = iap.state.prices[StoreIds.starterPack];
  if (left == null || price == null) return null;
  return StarterOfferData(
    productId: StoreIds.starterPack,
    price: price,
    coins: StoreCatalog.starterCoins,
    boosters: StoreCatalog.starterBoosters,
    timeLeft: hms(left),
  );
}

class ShopRoute extends StatelessWidget {
  const ShopRoute({super.key});

  @override
  Widget build(BuildContext context) {
    final shop = context.watch<ShopCubit>();
    final wallet = context.watch<WalletCubit>().state;
    final ads = context.watch<AdsCubit>();
    final iap = context.watch<IapCubit>();
    final prices = iap.state.prices;
    return ShopScreen(
      data: ShopData(
        coins: wallet.coins,
        tiles: [
          for (final b in Booster.values)
            for (final pack in [false, true])
              ShopTileData(
                booster: b,
                quantity: pack ? 3 : 1,
                price: (pack ? Economy.packPrice : Economy.singlePrice)[b]!,
                locked: shop.isLocked(b),
                unlockLevel: Economy.unlockLevel[b]!,
                affordable: wallet.coins >= (pack ? Economy.packPrice : Economy.singlePrice)[b]!,
              ),
        ],
        freeCoinsLeft: shop.freeCoinsLeftToday,
        freeCoinsAmount: ShopCubit.freeCoinsAmount,
        adAvailable: ads.rewardedReady,
        busy: shop.state.busy,
        vipActive: ads.vipActive,
        storeAvailable: iap.state.available,
        coinPacks: [
          for (final (id, badge) in [
            (StoreIds.coinsS, null),
            (StoreIds.coinsM, 'Popular'),
            (StoreIds.coinsL, null),
            (StoreIds.coinsXl, 'Best Value'),
          ])
            if (prices[id] != null)
              CoinPackData(productId: id, coins: StoreCatalog.coins[id]!, price: prices[id]!, badge: badge),
        ],
        starter: starterOffer(iap),
        vipPrice: prices[StoreIds.vipMonthly],
        purchaseBusy: iap.state.busy,
        message: iap.state.message,
      ),
      onBuy: (t) {
        final r = shop.buyBooster(t.booster, pack: t.quantity == 3);
        final msg = switch (r) {
          BuyResult.ok => null,
          BuyResult.locked => 'Unlocks at L${t.unlockLevel}',
          BuyResult.notEnoughCoins => 'Not enough coins',
        };
        if (msg != null) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
        }
      },
      onFreeCoins: shop.watchForFreeCoins,
      onBuyProduct: iap.buy,
      onRestore: iap.restore,
      onOpenVip: () => context.push('/vip'),
      onBack: () => context.canPop() ? context.pop() : context.go('/'),
    );
  }
}

class VipRoute extends StatelessWidget {
  const VipRoute({super.key});

  @override
  Widget build(BuildContext context) {
    final iap = context.watch<IapCubit>();
    final ads = context.watch<AdsCubit>();
    return VipScreen(
      price: iap.state.prices[StoreIds.vipMonthly],
      active: ads.vipActive,
      busy: iap.state.busy != null,
      message: iap.state.message,
      onSubscribe: () => iap.buy(StoreIds.vipMonthly),
      onRestore: iap.restore,
      onBack: () => context.canPop() ? context.pop() : context.go('/shop'),
    );
  }
}
