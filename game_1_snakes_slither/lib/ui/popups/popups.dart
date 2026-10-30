// OWNER: UI agent. PLACEHOLDERS for every in-game popup. Keep each
// widget's constructor; redesign freely (you may split into one file each and
// re-export from here). Logic shows/hides them; widgets only call callbacks.
import 'dart:async';

import 'package:flutter/material.dart';

import '../../contracts/app_keys.dart';
import '../../contracts/view_models.dart';

class _Card extends StatelessWidget {
  const _Card({super.key, required this.children});
  final List<Widget> children;
  @override
  Widget build(BuildContext context) => Center(
    child: Card(
      margin: const EdgeInsets.all(24),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(mainAxisSize: MainAxisSize.min, children: children),
      ),
    ),
  );
}

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

  /// Logic asks for confirmation itself when moves > 0.
  final VoidCallback onRestart;
  final VoidCallback onMap;
  final VoidCallback onHome;
  final void Function(SettingKey) onToggle;

  @override
  Widget build(BuildContext context) => _Card(
    key: AppKeys.pausePopup,
    children: [
      const Text('⏸ Paused'),
      FilledButton(key: AppKeys.resume, onPressed: onResume, child: const Text('▶ Resume')),
      TextButton(key: AppKeys.restart, onPressed: onRestart, child: const Text('↻ Restart')),
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextButton(onPressed: onMap, child: const Text('🗺 Map')),
          TextButton(onPressed: onHome, child: const Text('🏠 Home')),
        ],
      ),
      SettingsList(settings: settings, onToggle: onToggle),
    ],
  );
}

/// Shared by Pause and the Home settings screen.
class SettingsList extends StatelessWidget {
  const SettingsList({super.key, required this.settings, required this.onToggle});
  final SettingsData settings;
  final void Function(SettingKey) onToggle;

  @override
  Widget build(BuildContext context) {
    Widget row(String label, SettingKey k, bool v) =>
        SwitchListTile(title: Text(label), value: v, onChanged: (_) => onToggle(k), dense: true);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        row('🔊 Sound', SettingKey.sound, settings.sound),
        row('🎵 Music', SettingKey.music, settings.music),
        row('📳 Haptics', SettingKey.haptics, settings.haptics),
        row('🎨 Colour-blind', SettingKey.colourBlind, settings.colourBlind),
        row('🐢 Reduce motion', SettingKey.reducedMotion, settings.reducedMotion),
        const Text('Progress is saved on this device only'),
      ],
    );
  }
}

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

  /// True while an ad or the shop is open: freeze the 10-second ring.
  final bool paused;
  final VoidCallback onWatchAd;
  final VoidCallback onRefill;

  /// Also call this when the countdown reaches 0.
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
    return _Card(
      key: AppKeys.secondChancePopup,
      children: [
        const Text('Pip needs a berry!'),
        Text('💔  $_left'),
        FilledButton(
          key: AppKeys.watchAd,
          onPressed: d.canWatchAd && !widget.paused ? widget.onWatchAd : null,
          child: Text(
            d.adUsedForLevel
                ? 'Used for this level'
                : d.adAvailable
                ? '🎬 Watch ad  +1 ♥'
                : 'Ad unavailable',
          ),
        ),
        FilledButton.tonal(
          key: AppKeys.refill,
          onPressed: d.canRefill && !widget.paused ? widget.onRefill : null,
          child: Text('🫐 ${d.refillCost} 🪙  +1 ♥ (${d.refillsLeft} left)'),
        ),
        TextButton(
          key: AppKeys.noThanks,
          onPressed: widget.onDecline,
          child: const Text('No thanks'),
        ),
      ],
    );
  }
}

class LevelFailedPopup extends StatelessWidget {
  const LevelFailedPopup({super.key, required this.onRetry, required this.onHome});
  final VoidCallback onRetry;
  final VoidCallback onHome;
  @override
  Widget build(BuildContext context) => _Card(
    key: AppKeys.failedPopup,
    children: [
      const Text('Oh no! 🐍💤'),
      const Text('The snakes got tangled'),
      FilledButton(key: AppKeys.retry, onPressed: onRetry, child: const Text('↻ Try again')),
      TextButton(onPressed: onHome, child: const Text('🏠 Home')),
      const Text('Tip: Hold a snake to preview its path.'),
    ],
  );
}

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

  /// Only shown when data.hasNext.
  final VoidCallback onNext;
  final VoidCallback onMap;

  @override
  Widget build(BuildContext context) => _Card(
    key: AppKeys.completePopup,
    children: [
      Text('🎉 Level ${data.level} Complete!'),
      Text('${'★' * data.stars}${'☆' * (3 - data.stars)}'),
      Text(
        '+${data.totalCoins} 🪙'
        '${data.starBonus > 0 ? '  (+${data.starBonus} ★★★ bonus)' : ''}',
      ),
      if (data.canDouble)
        FilledButton.tonal(
          key: AppKeys.claimDouble,
          onPressed: adBusy ? null : onDouble,
          child: Text('🎬 Claim 2X  (${data.clearCoins * 2} 🪙)'),
        ),
      if (data.hasNext)
        FilledButton(key: AppKeys.next, onPressed: onNext, child: const Text('Next ▶')),
      TextButton(onPressed: onMap, child: const Text('Map')),
    ],
  );
}

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

  @override
  Widget build(BuildContext context) => _Card(
    key: AppKeys.miniShop,
    children: [
      Text('Out of ${data.booster.name}  ·  🪙 ${data.coins}'),
      FilledButton(
        onPressed: data.coins >= data.singlePrice ? onBuySingle : null,
        child: Text('×1  for ${data.singlePrice} 🪙'),
      ),
      FilledButton(
        onPressed: data.coins >= data.packPrice ? onBuyPack : null,
        child: Text('×3  for ${data.packPrice} 🪙'),
      ),
      TextButton(onPressed: onClose, child: const Text('Close')),
    ],
  );
}

class GiftBasketPopup extends StatefulWidget {
  const GiftBasketPopup({super.key, required this.data, required this.onCollect});

  /// Rewards are already in the wallet; this is the reveal.
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
    return _Card(
      key: AppKeys.giftBasket,
      children: [
        Text(d.isChest ? '🏆 Jungle Treasure Chest!' : '🧺 Jungle Gift Basket!'),
        if (!_open)
          TextButton(
            onPressed: () => setState(() => _open = true),
            child: const Text('tap to open'),
          )
        else
          Text('+${d.coins} 🪙  $boosters'),
        FilledButton(
          key: AppKeys.giftCollect,
          onPressed: widget.onCollect,
          child: const Text('Collect'),
        ),
      ],
    );
  }
}
