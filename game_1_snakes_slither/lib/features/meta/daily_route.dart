import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../contracts/view_models.dart';
import '../../services/time_guard.dart';
import '../../state/ads_cubit.dart';
import '../../state/daily_cubit.dart';
import '../../state/streak_cubit.dart';
import '../../state/wallet_cubit.dart';
import '../../ui/popups/popups.dart';
import '../../ui/screens/daily_screen.dart';

class DailyRoute extends StatelessWidget {
  const DailyRoute({super.key});

  static String dayTitle(DateTime date, DailyModifier modifier) {
    const days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];
    final d = days[date.weekday - 1];
    return '$d · ${modifier.label}';
  }

  static String trophyName(TrophyTier tier) {
    return switch (tier) {
      TrophyTier.bronze => '🥉 Bronze Coil',
      TrophyTier.silver => '🥈 Silver Coil',
      TrophyTier.gold => '🥇 Gold Coil',
      TrophyTier.platinum => '💎 Platinum Coil',
      TrophyTier.diamond => '👑 Diamond Coil',
    };
  }

  static String timeLeft(DateTime now) {
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    final diff = tomorrow.difference(now);
    final hours = diff.inHours;
    final minutes = diff.inMinutes % 60;
    return '${hours}h ${minutes}m left';
  }

  void _showSaverDialog(
    BuildContext context,
    StreakCubit streak,
    WalletCubit wallet,
    AdsCubit ads,
  ) {
    final s = streak.state;
    final nextReward = StreakState.ladder[(s.currentDay - 1).clamp(0, 6)];
    final boosterText = nextReward.booster != null
        ? ' + 1 ${boosterName(nextReward.booster!)}'
        : '';

    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (dialogCtx) => StreakSaverDialog(
        data: StreakSaverData(
          currentStreakDays: s.totalStreakDays,
          nextDayNumber: s.currentDay,
          nextDayCoins: nextReward.coins,
          nextDayBoosterText: boosterText,
          canAffordCoins: wallet.state.coins >= 200,
          adAvailable: ads.rewardedReady,
        ),
        onWatchAd: () async {
          final ok = await streak.saveStreakWithAd();
          if (dialogCtx.mounted) Navigator.of(dialogCtx).pop();
          if (!ok && context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Could not play rewarded ad.')),
            );
          }
        },
        onSaveWithCoins: () {
          final ok = streak.saveStreakWithCoins();
          if (dialogCtx.mounted) Navigator.of(dialogCtx).pop();
          if (!ok && context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Not enough coins.')),
            );
          }
        },
        onDecline: () {
          streak.declineSaver();
          if (dialogCtx.mounted) Navigator.of(dialogCtx).pop();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final daily = context.watch<DailyCubit>();
    final streak = context.watch<StreakCubit>();
    final wallet = context.watch<WalletCubit>();
    final ads = context.read<AdsCubit>();
    final time = context.read<TimeGuard>();
    final now = time.clock.now();

    final sState = streak.state;
    final dState = daily.state;

    final saverOffer = sState.hasSaverOffer;
    final saverUsed = sState.cycleSaverUsed;
    final saverStatus = saverOffer
        ? 'Offer waiting · Tap'
        : saverUsed
            ? 'Used this cycle'
            : 'Available · 1/cycle';

    final data = DailyData(
      dayTitle: dayTitle(now, dState.modifier),
      modifierLabel: dState.modifier.label,
      modifierDescription: dState.modifier.description,
      currentStreakDays: sState.totalStreakDays,
      currentCycleDay: sState.currentDay,
      clearCoinsReward: 100,
      completedToday: dState.completed,
      saverAvailable: saverOffer,
      saverStatus: saverStatus,
      trophyTierLabel: trophyName(sState.trophyTier),
      timeLeft: timeLeft(now),
      ladderCoins: StreakState.ladder.map((r) => r.coins).toList(),
    );

    return DailyScreen(
      data: data,
      onPlay: () => context.go('/daily/play'),
      onBack: () => context.go('/'),
      onOpenSaver: sState.hasSaverOffer
          ? () => _showSaverDialog(context, streak, wallet, ads)
          : null,
    );
  }
}
