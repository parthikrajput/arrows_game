import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../app/routes.dart';
import '../../app/services.dart';
import '../../app/theme/text_styles.dart';
import '../../app/theme/tokens.dart';
import '../../core/widgets/bevel_button.dart';
import '../../core/widgets/common.dart';
import '../../core/widgets/game_icons.dart';
import '../../core/widgets/garden_background.dart';
import '../../services/remote_config.dart';
import '../../state/daily_cubit.dart';
import '../../state/progress_cubit.dart';
import '../../state/streak_cubit.dart';
import '../gameplay/view/gameplay_page.dart';
import 'daily_modifier_chip.dart';
import 'streak_saver.dart';

class DailyPage extends StatefulWidget {
  const DailyPage({super.key});

  @override
  State<DailyPage> createState() => _DailyPageState();
}

class _DailyPageState extends State<DailyPage> {
  Timer? _clock;

  @override
  void initState() {
    super.initState();
    // Refresh the "next puzzle in" clock and catch midnight (dayKey change).
    _clock = Timer.periodic(const Duration(seconds: 30), (_) => setState(() {}));
  }

  @override
  void dispose() {
    _clock?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = context.read<AppServices>();
    final highest = context.select((ProgressCubit p) => p.state.highestCleared);
    final daily = context.watch<DailyCubit>();
    final streak = context.watch<StreakCubit>().state;
    final today = s.time.dayKey();
    final unlocked = daily.unlocked(highest);
    final locked = s.time.timeTravelLocked;

    return Scaffold(
      body: GardenBackground(
        hillsAt: 0.85,
        child: SafeArea(
          child: Column(
            children: [
              const HubHeader(title: 'Daily Jungle Puzzle'),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(Space.gutter, Space.sm, Space.gutter, Space.xxl),
                  children: [
                    if (!unlocked)
                      _LockedCard(level: s.config.dailyUnlockLevel)
                    else if (locked)
                      const ClockLockCard()
                    else ...[
                      _TodayCard(puzzle: daily.today(highest), claimed: daily.state.claimed(today)),
                      if (streak.saverOffered(today) && !daily.state.claimed(today)) ...[
                        const SizedBox(height: Space.md),
                        StreakSaverCard(today: today),
                      ],
                    ],
                    const SizedBox(height: Space.lg),
                    _StreakLadder(streak: streak, today: today, claimedToday: daily.state.claimed(today)),
                    const SizedBox(height: Space.lg),
                    _Calendar(starsByDay: daily.state.starsByDay, today: DateTime.parse(today)),
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

class _LockedCard extends StatelessWidget {
  const _LockedCard({required this.level});
  final int level;

  @override
  Widget build(BuildContext context) {
    return CreamCard(
      child: Row(
        children: [
          const Icon(Icons.lock_rounded, size: 40, color: AppColors.textSecondary),
          const SizedBox(width: Space.md),
          Expanded(child: Text('The Daily Jungle Puzzle unlocks at level $level.', style: AppText.bodyBold)),
        ],
      ),
    );
  }
}

class ClockLockCard extends StatelessWidget {
  const ClockLockCard({super.key});

  @override
  Widget build(BuildContext context) {
    return CreamCard(
      child: Row(
        children: [
          const Icon(Icons.schedule_rounded, size: 40, color: AppColors.danger),
          const SizedBox(width: Space.md),
          Expanded(child: Text('Your clock seems off — jungle time will return soon.', style: AppText.bodyBold)),
        ],
      ),
    );
  }
}

class _TodayCard extends StatelessWidget {
  const _TodayCard({required this.puzzle, required this.claimed});
  final DailyPuzzle puzzle;
  final bool claimed;

  @override
  Widget build(BuildContext context) {
    final s = context.read<AppServices>();
    final date = DateTime.parse(puzzle.dayKey);
    final left = s.time.untilMidnight();
    return CreamCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SilhouettePreview(silhouette: puzzle.silhouette),
              const SizedBox(width: Space.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${DateFormat.EEEE().format(date)} · ${silhouetteName(puzzle.silhouette)}', style: AppText.h2),
                    const SizedBox(height: 4),
                    DailyModifierChip(modifier: puzzle.modifier),
                    const SizedBox(height: 4),
                    Text(puzzle.modifier.rule, style: AppText.caption),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: Space.md),
          if (!claimed)
            Row(
              children: [
                Text('Reward ', style: AppText.bodyBold),
                const CoinIcon(size: 20),
                Text(' +${s.config.dailyClearCoins}  + streak gift', style: AppText.bodyBold),
              ],
            )
          else
            Row(
              children: [
                const Icon(Icons.check_circle_rounded, color: AppColors.primary),
                const SizedBox(width: Space.sm),
                Expanded(child: Text('Solved! Come back tomorrow · new puzzle in ${left.inHours}h ${left.inMinutes % 60}m', style: AppText.bodyBold)),
              ],
            ),
          const SizedBox(height: Space.md),
          BevelButton.text(
            claimed ? 'Replay (no reward)' : 'Play today',
            expand: true,
            style: claimed ? BevelStyle.cream : BevelStyle.primary,
            icon: Icons.play_arrow_rounded,
            logId: 'daily.play',
            onPressed: () {
              s.analytics.event('daily_start', {'dayKey': puzzle.dayKey, 'modifier': puzzle.modifier.name, 'paramsLevel': puzzle.paramsLevel});
              Navigator.of(context).pushNamed(Routes.play, arguments: GameArgs.daily(puzzle));
            },
          ),
        ],
      ),
    );
  }
}

class _StreakLadder extends StatelessWidget {
  const _StreakLadder({required this.streak, required this.today, required this.claimedToday});
  final StreakState streak;
  final String today;
  final bool claimedToday;

  @override
  Widget build(BuildContext context) {
    final shown = streak.displayDay(today);
    final nextDay = claimedToday ? null : streak.nextDayOn(today);
    final done = claimedToday ? streak.day : (nextDay == 1 ? 0 : shown);
    return CreamCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.local_fire_department_rounded, color: Color(0xFFFF7043)),
              const SizedBox(width: 6),
              Text('Jungle Streak  $shown', style: AppText.h2),
              const Spacer(),
              Text('Total ${streak.totalDays} days', style: AppText.caption),
            ],
          ),
          const SizedBox(height: Space.md),
          LayoutBuilder(builder: (context, c) {
            final w = (c.maxWidth - 6 * 6) / 7;
            return Row(
              children: [
                for (var d = 1; d <= 7; d++) ...[
                  if (d > 1) const SizedBox(width: 6),
                  _DayCell(day: d, width: w, reward: streakLadder[d - 1], done: d <= done, next: d == nextDay),
                ],
              ],
            );
          }),
          const SizedBox(height: Space.md),
          Row(
            children: [
              Icon(Icons.eco_rounded, color: streak.cycleSaverUsed ? AppColors.textDisabled : AppColors.primary, size: 20),
              const SizedBox(width: 6),
              Text('Saver: ${streak.cycleSaverUsed ? 'used this cycle' : 'available (1 per cycle)'}', style: AppText.caption),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(Icons.emoji_events_rounded, color: _trophyColor(streak.trophyTier), size: 20),
              const SizedBox(width: 6),
              Text('Trophy: ${streak.trophyTier == 0 ? 'finish Day 7 to earn one' : '${trophyTiers[streak.trophyTier]} Coil'}', style: AppText.caption),
            ],
          ),
        ],
      ),
    );
  }

  static Color _trophyColor(int tier) => switch (tier) {
        1 => const Color(0xFFCD7F32),
        2 => const Color(0xFF9E9E9E),
        3 => AppColors.coinGold,
        4 => const Color(0xFF90A4AE),
        5 => const Color(0xFF4FC3F7),
        _ => AppColors.textDisabled,
      };
}

