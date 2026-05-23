import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

TextTheme createTextTheme() {
  final baseTextTheme = GoogleFonts.nunitoTextTheme(const TextTheme());

  return baseTextTheme.copyWith(
    displayLarge: baseTextTheme.displayLarge?.copyWith(fontWeight: FontWeight.bold),
    displayMedium: baseTextTheme.displayMedium?.copyWith(fontWeight: FontWeight.bold),
    displaySmall: baseTextTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold),

    headlineLarge: baseTextTheme.headlineLarge?.copyWith(fontWeight: FontWeight.w600),
    headlineMedium: baseTextTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w600),
    headlineSmall: baseTextTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600),
    
    bodyLarge: baseTextTheme.bodyLarge?.copyWith(fontWeight: FontWeight.normal),
    bodyMedium: baseTextTheme.bodyMedium?.copyWith(fontWeight: FontWeight.normal),
    bodySmall: baseTextTheme.bodySmall?.copyWith(fontWeight: FontWeight.normal),

    titleLarge: baseTextTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
    titleMedium: baseTextTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
    titleSmall: baseTextTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),

    labelLarge: TextStyle(
      fontFamily: 'Jellee',
      fontSize: 14,
      height: 20 / 14,
    ),
    labelMedium: TextStyle(
      fontFamily: 'Jellee',
      fontSize: 12,
      height: 16 / 12,
    ),
    labelSmall: TextStyle(
      fontFamily: 'Jellee',
      fontSize: 11,
      height: 16 / 11,
    ),
  );
}