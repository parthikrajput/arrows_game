import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../app/routes.dart';
import '../../app/services.dart';
import '../../app/theme/text_styles.dart';
import '../../app/theme/tokens.dart';
import '../../core/widgets/bevel_button.dart';
import '../../core/widgets/common.dart';
import '../../core/widgets/confetti.dart';
import '../../core/widgets/game_icons.dart';
import '../../core/widgets/garden_background.dart';
import '../../core/widgets/pip.dart';
import '../../state/progress_cubit.dart';

/// "Garden Hero!" after L500.
class PhaseCompletePage extends StatelessWidget {
  const PhaseCompletePage({super.key});

  @override
  Widget build(BuildContext context) {
    final progress = context.watch<ProgressCubit>().state;
    final cfg = context.read<AppServices>().config;
    final maxStars = cfg.phaseLastLevel * 3;
    return Scaffold(
      body: GardenBackground(
        child: Stack(
          children: [
            const Positioned.fill(child: LeafConfetti(count: 80, duration: Duration(seconds: 4))),
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(Space.xl),
                  child: CreamCard(
                    padding: const EdgeInsets.all(Space.xl),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.emoji_events_rounded, size: 72, color: AppColors.coinGold),
                        Text('Garden Hero!', style: AppText.display),
                        const SizedBox(height: Space.sm),
                        Text('You freed every snake in Phase 1 (${cfg.phaseLastLevel} levels).', style: AppText.body, textAlign: TextAlign.center),
                        const SizedBox(height: Space.lg),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [const StarIcon(size: 28), const SizedBox(width: 6), Text('${fmt(progress.totalStars)} / ${fmt(maxStars)}', style: AppText.h1)],
                        ),
                        const Pip(pose: PipPose.wave, size: 140),
                        BevelButton.text(
                          cfg.maxPhase >= 2 ? 'Continue to L${cfg.phaseLastLevel + 1}' : 'Phase 2 coming soon',
                          expand: true,
                          onPressed: null,
                        ),
                        const SizedBox(height: Space.md),
                        Row(
                          children: [
                            Expanded(
                              child: BevelButton.text(
                                'Replay for ★★★',
                                style: BevelStyle.gold,
                                onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil(Routes.map, (r) => r.isFirst, arguments: 1),
                              ),
                            ),
                            const SizedBox(width: Space.md),
                            Expanded(
                              child: BevelButton.text('Home', style: BevelStyle.cream, onPressed: () => Navigator.of(context).popUntil((r) => r.isFirst)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
