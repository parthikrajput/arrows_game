// OWNER: UI agent. Canvas: Play.dc.html (LevelPlay, LevelHard, Hint, Hammer).
// [board] is a ready-made widget: placed in the remaining space, never wrapped
// in gesture detectors.
import 'package:flutter/material.dart';

import '../../contracts/app_keys.dart';
import '../../contracts/view_models.dart';
import '../theme/tokens.dart';
import '../widgets/art.dart';
import '../widgets/common.dart';

class GameplayScreen extends StatelessWidget {
  const GameplayScreen({
    super.key,
    required this.hud,
    required this.boosters,
    required this.board,
    required this.hammerMode,
    required this.onPause,
    required this.onBooster,
    required this.onCancelHammer,
    this.banner,
    this.bannerHeight = 0,
  });

  final HudData hud;

  /// Always Hint, Shield, Hammer in that order.
  final List<BoosterButtonData> boosters;
  final Widget board;

  /// Show the banner "Tap a snake or rock · Cancel".
  final bool hammerMode;
  final VoidCallback onPause;
  final void Function(Booster b) onBooster;
  final VoidCallback onCancelHammer;

  /// Adaptive banner (L11+, no VIP). Its height is reserved even before the
  /// ad loads, so the board never jumps.
  final Widget? banner;
  final double bannerHeight;

