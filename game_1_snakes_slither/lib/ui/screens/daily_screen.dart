// OWNER: UI agent. Canvas: Daily.dc.html.
import 'package:flutter/material.dart';

import '../../contracts/app_keys.dart';
import '../../contracts/view_models.dart';
import '../theme/tokens.dart';
import '../widgets/art.dart';
import '../widgets/common.dart';

class DailyScreen extends StatelessWidget {
  const DailyScreen({
    super.key,
    required this.data,
    required this.onPlay,
    required this.onBack,
    this.onOpenSaver,
  });

  final DailyData data;
  final VoidCallback onPlay;
  final VoidCallback onBack;
  final VoidCallback? onOpenSaver;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: AppKeys.dailyScreen,
      body: CreamBackground(
        child: SafeArea(
          child: CenteredColumn(
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      RoundButton(
                        label: 'Back',
                        onTap: onBack,
                        child: const LineIconView(LineIcon.back, size: 20),
                      ),
                      const Spacer(),
                      Container(
                        height: 32,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFDF0CC),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.access_time_rounded, size: 16, color: Color(0xFF9A5B00)),
                            const SizedBox(width: 6),
                            Text(
                              data.timeLeft.isNotEmpty ? data.timeLeft : 'Today',
                              style: AppText.nunito(13, color: const Color(0xFF9A5B00), weight: 800),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Column(
                      children: [
                        // Hero Art
                        const SizedBox(height: 8),
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: 180,
                              height: 140,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: RadialGradient(
                                  colors: [Color(0x70FFECA0), Color(0x00FFECA0)],
                                ),
                              ),
                            ),
                            const Bob(
                              child: ArtIcon(Art.gift, size: 84),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Daily Jungle Puzzle',
                          style: AppText.fredoka(28, color: AppColors.textPrimary, weight: 700),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${data.dayTitle} · ${data.modifierLabel} · Reward +${data.clearCoinsReward} coins',
                          style: AppText.nunito(15, color: AppColors.muted, weight: 700),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),

                        // Streak Card
                        CreamCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Jungle Streak',
                                      style: AppText.fredoka(18, color: AppColors.textPrimary),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFFE9D6),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      '🔥 ${data.currentStreakDays} days',
                                      style: AppText.nunito(13, color: const Color(0xFFC2410C), weight: 800),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 14),
                              // 7-day Ladder
                              Row(
                                children: [
                                  for (var i = 1; i <= 7; i++)
                                    Expanded(
                                      child: _DayStep(
                                        dayIndex: i,
                                        currentCycleDay: data.currentCycleDay,
                                        coins: data.ladderCoins.length >= i ? data.ladderCoins[i - 1] : 50,
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 14),

                        // Sub-cards (Saver & Trophy)
                        Row(
                          children: [
                            Expanded(
                              child: Pressable(
                                key: AppKeys.dailySaver,
                                onTap: data.saverAvailable ? onOpenSaver : null,
                                semanticLabel: 'Streak Saver, ${data.saverStatus}',
                                child: CreamCard(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Streak Saver',
                                        style: AppText.nunito(12, color: AppColors.muted, weight: 800),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        data.saverStatus,
                                        style: AppText.fredoka(
                                          15,
                                          color: data.saverAvailable ? AppColors.emerald : AppColors.muted,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: CreamCard(
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Cycle trophy',
                                        style: AppText.nunito(12, color: AppColors.muted, weight: 800),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        data.trophyTierLabel,
                                        style: AppText.fredoka(15, color: const Color(0xFF8A6A00)),
                                      ),
                                    ],
                                  ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // Bottom Action
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                  child: GameButton(
                    key: AppKeys.dailyPlay,
                    height: 58,
                    fontSize: 20,
                    label: data.completedToday ? 'Completed ✓' : '▶ Play today',
                    onTap: data.completedToday ? null : onPlay,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DayStep extends StatelessWidget {
  const _DayStep({
    required this.dayIndex,
    required this.currentCycleDay,
    required this.coins,
  });

  final int dayIndex;
  final int currentCycleDay;
  final int coins;

  @override
  Widget build(BuildContext context) {
    final isDone = dayIndex < currentCycleDay;
    final isCurrent = dayIndex == currentCycleDay;
    final isLast = dayIndex == 7;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'D$dayIndex',
          style: AppText.nunito(11, color: AppColors.muted, weight: 800),
        ),
        const SizedBox(height: 4),
        Container(
          width: 36,
          height: 38,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: isDone
                ? const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFF23A766), Color(0xFF13864D)],
                  )
                : isLast
                    ? const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0xFFFFD24A), Color(0xFFF4B72F)],
                      )
                    : null,
            color: isDone || isLast
                ? null
                : isCurrent
                    ? Colors.white
                    : const Color(0xFFF5F0DF),
            border: isCurrent ? Border.all(color: const Color(0xFFF4B72F), width: 2) : null,
            boxShadow: isDone
                ? const [BoxShadow(color: Color(0xFF03432A), offset: Offset(0, 3))]
                : isCurrent
                    ? [BoxShadow(color: const Color(0xFFF4B72F).withValues(alpha: 0.35), spreadRadius: 2)]
                    : null,
          ),
          child: Text(
            isDone
                ? '✓'
                : isLast
                    ? '🏆'
                    : isCurrent
                        ? '▶'
                        : '',
            style: AppText.fredoka(
              16,
              color: isDone
                  ? Colors.white
                  : isLast
                      ? const Color(0xFF4A2E00)
                      : isCurrent
                          ? const Color(0xFF9A5B00)
                          : AppColors.muted,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '$coins',
          style: AppText.fredoka(12, color: AppColors.textPrimary),
        ),
      ],
    );
  }
}
