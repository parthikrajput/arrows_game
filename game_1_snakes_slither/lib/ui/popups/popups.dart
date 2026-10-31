// OWNER: UI agent. Canvas: Pause, SecondChance, Failed, Complete, MiniShop,
// Gift, Chest. Logic shows/hides them over a scrim; widgets only call callbacks.
import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../contracts/app_keys.dart';
import '../../contracts/ui_feedback.dart';
import '../../contracts/view_models.dart';
import '../screens/settings_screen.dart';
import '../theme/tokens.dart';
import '../widgets/art.dart';
import '../widgets/common.dart';

String boosterName(Booster b) => switch (b) {
  Booster.hint => 'Glow Firefly',
  Booster.shield => 'Safety Shell',
  Booster.hammer => 'Magic Hammer',
};

class _Title extends StatelessWidget {
  const _Title(this.text, {this.size = 30});
  final String text;
  final double size;
  @override
  Widget build(BuildContext context) =>
      Text(text, textAlign: TextAlign.center, style: AppText.fredoka(size, weight: 700));
}

class _Sub extends StatelessWidget {
  const _Sub(this.text);
  final String text;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 4),
    child: Text(
      text,
      textAlign: TextAlign.center,
      style: AppText.nunito(14, weight: 700, color: AppColors.muted),
    ),
  );
}

class _Announce extends StatefulWidget {
  const _Announce({required this.child});
  final Widget child;
  @override
  State<_Announce> createState() => _AnnounceState();
}

class _AnnounceState extends State<_Announce> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) UiFeedback.of(context).sound(UiSound.popupOpen);
    });
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

