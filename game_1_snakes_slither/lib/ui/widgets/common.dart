// OWNER: UI agent. Shared pieces copied from the UI canvas: buttons with the
// 4 px lip and shine sweep, cream cards, pills, backgrounds and small motions.
import 'package:flutter/material.dart';

import '../../contracts/ui_feedback.dart';
import '../theme/tokens.dart';
import 'art.dart';

/// Press-down feedback used by every tappable canvas element (.ss-press).
class Pressable extends StatefulWidget {
  const Pressable({super.key, required this.child, this.onTap, this.semanticLabel, this.sound = true});
  final Widget child;
  final VoidCallback? onTap;
  final String? semanticLabel;
  final bool sound;

  @override
  State<Pressable> createState() => _PressableState();
}

class _PressableState extends State<Pressable> {
  bool _down = false;

  void _set(bool v) {
    if (widget.onTap != null && _down != v) setState(() => _down = v);
  }

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onTap != null;
    return Semantics(
      button: true,
      enabled: enabled,
      label: widget.semanticLabel,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) => _set(true),
        onTapCancel: () => _set(false),
        onTapUp: (_) => _set(false),
        onTap: enabled
            ? () {
                final fb = UiFeedback.of(context);
                if (widget.sound) fb.sound(UiSound.tap);
                fb.haptic();
                widget.onTap!();
              }
            : null,
        child: AnimatedSlide(
          duration: AppMotion.press,
          curve: Curves.easeOutBack,
          offset: Offset(0, _down ? .03 : 0),
          child: AnimatedScale(
            duration: AppMotion.press,
            curve: Curves.easeOutBack,
            scale: _down ? .97 : 1,
            child: widget.child,
          ),
        ),
      ),
    );
  }
}

/// A light band that sweeps across a button every 3.6 s (ssShine).
class ShineSweep extends StatefulWidget {
  const ShineSweep({super.key, required this.radius});
  final BorderRadius radius;
  @override
  State<ShineSweep> createState() => _ShineSweepState();
}

