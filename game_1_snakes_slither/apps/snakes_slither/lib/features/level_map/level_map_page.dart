import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../app/routes.dart';
import '../../app/services.dart';
import '../../app/theme/text_styles.dart';
import '../../app/theme/tokens.dart';
import '../../core/widgets/bevel_button.dart';
import '../../core/widgets/common.dart';
import '../../core/widgets/game_icons.dart';
import '../../core/widgets/pip.dart';
import '../../state/progress_cubit.dart';
import '../gameplay/view/gameplay_page.dart';
import '../rush/rush_page.dart';

class Biome {
  const Biome(this.name, this.from, this.to, this.color);
  final String name;
  final int from;
  final int to;
  final Color color;
}

const biomes = [
  Biome("Pip's Backyard", 1, 10, Color(0xFFA5D6A7)),
  Biome('Garden Meadow', 11, 100, Color(0xFF9CCC65)),
  Biome('Bamboo Grove', 101, 200, Color(0xFF81C784)),
  Biome('Mango Orchard', 201, 300, Color(0xFFFFCC80)),
  Biome('Misty Swamp', 301, 400, Color(0xFF80CBC4)),
  Biome('Moonlit Jungle', 401, 500, Color(0xFF9FA8DA)),
];

Biome biomeOf(int level) => biomes.firstWhere((b) => level <= b.to, orElse: () => biomes.last);

/// Winding vine path through the biomes, level 1 at the bottom.
class LevelMapPage extends StatefulWidget {
  const LevelMapPage({super.key, this.focusLevel});
  final int? focusLevel;

  @override
  State<LevelMapPage> createState() => _LevelMapPageState();
}

class _LevelMapPageState extends State<LevelMapPage> {
  static const double _rowH = 92;
  static const int _total = 500;
  late final ScrollController _scroll;
  int _visibleBiome = 1;

  double _offsetFor(int level, double viewport) => math.max(0, (level - 1) * _rowH - viewport / 2 + _rowH / 2);

  @override
  void initState() {
    super.initState();
    final focus = widget.focusLevel ?? context.read<ProgressCubit>().state.nextLevel;
    _visibleBiome = focus;
    _scroll = ScrollController(initialScrollOffset: _offsetFor(focus, 600))..addListener(_onScroll);
  }

  void _onScroll() {
    final level = ((_scroll.offset + 300) / _rowH).floor() + 1;
    if (biomeOf(level) != biomeOf(_visibleBiome)) setState(() => _visibleBiome = level);
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  void _jumpToCurrent() {
    final level = context.read<ProgressCubit>().state.nextLevel;
    _scroll.animateTo(
      _offsetFor(level, _scroll.position.viewportDimension),
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final progress = context.watch<ProgressCubit>().state;
    final biome = biomeOf(_visibleBiome);
    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 600),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color.lerp(biome.color, Colors.white, 0.55)!, biome.color],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              HubHeader(title: biome.name),
              if (progress.rushPendingLevel != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Space.gutter),
                  child: BevelButton.text(
                    'Your Rush is waiting!',
                    expand: true,
                    style: BevelStyle.gold,
                    icon: Icons.bolt_rounded,
                    height: 48,
                    onPressed: () => Navigator.of(context).push(rushRoute(progress.rushPendingLevel!)),
                  ),
                ),
              Expanded(
                child: Stack(
                  children: [
                    LayoutBuilder(
                      builder: (context, c) => ListView.builder(
                        controller: _scroll,
                        reverse: true,
                        itemExtent: _rowH,
                        itemCount: _total,
                        // Bottom room so the "Current" button never covers level 1.
                        padding: const EdgeInsets.only(top: Space.xl, bottom: 96),
                        itemBuilder: (_, i) => _NodeRow(level: i + 1, width: c.maxWidth, progress: progress),
                      ),
                    ),
                    Positioned(
                      right: Space.gutter,
                      bottom: Space.gutter,
                      child: FloatingActionButton.extended(
                        heroTag: 'jump',
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        onPressed: _jumpToCurrent,
                        icon: const Icon(Icons.my_location_rounded),
                        label: const Text('Current'),
                      ),
                    ),
                  ],
                ),
              ),
              const BannerSlot(),
            ],
          ),
        ),
      ),
    );
  }
}

class _NodeRow extends StatelessWidget {
  const _NodeRow({required this.level, required this.width, required this.progress});
  final int level;
  final double width;
  final ProgressState progress;

  static double xFor(int level, double width) => width / 2 + math.sin(level * 0.9) * (width * 0.28);

  @override
  Widget build(BuildContext context) {
    final x = xFor(level, width);
    final nextX = xFor(level + 1, width);
    final biome = biomeOf(level);
    final biomeStart = level == biome.from;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Vine to the next node (drawn upward since the list is reversed).
        if (level < 500)
          Positioned.fill(
            child: CustomPaint(painter: _VinePainter(from: Offset(x, _LevelMapPageState._rowH / 2), to: Offset(nextX, -_LevelMapPageState._rowH / 2), done: level <= progress.highestCleared)),
          ),
        if (biomeStart)
          Positioned(
            left: Space.gutter,
            bottom: 4,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.85), borderRadius: BorderRadius.circular(Radii.pill)),
              child: Text(biome.name, style: AppText.caption.copyWith(fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
            ),
          ),
        Positioned(
          left: x - 34,
          top: (_LevelMapPageState._rowH - 68) / 2,
          child: _LevelNode(level: level, progress: progress),
        ),
      ],
    );
  }
}

