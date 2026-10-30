import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../app/theme/text_styles.dart';
import '../../app/theme/tokens.dart';
import '../../core/widgets/bevel_button.dart';
import '../../core/widgets/common.dart';
import '../../core/widgets/popup.dart';
import '../../services/remote_config.dart';
import '../../services/store_service.dart';
import '../../state/shop_cubit.dart';

/// Contents of the Starter Pack (800 coins + 3 Hint + 2 Hammer + 2 Shield).
class StarterPackContents extends StatelessWidget {
  const StarterPackContents({super.key});

  @override
  Widget build(BuildContext context) {
    return const Wrap(
      spacing: Space.sm,
      runSpacing: Space.sm,
      alignment: WrapAlignment.center,
      children: [
        RewardChip(coins: 800),
        RewardChip(booster: BoosterType.hint, count: 3),
        RewardChip(booster: BoosterType.hammer, count: 2),
        RewardChip(booster: BoosterType.shield, count: 2),
      ],
    );
  }
}

Future<void> buyStarter(BuildContext context) async {
  final shop = context.read<ShopCubit>();
  await shop.loadProducts();
  final status = await shop.buy('starter_pack');
  if (!context.mounted) return;
  showToast(context, switch (status) {
    PurchaseStatus.purchased => 'Starter Pack added!',
    PurchaseStatus.pending => 'Purchase pending',
    PurchaseStatus.error => 'Store unavailable',
    PurchaseStatus.cancelled => 'Purchase cancelled',
  });
}

Future<void> showStarterPackPopup(BuildContext context) {
  final price = context.read<ShopCubit>().state.product('starter_pack')?.price ?? '₹79';
  return showGamePopup<void>(
    context,
    dismissible: true,
    builder: (ctx) => PopupCard(
      title: 'Starter Pack',
      onClose: () => Navigator.pop(ctx),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('A one-time jungle bundle to get you going.', style: AppText.body, textAlign: TextAlign.center),
          const SizedBox(height: Space.lg),
          const StarterPackContents(),
          const SizedBox(height: Space.xl),
          BevelButton.text(
            'Get it for $price',
            expand: true,
            style: BevelStyle.gold,
            logId: 'starter.buy',
            onPressed: () async {
              Navigator.pop(ctx);
              await buyStarter(context);
            },
          ),
          const SizedBox(height: Space.sm),
          Text('Available for 48 hours after level 15.', style: AppText.caption),
        ],
      ),
    ),
  );
}
