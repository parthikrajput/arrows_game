import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:puzzle_core/slither_engine.dart';

import '../../../app/theme/text_styles.dart';
import '../../../app/theme/tokens.dart';
import '../../../core/widgets/bevel_button.dart';
import '../../../core/widgets/common.dart';
import '../../../core/widgets/game_icons.dart';
import '../../../services/remote_config.dart';
import '../bloc/game_bloc.dart';

class GameHud extends StatelessWidget {
  const GameHud({super.key, required this.onPause, this.title, this.chip});
  final VoidCallback onPause;
  final String? title;
  final Widget? chip;

  @override
  Widget build(BuildContext context) {
    final s = context.watch<GameBloc>().state;
    return SizedBox(
      height: 64,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Space.gutter),
        child: Row(
          children: [
            RoundIconButton(icon: Icons.pause_rounded, label: 'Pause', onPressed: onPause),
            const SizedBox(width: Space.md),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title ?? (s.mode.isDaily ? 'Daily' : 'Level ${s.mode.level}'),
                    style: AppText.h2.copyWith(height: 1.1),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  ?chip,
                ],
              ),
            ),
            HeartsRow(hearts: s.hearts, max: s.maxHearts, shield: s.shieldCharges),
            const SizedBox(width: Space.sm),
            const CoinPill(showPlus: false),
          ],
        ),
      ),
    );
  }
}

class HeartsRow extends StatelessWidget {
  const HeartsRow({super.key, required this.hearts, required this.max, required this.shield});
  final int hearts;
  final int max;
  final int shield;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '$hearts of $max heart berries${shield > 0 ? ', shield $shield' : ''}',
      child: ExcludeSemantics(
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (var i = 0; i < max; i++)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 1),
                    child: AnimatedSwitcher(
                      duration: Motion.base,
                      transitionBuilder: (c, a) => ScaleTransition(
                        scale: Tween(begin: 1.6, end: 1.0).animate(CurvedAnimation(parent: a, curve: Curves.elasticOut)),
                        child: FadeTransition(opacity: a, child: c),
                      ),
                      child: HeartBerryIcon(key: ValueKey('h$i-${i < hearts}'), size: 26, empty: i >= hearts),
                    ),
                  ),
              ],
            ),
            AnimatedScale(
              scale: shield > 0 ? 1 : 0,
              duration: Motion.base,
              curve: shield > 0 ? Curves.easeOutBack : Curves.easeIn,
              child: Padding(
                padding: const EdgeInsets.only(top: 18),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const BoosterIcon(BoosterType.shield, size: 26),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      decoration: BoxDecoration(color: const Color(0xFFE65100), borderRadius: BorderRadius.circular(8)),
                      child: Text('$shield', style: AppText.caption.copyWith(color: Colors.white, fontWeight: FontWeight.w900)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// "Moves 7" or "Moves 7 / par 9" on Tuesday.
class MovesLabel extends StatelessWidget {
  const MovesLabel({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.watch<GameBloc>().state;
    final par = s.def.parMoves;
    final over = par != null && s.moves > par;
    return Padding(
      padding: const EdgeInsets.only(bottom: Space.xs),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
            decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.7), borderRadius: BorderRadius.circular(Radii.pill)),
            child: Text(
              par == null ? 'Moves ${s.moves}' : 'Moves ${s.moves} / par $par',
              style: AppText.caption.copyWith(fontWeight: FontWeight.w800, color: over ? AppColors.danger : AppColors.textSecondary),
            ),
          ),
          const SizedBox(width: Space.sm),
          Text('${s.snakesLeft} left', style: AppText.caption.copyWith(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

String levelTagLabel(LevelTag t) => switch (t) {
      LevelTag.hard => 'Hard',
      LevelTag.finale => 'Finale',
      _ => '',
    };
