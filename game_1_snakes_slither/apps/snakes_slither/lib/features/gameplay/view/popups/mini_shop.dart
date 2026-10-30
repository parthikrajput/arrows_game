import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/routes.dart';
import '../../../../app/services.dart';
import '../../../../app/theme/text_styles.dart';
import '../../../../app/theme/tokens.dart';
import '../../../../core/widgets/bevel_button.dart';
import '../../../../core/widgets/common.dart';
import '../../../../core/widgets/game_icons.dart';
import '../../../../services/ads_service.dart';
import '../../../../services/remote_config.dart';
import '../../../../state/ads_cubit.dart';
import '../../../../state/wallet_cubit.dart';

/// Bottom sheet for an empty booster (single / 3-pack) or for missing coins.
Future<void> showMiniShop(BuildContext context, {BoosterType? booster, bool coinsOnly = false, int? need}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.bgCream,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(Radii.lg))),
    builder: (_) => _MiniShop(booster: booster, coinsOnly: coinsOnly, need: need),
  );
}

class _MiniShop extends StatelessWidget {
  const _MiniShop({this.booster, required this.coinsOnly, this.need});
  final BoosterType? booster;
  final bool coinsOnly;
  final int? need;

  @override
  Widget build(BuildContext context) {
    final cfg = context.read<AppServices>().config;
    final wallet = context.watch<WalletCubit>();
    final ads = context.watch<AdsCubit>();
    final adsLeft = ads.shopAdsLeft;
    final b = booster;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(Space.xl, Space.md, Space.xl, Space.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.black12, borderRadius: BorderRadius.circular(2))),
            ),
            const SizedBox(height: Space.lg),
            Row(
              children: [
                if (b != null) ...[BoosterIcon(b, size: 44), const SizedBox(width: Space.md)],
                Expanded(
                  child: Text(
                    b != null ? 'Out of ${boosterName(b)}' : (need != null ? 'You need ${fmt(need!)} coins' : 'Get more coins'),
                    style: AppText.h2,
                  ),
                ),
                const CoinPill(showPlus: false),
              ],
            ),
            const SizedBox(height: Space.lg),
            if (b != null && !coinsOnly)
              Row(
                children: [
                  for (final pack in const [false, true]) ...[
                    if (pack) const SizedBox(width: Space.md),
                    Expanded(
                      child: _PackTile(
                        booster: b,
                        count: pack ? 3 : 1,
                        price: cfg.boosterPrice(b, pack: pack),
                        affordable: wallet.state.coins >= cfg.boosterPrice(b, pack: pack),
                        onBuy: () {
                          if (wallet.buyBooster(b, pack ? 3 : 1, cfg.boosterPrice(b, pack: pack))) {
                            Navigator.pop(context);
                            showToast(context, '+${pack ? 3 : 1} ${boosterShort(b)}');
                          }
                        },
                      ),
                    ),
                  ],
                ],
              ),
            const SizedBox(height: Space.md),
            BevelButton(
              expand: true,
              style: BevelStyle.primary,
              logId: 'minishop.ad_coins',
              onPressed: (adsLeft > 0 && ads.rewardedAvailable)
                  ? () async {
                      final ok = await ads.showRewarded(RewardedPlacement.shopCoins);
                      if (ok && context.mounted) context.read<WalletCubit>().earn('shop_ad', cfg.shopAdCoins);
                    }
                  : null,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.movie_filter_rounded),
                  const SizedBox(width: Space.sm),
                  Flexible(
                    child: Text(
                      !ads.rewardedAvailable ? 'Ad unavailable' : (adsLeft > 0 ? 'Watch ad  +${cfg.shopAdCoins}  ($adsLeft left)' : 'Come back tomorrow'),
                      style: AppText.button.copyWith(color: (adsLeft > 0 && ads.rewardedAvailable) ? Colors.white : AppColors.textDisabled),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: Space.md),
            BevelButton.text(
              'Get coins',
              style: BevelStyle.cream,
              icon: Icons.storefront_rounded,
              logId: 'minishop.get_coins',
              onPressed: () {
                Navigator.pop(context);
                Navigator.of(context).pushNamed(Routes.shop, arguments: 1);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _PackTile extends StatelessWidget {
  const _PackTile({required this.booster, required this.count, required this.price, required this.affordable, required this.onBuy});
  final BoosterType booster;
  final int count;
  final int price;
  final bool affordable;
  final VoidCallback onBuy;

  @override
  Widget build(BuildContext context) {
    return CreamCard(
      color: AppColors.surface,
      padding: const EdgeInsets.all(Space.md),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [BoosterIcon(booster, size: 36), Text(' ×$count', style: AppText.h2)],
          ),
          const SizedBox(height: Space.sm),
          BevelButton(
            expand: true,
            height: 44,
            style: BevelStyle.gold,
            onPressed: affordable ? onBuy : null,
            logId: 'minishop.buy.${booster.name}$count',
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
