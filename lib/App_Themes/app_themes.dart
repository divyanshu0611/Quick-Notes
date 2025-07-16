// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:quick_notes/App_Themes/Widget_Themes/container_theme.dart';
import 'package:quick_notes/App_Themes/Widget_Themes/icon_theme.dart';
import 'package:quick_notes/App_Themes/Widget_Themes/text_theme.dart';
import 'package:quick_notes/App_Themes/Widget_Themes/textformfield_theme.dart';

class CustomAppThemes {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: Colors.white,
    brightness: Brightness.light,
    textTheme: AppTextThemes.lightText,
    primaryColor: Colors.blue,
    canvasColor: Colors.grey.withAlpha(50),
    appBarTheme: AppBarTheme(backgroundColor: Colors.white),
    inputDecorationTheme: TextformfieldTheme.lightTheme,
    dividerTheme: DividerThemeData(color: Colors.black),
    iconTheme: CustomIconTheme.lighttheme,
    bottomAppBarTheme: BottomAppBarTheme()
    
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: Colors.black.withAlpha(80),
    brightness: Brightness.dark,
    textTheme: AppTextThemes.darkText,
    primaryColor: Colors.white,
    canvasColor: Colors.grey.withAlpha(80),
    appBarTheme: AppBarTheme(backgroundColor: Colors.black),
    inputDecorationTheme: TextformfieldTheme.darkTheme,
    dividerTheme: DividerThemeData(color: Colors.white),
    iconTheme: CustomIconTheme.darktheme,
  );
}