class _ShineSweepState extends State<ShineSweep> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 3600));

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (AppMotion.reduced(context)) {
      _c.stop();
    } else if (!_c.isAnimating) {
      _c.repeat();
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (AppMotion.reduced(context)) return const SizedBox.shrink();
    return IgnorePointer(
      child: ClipRRect(
        borderRadius: widget.radius,
        child: LayoutBuilder(
          builder: (_, box) => AnimatedBuilder(
            animation: _c,
            builder: (_, _) {
              final t = Curves.easeInOut.transform((_c.value / .6).clamp(0, 1));
              final w = box.maxWidth * .4;
              return Stack(
                children: [
                  Positioned(
                    left: -w * 1.2 + (box.maxWidth + w * 2.4) * t,
                    top: 0,
                    bottom: 0,
                    width: w,
                    child: Transform(
                      transform: Matrix4.skewX(-.36),
                      child: const DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [Color(0x00FFFFFF), Color(0x38FFFFFF), Color(0x00FFFFFF)]),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

enum ButtonTone { green, cream, gold }

class GameButton extends StatelessWidget {
  const GameButton({
    super.key,
    required this.label,
    required this.onTap,
    this.tone = ButtonTone.green,
    this.height = 56,
    this.fontSize,
    this.leading,
    this.shine = true,
  });
  final String label;
  final VoidCallback? onTap;
  final ButtonTone tone;
  final double height;
  final double? fontSize;
  final Widget? leading;
  final bool shine;

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    final r = BorderRadius.circular(tone == ButtonTone.green ? 20 : 18);
    final (BoxDecoration deco, Color fg) = switch (tone) {
      _ when !enabled => (
        BoxDecoration(
          color: const Color(0xFFD9D2BC),
          borderRadius: r,
          boxShadow: const [BoxShadow(color: Color(0xFFC2B996), offset: Offset(0, 4))],
        ),
        const Color(0xFFFFFFFF),
      ),
      ButtonTone.green => (
        BoxDecoration(
          gradient: kGreenButton,
          borderRadius: r,
          boxShadow: const [
            BoxShadow(color: AppColors.lip, offset: Offset(0, 4)),
            BoxShadow(color: Color(0x47075B35), offset: Offset(0, 12), blurRadius: 22),
          ],
        ),
        Colors.white,
      ),
      ButtonTone.cream => (
        BoxDecoration(
          color: AppColors.secondary,
          borderRadius: r,
          border: Border.all(color: AppColors.secondaryBorder),
          boxShadow: const [BoxShadow(color: AppColors.secondaryLip, offset: Offset(0, 3))],
        ),
        AppColors.text,
      ),
      ButtonTone.gold => (
        BoxDecoration(
          gradient: kGoldButton,
          borderRadius: r,
          boxShadow: const [
            BoxShadow(color: AppColors.goldLip, offset: Offset(0, 4)),
            BoxShadow(color: Color(0x40B37A00), offset: Offset(0, 10), blurRadius: 18),
          ],
        ),
        AppColors.goldText,
      ),
    };
    final size = fontSize ?? (tone == ButtonTone.green ? 21.0 : 17.0);
    return Pressable(
      onTap: onTap,
      semanticLabel: label,
      child: Container(
        height: height,
        decoration: deco,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (tone == ButtonTone.green && enabled)
              DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: r,
                  border: const Border(top: BorderSide(color: Color(0x52FFFFFF), width: 2)),
                ),
              ),
            if (shine && enabled && tone != ButtonTone.cream) ShineSweep(radius: r),
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (leading != null) ...[leading!, const SizedBox(width: 10)],
                  Flexible(
                    child: Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.fredoka(size, color: fg).copyWith(
                        shadows: tone == ButtonTone.green
                            ? const [Shadow(color: Color(0x2E000000), offset: Offset(0, 1))]
                            : null,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CreamCard extends StatelessWidget {
  const CreamCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(12),
    this.radius = 20,
    this.border,
  });
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;
  final Border? border;
  @override
  Widget build(BuildContext context) => Container(
    padding: padding,
    decoration: BoxDecoration(
      color: AppColors.card,
      borderRadius: BorderRadius.circular(radius),
      border: border ?? Border.all(color: AppColors.cardBorder),
      boxShadow: AppShadows.card,
    ),
    child: child,
  );
}

/// Coin balance chip with the green "+" (Home, Shop, Map).
class CoinPill extends StatelessWidget {
  const CoinPill({super.key, required this.coins, this.onTap, this.dark = false});
  final int coins;
  final VoidCallback? onTap;
  final bool dark;
  @override
  Widget build(BuildContext context) => Pressable(
    onTap: onTap,
    semanticLabel: '${fmt(coins)} coins',
    child: Container(
      height: 36,
      padding: const EdgeInsets.only(left: 7, right: 8),
      decoration: BoxDecoration(
        color: dark ? const Color(0x8C04341E) : AppColors.card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: dark ? const Color(0x2EFFFFFF) : AppColors.cardBorder),
        boxShadow: AppShadows.chip,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const ArtIcon(Art.coin, size: 22),
          const SizedBox(width: 6),
          Text(fmt(coins), style: AppText.fredoka(16, color: dark ? Colors.white : AppColors.text)),
          if (onTap != null) ...[
            const SizedBox(width: 6),
            Container(
              width: 20,
              height: 20,
              alignment: Alignment.center,
              decoration: const BoxDecoration(color: AppColors.emerald, shape: BoxShape.circle),
              child: Text('+', style: AppText.nunito(15, color: Colors.white, height: 1)),
            ),
          ],
        ],
      ),
    ),
  );
}

/// Round cream button (back, settings).
class RoundButton extends StatelessWidget {
  const RoundButton({super.key, required this.child, required this.onTap, required this.label, this.size = 44});
  final Widget child;
  final VoidCallback? onTap;
  final String label;
  final double size;
  @override
  Widget build(BuildContext context) => Pressable(
    onTap: onTap,
    semanticLabel: label,
    child: Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: AppColors.card,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(color: Color(0xFFC9BE9C), offset: Offset(0, 3)),
          BoxShadow(color: Color(0x33000000), offset: Offset(0, 8), blurRadius: 16),
        ],
      ),
      child: child,
    ),
  );
}

class ProgressBar extends StatelessWidget {
  const ProgressBar({super.key, required this.value, this.gold = false, this.height = 8});
  final double value;
  final bool gold;
  final double height;
  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(height / 2),
    child: SizedBox(
      height: height,
      child: Stack(
        children: [
          const Positioned.fill(child: ColoredBox(color: AppColors.cardBorder)),
          FractionallySizedBox(
            widthFactor: value.clamp(.04, 1),
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(height / 2),
                gradient: LinearGradient(
                  colors: gold ? const [Color(0xFFFFD84A), AppColors.gold] : const [AppColors.leaf, AppColors.emerald],
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

/// Cream page background with the blurred leaves in the corners.
class CreamBackground extends StatelessWidget {
  const CreamBackground({super.key, required this.child, this.leaves = true});
  final Widget child;
  final bool leaves;
  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: const BoxDecoration(gradient: kCreamBackground),
    child: Stack(
      children: [
        if (leaves) ...const [
          Positioned(left: -46, top: 70, child: Opacity(opacity: .85, child: LeafDecor(size: 120, angle: 130))),
          Positioned(
            right: -50,
            top: 260,
            child: Opacity(
              opacity: .7,
              child: LeafDecor(size: 110, angle: -120, from: Color(0xFFB6DE6A), to: Color(0xFF5DAA3C)),
            ),
          ),
          Positioned(
            left: -30,
            bottom: 60,
            child: Opacity(
              opacity: .9,
              child: LeafDecor(size: 130, angle: 60, from: Color(0xFF7CC24A), to: Color(0xFF2E8B3A)),
            ),
          ),
          Positioned(
            right: -40,
            bottom: -20,
            child: Opacity(opacity: .95, child: LeafDecor(size: 150, angle: -40, to: Color(0xFF2E8B3A))),
          ),
        ],
        Positioned.fill(child: child),
      ],
    ),
  );
}

/// Gentle up-down float (ssBob). Off when the system asks for less motion.
class Bob extends StatefulWidget {
  const Bob({super.key, required this.child, this.period = const Duration(milliseconds: 3600), this.distance = 7});
  final Widget child;
  final Duration period;
  final double distance;
  @override
  State<Bob> createState() => _BobState();
}

class _BobState extends State<Bob> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(vsync: this, duration: widget.period);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (AppMotion.reduced(context)) {
      _c.stop();
    } else if (!_c.isAnimating) {
      _c.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _c,
    child: widget.child,
    builder: (_, child) =>
        Transform.translate(offset: Offset(0, -widget.distance * Curves.easeInOut.transform(_c.value)), child: child),
  );
}

/// Scale-in with a small overshoot (ssPop), optionally delayed.
class PopIn extends StatefulWidget {
  const PopIn({super.key, required this.child, this.delay = Duration.zero, this.onShown});
  final Widget child;
  final Duration delay;
  final VoidCallback? onShown;
  @override
  State<PopIn> createState() => _PopInState();
}

class _PopInState extends State<PopIn> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
  bool _started = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;
    if (AppMotion.reduced(context)) {
      _c.value = 1;
      return;
    }
    Future.delayed(widget.delay, () {
      if (!mounted) return;
      widget.onShown?.call();
      _c.forward();
    });
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _c,
    child: widget.child,
    builder: (_, child) {
      final t = _c.value;
      final s = t < .7 ? .6 + (1.06 - .6) * (t / .7) : 1.06 - .06 * ((t - .7) / .3);
      return Opacity(
        opacity: (t / .7).clamp(0, 1),
        child: Transform.scale(scale: s, child: child),
      );
    },
  );
}

/// The popup card: cream, 28 radius, 6 px lip, optional green level badge.
class PopupCard extends StatelessWidget {
  const PopupCard({
    super.key,
    required this.children,
    this.badge,
    this.padding = const EdgeInsets.fromLTRB(20, 26, 20, 20),
  });
  final List<Widget> children;
  final String? badge;
  final EdgeInsets padding;
  @override
  Widget build(BuildContext context) => Center(
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 420),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22),
        child: PopIn(
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topCenter,
            children: [
              Container(
                width: double.infinity,
                padding: padding,
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: AppColors.cardBorder),
                  boxShadow: AppShadows.popup,
                ),
                child: Material(
                  type: MaterialType.transparency,
                  child: Column(mainAxisSize: MainAxisSize.min, children: children),
                ),
              ),
              if (badge != null)
                Positioned(
                  top: -18,
                  child: Container(
                    height: 34,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(17),
                      gradient: const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [AppColors.emeraldLight, AppColors.forest],
                      ),
                      boxShadow: const [BoxShadow(color: Color(0x4D075B35), offset: Offset(0, 4), blurRadius: 10)],
                    ),
                    child: Text(badge!, style: AppText.nunito(14, color: Colors.white)),
                  ),
                ),
            ],
          ),
        ),
      ),
    ),
  );
}

/// Dark green wash behind popups.
class PopupScrim extends StatelessWidget {
  const PopupScrim({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) => ColoredBox(
    color: const Color(0x8C03261A),
    child: SafeArea(child: child),
  );
}

class CenteredColumn extends StatelessWidget {
  const CenteredColumn({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) => Align(
    alignment: Alignment.topCenter,
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 600),
      child: SizedBox(width: double.infinity, child: child),
    ),
  );
}

String fmt(int n) {
  final s = n.abs().toString();
  final b = StringBuffer(n < 0 ? '-' : '');
  for (var i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) b.write(',');
    b.write(s[i]);
  }
  return b.toString();
}
