import 'package:flutter/material.dart';

import '../theme/tokens.dart';

enum RoundButtonVariant { cream, primary, danger }

/// Circular button with min 48×48 dp tap target, soft-3D lip,
/// and optional badge (e.g. settings, pause, booster buttons).
class RoundIconButton extends StatefulWidget {
  const RoundIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.label,
    this.size = 48,
    this.variant = RoundButtonVariant.cream,
    this.badge,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final String? label;
  final double size;
  final RoundButtonVariant variant;
  final Widget? badge;

  @override
  State<RoundIconButton> createState() => _RoundIconButtonState();
}

class _RoundIconButtonState extends State<RoundIconButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onPressed != null;
    final disableAnimations = MediaQuery.of(context).disableAnimations;

    final (List<Color> gradientColors, Color lipColor, Color iconColor) = switch (widget.variant) {
      RoundButtonVariant.cream => enabled
          ? ([Colors.white, AppColors.creamEdge], AppColors.creamLip, AppColors.textPrimary)
          : ([const Color(0xFFF2F0E8), const Color(0xFFE4E2D8)], const Color(0xFFCCC9BD), AppColors.textDisabled),
      RoundButtonVariant.primary => enabled
          ? ([AppColors.primaryLight, AppColors.primary], AppColors.primaryDark, Colors.white)
          : ([const Color(0xFFD4DDD6), const Color(0xFFC0CCC3)], const Color(0xFFA5B2A9), Colors.white70),
      RoundButtonVariant.danger => enabled
          ? ([const Color(0xFFEF5350), AppColors.danger], const Color(0xFF8E0000), Colors.white)
          : ([const Color(0xFFE4C3C3), const Color(0xFFCCA5A5)], const Color(0xFFAF8888), Colors.white70),
    };

    final lipHeight = _pressed ? 1.0 : 3.0;
    final translateY = _pressed ? 2.0 : 0.0;

    return Semantics(
      button: true,
      enabled: enabled,
      label: widget.label,
      child: GestureDetector(
        onTapDown: enabled ? (_) => setState(() => _pressed = true) : null,
        onTapUp: enabled ? (_) => setState(() => _pressed = false) : null,
        onTapCancel: enabled ? () => setState(() => _pressed = false) : null,
        onTap: widget.onPressed,
        behavior: HitTestBehavior.opaque,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            AnimatedContainer(
              duration: disableAnimations ? Duration.zero : const Duration(milliseconds: 60),
              curve: Curves.easeOut,
              transform: Matrix4.translationValues(0, translateY, 0),
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: gradientColors,
                ),
                border: Border.all(color: Colors.white, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: lipColor,
                    blurRadius: 0,
                    offset: Offset(0, lipHeight),
                  ),
                  if (!_pressed && enabled)
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                ],
              ),
              child: Center(
                child: Icon(widget.icon, color: iconColor, size: widget.size * 0.52),
              ),
            ),
            if (widget.badge != null)
              Positioned(
                top: -4,
                right: -4,
                child: widget.badge!,
              ),
          ],
        ),
      ),
    );
  }
}
