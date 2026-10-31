// OWNER: UI agent. Complete in-game popups redesign using A1 design system widgets.
// Preserves all constructors and AppKeys.
import 'dart:async';
import 'package:flutter/material.dart';

import '../../contracts/app_keys.dart';
import '../../contracts/view_models.dart';
import '../theme/tokens.dart';
import '../widgets/bevel_button.dart';
import '../widgets/popup_card.dart';
import '../widgets/star_row.dart';

/// Pause popup with game actions and embedded settings list.
class PausePopup extends StatelessWidget {
  const PausePopup({
    super.key,
    required this.settings,
    required this.onResume,
    required this.onRestart,
    required this.onMap,
    required this.onHome,
    required this.onToggle,
  });

  final SettingsData settings;
  final VoidCallback onResume;
  final VoidCallback onRestart;
  final VoidCallback onMap;
  final VoidCallback onHome;
  final void Function(SettingKey) onToggle;

  @override
  Widget build(BuildContext context) {
    return PopupCard(
      key: AppKeys.pausePopup,
      title: '⏸ Paused',
      maxWidth: 360,
      onClose: onResume,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: Space.sm),
          // Resume (Primary 3D button)
          BevelButton.text(
            '▶ Resume',
            key: AppKeys.resume,
            onPressed: onResume,
            variant: BevelVariant.primary,
            expand: true,
          ),
          const SizedBox(height: Space.md),

          // Restart
          BevelButton.text(
            '↻ Restart',
            key: AppKeys.restart,
            onPressed: onRestart,
            variant: BevelVariant.secondary,
            expand: true,
          ),
          const SizedBox(height: Space.md),

          // Map & Home row
          Row(
            children: [
              Expanded(
                child: BevelButton.text(
                  '🗺 Map',
                  onPressed: onMap,
                  variant: BevelVariant.secondary,
                  height: 48,
                ),
              ),
              const SizedBox(width: Space.md),
              Expanded(
                child: BevelButton.text(
                  '🏠 Home',
                  onPressed: onHome,
                  variant: BevelVariant.secondary,
                  height: 48,
                ),
              ),
            ],
          ),
          const SizedBox(height: Space.lg),

          // Divider
          const Divider(height: 1, color: AppColors.creamEdge),
          const SizedBox(height: Space.sm),

          // Settings list
          SettingsList(settings: settings, onToggle: onToggle),
        ],
      ),
    );
  }
}

/// Settings toggles shared between Pause popup and Home settings page.
class SettingsList extends StatelessWidget {
  const SettingsList({
    super.key,
    required this.settings,
    required this.onToggle,
  });

  final SettingsData settings;
  final void Function(SettingKey) onToggle;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildToggle('🔊 Sound', SettingKey.sound, settings.sound),
        _buildToggle('🎵 Music', SettingKey.music, settings.music),
        _buildToggle('📳 Haptics', SettingKey.haptics, settings.haptics),
        _buildToggle('🎨 Colour-blind', SettingKey.colourBlind, settings.colourBlind),
        _buildToggle('🐢 Reduce motion', SettingKey.reducedMotion, settings.reducedMotion),
        const SizedBox(height: Space.sm),
        Text(
          'Progress is saved on this device only',
          style: AppText.caption.copyWith(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildToggle(String label, SettingKey key, bool value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppText.body.copyWith(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          Transform.scale(
            scale: 0.85,
            child: Switch(
              value: value,
              onChanged: (_) => onToggle(key),
              activeThumbColor: AppColors.primary,
              activeTrackColor: AppColors.primaryLight.withValues(alpha: 0.5),
              inactiveThumbColor: const Color(0xFFB0BEC5),
              inactiveTrackColor: const Color(0xFFECEFF1),
            ),
          ),
        ],
      ),
    );
  }
}

/// Second chance revive popup with 10-second countdown ring.
class SecondChancePopup extends StatefulWidget {
  const SecondChancePopup({
    super.key,
    required this.data,
    required this.paused,
    required this.onWatchAd,
    required this.onRefill,
    required this.onDecline,
  });

  final SecondChanceData data;
  final bool paused;
  final VoidCallback onWatchAd;
  final VoidCallback onRefill;
  final VoidCallback onDecline;

  static const countdown = Duration(seconds: 10);

  @override
  State<SecondChancePopup> createState() => _SecondChancePopupState();
}

class _SecondChancePopupState extends State<SecondChancePopup> {
  int _left = SecondChancePopup.countdown.inSeconds;
  Timer? _t;

  @override
  void initState() {
    super.initState();
    _t = Timer.periodic(const Duration(seconds: 1), (_) {
      if (widget.paused) return;
      if (!mounted) return;
      setState(() => _left--);
      if (_left <= 0) {
        _t?.cancel();
        widget.onDecline();
      }
    });
  }

