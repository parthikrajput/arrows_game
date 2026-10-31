// OWNER: UI agent. Complete design system tokens per Phase 1 doc 06 & canvas brand.
import 'package:flutter/material.dart';

import '../../contracts/view_models.dart';

/// Snakes Slither brand palette and color tokens.
/// Source of truth: design/ui_canvas/README.md & phases/phase_1/06_UI_UX_SCREENS.md §2.1.
class AppColors {
  const AppColors._();

  // Brand palette
  static const primary = Color(0xFF075B35); // Forest primary
  static const primaryLight = Color(0xFF13864D); // Emerald secondary
  static const primaryLeaf = Color(0xFFA8D94F); // Leaf accent
  static const primaryDark = Color(0xFF043820); // Deep forest for bevel lip
  static const onPrimary = Color(0xFFFFFFFF);

  // Background & surface
  static const bgSage = Color(0xFFF7F4E8); // Cream background from UI canvas
  static const bgCream = Color(0xFFFFFEF8); // Card background from UI canvas
  static const surface = Color(0xFFFFFFFF);
  static const surfaceAlt = Color(0xFFF7F9FA);
  static const creamEdge = Color(0xFFF4EFE3);
  static const creamLip = Color(0xFFDCD6C5);

  // Coins, stars & rewards
  static const coinGold = Color(0xFFF4B72F); // Brand Gold
  static const coinGoldDark = Color(0xFFB8860B);
  static const starYellow = Color(0xFFFFD54F);

  // Status & feedback
  static const heart = Color(0xFFE53935);
  static const danger = Color(0xFFC62828);
  static const previewClear = Color(0xFF075B35);
  static const previewBlocked = Color(0xFFD32F2F);
  static const vipPurple = Color(0xFF7E57C2);
  static const scrim = Color(0x73000000);

  // Text colors (WCAG AA contrast compliant against bgCream & bgSage)
  static const textPrimary = Color(0xFF163B28); // Brand dark green text
  static const textSecondary = Color(0xFF4A6B56); // Medium contrast green
  static const textDisabled = Color(0xFF9AA59D);

  // Snake palette (8 colors from Phase 1 doc 06 §2.2)
  static Color snake(SnakeColor c) => switch (c) {
    SnakeColor.red => const Color(0xFFFF7043),
    SnakeColor.green => const Color(0xFF7CB342),
    SnakeColor.blue => const Color(0xFF29B6F6),
    SnakeColor.yellow => const Color(0xFFFFCA28),
    SnakeColor.purple => const Color(0xFF9575CD),
    SnakeColor.orange => const Color(0xFFFFA726),
    SnakeColor.pink => const Color(0xFFF06292),
    SnakeColor.teal => const Color(0xFF26A69A),
  };

  /// Biome board tints (doc 01 §2.3)
  static Color biomeTint(int level) {
    if (level <= 100) return const Color(0xFFE8F5E9);
    if (level <= 200) return const Color(0xFFE6F2DF);
    if (level <= 300) return const Color(0xFFFFF4E0);
    if (level <= 400) return const Color(0xFFE3EFEA);
    return const Color(0xFFE4E8F5);
  }
}

/// Spacing scale (4, 8, 12, 16, 24, 32, 48).
abstract final class Space {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;
  static const double huge = 48;
  static const double gutter = 16;
}

/// Corner radii tokens (xs 8, sm 12, md 16, lg 24, pill 999).
abstract final class Radii {
  static const double xs = 8;
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 24;
  static const double pill = 999;
}

/// Pre-baked and box shadows (elev1, elev2, bevelLip, pressed).
abstract final class Shadows {
  static const elev1 = [
    BoxShadow(color: Color(0x14000000), blurRadius: 12, offset: Offset(0, 4)),
  ];

  static const elev2 = [
    BoxShadow(color: Color(0x1F000000), blurRadius: 24, offset: Offset(0, 8)),
  ];

  static const bevelLip = [
    BoxShadow(color: Color(0x33000000), blurRadius: 0, offset: Offset(0, 4)),
  ];

  static const pressed = [
    BoxShadow(color: Color(0x33000000), blurRadius: 0, offset: Offset(0, 1)),
  ];

  static List<BoxShadow> bevel(Color lip, {bool pressed = false}) => [
    BoxShadow(color: lip, blurRadius: 0, offset: Offset(0, pressed ? 1 : 4)),
    if (!pressed)
      const BoxShadow(color: Color(0x1F163B28), blurRadius: 10, offset: Offset(0, 5)),
  ];
}

/// Motion durations and easing curves from doc 06 §2.6.
class AppMotion {
  const AppMotion._();

  static const fast = Duration(milliseconds: 150);
  static const base = Duration(milliseconds: 250);
  static const move = Duration(milliseconds: 320);
  static const bonk = Duration(milliseconds: 380);
  static const popupIn = Duration(milliseconds: 300);
  static const locked = Duration(milliseconds: 200);

  static const Curve fastCurve = Curves.easeOut;
  static const Curve baseCurve = Curves.easeOutCubic;
  static const Curve moveCurve = Curves.easeInOutCubic;
  static const Curve bonkForwardCurve = Curves.easeOut;
  static const Curve bonkBackCurve = Curves.elasticOut;
  static const Curve popupCurve = Curves.easeOutBack;

  /// Exit duration scales with path distance: 250–450 ms.
  static Duration exitFor(int cellsTravelled) =>
      Duration(milliseconds: (250 + cellsTravelled * 25).clamp(250, 450));
}

/// Typography system bundling Fredoka and Nunito offline with Gujarati/Hindi fallbacks.
/// Source of truth: doc 06 §2.3.
abstract final class AppText {
  static const _fallbacks = ['BalooBhai2', 'Baloo2'];

  static const display = TextStyle(
    fontFamily: 'Fredoka',
    fontFamilyFallback: _fallbacks,
    fontSize: 32,
    height: 40 / 32,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const h1 = TextStyle(
    fontFamily: 'Fredoka',
    fontFamilyFallback: _fallbacks,
    fontSize: 24,
    height: 32 / 24,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const h2 = TextStyle(
    fontFamily: 'Fredoka',
    fontFamilyFallback: _fallbacks,
    fontSize: 20,
    height: 28 / 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const body = TextStyle(
    fontFamily: 'Nunito',
    fontFamilyFallback: _fallbacks,
    fontSize: 16,
    height: 24 / 16,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );

  static const caption = TextStyle(
    fontFamily: 'Nunito',
    fontFamilyFallback: _fallbacks,
    fontSize: 13,
    height: 18 / 13,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
  );

  static const button = TextStyle(
    fontFamily: 'Fredoka',
    fontFamilyFallback: _fallbacks,
    fontSize: 18,
    height: 24 / 18,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  static const hudNumber = TextStyle(
    fontFamily: 'Fredoka',
    fontFamilyFallback: _fallbacks,
    fontSize: 20,
    height: 24 / 20,
    fontWeight: FontWeight.w600,
    fontFeatures: [FontFeature.tabularFigures()],
    color: AppColors.textPrimary,
  );
}

/// Builds the app's light ThemeData.
ThemeData buildAppTheme() => ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  colorScheme: ColorScheme.fromSeed(
    seedColor: AppColors.primary,
    primary: AppColors.primary,
    secondary: AppColors.primaryLight,
    surface: AppColors.bgCream,
    brightness: Brightness.light,
  ),
  scaffoldBackgroundColor: AppColors.bgSage,
  cardColor: AppColors.bgCream,
  fontFamily: 'Nunito',
  fontFamilyFallback: const ['BalooBhai2', 'Baloo2'],
);