// ── Pause ──

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
  Widget build(BuildContext context) {
    Widget round(SettingKey k, Widget icon, bool on, String label) => Semantics(
      toggled: on,
      label: label,
      child: Pressable(
        onTap: () => onToggle(k),
        child: AnimatedContainer(
          duration: AppMotion.fast,
          width: 52,
          height: 52,
          alignment: Alignment.center,
          decoration: BoxDecoration(color: on ? AppColors.leafWash : AppColors.track, shape: BoxShape.circle),
          child: Opacity(opacity: on ? 1 : .45, child: icon),
        ),
      ),
    );
    return _Announce(
      child: PopupCard(
        key: AppKeys.pausePopup,
        children: [
          const _Title('Paused'),
          const _Sub('Take a breath, the snakes will wait'),
          const SizedBox(height: 20),
          GameButton(key: AppKeys.resume, label: 'Resume', onTap: onResume),
          const SizedBox(height: 10),
          GameButton(key: AppKeys.restart, label: 'Restart', tone: ButtonTone.cream, height: 50, onTap: onRestart),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: GameButton(label: 'Map', tone: ButtonTone.cream, height: 50, onTap: onMap),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: GameButton(label: 'Home', tone: ButtonTone.cream, height: 50, onTap: onHome),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Wrap(
            spacing: 14,
            runSpacing: 10,
            alignment: WrapAlignment.center,
            children: [
              round(SettingKey.sound, settingsIcon(SettingKey.sound), settings.sound, 'Sound'),
              round(SettingKey.music, settingsIcon(SettingKey.music), settings.music, 'Music'),
              round(SettingKey.haptics, settingsIcon(SettingKey.haptics), settings.haptics, 'Haptics'),
              round(
                SettingKey.colourBlind,
                settingsIcon(SettingKey.colourBlind),
                settings.colourBlind,
                'Colour-blind mode',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Shared by Pause and the Home settings screen.
class SettingsList extends StatelessWidget {
  const SettingsList({super.key, required this.settings, required this.onToggle});
  final SettingsData settings;
  final void Function(SettingKey) onToggle;

  @override
  Widget build(BuildContext context) {
    Widget row(String label, SettingKey k, bool v, {bool first = false}) =>
        SettingRow(icon: settingsIcon(k), label: label, value: v, onChanged: () => onToggle(k), first: first);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        const SectionLabel('GAME'),
        CreamCard(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
          child: Column(
            children: [
              row('Sound', SettingKey.sound, settings.sound, first: true),
              row('Music', SettingKey.music, settings.music),
              row('Haptics', SettingKey.haptics, settings.haptics),
            ],
          ),
        ),
        const SizedBox(height: 14),
        const SectionLabel('COMFORT'),
        CreamCard(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
          child: Column(
            children: [
              row('Colour-blind mode', SettingKey.colourBlind, settings.colourBlind, first: true),
              row('Reduce motion', SettingKey.reducedMotion, settings.reducedMotion),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Progress is saved on this device only',
          textAlign: TextAlign.center,
          style: AppText.nunito(13, color: AppColors.muted),
        ),
      ],
    );
  }
}

// ── Second Chance ──

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
      if (_left > 0 && _left <= 3) UiFeedback.of(context).sound(UiSound.countdown);
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
    final total = SecondChancePopup.countdown.inSeconds;
    return _Announce(
      child: PopupCard(
        key: AppKeys.secondChancePopup,
        padding: const EdgeInsets.fromLTRB(18, 22, 18, 14),
        children: [
          const _Title('Pip needs a berry!', size: 26),
          const SizedBox(height: 14),
          Semantics(
            label: '$_left seconds left',
            child: SizedBox(
              width: 112,
              height: 112,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  TweenAnimationBuilder<double>(
                    tween: Tween(end: _left / total),
                    duration: const Duration(milliseconds: 900),
                    builder: (_, v, _) => CustomPaint(size: const Size.square(112), painter: _RingPainter(v)),
                  ),
                  const Positioned(top: 26, child: ArtIcon(Art.heart, size: 46)),
                  Positioned(
                    bottom: 20,
                    child: Text('$_left', style: AppText.fredoka(16, color: AppColors.muted)),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
          GameButton(
            key: AppKeys.watchAd,
            height: 60,
            fontSize: 18,
            leading: const LineIconView(LineIcon.video, size: 22, color: Colors.white),
            label: d.adUsedForLevel
                ? 'Used for this level'
                : d.adAvailable
                ? 'Watch ad · +1 heart'
                : 'Ad unavailable',
            onTap: d.canWatchAd && !widget.paused ? widget.onWatchAd : null,
          ),
          const SizedBox(height: 12),
          _RefillButton(data: d, enabled: d.canRefill && !widget.paused, onTap: widget.onRefill),
          const SizedBox(height: 6),
          Pressable(
            key: AppKeys.noThanks,
            onTap: widget.onDecline,
            semanticLabel: 'No thanks',
            child: SizedBox(
              height: 44,
              child: Center(
                child: Text('No thanks', style: AppText.nunito(15, color: const Color(0xFF5B6B5F))),
              ),
            ),
          ),
          Text(
            'The board stays as it is. Using a revive or refill gives 1 star.',
            textAlign: TextAlign.center,
            style: AppText.nunito(12, weight: 700, color: const Color(0xFF5B6B5F)),
          ),
        ],
      ),
    );
  }
}

class _RefillButton extends StatelessWidget {
  const _RefillButton({required this.data, required this.enabled, required this.onTap});
  final SecondChanceData data;
  final bool enabled;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Pressable(
    key: AppKeys.refill,
    onTap: enabled ? onTap : null,
    semanticLabel: 'Heart Berry Refill for ${data.refillCost} coins, ${data.refillsLeft} left',
    child: Opacity(
      opacity: enabled ? 1 : .5,
      child: Container(
        constraints: const BoxConstraints(minHeight: 60),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: const Color(0xFFD5E3D3), width: 2),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const ArtIcon(Art.coin, size: 24),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                '${data.refillCost} · Heart Berry Refill',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppText.fredoka(17),
              ),
            ),
            const SizedBox(width: 6),
            Text('(${data.refillsLeft} left)', style: AppText.nunito(13, color: const Color(0xFF5B6B5F))),
          ],
        ),
      ),
    ),
  );
}

class _RingPainter extends CustomPainter {
  _RingPainter(this.v);
  final double v;
  @override
  void paint(Canvas canvas, Size size) {
    final c = size.center(Offset.zero);
    final p = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(c, 50, p..color = const Color(0xFFE0E8E1));
    canvas.drawArc(
      Rect.fromCircle(center: c, radius: 50),
      -math.pi / 2,
      2 * math.pi * v,
      false,
      p..color = const Color(0xFF66BB6A),
    );
  }

  @override
  bool shouldRepaint(_RingPainter o) => o.v != v;
}

// ── Level Failed ──

class LevelFailedPopup extends StatelessWidget {
  const LevelFailedPopup({super.key, required this.onRetry, required this.onHome});
  final VoidCallback onRetry;
  final VoidCallback onHome;
  @override
  Widget build(BuildContext context) => _Announce(
    child: PopupCard(
      key: AppKeys.failedPopup,
      children: [
        const _Title('Level Failed!'),
        const SizedBox(height: 6),
        Image.asset('assets/images/pip_sad.png', height: 110, semanticLabel: 'Sad Pip'),
        const SizedBox(height: 4),
        Text("Don't give up!", style: AppText.fredoka(20)),
        const _Sub('Out of heart berries. The board resets with 3 hearts.'),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(color: AppColors.well, borderRadius: BorderRadius.circular(17)),
          child: Text('Tip: hold a snake to preview its path', style: AppText.nunito(13, color: AppColors.muted)),
        ),
        const SizedBox(height: 18),
        GameButton(key: AppKeys.retry, label: 'Retry', onTap: onRetry),
        const SizedBox(height: 10),
        GameButton(label: 'Home', tone: ButtonTone.cream, height: 50, onTap: onHome),
      ],
    ),
  );
}

// ── Level Complete ──

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
  Widget build(BuildContext context) {
    final fb = UiFeedback.of(context);
    Widget star(int i, double size, double angle) {
      final on = i < data.stars;
      return Transform.rotate(
        angle: angle,
        child: PopIn(
          delay: Duration(milliseconds: 250 + i * 200),
          onShown: on ? () => fb.sound(UiSound.starPop) : null,
          child: ArtIcon(on ? Art.star : Art.starEmpty, size: size),
        ),
      );
    }

    return Stack(
      children: [
        const Positioned.fill(child: IgnorePointer(child: Confetti())),
        PopupCard(
          key: AppKeys.completePopup,
          badge: 'LEVEL ${data.level}',
          children: [
            const _Title('Level Complete!'),
            const SizedBox(height: 14),
            Semantics(
              label: '${data.stars} of 3 stars',
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  star(0, 58, -.21),
                  Padding(padding: const EdgeInsets.only(bottom: 14), child: star(1, 72, 0)),
                  star(2, 58, .21),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: AppColors.well, borderRadius: BorderRadius.circular(18)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const ArtIcon(Art.coin, size: 30),
                  const SizedBox(width: 8),
                  Text('+${data.totalCoins}', style: AppText.fredoka(22)),
                ],
              ),
            ),
            if (data.starBonus > 0)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text.rich(
                  TextSpan(
                    style: AppText.nunito(14, color: AppColors.muted),
                    children: [
                      TextSpan(text: '+${data.clearCoins} '),
                      TextSpan(text: 'coins', style: AppText.nunito(14)),
                      TextSpan(text: '   +${data.starBonus} '),
                      TextSpan(text: '3-star bonus', style: AppText.nunito(14)),
                    ],
                  ),
                ),
              ),
            if (data.canDouble) ...[
              const SizedBox(height: 14),
              GameButton(
                key: AppKeys.claimDouble,
                tone: ButtonTone.gold,
                height: 50,
                fontSize: 18,
                leading: const LineIconView(LineIcon.video, size: 22, color: AppColors.goldText),
                label: 'Claim 2X · ${data.clearCoins * 2} coins',
                onTap: adBusy ? null : onDouble,
              ),
            ],
            const SizedBox(height: 18),
            if (data.hasNext) ...[
              GameButton(
                key: AppKeys.next,
                label: 'Next',
                leading: const LineIconView(LineIcon.play, color: Colors.white),
                onTap: onNext,
              ),
              const SizedBox(height: 10),
            ],
            GameButton(label: 'Map', tone: ButtonTone.cream, height: 50, onTap: onMap),
          ],
        ),
      ],
    );
  }
}

