import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/services.dart';
import '../../../../app/theme/text_styles.dart';
import '../../../../app/theme/tokens.dart';
import '../../../../core/widgets/bevel_button.dart';
import '../../../../core/widgets/common.dart';
import '../../../../core/widgets/confetti.dart';
import '../../../../core/widgets/game_icons.dart';
import '../../../../core/widgets/pip.dart';
import '../../../../core/widgets/popup.dart';
import '../../../../services/ads_service.dart';
import '../../../../services/audio_service.dart';
import '../../../../services/remote_config.dart';
import '../../../../state/ads_cubit.dart';
import '../../../../state/progress_cubit.dart';
import '../../../../state/wallet_cubit.dart';

enum CompleteAction { next, map }

/// Stars that pop in one by one.
class StarRow extends StatefulWidget {
  const StarRow({super.key, required this.stars, this.size = 52});
  final int stars;
  final double size;

  @override
  State<StarRow> createState() => _StarRowState();
}

class _StarRowState extends State<StarRow> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200))..forward();
  int _played = 0;

  @override
  void initState() {
    super.initState();
    _c.addListener(() {
      final shown = (_c.value * 3.4).floor().clamp(0, widget.stars);
      if (shown > _played) {
        _played = shown;
        context.read<AppServices>().audio.play(Sfx.starPop);
      }
    });
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '${widget.stars} of 3 stars',
      child: AnimatedBuilder(
        animation: _c,
        builder: (_, _) => Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (var i = 0; i < 3; i++)
              Padding(
                padding: EdgeInsets.only(left: 6, right: 6, bottom: i == 1 ? 14 : 0),
                child: Transform.scale(
                  scale: i < widget.stars ? Curves.elasticOut.transform(((_c.value * 3.4 - i).clamp(0.0, 1.0))) : 1,
                  child: StarIcon(size: i == 1 ? widget.size * 1.15 : widget.size, filled: i < widget.stars && _c.value * 3.4 > i),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

Future<CompleteAction> showLevelComplete(BuildContext context, WinReward reward) async {
  final r = await showGamePopup<CompleteAction>(context, builder: (_) => _LevelComplete(reward: reward));
  return r ?? CompleteAction.next;
}

class _LevelComplete extends StatefulWidget {
  const _LevelComplete({required this.reward});
  final WinReward reward;

  @override
  State<_LevelComplete> createState() => _LevelCompleteState();
}

class _LevelCompleteState extends State<_LevelComplete> {
  bool _doubled = false;
  bool _busy = false;

  Future<void> _double() async {
    setState(() => _busy = true);
    final ok = await context.read<AdsCubit>().showRewarded(RewardedPlacement.doubleWin);
    if (!mounted) return;
    if (ok) {
      // Doubles the base clear coins only, never the star bonus.
      context.read<WalletCubit>().earn('win_2x', widget.reward.clearCoins);
      context.read<AppServices>().audio.play(Sfx.coinsFly);
    }
    setState(() {
      _busy = false;
      _doubled = ok;
    });
  }

  @override
  Widget build(BuildContext context) {
    final r = widget.reward;
    final adOk = context.read<AdsCubit>().rewardedAvailable;
    return Stack(
      children: [
        const Positioned.fill(child: LeafConfetti()),
        PopScope(
          canPop: false,
          child: PopupCard(
            title: 'Level ${r.level} Complete!',
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: Space.sm),
                StarRow(stars: r.stars),
                const SizedBox(height: Space.md),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: Space.sm,
                  runSpacing: Space.sm,
                  children: [
                    if (r.clearCoins > 0) RewardChip(coins: _doubled ? r.clearCoins * 2 : r.clearCoins),
                    if (r.starBonus > 0)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(color: AppColors.coinGold.withValues(alpha: 0.25), borderRadius: BorderRadius.circular(Radii.pill)),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('+${r.starBonus} ', style: AppText.bodyBold),
                            const StarIcon(size: 16),
                            const StarIcon(size: 16),
                            const StarIcon(size: 16),
                            Text(' bonus', style: AppText.bodyBold),
                          ],
                        ),
                      ),
                    if (r.total == 0) Text('Replay complete — best stars saved', style: AppText.caption),
                  ],
                ),
                const SizedBox(height: Space.lg),
                if (r.firstClear && r.clearCoins > 0 && !_doubled)
                  Padding(
                    padding: const EdgeInsets.only(bottom: Space.md),
                    child: BevelButton(
                      expand: true,
                      style: BevelStyle.gold,
                      onPressed: (_busy || !adOk) ? null : _double,
                      logId: 'complete.2x',
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.movie_filter_rounded, color: Color(0xFF4E3500)),
                          const SizedBox(width: Space.sm),
                          Text(adOk ? 'Claim 2X  (${r.clearCoins * 2}' : 'Ad unavailable', style: AppText.button.copyWith(color: const Color(0xFF4E3500))),
                          if (adOk) ...[const SizedBox(width: 4), const CoinIcon(size: 20), Text(')', style: AppText.button.copyWith(color: const Color(0xFF4E3500)))],
                        ],
                      ),
                    ),
                  ),
                BevelButton.text('Next', expand: true, icon: Icons.play_arrow_rounded, logId: 'complete.next', onPressed: _busy ? null : () => Navigator.pop(context, CompleteAction.next)),
                const SizedBox(height: Space.sm),
                TextButton(
                  onPressed: _busy ? null : () => Navigator.pop(context, CompleteAction.map),
                  child: Text('Map', style: AppText.bodyBold.copyWith(color: AppColors.primary)),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

enum FailedAction { retry, home }

const _tips = [
  'Hold a snake to preview its path.',
  'Look for snakes facing an open edge first.',
  'A snake can be tapped anywhere on its body.',
  'The Glow Firefly shows the next safe snake.',
  'Safety Shell Shield saves two heart berries.',
];

Future<FailedAction> showLevelFailed(BuildContext context, {required int attempt}) async {
  context.read<AppServices>().audio.play(Sfx.fail);
  final r = await showGamePopup<FailedAction>(
    context,
    builder: (ctx) => PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) Navigator.pop(ctx, FailedAction.home);
      },
      child: PopupCard(
        title: 'Oh no!',
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Pip(pose: PipPose.sleep, size: 110),
            Text('The snakes got tangled', style: AppText.h2, textAlign: TextAlign.center),
            const SizedBox(height: Space.xl),
            BevelButton.text('Try again', expand: true, icon: Icons.refresh_rounded, logId: 'failed.retry', onPressed: () => Navigator.pop(ctx, FailedAction.retry)),
            const SizedBox(height: Space.md),
            BevelButton.text('Home', expand: true, style: BevelStyle.cream, icon: Icons.home_rounded, logId: 'failed.home', onPressed: () => Navigator.pop(ctx, FailedAction.home)),
            const SizedBox(height: Space.lg),
            Row(
              children: [
                const Icon(Icons.lightbulb_outline_rounded, color: AppColors.coinGoldDark, size: 20),
                const SizedBox(width: Space.sm),
                Expanded(child: Text('Tip: ${_tips[attempt % _tips.length]}', style: AppText.caption)),
              ],
            ),
          ],
        ),
      ),
    ),
  );
  return r ?? FailedAction.home;
}