  @override
  Widget build(BuildContext context) => Scaffold(
    key: AppKeys.gameplayScreen,
    backgroundColor: AppColors.grass,
    body: DecoratedBox(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: const Alignment(0, -.4),
          radius: 1.2,
          colors: hud.isHard
              ? const [Color(0xFF4E9A36), Color(0xFF2F7424), Color(0xFF1C5418)]
              : const [Color(0xFF5FAE3F), Color(0xFF3C8A2E), Color(0xFF23661F)],
          stops: const [0, .55, 1],
        ),
      ),
      child: Stack(
        children: [
          const Positioned(
            left: 0,
            right: 0,
            top: 0,
            height: 150,
            child: IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0x80032312), Color(0x00032312)],
                  ),
                ),
              ),
            ),
          ),
          SafeArea(
            child: CenteredColumn(
              child: Column(
                children: [
                  _Hud(hud: hud, onPause: onPause),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                    child: AnimatedSwitcher(
                      duration: AppMotion.base,
                      child: hammerMode
                          ? _HammerBanner(onCancel: onCancelHammer)
                          : Row(
                              key: const ValueKey('goals'),
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (hud.gemsLeft != null)
                                  _GoalChip(
                                    key: AppKeys.hudGems,
                                    color: const Color(0xFF26C6DA),
                                    icon: Icons.diamond_rounded,
                                    text: '${hud.gemsLeft}',
                                    label: '${hud.gemsLeft} gems left',
                                  ),
                                Flexible(
                                  child: Text(
                                    'Tap a snake to slide it out',
                                    overflow: TextOverflow.ellipsis,
                                    style: AppText.nunito(12, color: const Color(0xEBFFFFFF)).copyWith(
                                      shadows: const [
                                        Shadow(color: Color(0x66000000), offset: Offset(0, 1), blurRadius: 2),
                                      ],
                                    ),
                                  ),
                                ),
                                if (hud.mongooseHp != null)
                                  _GoalChip(
                                    key: AppKeys.hudMongoose,
                                    color: AppColors.hardRed,
                                    icon: Icons.favorite_rounded,
                                    text: 'HP ${hud.mongooseHp}',
                                    label: 'Mongoose HP ${hud.mongooseHp}',
                                  ),
                              ],
                            ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Center(child: board),
                    ),
                  ),
                  SizedBox(
                    height: 128,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 14),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          for (final b in boosters) ...[
                            if (b != boosters.first) const SizedBox(width: 12),
                            Flexible(
                              child: _Highlight(
                                on: b.highlight,
                                radius: 22,
                                child: _BoosterCard(data: b, onTap: () => onBooster(b.booster)),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  if (bannerHeight > 0) ...[
                    // ≥ 8 dp gap and a divider between the boosters and the ad.
                    const SizedBox(height: 4),
                    const Divider(height: 4, thickness: 1, color: Color(0x33FFFFFF)),
                    SizedBox(height: bannerHeight, child: banner ?? const SizedBox.shrink()),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

/// Pulsing gold ring a tutorial puts around a HUD part or booster.
class _Highlight extends StatefulWidget {
  const _Highlight({required this.on, required this.child, this.radius = 16});
  final bool on;
  final Widget child;
  final double radius;
  @override
  State<_Highlight> createState() => _HighlightState();
}

class _HighlightState extends State<_Highlight> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 1100));

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _sync();
  }

  @override
  void didUpdateWidget(_Highlight old) {
    super.didUpdateWidget(old);
    _sync();
  }

  void _sync() {
    if (widget.on && !AppMotion.reduced(context)) {
      if (!_c.isAnimating) _c.repeat(reverse: true);
    } else {
      _c.stop();
      _c.value = widget.on ? 1 : 0;
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => !widget.on
      ? widget.child
      : AnimatedBuilder(
          animation: _c,
          builder: (_, child) => DecoratedBox(
            position: DecorationPosition.foreground,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(widget.radius),
              border: Border.all(color: AppColors.gold.withValues(alpha: .55 + .45 * _c.value), width: 3),
              boxShadow: [BoxShadow(color: AppColors.gold.withValues(alpha: .45 * _c.value), blurRadius: 12)],
            ),
            child: child,
          ),
          child: widget.child,
        );
}

class _GoalChip extends StatelessWidget {
  const _GoalChip({super.key, required this.color, required this.icon, required this.text, required this.label});
  final Color color;
  final IconData icon;
  final String text;
  final String label;
  @override
  Widget build(BuildContext context) => Semantics(
    label: label,
    child: Container(
      margin: const EdgeInsets.symmetric(horizontal: 6),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: _pill(12),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(text, style: AppText.fredoka(13, color: Colors.white)),
        ],
      ),
    ),
  );
}

BoxDecoration _pill(double r) => BoxDecoration(
  color: AppColors.hudPill,
  borderRadius: BorderRadius.circular(r),
  border: Border.all(color: const Color(0x29FFFFFF)),
  boxShadow: AppShadows.hud,
);

class _Hud extends StatelessWidget {
  const _Hud({required this.hud, required this.onPause});
  final HudData hud;
  final VoidCallback onPause;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
    child: SizedBox(
      height: 50,
      child: Row(
        children: [
          Pressable(
            key: AppKeys.pauseButton,
            onTap: onPause,
            semanticLabel: 'Pause',
            child: Container(
              width: 50,
              height: 50,
              alignment: Alignment.center,
              decoration: _pill(25),
              child: const LineIconView(LineIcon.pause, size: 20, color: Colors.white),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _Highlight(
              on: hud.highlightMoves,
              radius: 14,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: _pill(14),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FittedBox(
                      child: Row(
                        children: [
                          Text(
                            'LEVEL ${hud.level}',
                            style: AppText.nunito(11, color: const Color(0xFFFFD84A), spacing: .6),
                          ),
                          if (hud.isHard) ...[
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                              decoration: BoxDecoration(
                                color: AppColors.hardRed,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text('HARD', style: AppText.nunito(10, color: Colors.white, spacing: .5)),
                            ),
                          ],
                        ],
                      ),
                    ),
                    FittedBox(
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: '${hud.moves} ',
                              style: AppText.fredoka(20, color: Colors.white, height: 1),
                            ),
                            TextSpan(
                              text: 'moves',
                              style: AppText.fredoka(13, color: const Color(0xBFFFFFFF), height: 1),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (hud.showHearts) const SizedBox(width: 8),
          if (hud.showHearts)
            _Highlight(
              on: hud.highlightHearts,
              radius: 14,
              child: Semantics(
                label:
                    '${hud.hearts} of ${hud.maxHearts} hearts${hud.shieldCharges > 0 ? ', shell shield ${hud.shieldCharges}' : ''}',
                child: Container(
                  height: 50,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: _pill(14),
                  child: Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.center,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          for (var i = 0; i < hud.maxHearts; i++)
                            Padding(
                              padding: EdgeInsets.only(left: i == 0 ? 0 : 3),
                              child: AnimatedSwitcher(
                                duration: AppMotion.base,
                                transitionBuilder: (c, a) => ScaleTransition(scale: a, child: c),
                                child: ArtIcon(
                                  i < hud.hearts ? Art.heart : Art.heartEmpty,
                                  key: ValueKey(i < hud.hearts),
                                  size: 20,
                                ),
                              ),
                            ),
                        ],
                      ),
                      if (hud.shieldCharges > 0)
                        Positioned(
                          right: -16,
                          top: -6,
                          child: Container(
                            height: 24,
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFF3D6),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: const Color(0xFFE0A33A), width: 2),
                              boxShadow: const [
                                BoxShadow(color: Color(0x40000000), offset: Offset(0, 2), blurRadius: 4),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const ArtIcon(Art.shell, size: 14),
                                Text(
                                  '${hud.shieldCharges}',
                                  style: AppText.fredoka(12, color: const Color(0xFF8A4A10)),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          const SizedBox(width: 8),
          Container(
            height: 50,
            padding: const EdgeInsets.only(left: 8, right: 10),
            decoration: _pill(14),
            child: Row(
              children: [
                const ArtIcon(Art.coin, size: 22),
                const SizedBox(width: 5),
                Text(fmt(hud.coins), style: AppText.fredoka(16, color: Colors.white)),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

class _HammerBanner extends StatelessWidget {
  const _HammerBanner({required this.onCancel});
  final VoidCallback onCancel;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.fromLTRB(16, 6, 6, 6),
    decoration: BoxDecoration(
      color: const Color(0xC704341E),
      borderRadius: BorderRadius.circular(22),
      border: Border.all(color: const Color(0x38FFFFFF)),
      boxShadow: const [BoxShadow(color: Color(0x40000000), offset: Offset(0, 8), blurRadius: 18)],
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const ArtIcon(Art.hammer, size: 24),
        const SizedBox(width: 8),
        Text('Tap a snake or rock', style: AppText.fredoka(16, color: Colors.white)),
        const SizedBox(width: 10),
        Pressable(
          key: AppKeys.hammerCancel,
          onTap: onCancel,
          semanticLabel: 'Cancel hammer',
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.secondary,
              borderRadius: BorderRadius.circular(14),
              boxShadow: const [BoxShadow(color: AppColors.secondaryLip, offset: Offset(0, 2))],
            ),
            child: Text('Cancel', style: AppText.nunito(13)),
          ),
        ),
      ],
    ),
  );
}

class _BoosterCard extends StatelessWidget {
  const _BoosterCard({required this.data, required this.onTap});
  final BoosterButtonData data;
  final VoidCallback onTap;

  static String name(Booster b) => switch (b) {
    Booster.hint => 'Firefly',
    Booster.shield => 'Shell',
    Booster.hammer => 'Hammer',
  };

  @override
  Widget build(BuildContext context) {
    final b = data;
    final tappable = !b.locked && b.enabled;
    final buy = !b.locked && !b.capReached && b.count == 0;
    return Pressable(
      key: AppKeys.booster(b.booster.name),
      onTap: tappable ? onTap : null,
      semanticLabel: b.locked
          ? '${name(b.booster)}, opens at level ${b.unlockLevel}'
          : b.capReached
          ? '${name(b.booster)}, used ${b.used} of ${b.cap}'
          : buy
          ? '${name(b.booster)}, buy more'
          : '${name(b.booster)}, ${b.count} left',
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 98),
        child: Opacity(
          opacity: b.locked ? .82 : (!b.enabled && !b.active ? .7 : 1),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              AnimatedContainer(
                duration: AppMotion.base,
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.cardBorder),
                  boxShadow: b.active
                      ? const [
                          BoxShadow(color: Color(0xFFFFE066), spreadRadius: 3),
                          BoxShadow(color: Color(0x40000000), offset: Offset(0, 8), blurRadius: 18),
                        ]
                      : const [
                          BoxShadow(color: AppColors.secondaryLip, offset: Offset(0, 4)),
                          BoxShadow(color: Color(0x2E000000), offset: Offset(0, 8), blurRadius: 16),
                        ],
                ),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(child: ArtIcon(ArtIcon.booster(b.booster), size: 54, dim: b.locked)),
                      const SizedBox(height: 4),
                      Text(name(b.booster), style: AppText.fredoka(14)),
                    ],
                  ),
                ),
              ),
              if (b.locked)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(color: const Color(0x8C163B28), borderRadius: BorderRadius.circular(20)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const LineIconView(LineIcon.lock, size: 22, color: Colors.white),
                        const SizedBox(height: 2),
                        Text('Opens at L${b.unlockLevel}', style: AppText.nunito(12, color: Colors.white)),
                      ],
                    ),
                  ),
                )
              else
                Positioned(
                  top: -8,
                  right: -6,
                  child: _Badge(
                    text: b.capReached
                        ? '${b.used}/${b.cap}'
                        : buy
                        ? '+ Buy'
                        : '${b.count}',
                    gold: buy,
                    grey: b.capReached,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.text, this.gold = false, this.grey = false});
  final String text;
  final bool gold;
  final bool grey;
  @override
  Widget build(BuildContext context) => Container(
    constraints: const BoxConstraints(minWidth: 26),
    height: 26,
    padding: const EdgeInsets.symmetric(horizontal: 7),
    alignment: Alignment.center,
    decoration: BoxDecoration(
      gradient: grey
          ? const LinearGradient(colors: [Color(0xFF9AA59D), Color(0xFF7D8C80)])
          : gold
          ? kGoldButton
          : const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [AppColors.emeraldLight, AppColors.emerald],
            ),
      borderRadius: BorderRadius.circular(13),
      border: Border.all(color: AppColors.card, width: 2),
      boxShadow: [
        BoxShadow(
          color: gold
              ? AppColors.goldLip
              : grey
              ? const Color(0xFF5B6B5F)
              : AppColors.lip,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Text(
      text,
      style: gold ? AppText.nunito(12, color: const Color(0xFF5A3A00)) : AppText.fredoka(13, color: Colors.white),
    ),
  );
}
