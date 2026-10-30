import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../app/services.dart';
import '../../app/theme/text_styles.dart';
import '../../app/theme/tokens.dart';
import '../../core/widgets/bevel_button.dart';
import '../../core/widgets/common.dart';
import '../../core/widgets/popup.dart';
import '../../services/ads_service.dart';
import '../../state/ads_cubit.dart';
import '../../state/streak_cubit.dart';
import '../../state/wallet_cubit.dart';
import '../gameplay/view/popups/mini_shop.dart';

/// Accepts the Streak Saver Leaf by ad or coins. Returns true when saved.
Future<bool> acceptSaver(BuildContext context, {required String today, required bool viaAd}) async {
  final s = context.read<AppServices>();
  final streak = context.read<StreakCubit>();
  if (viaAd) {
    final ok = await context.read<AdsCubit>().showRewarded(RewardedPlacement.streakSaver);
    if (ok) streak.useSaver(today, via: 'ad');
    return ok;
  }
  final wallet = context.read<WalletCubit>();
  if (!wallet.canAfford(s.config.streakSaverCoins)) {
    await showMiniShop(context, coinsOnly: true, need: s.config.streakSaverCoins);
    return false;
  }
  if (wallet.spend('streak_saver', s.config.streakSaverCoins)) {
    streak.useSaver(today, via: 'coins');
    return true;
  }
  return false;
}

class StreakSaverCard extends StatelessWidget {
  const StreakSaverCard({super.key, required this.today});
  final String today;

  @override
  Widget build(BuildContext context) {
    final s = context.read<AppServices>();
    final adOk = context.read<AdsCubit>().rewardedAvailable;
    final day = context.select((StreakCubit c) => c.state.day);
    return CreamCard(
      color: const Color(0xFFFFF3E0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.eco_rounded, color: AppColors.primary, size: 32),
              const SizedBox(width: Space.sm),
              Expanded(child: Text('Save your $day-day streak!', style: AppText.h2)),
            ],
          ),
          const SizedBox(height: 4),
          Text('You missed one day. Use the Streak Saver Leaf before solving today\'s puzzle.', style: AppText.caption),
          const SizedBox(height: Space.md),
          Row(
            children: [
              Expanded(
                child: BevelButton.text(
                  adOk ? 'Watch ad' : 'Ad unavailable',
                  icon: Icons.movie_filter_rounded,
                  height: 48,
                  onPressed: adOk ? () => acceptSaver(context, today: today, viaAd: true) : null,
                ),
              ),
              const SizedBox(width: Space.md),
              Expanded(
                child: BevelButton.text(
                  '${fmt(s.config.streakSaverCoins)} coins',
                  style: BevelStyle.gold,
                  height: 48,
                  onPressed: () => acceptSaver(context, today: today, viaAd: false),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Shown once on the first Home visit of a day with a missed-one gap.
Future<void> showStreakSaverOffer(BuildContext context, String today) {
  return showGamePopup<void>(
    context,
    dismissible: true,
    builder: (ctx) => PopupCard(
      title: 'Streak in danger!',
      onClose: () {
        ctx.read<AppServices>().analytics.event('streak_saver', {'via': 'declined'});
        Navigator.pop(ctx);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          StreakSaverCard(today: today),
          const SizedBox(height: Space.md),
          BlocListener<StreakCubit, StreakState>(
            listener: (c, st) {
              if (st.saverDayKey == today) Navigator.pop(c);
            },
            child: TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Not now')),
          ),
        ],
      ),
    ),
  );
}
