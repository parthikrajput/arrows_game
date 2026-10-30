import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'tokens.dart';

abstract final class AppText {
  static TextStyle _fredoka(double size, double height, {Color color = AppColors.textPrimary}) =>
      GoogleFonts.fredoka(fontSize: size, height: height / size, fontWeight: FontWeight.w600, color: color);

  static TextStyle _nunito(double size, double height, {FontWeight weight = FontWeight.w500, Color color = AppColors.textPrimary}) =>
      GoogleFonts.nunito(fontSize: size, height: height / size, fontWeight: weight, color: color);

  static TextStyle get display => _fredoka(32, 40);
  static TextStyle get h1 => _fredoka(24, 32);
  static TextStyle get h2 => _fredoka(20, 28);
  static TextStyle get body => _nunito(16, 24);
  static TextStyle get bodyBold => _nunito(16, 24, weight: FontWeight.w800);
  static TextStyle get caption => _nunito(13, 18, color: AppColors.textSecondary);
  static TextStyle get button => _fredoka(18, 24, color: AppColors.onPrimary);
  static TextStyle get hudNumber =>
      _fredoka(20, 24).copyWith(fontFeatures: const [FontFeature.tabularFigures()]);
}
