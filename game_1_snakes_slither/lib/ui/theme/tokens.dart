// OWNER: UI agent. Values copied from the UI canvas "Snake Slither Game UI"
// (design/ui_canvas). Keep names stable once used.
import 'package:flutter/material.dart';

import '../../contracts/view_models.dart';

class AppColors {
  const AppColors._();
  // Canvas palette.
  static const forest = Color(0xFF075B35);
  static const emerald = Color(0xFF13864D);
  static const emeraldLight = Color(0xFF23A766);
  static const lip = Color(0xFF03432A);
  static const leaf = Color(0xFFA8D94F);
  static const leafWash = Color(0xFFE3F2D3);
  static const gold = Color(0xFFF4B72F);
  static const goldLight = Color(0xFFFFD24A);
  static const goldLip = Color(0xFFB37A00);
  static const goldText = Color(0xFF4A2E00);
  static const goldWash = Color(0xFFFDF0CC);
  static const cream = Color(0xFFF7F4E8);
  static const creamDeep = Color(0xFFEFE9D3);
  static const card = Color(0xFFFFFEF8);
  static const cardBorder = Color(0xFFECE5CF);
  static const well = Color(0xFFF5F0DF);
  static const secondary = Color(0xFFEFE9D6);
  static const secondaryBorder = Color(0xFFE2D9BE);
  static const secondaryLip = Color(0xFFD6CBAA);
  static const track = Color(0xFFEDE6D0);
  static const text = Color(0xFF163B28);
  static const muted = Color(0xFF6B7F70);
  static const navIdle = Color(0xFF7D8C80);
  static const red = Color(0xFFE84B3C);
  static const redLip = Color(0xFFA8281C);
  static const hardRed = Color(0xFFE5322D);
  static const hudPill = Color(0xB804341E); // rgba(4,52,30,0.72)
  static const grass = Color(0xFF3C8A2E);

  // Older names still used by logic-side code.
  static const bgSage = cream;
  static const bgCream = cream;
  static const surface = card;
  static const surfaceAlt = well;
  static const primary = emerald;
  static const primaryLight = Color(0xFF66BB6A);
  static const onPrimary = Color(0xFFFFFFFF);
  static const coinGold = Color(0xFFF9C93A);
  static const coinGoldDark = Color(0xFFB8730A);
  static const heart = Color(0xFFFF4D5E);
  static const danger = Color(0xFFD32F2F);
  static const previewClear = Color(0xFF2E7D32);
  static const previewBlocked = Color(0xFFD32F2F);
  static const textPrimary = text;
  static const textSecondary = muted;
  static const textDisabled = Color(0xFF9AA59D);
  static const vipPurple = Color(0xFF7E57C2);
  static const scrim = Color(0x9903261A);

  static Color snake(SnakeColor c) => snakePalette(c).body;

  static SnakePalette snakePalette(SnakeColor c) => switch (c) {
    SnakeColor.red => const SnakePalette(
      Color(0xFFFF7043),
      Color(0xFFBF360C),
      Color(0xFFFFD1BF),
      [0.01, 3],
      1.9,
      true,
      0.85,
    ),
    SnakeColor.green => const SnakePalette(
      Color(0xFF7CB342),
      Color(0xFF33691E),
      Color(0xFFE3F2C7),
      [1.6, 1.8],
      0.9,
      true,
      0.85,
    ),
    SnakeColor.blue => const SnakePalette(
      Color(0xFF29B6F6),
      Color(0xFF01579B),
      Color(0xFFE1F5FE),
      [0.7, 2.6],
      5.2,
      false,
      0.45,
    ),
    SnakeColor.yellow => const SnakePalette(
      Color(0xFFFFCA28),
      Color(0xFFA87A00),
      Color(0xFFFFF8D6),
      [0.01, 2.2],
      1.3,
      true,
      0.9,
    ),
    SnakeColor.purple => const SnakePalette(
      Color(0xFF9575CD),
      Color(0xFF4527A0),
      Color(0xFFEDE7F6),
      [0.01, 3.4],
      2.2,
      true,
      0.8,
    ),
    SnakeColor.orange => const SnakePalette(
      Color(0xFFFFA726),
      Color(0xFFD84315),
      Color(0xFFFFE6C2),
      [1, 3.2],
      6,
      false,
      0.4,
    ),
    SnakeColor.pink => const SnakePalette(
      Color(0xFFF06292),
      Color(0xFFAD1457),
      Color(0xFFFDE3EC),
      [0.01, 2.6],
      1.6,
      true,
      0.85,
    ),
    SnakeColor.teal => const SnakePalette(
      Color(0xFF26A69A),
      Color(0xFF004D40),
      Color(0xFFD6F2EF),
      [1.4, 2.2],
      1,
      true,
      0.85,
    ),
  };
}

