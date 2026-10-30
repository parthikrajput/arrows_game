import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../contracts/view_models.dart';
import '../../state/ads_cubit.dart';
import '../../state/economy.dart';
import '../../state/shop_cubit.dart';
import '../../state/wallet_cubit.dart';
import '../../ui/screens/shop_screen.dart';

class ShopRoute extends StatelessWidget {
  const ShopRoute({super.key});

  @override
  Widget build(BuildContext context) {
    final shop = context.watch<ShopCubit>();
    final wallet = context.watch<WalletCubit>().state;
    final ads = context.watch<AdsCubit>();
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
        storeAvailable: false,
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
      onBack: () => context.canPop() ? context.pop() : context.go('/'),
    );
  }
}
