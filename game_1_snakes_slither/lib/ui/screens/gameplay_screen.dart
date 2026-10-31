import 'package:flutter/material.dart';

import '../../contracts/app_keys.dart';
import '../../contracts/view_models.dart';
import '../theme/tokens.dart';
import '../widgets/coin_pill.dart';
import '../widgets/heart_berries.dart';
import '../widgets/round_icon_button.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: AppKeys.gameplayScreen,
      backgroundColor: AppColors.bgSage,
      body: SafeArea(
        child: Column(
          children: [
            // 1. HUD (64 dp)
            _buildHud(context),

            // 2. Hammer target mode banner (when active)
            if (hammerMode) _buildHammerBanner(context),

            // 3. Board: occupies remaining space, unwrapped, centered
            Expanded(
              child: Center(
                child: board,
              ),
            ),

            // 4. Booster Bar (88 dp)
            _buildBoosterBar(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHud(BuildContext context) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: Space.gutter),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Pause button (min 48×48 tap area)
          RoundIconButton(
            key: AppKeys.pauseButton,
            icon: Icons.pause_rounded,
            onPressed: onPause,
            size: 44,
            label: 'Pause game',
            variant: RoundButtonVariant.cream,
          ),
          const SizedBox(width: Space.sm),

          // Level badge with optional Hard chip
          _buildLevelBadge(),

          const Spacer(),

          // Heart berries (with shield overlay)
          HeartBerries(
            hearts: hud.hearts,
            maxHearts: hud.maxHearts,
            shieldCharges: hud.shieldCharges,
          ),

          const Spacer(),

          // Coins and Moves
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              CoinPill(coins: hud.coins),
              const SizedBox(height: 2),
              Text(
                'Moves ${hud.moves}',
                style: AppText.caption.copyWith(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLevelBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.bgCream,
        borderRadius: BorderRadius.circular(Radii.pill),
        border: Border.all(color: AppColors.creamEdge, width: 1.5),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Lv ${hud.level}',
            style: AppText.h2.copyWith(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          if (hud.isHard) ...[
            const SizedBox(width: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.danger,
                borderRadius: BorderRadius.circular(Radii.xs),
              ),
              child: const Text(
                '🐾',
                style: TextStyle(fontSize: 10, height: 1.1),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildHammerBanner(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: Space.gutter, vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.bgCream,
        borderRadius: BorderRadius.circular(Radii.md),
        border: Border.all(color: const Color(0xFFFFB74D), width: 2),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1F000000),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('🔨', style: TextStyle(fontSize: 18)),
          const SizedBox(width: Space.sm),
          Expanded(
            child: Text(
              'Tap a snake or rock · Cancel',
              style: AppText.body.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          TextButton(
            key: AppKeys.hammerCancel,
            onPressed: onCancelHammer,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              backgroundColor: const Color(0xFFF0EAE1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Radii.sm),
              ),
            ),
            child: Text(
              'Cancel',
              style: AppText.button.copyWith(
                fontSize: 13,
                color: AppColors.danger,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBoosterBar(BuildContext context) {
    return Container(
      height: 88,
      padding: const EdgeInsets.symmetric(horizontal: Space.gutter, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          for (final b in boosters)
            _BoosterButtonItem(
              data: b,
              onTap: () {
                if (b.locked) return;
                if (b.capReached) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Limit for this try'),
                      duration: Duration(seconds: 2),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                  return;
                }
                if (!b.enabled) return;
                onBooster(b.booster);
              },
            ),
        ],
      ),
    );
  }
}

class _BoosterButtonItem extends StatefulWidget {
  const _BoosterButtonItem({
    required this.data,
    required this.onTap,
  });

  final BoosterButtonData data;
  final VoidCallback onTap;

  @override
  State<_BoosterButtonItem> createState() => _BoosterButtonItemState();
}

class _BoosterButtonItemState extends State<_BoosterButtonItem> {
  bool _pressed = false;

  static const _emoji = {
    Booster.hint: '🪲',
    Booster.shield: '🐚',
    Booster.hammer: '🔨',
  };

  static const _name = {
    Booster.hint: 'Hint',
    Booster.shield: 'Shield',
    Booster.hammer: 'Hammer',
  };

  @override
  Widget build(BuildContext context) {
    final b = widget.data;
    final isInteractive = !b.locked && (b.enabled || b.capReached);
    final isDimmed = !b.enabled && !b.locked && !b.capReached;
    final boosterName = _name[b.booster] ?? b.booster.name;

    final semanticsLabel = b.locked
        ? '$boosterName booster, locked until level ${b.unlockLevel}'
        : b.capReached
            ? '$boosterName booster, limit ${b.used} of ${b.cap} used'
            : '$boosterName booster, ${b.count} left';

    final translateY = (_pressed && isInteractive) ? 2.5 : 0.0;
    final lipHeight = (_pressed && isInteractive) ? 1.0 : 3.5;

    return Semantics(
      button: true,
      enabled: isInteractive,
      label: semanticsLabel,
      child: GestureDetector(
        key: AppKeys.booster(b.booster.name),
        onTapDown: isInteractive ? (_) => setState(() => _pressed = true) : null,
        onTapUp: isInteractive ? (_) => setState(() => _pressed = false) : null,
        onTapCancel: isInteractive ? () => setState(() => _pressed = false) : null,
        onTap: widget.onTap,
        behavior: HitTestBehavior.opaque,
        child: Opacity(
          opacity: (b.locked || isDimmed || b.capReached) ? 0.65 : 1.0,
          child: SizedBox(
            width: 68,
            height: 72,
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.topCenter,
              children: [
                // 3D Circular Button Base
                AnimatedContainer(
                  duration: const Duration(milliseconds: 60),
                  transform: Matrix4.translationValues(0, translateY, 0),
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: b.active
                          ? [const Color(0xFFFFF9C4), const Color(0xFFFFD54F)]
                          : b.locked
                              ? [const Color(0xFFECEFF1), const Color(0xFFCFD8DC)]
                              : [Colors.white, AppColors.bgCream],
                    ),
                    border: Border.all(
                      color: b.active ? AppColors.coinGold : Colors.white,
                      width: b.active ? 2.5 : 2.0,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: b.active
                            ? AppColors.coinGoldDark
                            : b.locked
                                ? const Color(0xFF90A4AE)
                                : AppColors.creamLip,
                        blurRadius: 0,
                        offset: Offset(0, lipHeight),
                      ),
                      if (!_pressed && !b.locked)
                        BoxShadow(
                          color: b.active
                              ? const Color(0x55F4B72F)
                              : const Color(0x18163B28),
                          blurRadius: b.active ? 8 : 4,
                          offset: const Offset(0, 3),
                        ),
                    ],
                  ),
                  child: Center(
                    child: b.locked
                        ? const Icon(Icons.lock_rounded, size: 24, color: Color(0xFF78909C))
                        : Text(
                            _emoji[b.booster] ?? '✨',
                            style: const TextStyle(fontSize: 26),
                          ),
                  ),
                ),

                // Badge (Count, Lock Level, or Cap State)
                Positioned(
                  bottom: 6 - translateY,
                  child: _buildBadge(b),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBadge(BoosterButtonData b) {
    if (b.locked) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: const Color(0xFF546E7A),
          borderRadius: BorderRadius.circular(Radii.pill),
          border: Border.all(color: Colors.white, width: 1.2),
        ),
        child: Text(
          'L${b.unlockLevel}',
          style: AppText.caption.copyWith(
            fontSize: 10,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
      );
    }

    if (b.capReached) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: const Color(0xFF78909C),
          borderRadius: BorderRadius.circular(Radii.pill),
          border: Border.all(color: Colors.white, width: 1.2),
        ),
        child: Text(
          '${b.used}/${b.cap}',
          style: AppText.caption.copyWith(
            fontSize: 10,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
      );
    }

    if (b.count == 0) {
      // Mini shop prompt "+'
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: AppColors.primaryLight,
          borderRadius: BorderRadius.circular(Radii.pill),
          border: Border.all(color: Colors.white, width: 1.2),
        ),
        child: Text(
          '+',
          style: AppText.caption.copyWith(
            fontSize: 11,
            fontWeight: FontWeight.w900,
            color: Colors.white,
          ),
        ),
      );
    }

    // Normal count badge
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: b.active ? AppColors.coinGold : AppColors.primary,
        borderRadius: BorderRadius.circular(Radii.pill),
        border: Border.all(color: Colors.white, width: 1.2),
        boxShadow: const [
          BoxShadow(
            color: Color(0x22000000),
            blurRadius: 3,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Text(
        '${b.count}',
        style: AppText.caption.copyWith(
          fontSize: 11,
          fontWeight: FontWeight.w800,
          color: Colors.white,
        ),
      ),
    );
  }
}
