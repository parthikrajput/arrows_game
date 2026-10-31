// OWNER: UI agent. Canvas: Saver.dc.html.
import 'package:flutter/material.dart';

import '../../contracts/app_keys.dart';
import '../../contracts/view_models.dart';
import '../theme/tokens.dart';
import '../widgets/art.dart';
import '../widgets/common.dart';

class StreakSaverDialog extends StatelessWidget {
  const StreakSaverDialog({
    super.key,
    required this.data,
    required this.onWatchAd,
    required this.onSaveWithCoins,
    required this.onDecline,
  });

  final StreakSaverData data;
  final VoidCallback onWatchAd;
  final VoidCallback onSaveWithCoins;
  final VoidCallback onDecline;

  @override
  Widget build(BuildContext context) {
    return PopupScrim(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 390),
            child: PopupCard(
              key: AppKeys.saverPopup,
              badge: 'STREAK SAVER',
              children: [
                const SizedBox(height: 12),
                // Leaf with flame badge
                Stack(
                  alignment: Alignment.center,
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFFEEF8E9), Color(0xFFD5EBCB)],
                        ),
                      ),
                      child: const Center(
                        child: ArtIcon(Art.gift, size: 48),
                      ),
                    ),
                    Positioned(
                      right: -4,
                      bottom: -4,
                      child: Container(
                        width: 28,
                        height: 28,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: const [
                            BoxShadow(color: Color(0x26000000), offset: Offset(0, 2), blurRadius: 6),
                          ],
                        ),
                        child: const Text('🔥', style: TextStyle(fontSize: 14)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                Text(
                  'Save your streak?',
                  style: AppText.fredoka(24, color: AppColors.textPrimary),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'You missed 1 day. Keep your ${data.currentStreakDays}-day Jungle Streak alive, and today\'s clear gives the Day ${data.nextDayNumber} reward: ${data.nextDayCoins} coins${data.nextDayBoosterText}.',
                  style: AppText.nunito(14, color: AppColors.muted, weight: 700),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),

                // Button 1: Watch ad to save
                GameButton(
                  key: AppKeys.saverWatchAd,
                  leading: const Icon(Icons.movie_rounded, color: Colors.white, size: 22),
                  label: 'Watch ad to save',
                  onTap: data.adAvailable ? onWatchAd : null,
                ),
                const SizedBox(height: 10),

                // Button 2: Save for 200 coins
                GameButton(
                  key: AppKeys.saverCoins,
                  tone: ButtonTone.cream,
                  leading: const ArtIcon(Art.coin, size: 20),
                  label: 'Save for ${data.coinCost} coins',
                  onTap: data.canAffordCoins ? onSaveWithCoins : null,
                ),
                const SizedBox(height: 8),

                // Button 3: Decline / reset
                TextButton(
                  key: AppKeys.saverDecline,
                  onPressed: onDecline,
                  child: Text(
                    'Let it reset to Day 1',
                    style: AppText.nunito(14, color: AppColors.muted, weight: 800),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '1 save per 7-day cycle. The missed day\'s reward isn\'t paid.',
                  style: AppText.nunito(11, color: AppColors.muted, weight: 700),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
