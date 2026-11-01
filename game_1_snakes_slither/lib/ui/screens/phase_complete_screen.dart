// OWNER: UI agent. Canvas: PhaseComplete.dc.html.
import 'package:flutter/material.dart';

import '../../contracts/app_keys.dart';
import '../theme/tokens.dart';
import '../widgets/art.dart';
import '../widgets/common.dart';

class PhaseCompleteScreen extends StatelessWidget {
  const PhaseCompleteScreen({
    super.key,
    required this.stars,
    required this.maxStars,
    required this.onReplay,
    required this.onHome,
  });
  final int stars;
  final int maxStars;

  /// Opens the Level Map so a level can be replayed for 3 stars.
  final VoidCallback onReplay;
  final VoidCallback onHome;

  @override
  Widget build(BuildContext context) => Scaffold(
    key: AppKeys.phaseCompleteScreen,
    body: CreamBackground(
      child: SafeArea(
        child: CenteredColumn(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
            child: Column(
              children: [
                Container(
                  height: 30,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(color: AppColors.forest, borderRadius: BorderRadius.circular(15)),
                  child: Text('PHASE 1 COMPLETE · LEVEL 500', style: AppText.nunito(12, color: Colors.white, spacing: .6)),
                ),
                const SizedBox(height: 18),
                Bob(child: Image.asset('assets/images/pip_hero.png', height: 180, excludeFromSemantics: true)),
                const SizedBox(height: 10),
                PopIn(
                  child: Container(
                    key: AppKeys.gardenHeroBadge,
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [AppColors.goldLight, AppColors.gold]),
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: const [BoxShadow(color: AppColors.goldLip, offset: Offset(0, 4))],
                    ),
                    child: Text('Garden Hero!', style: AppText.fredoka(28, color: const Color(0xFF5A3A00))),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'You freed every snake in Phase 1, all 500 levels. The Mongoose King tipped his hat and left the garden.',
                  textAlign: TextAlign.center,
                  style: AppText.nunito(16, color: const Color(0xFF3B5240)),
                ),
                const SizedBox(height: 16),
                CreamCard(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const ArtIcon(Art.star, size: 28),
                      const SizedBox(width: 8),
                      Text('${fmt(stars)} / ${fmt(maxStars)}', style: AppText.fredoka(24)),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.leafWash,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.cardBorder),
                  ),
                  child: Text('Phase 2 coming soon', textAlign: TextAlign.center, style: AppText.fredoka(18, color: AppColors.forest)),
                ),
                const SizedBox(height: 18),
                GameButton(key: AppKeys.phaseReplay, label: 'Replay for 3 stars', onTap: onReplay),
                const SizedBox(height: 10),
                GameButton(key: AppKeys.phaseHome, label: 'Home', tone: ButtonTone.cream, onTap: onHome),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