enum StuckAction { restart, home }

/// Soft-lock: no snake can ever leave. Restart costs nothing.
Future<StuckAction> showStuck(BuildContext context) async {
  final r = await showGamePopup<StuckAction>(
    context,
    builder: (ctx) => PopupCard(
      title: 'All tangled up',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Pip(pose: PipPose.sad, size: 100),
          Text('No snake can get out from here. Restart for free — no heart lost.', style: AppText.body, textAlign: TextAlign.center),
          const SizedBox(height: Space.xl),
          BevelButton.text('Restart', expand: true, icon: Icons.refresh_rounded, onPressed: () => Navigator.pop(ctx, StuckAction.restart)),
          const SizedBox(height: Space.sm),
          TextButton(onPressed: () => Navigator.pop(ctx, StuckAction.home), child: const Text('Home')),
        ],
      ),
    ),
  );
  return r ?? StuckAction.restart;
}

/// Daily Result: +100 coins, streak day reward, calendar stamp.
Future<void> showDailyResult(
  BuildContext context, {
  required int stars,
  required int coins,
  required int? streakDay,
  required StreakReward? streakReward,
  required bool trophyUp,
}) {
  return showGamePopup<void>(
    context,
    builder: (ctx) => Stack(
      children: [
        const Positioned.fill(child: LeafConfetti()),
        PopupCard(
          title: 'Daily Puzzle solved!',
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              StarRow(stars: stars),
              const SizedBox(height: Space.md),
              if (coins > 0) RewardChip(coins: coins) else Text('Already claimed today — great practice!', style: AppText.caption),
              if (streakDay != null && streakReward != null) ...[
                const SizedBox(height: Space.lg),
                Text('Jungle Streak · Day $streakDay', style: AppText.h2),
                const SizedBox(height: Space.sm),
                Wrap(
                  spacing: Space.sm,
                  runSpacing: Space.sm,
                  alignment: WrapAlignment.center,
                  children: [
                    RewardChip(coins: streakReward.coins),
                    for (final b in streakReward.boosters) RewardChip(booster: b),
                  ],
                ),
                if (trophyUp) ...[
                  const SizedBox(height: Space.md),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.emoji_events_rounded, color: AppColors.coinGoldDark, size: 32),
                      const SizedBox(width: Space.sm),
                      Text('Golden Coil Trophy up!', style: AppText.bodyBold),
                    ],
                  ),
                ],
              ],
              const SizedBox(height: Space.xl),
              BevelButton.text('Continue', expand: true, onPressed: () => Navigator.pop(ctx)),
            ],
          ),
        ),
      ],
    ),
  );
}