  @override
  void dispose() {
    _t?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final d = widget.data;
    final progress = (_left / SecondChancePopup.countdown.inSeconds).clamp(0.0, 1.0);

    return PopupCard(
      key: AppKeys.secondChancePopup,
      title: 'Pip needs a berry!',
      maxWidth: 360,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: Space.sm),

          // Countdown Ring with Heart
          SizedBox(
            width: 90,
            height: 90,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 86,
                  height: 86,
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 6,
                    backgroundColor: const Color(0xFFECEFF1),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      _left <= 3 ? AppColors.danger : AppColors.primary,
                    ),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('💔', style: TextStyle(fontSize: 24)),
                    Text(
                      '$_left',
                      style: AppText.h2.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: _left <= 3 ? AppColors.danger : AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: Space.lg),

          // Rewarded Ad Option
          BevelButton.text(
            d.adUsedForLevel
                ? 'Used for this level'
                : d.adAvailable
                    ? '🎬 Watch ad  +1 ♥'
                    : 'Ad unavailable',
            key: AppKeys.watchAd,
            onPressed: d.canWatchAd && !widget.paused ? widget.onWatchAd : null,
            variant: BevelVariant.gold,
            expand: true,
          ),
          const SizedBox(height: Space.md),

          // Coin Refill Option
          BevelButton.text(
            '🫐 ${d.refillCost} 🪙  +1 ♥ (${d.refillsLeft} left)',
            key: AppKeys.refill,
            onPressed: d.canRefill && !widget.paused ? widget.onRefill : null,
            variant: BevelVariant.primary,
            expand: true,
          ),
          const SizedBox(height: Space.md),

          // Decline Button
          BevelButton.text(
            'No thanks',
            key: AppKeys.noThanks,
            onPressed: widget.onDecline,
            variant: BevelVariant.secondary,
            height: 46,
            expand: true,
          ),
        ],
      ),
    );
  }
}

/// Level failed screen with sad sleepy Pip.
class LevelFailedPopup extends StatelessWidget {
  const LevelFailedPopup({
    super.key,
    required this.onRetry,
    required this.onHome,
  });

  final VoidCallback onRetry;
  final VoidCallback onHome;

  @override
  Widget build(BuildContext context) {
    return PopupCard(
      key: AppKeys.failedPopup,
      title: 'Oh no! 🐍💤',
      maxWidth: 360,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: Space.sm),

          // Sleepy / Sad Pip visual
          Image.asset(
            'assets/images/sad.png',
            width: 100,
            height: 100,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) =>
                const Text('🐍💤', style: TextStyle(fontSize: 48)),
          ),
          const SizedBox(height: Space.md),

          Text(
            'The snakes got tangled',
            style: AppText.h2.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: Space.lg),

          // Try again primary button
          BevelButton.text(
            '↻ Try again',
            key: AppKeys.retry,
            onPressed: onRetry,
            variant: BevelVariant.primary,
            expand: true,
          ),
          const SizedBox(height: Space.md),

          // Home button
          BevelButton.text(
            '🏠 Home',
            onPressed: onHome,
            variant: BevelVariant.secondary,
            expand: true,
          ),
          const SizedBox(height: Space.lg),

