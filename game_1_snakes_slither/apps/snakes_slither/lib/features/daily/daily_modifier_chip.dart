import 'package:flutter/material.dart';
import 'package:puzzle_core/slither_engine.dart';

import '../../app/theme/tokens.dart';
import '../../core/widgets/common.dart';
import '../../state/daily_cubit.dart';

class DailyModifierChip extends StatelessWidget {
  const DailyModifierChip({super.key, required this.modifier});
  final DailyModifier modifier;

  @override
  Widget build(BuildContext context) {
    final icon = switch (modifier) {
      DailyModifier.classic => Icons.eco_rounded,
      DailyModifier.parMoves => Icons.flag_rounded,
      DailyModifier.oneHeart => Icons.favorite_rounded,
      DailyModifier.bigBoard => Icons.grid_on_rounded,
    };
    return Chip2(modifier.title, icon: icon, color: modifier == DailyModifier.oneHeart ? AppColors.heart : AppColors.primary);
  }
}

String silhouetteName(Silhouette s) => switch (s) {
      Silhouette.butterfly => 'Butterfly',
      Silhouette.leaf => 'Leaf',
      Silhouette.turtle => 'Turtle',
      Silhouette.cloud => 'Cloud',
      Silhouette.egg => 'Snake Egg',
      Silhouette.mango => 'Mango',
      Silhouette.sun => 'Sun',
    };

/// Tiny preview of today's silhouette.
class SilhouettePreview extends StatelessWidget {
  const SilhouettePreview({super.key, required this.silhouette, this.size = 72});
  final Silhouette silhouette;
  final double size;

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: CustomPaint(size: Size.square(size), painter: _SilhouettePainter(silhouette.mask(11, 11))),
    );
  }
}

class _SilhouettePainter extends CustomPainter {
  _SilhouettePainter(this.mask);
  final Set<Cell> mask;

  @override
  void paint(Canvas canvas, Size s) {
    final cell = s.width / 11;
    canvas.drawRRect(RRect.fromRectAndRadius(Offset.zero & s, const Radius.circular(12)), Paint()..color = const Color(0xFFDCEFD8));
    final p = Paint()..color = AppColors.primary.withValues(alpha: 0.85);
    for (final c in mask) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(Rect.fromLTWH(c.x * cell, c.y * cell, cell, cell).deflate(0.8), Radius.circular(cell * 0.25)),
        p,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _SilhouettePainter old) => old.mask.length != mask.length;
}
