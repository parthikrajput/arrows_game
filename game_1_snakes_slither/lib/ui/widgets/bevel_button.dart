import 'package:flutter/material.dart';

import '../theme/tokens.dart';

enum BevelVariant { primary, secondary, outline, gold, danger }

class BevelButton extends StatefulWidget {
  const BevelButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.variant = BevelVariant.primary,
    this.height = 54,
    this.minWidth,
    this.radius = Radii.md,
    this.expand = false,
    this.padding = const EdgeInsets.symmetric(horizontal: Space.xl),
    this.semanticsLabel,
  });

  /// Factory convenience for text labels.
  factory BevelButton.text(
    String label, {
    Key? key,
    required VoidCallback? onPressed,
    BevelVariant variant = BevelVariant.primary,
    double height = 54,
    double? minWidth,
    bool expand = false,
    Widget? icon,
    String? semanticsLabel,
  }) =>
      BevelButton(
        key: key,
        onPressed: onPressed,
        variant: variant,
        height: height,
        minWidth: minWidth,
        expand: expand,
        semanticsLabel: semanticsLabel ?? label,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[icon, const SizedBox(width: Space.sm)],
            Flexible(
              child: Text(
                label,
                style: AppText.button.copyWith(color: _textColor(variant, onPressed != null)),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      );

  final VoidCallback? onPressed;
  final Widget child;
  final BevelVariant variant;
  final double height;
  final double? minWidth;
  final double radius;
  final bool expand;
  final EdgeInsets padding;
  final String? semanticsLabel;

  static Color _textColor(BevelVariant variant, bool enabled) {
    if (!enabled) return AppColors.textDisabled;
    return switch (variant) {
      BevelVariant.primary => Colors.white,
      BevelVariant.secondary => AppColors.textPrimary,
      BevelVariant.outline => AppColors.primary,
      BevelVariant.gold => const Color(0xFF4E3500),
      BevelVariant.danger => Colors.white,
    };
  }

  @override
  State<BevelButton> createState() => _BevelButtonState();
}

class _BevelButtonState extends State<BevelButton> {
  bool _pressed = false;

  void _onTapDown(TapDownDetails _) {
    if (widget.onPressed == null) return;
    setState(() => _pressed = true);
  }

  void _onTapUp(TapUpDetails _) {
    if (widget.onPressed == null) return;
    setState(() => _pressed = false);
  }

  void _onTapCancel() {
    if (widget.onPressed == null) return;
    setState(() => _pressed = false);
  }

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onPressed != null;
    final textScale = MediaQuery.textScalerOf(context).clamp(minScaleFactor: 1.0, maxScaleFactor: 2.0);
    final disableAnimations = MediaQuery.of(context).disableAnimations;

    // Palette per variant
    final (List<Color> gradientColors, Color lipColor, Color borderColor) = switch (widget.variant) {
      BevelVariant.primary => enabled
          ? ([AppColors.primaryLight, AppColors.primary], AppColors.primaryDark, Colors.white.withValues(alpha: 0.25))
          : ([const Color(0xFFD4DDD6), const Color(0xFFC0CCC3)], const Color(0xFFA5B2A9), Colors.transparent),
      BevelVariant.secondary => enabled
          ? ([Colors.white, AppColors.creamEdge], AppColors.creamLip, Colors.white)
          : ([const Color(0xFFF0EFE9), const Color(0xFFE4E2D8)], const Color(0xFFCBC8BC), Colors.transparent),
      BevelVariant.outline => enabled
          ? ([Colors.transparent, Colors.transparent], Colors.transparent, AppColors.primary)
          : ([Colors.transparent, Colors.transparent], Colors.transparent, AppColors.textDisabled),
      BevelVariant.gold => enabled
          ? ([const Color(0xFFFFE082), AppColors.coinGold], AppColors.coinGoldDark, Colors.white.withValues(alpha: 0.4))
          : ([const Color(0xFFEADCB3), const Color(0xFFD4C597)], const Color(0xFFB5A678), Colors.transparent),
      BevelVariant.danger => enabled
          ? ([const Color(0xFFEF5350), AppColors.danger], const Color(0xFF8E0000), Colors.white.withValues(alpha: 0.3))
          : ([const Color(0xFFE4C3C3), const Color(0xFFCCA5A5)], const Color(0xFFAF8888), Colors.transparent),
    };

    final isOutline = widget.variant == BevelVariant.outline;
    final lipHeight = isOutline ? 0.0 : (_pressed ? 1.0 : 4.0);
    final translateY = isOutline ? 0.0 : (_pressed ? 3.0 : 0.0);

    Widget content = ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: widget.minWidth ?? 48.0,
        minHeight: 48.0,
      ),
      child: Container(
        height: widget.height,
        padding: widget.padding,
        alignment: Alignment.center,
        child: widget.child,
      ),
    );

    if (widget.expand) {
      content = SizedBox(width: double.infinity, child: content);
    }

    return Semantics(
      button: true,
      enabled: enabled,
      label: widget.semanticsLabel,
      child: GestureDetector(
        onTapDown: enabled ? _onTapDown : null,
        onTapUp: enabled ? _onTapUp : null,
        onTapCancel: enabled ? _onTapCancel : null,
        onTap: widget.onPressed,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: disableAnimations ? Duration.zero : const Duration(milliseconds: 60),
          curve: Curves.easeOut,
          transform: Matrix4.translationValues(0, translateY, 0),
          decoration: BoxDecoration(
            gradient: isOutline ? null : LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: gradientColors,
            ),
            borderRadius: BorderRadius.circular(widget.radius),
            border: Border.all(
              color: borderColor,
              width: isOutline ? 2.0 : 1.5,
            ),
            boxShadow: isOutline ? null : [
              BoxShadow(
                color: lipColor,
                blurRadius: 0,
                offset: Offset(0, lipHeight),
              ),
              if (!_pressed && enabled)
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.12),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
            ],
          ),
          child: MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaler: textScale),
            child: content,
          ),
        ),
      ),
    );
  }
}
