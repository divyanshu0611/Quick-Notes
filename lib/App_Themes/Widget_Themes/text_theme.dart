import 'package:flutter/material.dart';
import 'package:quick_notes/App_Themes/App_Colors/app_colors.dart';

class AppTextThemes {
  // Font Family Name (make this consistent in all styles)
  static const String _fontFamily = "Poppins";

  /// 🌞 LIGHT THEME TEXT STYLES
  static TextTheme lightText = TextTheme(
    // Main Titles (ex: Screen Titles)
    titleLarge: TextStyle(
      fontFamily: _fontFamily,
      fontWeight: FontWeight.w700,
      fontSize: 26,
      color: AppColors.blackTextColor,
    ),

    // Large Headlines
    headlineLarge: TextStyle(
      fontFamily: _fontFamily,
      fontWeight: FontWeight.w600,
      fontSize: 22,
      color: AppColors.blackTextColor,
    ),

    // Body Text (for paragraphs)
    bodyLarge: TextStyle(
      fontFamily: _fontFamily,
      fontWeight: FontWeight.w400,
      fontSize: 16,
      color: AppColors.blackTextColor,
    ),

    // Display Text (emphasis banners or headings)
    displayLarge: TextStyle(
      fontFamily: _fontFamily,
      fontWeight: FontWeight.w800,
      fontSize: 30,
      color: AppColors.blackTextColor,
    ),

    // Label Text (buttons, small UI elements)
    labelLarge: TextStyle(
      fontFamily: _fontFamily,
      fontWeight: FontWeight.w500,
      fontSize: 13,
      color: AppColors.greyTextColor,
    ),
  );

  /// 🌚 DARK THEME TEXT STYLES
  static TextTheme darkText = TextTheme(
    titleLarge: TextStyle(
      fontFamily: _fontFamily,
      fontWeight: FontWeight.w700,
      fontSize: 26,
      color: AppColors.whiteTextColor,
    ),

    headlineLarge: TextStyle(
      fontFamily: _fontFamily,
      fontWeight: FontWeight.w600,
      fontSize: 22,
      color: AppColors.whiteTextColor,
    ),

    bodyLarge: TextStyle(
      fontFamily: _fontFamily,
      fontWeight: FontWeight.w400,
      fontSize: 16,
      color: AppColors.whiteTextColor,
    ),

    displayLarge: TextStyle(
      fontFamily: _fontFamily,
      fontWeight: FontWeight.w800,
      fontSize: 30,
      color: AppColors.whiteTextColor,
    ),

    labelLarge: TextStyle(
      fontFamily: _fontFamily,
      fontWeight: FontWeight.w500,
      fontSize: 13,
      color: AppColors.greyTextColor,
    ),
  );
}
