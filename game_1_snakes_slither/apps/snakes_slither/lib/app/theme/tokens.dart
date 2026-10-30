import 'package:flutter/material.dart';
import 'package:puzzle_core/slither_engine.dart';

abstract final class AppColors {
  static const bgSage = Color(0xFFE8F5E9);
  static const bgCream = Color(0xFFFFFBF2);
  static const surface = Color(0xFFFFFFFF);
  static const surfaceAlt = Color(0xFFF7F9FA);
  static const primary = Color(0xFF2E7D32);
  static const primaryLight = Color(0xFF66BB6A);
  static const primaryDark = Color(0xFF1B5E20);
  static const onPrimary = Color(0xFFFFFFFF);
  static const coinGold = Color(0xFFFFCA28);
  static const coinGoldDark = Color(0xFFB8860B);
  static const heart = Color(0xFFE53935);
  static const danger = Color(0xFFC62828);
  static const previewClear = Color(0xFF2E7D32);
  static const previewBlocked = Color(0xFFD32F2F);
  static const textPrimary = Color(0xFF1B2B1F);
  static const textSecondary = Color(0xFF5B6B5F);
  static const textDisabled = Color(0xFF9AA59D);
  static const scrim = Color(0x73000000);
  static const vipPurple = Color(0xFF7E57C2);
  static const creamLip = Color(0xFFC9B993);
  static const creamEdge = Color(0xFFF2ECDD);
  static const wood = Color(0xFF8D6E63);
  static const sky = Color(0xFFBFE4F4);
  static const grassLight = Color(0xFFA9D893);
  static const grass = Color(0xFF7FBF62);

  static Color snake(SnakeColor c) => switch (c) {
        SnakeColor.red => const Color(0xFFFF7043),
        SnakeColor.green => const Color(0xFF7CB342),
        SnakeColor.blue => const Color(0xFF29B6F6),
        SnakeColor.yellow => const Color(0xFFFFCA28),
        SnakeColor.purple => const Color(0xFF9575CD),
        SnakeColor.orange => const Color(0xFFFFA726),
        SnakeColor.pink => const Color(0xFFF06292),
        SnakeColor.teal => const Color(0xFF26A69A),
        SnakeColor.gold => const Color(0xFFFFC107),
      };

  /// Board tint per biome (by level).
  static Color biomeTint(int level) {
    if (level <= 100) return const Color(0xFFE8F5E9);
    if (level <= 200) return const Color(0xFFE6F2DF);
    if (level <= 300) return const Color(0xFFFFF4E0);
    if (level <= 400) return const Color(0xFFE3EFEA);
    return const Color(0xFFE4E8F5);
  }
}

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

abstract final class Radii {
  static const double xs = 8;
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 24;
  static const double pill = 999;
}

abstract final class Shadows {
  static const elev1 = [BoxShadow(color: Color(0x14000000), blurRadius: 12, offset: Offset(0, 4))];
  static const elev2 = [BoxShadow(color: Color(0x1F000000), blurRadius: 24, offset: Offset(0, 8))];

  static List<BoxShadow> bevel(Color lip, {bool pressed = false}) => [
        BoxShadow(color: lip, blurRadius: 0, offset: Offset(0, pressed ? 1 : 4)),
        if (!pressed) const BoxShadow(color: Color(0x1F283C1E), blurRadius: 12, offset: Offset(0, 6)),
      ];
}

abstract final class Motion {
  static const fast = Duration(milliseconds: 150);
  static const base = Duration(milliseconds: 250);
  static const bonk = Duration(milliseconds: 380);
  static const popupIn = Duration(milliseconds: 300);
  static const Curve fastCurve = Curves.easeOut;
  static const Curve baseCurve = Curves.easeOutCubic;
  static const Curve popupCurve = Curves.easeOutBack;
}