/// Falling paper confetti (ssConfetti). Off with reduced motion.
class Confetti extends StatefulWidget {
  const Confetti({super.key});
  @override
  State<Confetti> createState() => _ConfettiState();
}

class _ConfettiState extends State<Confetti> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(vsync: this, duration: const Duration(seconds: 5));

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!AppMotion.reduced(context) && !_c.isAnimating) _c.repeat();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (AppMotion.reduced(context)) return const SizedBox.shrink();
    return AnimatedBuilder(
      animation: _c,
      builder: (_, _) => CustomPaint(painter: _ConfettiPainter(_c.value)),
    );
  }
}

class _ConfettiPainter extends CustomPainter {
  _ConfettiPainter(this.t);
  final double t;
  static const _colors = [
    Color(0xFFFF8DC0),
    Color(0xFFFFD84A),
    Color(0xFF7CC24A),
    Color(0xFF4FC3F7),
    Color(0xFFFF8A65),
    Color(0xFFB39DDB),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final rnd = math.Random(7);
    for (var i = 0; i < 26; i++) {
      final x0 = rnd.nextDouble() * size.width;
      final speed = .7 + rnd.nextDouble() * .6;
      final phase = rnd.nextDouble();
      final p = (t * speed + phase) % 1;
      final y = -40 + p * (size.height + 80);
      final x = x0 + math.sin(p * 6 + i) * 18;
      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(p * 9 + i);
      canvas.drawRRect(
        RRect.fromRectAndRadius(const Rect.fromLTWH(-3.5, -8, 7, 16), const Radius.circular(2)),
        Paint()..color = _colors[i % _colors.length],
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_ConfettiPainter o) => o.t != t;
}

// ── Mini shop ──

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
  Widget build(BuildContext context) {
    Widget tile(int qty, int price, VoidCallback onTap) {
      final ok = data.coins >= price;
      return Expanded(
        child: Pressable(
          onTap: ok ? onTap : null,
          semanticLabel: '$qty ${boosterName(data.booster)} for $price coins',
          child: Opacity(
            opacity: ok ? 1 : .55,
            child: CreamCard(
              padding: const EdgeInsets.fromLTRB(8, 12, 8, 10),
              child: Column(
                children: [
                  ArtIcon(ArtIcon.booster(data.booster), size: 52),
                  const SizedBox(height: 2),
                  Text('× $qty', style: AppText.fredoka(18)),
                  const SizedBox(height: 8),
                  Container(
                    height: 34,
                    decoration: BoxDecoration(
                      gradient: ok ? kGreenButton : null,
                      color: ok ? null : const Color(0xFFD9D2BC),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(color: ok ? AppColors.lip : const Color(0xFFC2B996), offset: const Offset(0, 3)),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const ArtIcon(Art.coin, size: 16),
                        const SizedBox(width: 5),
                        Text('$price', style: AppText.fredoka(15, color: Colors.white)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Align(
      alignment: Alignment.bottomCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: _Announce(
          child: Material(
            key: AppKeys.miniShop,
            type: MaterialType.transparency,
            child: Container(
              padding: EdgeInsets.fromLTRB(18, 10, 18, 18 + MediaQuery.paddingOf(context).bottom),
              decoration: const BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                boxShadow: [BoxShadow(color: Color(0x4D000000), offset: Offset(0, -10), blurRadius: 30)],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 44,
                    height: 5,
                    decoration: BoxDecoration(color: AppColors.cardBorder, borderRadius: BorderRadius.circular(3)),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: Text('Out of ${boosterName(data.booster)}', style: AppText.fredoka(22))),
                      CoinPill(coins: data.coins),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      tile(1, data.singlePrice, onBuySingle),
                      const SizedBox(width: 12),
                      tile(3, data.packPrice, onBuyPack),
                    ],
                  ),
                  const SizedBox(height: 14),
                  GameButton(label: 'Close', tone: ButtonTone.cream, height: 48, onTap: onClose),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Jungle Gift Basket / Treasure Chest ──

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

  void _reveal() {
    UiFeedback.of(context).sound(UiSound.giftOpen);
    setState(() => _open = true);
  }

  @override
  Widget build(BuildContext context) {
    final d = widget.data;
    final items = <Widget>[
      _Reward(icon: const ArtIcon(Art.coin, size: 40), label: '+${d.coins}'),
      for (final e in d.boosters.entries)
        _Reward(icon: ArtIcon(ArtIcon.booster(e.key), size: 44), label: '+${e.value}'),
    ];
    return Stack(
      children: [
        if (_open) const Positioned.fill(child: IgnorePointer(child: Confetti())),
        PopupCard(
          key: AppKeys.giftBasket,
          badge: 'LEVEL ${d.level}',
          children: [
            _Title(d.isChest ? 'Jungle Treasure Chest!' : 'Jungle Gift Basket!', size: 26),
            const SizedBox(height: 12),
            AnimatedSwitcher(
              duration: AppMotion.popupIn,
              transitionBuilder: (c, a) => ScaleTransition(scale: a, child: c),
              child: _open
                  ? Wrap(
                      key: const ValueKey('open'),
                      spacing: 10,
                      runSpacing: 10,
                      alignment: WrapAlignment.center,
                      children: items,
                    )
                  : Pressable(
                      key: const ValueKey('closed'),
                      onTap: _reveal,
                      semanticLabel: 'Tap to open',
                      child: Column(
                        children: [
                          Bob(
                            period: const Duration(milliseconds: 1600),
                            child: ArtIcon(Art.gift, size: d.isChest ? 132 : 112),
                          ),
                          Text('Tap to open', style: AppText.nunito(14, color: AppColors.muted)),
                        ],
                      ),
                    ),
            ),
            const SizedBox(height: 18),
            GameButton(key: AppKeys.giftCollect, label: 'Collect', onTap: widget.onCollect),
          ],
        ),
      ],
    );
  }
}

class _Reward extends StatelessWidget {
  const _Reward({required this.icon, required this.label});
  final Widget icon;
  final String label;
  @override
  Widget build(BuildContext context) => PopIn(
    child: Container(
      width: 84,
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(color: AppColors.well, borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          SizedBox(height: 46, child: Center(child: icon)),
          const SizedBox(height: 4),
          Text(label, style: AppText.fredoka(18)),
        ],
      ),
    ),
  );
}
