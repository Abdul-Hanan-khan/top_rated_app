import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ColorScheme light = ColorScheme.light(
    primary: AppColor.primary,
    onPrimary: Colors.white,
    primaryVariant: AppColor.primaryDark,
    secondary: AppColor.secondary,
    onSecondary: Colors.white,
    secondaryVariant: AppColor.secondaryDark,
    background: AppColor.background,
    onBackground: AppColor.primaryTextColor,
    surface: AppColor.surface,
    onSurface: AppColor.primaryTextColor,
    error: AppColor.error,
    onError: AppColor.primaryTextColor,
    brightness: Brightness.light,
  );
}

class AppTextTheme {
  static final _primaryStyle = GoogleFonts.roboto;
  static final _secondaryStyle = GoogleFonts.openSans;
  static TextTheme get normal => TextTheme(
        headline1: _primaryStyle(
          fontSize: 96,
          fontWeight: FontWeight.w300,
          color: AppColor.primaryTextColor,
          letterSpacing: -1.5,
        ),
        headline2: _primaryStyle(
          fontSize: 60,
          fontWeight: FontWeight.w300,
          color: AppColor.primaryTextColor,
          letterSpacing: -0.5,
        ),
        headline3: _primaryStyle(
          fontSize: 48,
          letterSpacing: 0,
        ),
        headline4: _primaryStyle(
          fontSize: 34,
          color: AppColor.primaryTextColor,
          letterSpacing: 0.25,
        ),
        headline5: _primaryStyle(
          fontSize: 24,
          color: AppColor.primaryTextColor,
          letterSpacing: 0,
        ),
        headline6: _primaryStyle(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: AppColor.primaryTextColor,
          letterSpacing: 0.15,
        ),
        subtitle1: _primaryStyle(
          fontSize: 17,
          color: AppColor.primaryTextColor,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.15,
        ),
        subtitle2: _primaryStyle(
          fontSize: 15,
          color: AppColor.primaryTextColor,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.1,
        ),
        bodyText1: _secondaryStyle(
          fontSize: 16,
          letterSpacing: 0.5,
        ),
        bodyText2: _secondaryStyle(
          fontSize: 14,
          letterSpacing: 0.25,
        ),
        button: _primaryStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          // letterSpacing: 1.25,
        ),
        caption: _secondaryStyle(
          fontSize: 13,
          letterSpacing: 0.4,
        ),
        overline: _secondaryStyle(
          fontSize: 10,
          letterSpacing: 1.5,
        ),
      );
}

class AppColor {
  static const primary = Color(0xFFEC4426);
  static const primaryDark = Color(0xFFEC4426);

  static const secondary = Color(0xFFFCA93D);
  static const secondaryDark = Color(0xFFFCA93D);

  static const error = Colors.redAccent;

  static const background = Color(0xFFE9EEF1);
  static const surface = Color(0xFFFFFFFF);

  static const selection = Color(0xFFebebeb);
  static const dividerColor = Color(0xFF393939);
  static const iconsColor = secondary;
  static const textFieldFill = Color(0xFFebebeb);
  // static const primaryTextColor = Color(0xFF393939);
  static const primaryTextColor = Color(0xFF90A1B9);
  static const primaryDisplayColor = Colors.grey;
  static const accentTextColor = Colors.white;
  static const accentDisplayColor = Color(0xFFF7F7F7);
  static const secondaryBackground = Color(0xFFE5E5E5);
}
