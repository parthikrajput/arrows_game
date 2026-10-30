import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../app/theme/text_styles.dart';
import '../../app/theme/tokens.dart';
import '../../core/widgets/bevel_button.dart';
import '../../core/widgets/common.dart';
import '../../core/widgets/garden_background.dart';
import '../../services/store_service.dart';
import '../../state/ads_cubit.dart';
import '../../state/shop_cubit.dart';

class VipPage extends StatefulWidget {
  const VipPage({super.key});

  @override
  State<VipPage> createState() => _VipPageState();
}

class _VipPageState extends State<VipPage> {
  @override
  void initState() {
    super.initState();
    context.read<ShopCubit>().loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    final ads = context.watch<AdsCubit>();
    final shop = context.watch<ShopCubit>().state;
    final active = ads.vipActive;
    final until = ads.state.vipActiveUntil;
    final expired = !active && until != null;
    final price = shop.product('vip_monthly')?.price;
    return Scaffold(
      body: GardenBackground(
        hillsAt: 0.85,
        child: SafeArea(
          child: Column(
            children: [
              const HubHeader(title: 'VIP No-Ads Pass', showCoins: false),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(Space.gutter),
                  children: [
                    CreamCard(
                      color: const Color(0xFFF3EEFB),
                      padding: const EdgeInsets.all(Space.xl),
                      child: Column(
                        children: [
                          const Icon(Icons.workspace_premium_rounded, size: 72, color: AppColors.vipPurple),
                          Text(active ? 'VIP active' : 'Play without interruptions', style: AppText.h1, textAlign: TextAlign.center),
                          if (active && until != null)
                            Text('Active until ${DateFormat.yMMMd().format(until.toLocal())}', style: AppText.bodyBold.copyWith(color: AppColors.vipPurple)),
                          if (expired) Text('Your pass expired — ads are back.', style: AppText.bodyBold.copyWith(color: AppColors.danger)),
                          const SizedBox(height: Space.lg),
                          for (final b in const ['No interstitial ads', 'No banner ads', 'Rewarded ads stay optional'])
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Row(
                                children: [
                                  const Icon(Icons.check_circle_rounded, color: AppColors.primary),
                                  const SizedBox(width: Space.sm),
                                  Text(b, style: AppText.bodyBold),
                                ],
                              ),
                            ),
                          const SizedBox(height: Space.lg),
                          Text(price == null ? '…' : '$price / month', style: AppText.display),
                          Text('Auto-renews monthly. Cancel anytime in your store account.', style: AppText.caption, textAlign: TextAlign.center),
                          const SizedBox(height: Space.lg),
                          if (!active)
                            BevelButton.text(
                              shop.busySku == 'vip_monthly' ? 'Please wait…' : 'Subscribe',
                              expand: true,
                              style: BevelStyle.vip,
                              logId: 'vip.subscribe',
                              onPressed: price == null || shop.busySku != null
                                  ? null
                                  : () async {
                                      final status = await context.read<ShopCubit>().buy('vip_monthly');
                                      if (context.mounted && status == PurchaseStatus.purchased) showToast(context, 'Welcome to VIP!');
                                    },
                            )
                          else
                            BevelButton.text('Manage subscription', expand: true, style: BevelStyle.cream, onPressed: () => showToast(context, 'Opens your store subscriptions page')),
                        ],
                      ),
                    ),
                    const SizedBox(height: Space.md),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () async {
                            final ok = await context.read<ShopCubit>().restore();
                            if (context.mounted) showToast(context, ok ? 'Purchases restored' : 'Nothing to restore');
                          },
                          child: const Text('Restore'),
                        ),
                        TextButton(onPressed: () {}, child: const Text('Terms')),
                        TextButton(onPressed: () {}, child: const Text('Privacy')),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
