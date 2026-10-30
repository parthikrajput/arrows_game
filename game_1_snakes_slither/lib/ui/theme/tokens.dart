// OWNER: Antigravity (UI). Seeded with the doc 06 token values so the
// placeholders compile; extend freely, but keep names stable once used.
import 'package:flutter/material.dart';

import '../../contracts/view_models.dart';

class AppColors {
  const AppColors._();
  static const bgSage = Color(0xFFE8F5E9);
  static const bgCream = Color(0xFFFFFBF2);
  static const surface = Color(0xFFFFFFFF);
  static const surfaceAlt = Color(0xFFF7F9FA);
  static const primary = Color(0xFF2E7D32);
  static const primaryLight = Color(0xFF66BB6A);
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
  static const vipPurple = Color(0xFF7E57C2);
  static const scrim = Color(0x73000000);

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
}

class AppMotion {
  const AppMotion._();
  static const fast = Duration(milliseconds: 150);
  static const base = Duration(milliseconds: 250);
  static const bonk = Duration(milliseconds: 380);
  static const popupIn = Duration(milliseconds: 300);
  static const locked = Duration(milliseconds: 200);

  /// Exit duration grows with distance: 250–450 ms.
  static Duration exitFor(int cellsTravelled) =>
      Duration(milliseconds: (250 + cellsTravelled * 25).clamp(250, 450));
}

ThemeData buildAppTheme() => ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary, surface: AppColors.bgCream),
  scaffoldBackgroundColor: AppColors.bgSage,
  useMaterial3: true,
);
