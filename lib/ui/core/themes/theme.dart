import 'package:flutter/material.dart';
import 'package:genshin_import/ui/core/themes/typography.dart';
import 'colors.dart';

extension MyThemeX on BuildContext {
  MyColors get myColors => Theme.of(this).extension<MyColors>()!;
}

class AppTheme {

  static const lightColors = MyColors(
    primary: Color(0xFF3E4557),
    primaryVariant: Color(0xFF2C2F40),
    primaryLight: Color(0xFF9FA2AB),
    primaryVariantLight: Color(0xFF666976),
    error: Color(0xFFFE4A4E),
    errorVariant: Color(0xFFEB2A2E),
    errorLight: Color(0xFFFFC9CA),
    errorVariantLight: Color(0xFFF9C0C1),
    neutralDarkest: Color(0xFF4B4B4B),
    neutralMidDark: Color(0xFF777777),
    neutralDark: Color(0xFFAFAFAF),
    neutralLight: Color(0xFFE5E5E5),
    neutralMidLight: Color(0xFFF7F7F7),
    neutralLightest: Color(0xFFFFFFFF),
    darken: Color.fromARGB(160, 0, 0, 0),
  );

  static ThemeData get light => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    textTheme: createTextTheme(),
    extensions: [lightColors],
    scaffoldBackgroundColor: lightColors.neutralLightest,

    textSelectionTheme: TextSelectionThemeData(
      selectionHandleColor: lightColors.primary,
      selectionColor: lightColors.primaryLight,
      cursorColor: lightColors.primary,
    ),
  );

  
}