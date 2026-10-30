import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../app/services.dart';
import '../../app/theme/text_styles.dart';
import '../../app/theme/tokens.dart';
import '../../services/audio_service.dart';
import '../logging/app_logger.dart';

enum BevelStyle { primary, cream, gold, vip, danger }

class _Palette {
  const _Palette(this.top, this.bottom, this.lip, this.text);
  final Color top;
  final Color bottom;
  final Color lip;
  final Color text;
}

_Palette _paletteFor(BevelStyle s) => switch (s) {
      BevelStyle.primary => const _Palette(Color(0xFF7BD27E), AppColors.primary, AppColors.primaryDark, Colors.white),
      BevelStyle.cream => const _Palette(Colors.white, AppColors.creamEdge, AppColors.creamLip, AppColors.textPrimary),
      BevelStyle.gold => const _Palette(Color(0xFFFFE082), Color(0xFFFFB300), Color(0xFFB8860B), Color(0xFF4E3500)),
      BevelStyle.vip => const _Palette(Color(0xFFB39DDB), AppColors.vipPurple, Color(0xFF4527A0), Colors.white),
      BevelStyle.danger => const _Palette(Color(0xFFEF9A9A), AppColors.danger, Color(0xFF8E0000), Colors.white),
    };

/// Soft-3D button with a bottom lip that presses down (bevelLip → pressed).
class BevelButton extends StatefulWidget {
  const BevelButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.style = BevelStyle.primary,
    this.height = 56,
    this.radius = Radii.md,
    this.expand = false,
    this.semanticLabel,
    this.logId,
    this.padding = const EdgeInsets.symmetric(horizontal: Space.xl),
  });

  /// Text-only convenience.
  factory BevelButton.text(
    String label, {
    Key? key,
    required VoidCallback? onPressed,
    BevelStyle style = BevelStyle.primary,
    double height = 56,
    bool expand = false,
    IconData? icon,
    String? logId,
  }) =>
      BevelButton(
        key: key,
        onPressed: onPressed,
        style: style,
        height: height,
        expand: expand,
        semanticLabel: label,
        logId: logId,
        child: Builder(builder: (context) {
          final color = _paletteFor(style).text;
          return Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[Icon(icon, color: color, size: 22), const SizedBox(width: Space.sm)],
              Flexible(
                child: Text(label, style: AppText.button.copyWith(color: color), textAlign: TextAlign.center, maxLines: 2),
              ),
            ],
          );
        }),
      );

  final VoidCallback? onPressed;
  final Widget child;
  final BevelStyle style;
  final double height;
  final double radius;
  final bool expand;
  final String? semanticLabel;
  final String? logId;
  final EdgeInsets padding;

  @override
  State<BevelButton> createState() => _BevelButtonState();
}

class _BevelButtonState extends State<BevelButton> {
  bool _down = false;

  void _setDown(bool v) {
    if (widget.onPressed == null || _down == v) return;
    setState(() => _down = v);
  }

  void _tap() {
    final cb = widget.onPressed;
    if (cb == null) return;
    final s = context.read<AppServices>();
    s.audio.play(Sfx.uiTap);
    s.haptics.selection();
    if (widget.logId != null) log.tap('btn:${widget.logId}');
    cb();
  }

  @override
  Widget build(BuildContext context) {
    final p = _paletteFor(widget.style);
    final enabled = widget.onPressed != null;
    final lip = enabled ? p.lip : const Color(0xFFB0B8B2);
    final top = enabled ? p.top : const Color(0xFFE3E7E4);
    final bottom = enabled ? p.bottom : const Color(0xFFC9D0CB);
    final button = AnimatedContainer(
      duration: const Duration(milliseconds: 90),
      curve: Curves.easeOut,
      height: widget.height,
      transform: Matrix4.translationValues(0, _down ? 3 : 0, 0),
      padding: widget.padding,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(widget.radius),
        gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [top, bottom]),
        border: Border.all(color: Colors.white.withValues(alpha: 0.55), width: 2),
        boxShadow: Shadows.bevel(lip, pressed: _down),
      ),
      alignment: Alignment.center,
      child: DefaultTextStyle.merge(
        style: TextStyle(color: enabled ? p.text : AppColors.textDisabled),
        child: IconTheme.merge(data: IconThemeData(color: enabled ? p.text : AppColors.textDisabled), child: widget.child),
      ),
    );
    return Semantics(
      button: true,
      enabled: enabled,
      label: widget.semanticLabel,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) => _setDown(true),
        onTapUp: (_) => _setDown(false),
        onTapCancel: () => _setDown(false),
        onTap: _tap,
        child: ConstrainedBox(
          constraints: BoxConstraints(minWidth: widget.expand ? double.infinity : 48, minHeight: 48),
          // The centred container would otherwise grow to any loose width it is given.
          child: widget.expand ? button : IntrinsicWidth(child: button),
        ),
      ),
    );
  }
}

/// Round cream button (settings, pause, back) with the same press feel.
class RoundIconButton extends StatelessWidget {
  const RoundIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    required this.label,
    this.size = 48,
    this.badge,
    this.style = BevelStyle.cream,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final String label;
  final double size;
  final String? badge;
  final BevelStyle style;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        SizedBox(
          width: size,
          height: size,
          child: BevelButton(
            onPressed: onPressed,
            style: style,
            height: size,
            radius: size / 2,
            padding: EdgeInsets.zero,
            semanticLabel: label,
            logId: label.toLowerCase().replaceAll(' ', '_'),
            child: Icon(icon, size: size * 0.5),
          ),
        ),
        if (badge != null)
          Positioned(
            right: -4,
            top: -4,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
              decoration: BoxDecoration(
                color: AppColors.heart,
                borderRadius: BorderRadius.circular(Radii.pill),
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: Text(badge!, style: AppText.caption.copyWith(color: Colors.white, fontWeight: FontWeight.w800)),
            ),
          ),
      ],
    );
  }
}
