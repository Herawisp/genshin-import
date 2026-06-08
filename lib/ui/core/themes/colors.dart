import 'package:flutter/material.dart';

class MyColors extends ThemeExtension<MyColors> {
  final Color? primary;
  final Color? primaryVariant;
  final Color? primaryLight;
  final Color? primaryVariantLight;
  final Color? error;
  final Color? errorVariant;
  final Color? errorLight;
  final Color? errorVariantLight;
  final Color? neutralDarkest;
  final Color? neutralMidDark;
  final Color? neutralDark;
  final Color? neutralLight;
  final Color? neutralMidLight;
  final Color? neutralLightest;
  final Color? darken;

  const MyColors({
    required this.primary,
    required this.primaryVariant,
    required this.primaryLight,
    required this.primaryVariantLight,
    required this.error,
    required this.errorVariant,
    required this.errorLight,
    required this.errorVariantLight,
    required this.neutralDarkest,
    required this.neutralMidDark,
    required this.neutralDark,
    required this.neutralLight,
    required this.neutralMidLight,
    required this.neutralLightest,
    required this.darken,
  });

  @override
  MyColors copyWith({
    Color? primary,
    Color? primaryVariant,
    Color? primaryLight,
    Color? primaryVariantLight,
    Color? secondary,
    Color? secondaryVariant,
    Color? secondaryLight,
    Color? secondaryVariantLight,
    Color? error,
    Color? errorVariant,
    Color? errorLight,
    Color? errorVariantLight,
    Color? neutralDarkest,
    Color? neutralMidDark,
    Color? neutralDark,
    Color? neutralLight,
    Color? neutralMidLight,
    Color? neutralLightest,
    Color? darken,
  }) {
    return MyColors(
      primary: primary ?? this.primary,
      primaryVariant: primaryVariant ?? this.primaryVariant,
      primaryLight: primaryLight ?? this.primaryLight,
      primaryVariantLight: primaryVariantLight ?? this.primaryVariantLight,
      error: error ?? this.error,
      errorVariant: errorVariant ?? this.errorVariant,
      errorLight: errorLight ?? this.errorLight,
      errorVariantLight: errorVariantLight ?? this.errorVariantLight,
      neutralDarkest: neutralDarkest ?? this.neutralDarkest,
      neutralMidDark: neutralMidDark ?? this.neutralMidDark,
      neutralDark: neutralDark ?? this.neutralDark,
      neutralLight: neutralLight ?? this.neutralLight,
      neutralMidLight: neutralMidLight ?? this.neutralMidLight,
      neutralLightest: neutralLightest ?? this.neutralLightest,
      darken: darken ?? this.darken,
    );
  }

  @override
  MyColors lerp(ThemeExtension<MyColors>? other, double t) {
    if (other is! MyColors) return this;
    return MyColors(
      primary: Color.lerp(primary, other.primary, t),
      primaryVariant: Color.lerp(primaryVariant, other.primaryVariant, t),
      primaryLight: Color.lerp(primaryLight, other.primaryLight, t),
      primaryVariantLight: Color.lerp(
        primaryVariantLight,
        other.primaryVariantLight,
        t,
      ),
      error: Color.lerp(error, other.error, t),
      errorVariant: Color.lerp(errorVariant, other.errorVariant, t),
      errorLight: Color.lerp(errorLight, other.errorLight, t),
      errorVariantLight: Color.lerp(
        errorVariantLight,
        other.errorVariantLight,
        t,
      ),
      neutralDarkest: Color.lerp(neutralDarkest, other.neutralDarkest, t),
      neutralMidDark: Color.lerp(neutralMidDark, other.neutralMidDark, t),
      neutralDark: Color.lerp(neutralDark, other.neutralDark, t),
      neutralLight: Color.lerp(neutralLight, other.neutralLight, t),
      neutralMidLight: Color.lerp(neutralMidLight, other.neutralMidLight, t),
      neutralLightest: Color.lerp(neutralLightest, other.neutralLightest, t),
      darken: Color.lerp(darken, other.darken, t),
    );
  }
}