class _DayCell extends StatelessWidget {
  const _DayCell({required this.day, required this.width, required this.reward, required this.done, required this.next});
  final int day;
  final double width;
  final StreakReward reward;
  final bool done;
  final bool next;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Day $day, ${reward.coins} coins${done ? ', done' : ''}',
      child: AnimatedContainer(
        duration: Motion.base,
        width: width,
        padding: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: done ? AppColors.primaryLight.withValues(alpha: 0.3) : Colors.white,
          borderRadius: BorderRadius.circular(Radii.sm),
          border: Border.all(color: next ? AppColors.coinGold : Colors.transparent, width: 2),
        ),
        child: ExcludeSemantics(
          child: Column(
            children: [
              Text('D$day', style: AppText.caption.copyWith(fontWeight: FontWeight.w800)),
              const SizedBox(height: 2),
              SizedBox(
                height: 24,
                child: done
                    ? const Icon(Icons.check_circle_rounded, color: AppColors.primary, size: 22)
                    : day == 7
                        ? const Icon(Icons.emoji_events_rounded, color: AppColors.coinGoldDark, size: 22)
                        : reward.boosters.isNotEmpty
                            ? BoosterIcon(reward.boosters.first, size: 22)
                            : const CoinIcon(size: 18),
              ),
              FittedBox(child: Text('${reward.coins}', style: AppText.caption.copyWith(fontWeight: FontWeight.w800))),
            ],
          ),
        ),
      ),
    );
  }
}

class _Calendar extends StatelessWidget {
  const _Calendar({required this.starsByDay, required this.today});
  final Map<String, int> starsByDay;
  final DateTime today;

  @override
  Widget build(BuildContext context) {
    final first = DateTime(today.year, today.month);
    final days = DateTime(today.year, today.month + 1, 0).day;
    final lead = first.weekday - 1;
    String key(int d) => '${today.year}-${today.month.toString().padLeft(2, '0')}-${d.toString().padLeft(2, '0')}';
    return CreamCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(DateFormat.yMMMM().format(today), style: AppText.h2),
          const SizedBox(height: Space.sm),
          GridView.count(
            crossAxisCount: 7,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
            children: [
              for (final d in const ['M', 'T', 'W', 'T', 'F', 'S', 'S']) Center(child: Text(d, style: AppText.caption)),
              for (var i = 0; i < lead; i++) const SizedBox(),
              for (var d = 1; d <= days; d++)
                Container(
                  decoration: BoxDecoration(
                    color: starsByDay.containsKey(key(d)) ? AppColors.primaryLight.withValues(alpha: 0.35) : Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: d == today.day ? AppColors.primary : Colors.transparent, width: 2),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('$d', style: AppText.caption.copyWith(fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                      if (starsByDay[key(d)] != null)
                        FittedBox(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [for (var i = 0; i < starsByDay[key(d)]!; i++) const StarIcon(size: 9)],
                          ),
                        ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