/// Body, outline and highlight colours plus the dash pattern that makes each
/// colour readable without colour vision (doc 06 §2.2).
class SnakePalette {
  const SnakePalette(
    this.body,
    this.dark,
    this.light,
    this.dash,
    this.patternWidth,
    this.roundCap,
    this.patternOpacity,
  );
  final Color body;
  final Color dark;
  final Color light;

  /// On/off lengths in board units (one cell = 10).
  final List<double> dash;
  final double patternWidth;
  final bool roundCap;
  final double patternOpacity;
}

class AppMotion {
  const AppMotion._();
  static const fast = Duration(milliseconds: 150);
  static const base = Duration(milliseconds: 250);
  static const bonk = Duration(milliseconds: 380);
  static const popupIn = Duration(milliseconds: 300);
  static const locked = Duration(milliseconds: 200);
  static const press = Duration(milliseconds: 140);

  /// Exit duration grows with distance: 250–450 ms.
  static Duration exitFor(int cellsTravelled) => Duration(milliseconds: (250 + cellsTravelled * 25).clamp(250, 450));

  static bool reduced(BuildContext context) => MediaQuery.maybeDisableAnimationsOf(context) ?? false;
}

/// Fredoka for headlines and numbers, Nunito for body text. Both are bundled
/// variable fonts, so weight goes through a font variation as well.
class AppText {
  const AppText._();
  static TextStyle fredoka(double size, {double weight = 600, Color color = AppColors.text, double? height}) =>
      TextStyle(
        fontFamily: 'Fredoka',
        fontSize: size,
        fontWeight: _w(weight),
        fontVariations: [FontVariation.weight(weight)],
        color: color,
        height: height,
        fontFeatures: const [FontFeature.tabularFigures()],
      );

  static TextStyle nunito(
    double size, {
    double weight = 800,
    Color color = AppColors.text,
    double? height,
    double? spacing,
  }) => TextStyle(
    fontFamily: 'Nunito',
    fontSize: size,
    fontWeight: _w(weight),
    fontVariations: [FontVariation.weight(weight)],
    color: color,
    height: height,
    letterSpacing: spacing,
  );

  static FontWeight _w(double w) => FontWeight.values[((w / 100).round() - 1).clamp(0, 8)];
}

class AppShadows {
  const AppShadows._();
  static const card = [
    BoxShadow(color: Color(0x2EB4A578), offset: Offset(0, 2)),
    BoxShadow(color: Color(0x12163B28), offset: Offset(0, 10), blurRadius: 24),
  ];
  static const chip = [BoxShadow(color: Color(0x1A163B28), offset: Offset(0, 4), blurRadius: 12)];
  static const popup = [
    BoxShadow(color: AppColors.secondaryLip, offset: Offset(0, 6)),
    BoxShadow(color: Color(0x59000000), offset: Offset(0, 30), blurRadius: 60),
  ];
  static const hud = [BoxShadow(color: Color(0x33000000), offset: Offset(0, 6), blurRadius: 14)];
}

const kCreamBackground = RadialGradient(
  center: Alignment(0, -1),
  radius: 1.25,
  colors: [AppColors.card, AppColors.cream, AppColors.creamDeep],
  stops: [0, .55, 1],
);

const kGreenButton = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [AppColors.emeraldLight, AppColors.emerald, AppColors.forest],
  stops: [0, .42, 1],
);

const kGoldButton = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [AppColors.goldLight, AppColors.gold],
);

ThemeData buildAppTheme() => ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: AppColors.emerald, surface: AppColors.cream),
  scaffoldBackgroundColor: AppColors.cream,
  fontFamily: 'Nunito',
  useMaterial3: true,
  splashFactory: NoSplash.splashFactory,
  highlightColor: Colors.transparent,
);
