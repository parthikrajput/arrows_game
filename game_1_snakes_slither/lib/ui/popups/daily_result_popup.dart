// OWNER: UI agent. Canvas: DailyResult.dc.html.
import 'package:flutter/material.dart';

import '../../contracts/app_keys.dart';
import '../../contracts/view_models.dart';
import '../theme/tokens.dart';
import '../widgets/art.dart';
import '../widgets/common.dart';

class DailyResultPopup extends StatelessWidget {
  const DailyResultPopup({
    super.key,
    required this.data,
    required this.onCollect,
  });

  final DailyResultData data;
  final VoidCallback onCollect;

  @override
  Widget build(BuildContext context) {
    return PopupScrim(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 390),
            child: PopupCard(
              key: AppKeys.dailyResultPopup,
              badge: data.dayTitle.isNotEmpty ? data.dayTitle : 'DAILY CLEARED',
              children: [
                const SizedBox(height: 12),
                Text(
                  'Daily Jungle Puzzle\ncleared!',
                  style: AppText.fredoka(26, color: AppColors.textPrimary, height: 1.15),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),

                // Leaf stamp container
                Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(28),
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFFEEF8E9), Color(0xFFCFE6C4)],
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x2E1E3C1E),
                            offset: Offset(0, 10),
                            blurRadius: 20,
                          ),
                        ],
                      ),
                      child: const Center(
                        child: ArtIcon(Art.gift, size: 64),
                      ),
                    ),
                    Positioned(
                      right: -8,
                      bottom: -8,
                      child: Container(
                        height: 28,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppColors.emerald,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: Text(
                          data.stampedDate.isNotEmpty ? 'Stamped ${data.stampedDate}' : 'Stamped',
                          style: AppText.nunito(11, color: Colors.white, weight: 800),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Stars & moves
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (var i = 1; i <= 3; i++)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 3),
                        child: ArtIcon(
                          i <= data.stars ? Art.star : Art.starEmpty,
                          size: 32,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  '${data.moves} moves · par ${data.parMoves}',
                  style: AppText.nunito(13, color: AppColors.muted, weight: 800),
                ),
                const SizedBox(height: 16),

                // Rewards breakdown Card
                CreamCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text('Daily clear', style: AppText.nunito(15, weight: 800)),
                          ),
                          Text('+${data.clearCoins} coins', style: AppText.fredoka(16, color: AppColors.emerald)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                const Text('🔥 ', style: TextStyle(fontSize: 16)),
                                Expanded(
                                  child: Text(
                                    'Jungle Streak · Day ${data.streakDay}',
                                    style: AppText.nunito(15, weight: 800),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text('+${data.streakCoins} coins', style: AppText.fredoka(16, color: AppColors.emerald)),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // 7-day mini progress bar
                      Row(
                        children: [
                          for (var i = 1; i <= 7; i++)
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.symmetric(horizontal: 2),
                                height: 28,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: i == data.streakDay
                                      ? const Color(0xFFFF8F00)
                                      : i < data.streakDay
                                          ? AppColors.emerald
                                          : const Color(0xFFF1F5F0),
                                ),
                                child: Text(
                                  'D$i',
                                  style: AppText.fredoka(
                                    11,
                                    color: i <= data.streakDay ? Colors.white : AppColors.muted,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                      if (data.tomorrowRewardText.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text(
                          data.tomorrowRewardText,
                          style: AppText.nunito(12, color: AppColors.muted, weight: 700),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Collect Button
                GameButton(
                  key: AppKeys.dailyResultCollect,
                  label: 'Collect',
                  onTap: onCollect,
                ),
                if (data.nextDailyTimeLeft.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    'Next Daily in ${data.nextDailyTimeLeft}',
                    style: AppText.nunito(12, color: AppColors.muted, weight: 700),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
