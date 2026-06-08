import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

TextTheme createTextTheme() {
  final baseTextTheme = GoogleFonts.nunitoTextTheme(const TextTheme());

  return baseTextTheme.copyWith(
    displayLarge: baseTextTheme.displayLarge?.copyWith(
      fontWeight: FontWeight.bold,
    ),
    displayMedium: baseTextTheme.displayMedium?.copyWith(
      fontWeight: FontWeight.bold,
    ),
    displaySmall: baseTextTheme.displaySmall?.copyWith(
      fontWeight: FontWeight.bold,
    ),

    bodyLarge: baseTextTheme.bodyLarge?.copyWith(fontWeight: FontWeight.normal),
    bodyMedium: baseTextTheme.bodyMedium?.copyWith(
      fontWeight: FontWeight.normal,
    ),
    bodySmall: baseTextTheme.bodySmall?.copyWith(fontWeight: FontWeight.normal),

    titleLarge: baseTextTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
    titleMedium: baseTextTheme.titleMedium?.copyWith(
      fontWeight: FontWeight.bold,
    ),
    titleSmall: baseTextTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),

    labelLarge: TextStyle(
      fontFamily: 'HYWenHei',
      fontSize: 14,
      height: 20 / 14,
    ),
    labelMedium: TextStyle(
      fontFamily: 'HYWenHei',
      fontSize: 12,
      height: 16 / 12,
    ),
    labelSmall: TextStyle(
      fontFamily: 'HYWenHei',
      fontSize: 11,
      height: 16 / 11,
    ),

    headlineLarge: TextStyle(
      fontFamily: 'HYWenHei',
      fontSize: 32,
      height: 40 / 32,
    ),
    headlineMedium: TextStyle(
      fontFamily: 'HYWenHei',
      fontSize: 28,
      height: 36 / 28,
    ),
    headlineSmall: TextStyle(
      fontFamily: 'HYWenHei',
      fontSize: 24,
      height: 32 / 24,
    ),
  );
}

extension CustomLabels on TextTheme {
  TextStyle get tinyLabelLarge =>
      const TextStyle(fontFamily: 'HYWenHei', fontSize: 8, height: 12 / 8);

  TextStyle get tinyLabelMedium =>
      const TextStyle(fontFamily: 'HYWenHei', fontSize: 6, height: 8 / 6);

  TextStyle get tinyLabelSmall =>
      const TextStyle(fontFamily: 'HYWenHei', fontSize: 4, height: 6 / 4);
}