class _VinePainter extends CustomPainter {
  _VinePainter({required this.from, required this.to, required this.done});
  final Offset from;
  final Offset to;
  final bool done;

  @override
  void paint(Canvas canvas, Size size) {
    final mid = Offset((from.dx + to.dx) / 2 + 20, (from.dy + to.dy) / 2);
    final path = Path()
      ..moveTo(from.dx, from.dy)
      ..quadraticBezierTo(mid.dx, mid.dy, to.dx, to.dy);
    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 10
        ..strokeCap = StrokeCap.round
        ..color = done ? const Color(0xFF558B2F) : Colors.white.withValues(alpha: 0.6),
    );
    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..color = done ? const Color(0xFF9CCC65) : Colors.white,
    );
  }

  @override
  bool shouldRepaint(covariant _VinePainter old) => old.done != done || old.from != from || old.to != to;
}

class _LevelNode extends StatelessWidget {
  const _LevelNode({required this.level, required this.progress});
  final int level;
  final ProgressState progress;

  @override
  Widget build(BuildContext context) {
    final cleared = progress.stars.containsKey(level);
    final current = level == progress.nextLevel && !cleared;
    final locked = !progress.isUnlocked(level);
    final hard = level % 10 == 9;
    final gift = level % 10 == 0 && level < 500;
    final finale = level == 500;
    final stars = progress.starsOf(level);
    final fill = locked
        ? const Color(0xFFBDBDBD)
        : hard
            ? const Color(0xFFE57373)
            : current
                ? AppColors.coinGold
                : AppColors.primaryLight;
    final label = 'Level $level${locked ? ', locked' : ''}${cleared ? ', $stars stars' : ''}${hard ? ', hard' : ''}';
    return Semantics(
      button: !locked,
      label: label,
      child: GestureDetector(
        onTap: locked ? () => showToast(context, 'Clear level ${level - 1} first') : () => showLevelStartSheet(context, level),
        child: SizedBox(
          width: 68,
          height: 68,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              if (current) const _Pulse(),
              Container(
                width: finale ? 64 : 56,
                height: finale ? 64 : 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(center: const Alignment(-0.3, -0.4), colors: [Color.lerp(fill, Colors.white, 0.5)!, fill]),
                  border: Border.all(color: Colors.white, width: 3),
                  boxShadow: [BoxShadow(color: Color.lerp(fill, Colors.black, 0.35)!, offset: const Offset(0, 4))],
                ),
                alignment: Alignment.center,
                child: ExcludeSemantics(
                  child: locked
                      ? const Icon(Icons.lock_rounded, color: Colors.white)
                      : finale
                          ? const Icon(Icons.castle_rounded, color: Colors.white, size: 30)
                          : Text('$level', style: AppText.h2.copyWith(color: Colors.white, fontSize: level >= 100 ? 17 : 20, shadows: const [Shadow(blurRadius: 2)])),
                ),
              ),
              if (cleared)
                Positioned(
                  bottom: -8,
                  child: Row(children: [for (var i = 0; i < 3; i++) StarIcon(size: 16, filled: i < stars)]),
                ),
              if (gift && !cleared) const Positioned(right: -6, top: -6, child: Icon(Icons.card_giftcard_rounded, color: Color(0xFFD81B60), size: 22)),
              if (hard && !locked) const Positioned(left: -6, top: -6, child: Icon(Icons.pets_rounded, color: Color(0xFFC62828), size: 20)),
              if (current) const Positioned(right: -36, child: Pip(size: 40, animate: false)),
            ],
          ),
        ),
      ),
    );
  }
}

class _Pulse extends StatefulWidget {
  const _Pulse();

  @override
  State<_Pulse> createState() => _PulseState();
}

class _PulseState extends State<_Pulse> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 1400))..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).disableAnimations) return const SizedBox.shrink();
    return AnimatedBuilder(
      animation: _c,
      builder: (_, _) => Container(
        width: 56 + _c.value * 26,
        height: 56 + _c.value * 26,
        decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.coinGold.withValues(alpha: 0.5 * (1 - _c.value))),
      ),
    );
  }
}

Future<void> showLevelStartSheet(BuildContext context, int level) {
  final s = context.read<AppServices>();
  final progress = context.read<ProgressCubit>().state;
  final best = progress.starsOf(level);
  final hard = level % 10 == 9;
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: AppColors.bgCream,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(Radii.lg))),
    builder: (ctx) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(Space.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Level $level', style: AppText.display),
            Text(biomeOf(level).name, style: AppText.caption),
            const SizedBox(height: Space.md),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [for (var i = 0; i < 3; i++) Padding(padding: const EdgeInsets.all(4), child: StarIcon(size: 36, filled: i < best))],
            ),
            if (hard) ...[const SizedBox(height: Space.sm), const Chip2('Hard level', color: AppColors.danger, icon: Icons.pets_rounded)],
            if (best == 0 && level % 10 == 0 && level < s.config.phaseLastLevel)
              Padding(padding: const EdgeInsets.only(top: Space.sm), child: Text('A Jungle Gift Basket waits here!', style: AppText.bodyBold)),
            const SizedBox(height: Space.xl),
            BevelButton.text(
              best > 0 ? 'Replay' : 'Play',
              expand: true,
              icon: Icons.play_arrow_rounded,
              logId: 'map.play',
              onPressed: () {
                Navigator.pop(ctx);
                Navigator.of(context).pushNamed(Routes.play, arguments: GameArgs.level(level));
              },
            ),
          ],
        ),
      ),
    ),
  );
}
