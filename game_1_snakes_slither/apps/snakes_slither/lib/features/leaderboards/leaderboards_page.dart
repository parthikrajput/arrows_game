import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../app/theme/text_styles.dart';
import '../../app/theme/tokens.dart';
import '../../core/widgets/bevel_button.dart';
import '../../core/widgets/common.dart';
import '../../core/widgets/game_icons.dart';
import '../../core/widgets/garden_background.dart';
import '../../state/leaderboard_cubit.dart';
import '../../state/progress_cubit.dart';
import '../../state/streak_cubit.dart';

class LeaderboardsPage extends StatefulWidget {
  const LeaderboardsPage({super.key});

  @override
  State<LeaderboardsPage> createState() => _LeaderboardsPageState();
}

class _LeaderboardsPageState extends State<LeaderboardsPage> {
  bool _signingIn = false;

  Future<void> _signIn() async {
    setState(() => _signingIn = true);
    final ok = await context.read<LeaderboardCubit>().signIn();
    if (!mounted) return;
    setState(() => _signingIn = false);
    showToast(context, ok ? 'Signed in' : 'Play Games is not connected in this build yet. Your scores are saved and will sync later.');
  }

  @override
  Widget build(BuildContext context) {
    final progress = context.watch<ProgressCubit>().state;
    final streak = context.watch<StreakCubit>().state;
    final lb = context.watch<LeaderboardCubit>().state;
    final stats = [
      (Icons.flag_rounded, 'Highest Level', '${progress.highestCleared}', AppColors.primary),
      (Icons.star_rounded, 'Total Stars', fmt(progress.totalStars), AppColors.coinGoldDark),
      (Icons.local_fire_department_rounded, 'Streak Days', '${streak.totalDays}', const Color(0xFFFF7043)),
    ];
    return Scaffold(
      body: GardenBackground(
        hillsAt: 0.8,
        child: SafeArea(
          child: Column(
            children: [
              const HubHeader(title: 'Leaderboards', showCoins: false),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(Space.gutter),
                  children: [
                    for (final (icon, label, value, color) in stats) ...[
                      CreamCard(
                        child: Row(
                          children: [
                            Container(
                              width: 52,
                              height: 52,
                              decoration: BoxDecoration(color: color.withValues(alpha: 0.15), shape: BoxShape.circle),
                              child: icon == Icons.star_rounded ? const Center(child: StarIcon(size: 30)) : Icon(icon, color: color, size: 30),
                            ),
                            const SizedBox(width: Space.md),
                            Expanded(child: Text(label, style: AppText.h2)),
                            Text(value, style: AppText.h1),
                          ],
                        ),
                      ),
                      const SizedBox(height: Space.md),
                    ],
                    const SizedBox(height: Space.md),
                    BevelButton.text(
                      lb.signedIn ? 'Open Play Games' : (_signingIn ? 'Signing in…' : 'Sign in to compare'),
                      expand: true,
                      icon: Icons.sports_esports_rounded,
                      onPressed: _signingIn ? null : _signIn,
                    ),
                    const SizedBox(height: Space.md),
                    Text('Leaderboards are just for fun — no rewards depend on rank.', style: AppText.caption, textAlign: TextAlign.center),
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
