import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'tokens.dart';

ThemeData buildAppTheme() {
  final base = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      primary: AppColors.primary,
      surface: AppColors.bgCream,
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: AppColors.bgSage,
  );
  return base.copyWith(
    textTheme: base.textTheme.apply(
      fontFamily: GoogleFonts.nunito().fontFamily,
      bodyColor: AppColors.textPrimary,
      displayColor: AppColors.textPrimary,
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: AppColors.textPrimary,
      contentTextStyle: GoogleFonts.nunito(color: Colors.white, fontWeight: FontWeight.w700),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Radii.sm)),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.all(Colors.white),
      trackColor: WidgetStateProperty.resolveWith(
        (s) => s.contains(WidgetState.selected) ? AppColors.primary : AppColors.textDisabled,
      ),
      trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
    ),
  );
}