          // Pro-tip card
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F7ED),
              borderRadius: BorderRadius.circular(Radii.sm),
              border: Border.all(color: const Color(0xFFD4EBD2), width: 1.2),
            ),
            child: Row(
              children: [
                const Text('💡', style: TextStyle(fontSize: 16)),
                const SizedBox(width: Space.sm),
                Expanded(
                  child: Text(
                    'Tip: Hold a snake to preview its path.',
                    style: AppText.caption.copyWith(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Level complete victory popup with animated stars and coin double claim.
class LevelCompletePopup extends StatelessWidget {
  const LevelCompletePopup({
    super.key,
    required this.data,
    required this.adBusy,
    required this.onDouble,
    required this.onNext,
    required this.onMap,
  });

  final LevelCompleteData data;
  final bool adBusy;
  final VoidCallback onDouble;
  final VoidCallback onNext;
  final VoidCallback onMap;

  @override
  Widget build(BuildContext context) {
    return PopupCard(
      key: AppKeys.completePopup,
      title: '🎉 Level ${data.level} Complete!',
      maxWidth: 380,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: Space.md),

          // Stars row (0–3 stars)
          StarRow(
            stars: data.stars,
            animate: true,
            size: 48,
          ),
          const SizedBox(height: Space.lg),

          // Coin breakdown banner
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF9E8),
              borderRadius: BorderRadius.circular(Radii.md),
              border: Border.all(color: const Color(0xFFFFE082), width: 1.5),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('🪙', style: TextStyle(fontSize: 22)),
                    const SizedBox(width: Space.sm),
                    Text(
                      '+${data.totalCoins}',
                      style: AppText.h1.copyWith(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
                if (data.starBonus > 0) ...[
                  const SizedBox(height: 2),
                  Text(
                    '(+${data.starBonus} ★★★ bonus)',
                    style: AppText.caption.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.coinGoldDark,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: Space.lg),

          // Claim 2X Rewarded Ad Button
          if (data.canDouble) ...[
            BevelButton.text(
              '🎬 Claim 2X  (${data.clearCoins * 2} 🪙)',
              key: AppKeys.claimDouble,
              onPressed: adBusy ? null : onDouble,
              variant: BevelVariant.gold,
              expand: true,
            ),
            const SizedBox(height: Space.md),
          ],

          // Next Level Button
          if (data.hasNext) ...[
            BevelButton.text(
              'Next ▶',
              key: AppKeys.next,
              onPressed: onNext,
              variant: BevelVariant.primary,
              expand: true,
            ),
            const SizedBox(height: Space.md),
          ],

          // Map button
          BevelButton.text(
            'Map',
            onPressed: onMap,
            variant: BevelVariant.secondary,
            height: 48,
            expand: true,
          ),
        ],
      ),
    );
  }
}

/// Mini booster purchase sheet when inventory is empty.
class MiniShopSheet extends StatelessWidget {
  const MiniShopSheet({
    super.key,
    required this.data,
    required this.onBuySingle,
    required this.onBuyPack,
    required this.onClose,
  });

  final MiniShopData data;
  final VoidCallback onBuySingle;
  final VoidCallback onBuyPack;
  final VoidCallback onClose;

  static const _emoji = {
    Booster.hint: '🪲✨',
    Booster.shield: '🐚',
    Booster.hammer: '🔨',
  };

  @override
  Widget build(BuildContext context) {
    final emoji = _emoji[data.booster] ?? '✨';

    return PopupCard(
      key: AppKeys.miniShop,
      title: 'Out of ${data.booster.name}',
      maxWidth: 360,
      onClose: onClose,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: Space.sm),

          // Current coins banner
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                emoji,
                style: const TextStyle(fontSize: 32),
              ),
              const SizedBox(width: Space.md),
              Text(
                'Balance: 🪙 ${data.coins}',
                style: AppText.h2.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: Space.lg),

          // Buy x1
          BevelButton.text(
            '×1  for ${data.singlePrice} 🪙',
            onPressed: data.coins >= data.singlePrice ? onBuySingle : null,
            variant: BevelVariant.primary,
            expand: true,
          ),
          const SizedBox(height: Space.md),

          // Buy x3 Pack
          BevelButton.text(
            '×3  for ${data.packPrice} 🪙',
            onPressed: data.coins >= data.packPrice ? onBuyPack : null,
            variant: BevelVariant.gold,
            expand: true,
          ),
          const SizedBox(height: Space.md),

          // Close button
          BevelButton.text(
            'Close',
            onPressed: onClose,
            variant: BevelVariant.secondary,
            height: 46,
            expand: true,
          ),
        ],
      ),
    );
  }
}

/// Jungle gift basket / milestone chest reveal popup.
class GiftBasketPopup extends StatefulWidget {
  const GiftBasketPopup({
    super.key,
    required this.data,
    required this.onCollect,
  });

  final GiftBasketData data;
  final VoidCallback onCollect;

  @override
  State<GiftBasketPopup> createState() => _GiftBasketPopupState();
}

class _GiftBasketPopupState extends State<GiftBasketPopup> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    final d = widget.data;
    final boosters = d.boosters.entries.map((e) => '+${e.value} ${e.key.name}').join('  ');

    return PopupCard(
      key: AppKeys.giftBasket,
      title: d.isChest ? '🏆 Jungle Treasure Chest!' : '🧺 Jungle Gift Basket!',
      maxWidth: 360,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: Space.sm),

          // Basket visual
          Text(
            d.isChest ? (_open ? '👑' : '🏆') : (_open ? '✨' : '🧺'),
            style: const TextStyle(fontSize: 64),
          ),
          const SizedBox(height: Space.md),

          if (!_open)
            BevelButton.text(
              'Tap to Open',
              onPressed: () => setState(() => _open = true),
              variant: BevelVariant.gold,
              expand: true,
            )
          else ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF9E8),
                borderRadius: BorderRadius.circular(Radii.md),
                border: Border.all(color: const Color(0xFFFFE082), width: 1.5),
              ),
              child: Text(
                '+${d.coins} 🪙  $boosters',
                style: AppText.h2.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            if (d.isChest) ...[
              const SizedBox(height: Space.sm),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.vipPurple,
                  borderRadius: BorderRadius.circular(Radii.pill),
                  border: Border.all(color: Colors.white, width: 1.5),
                ),
                child: const Text(
                  '🏅 Garden Hero Badge Unlocked',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
            const SizedBox(height: Space.lg),
            BevelButton.text(
              'Collect',
              key: AppKeys.giftCollect,
              onPressed: widget.onCollect,
              variant: BevelVariant.primary,
              expand: true,
            ),
          ],
        ],
      ),
    );
  }
}
