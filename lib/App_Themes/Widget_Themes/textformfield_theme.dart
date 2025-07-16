import 'package:flutter/material.dart';

class TextformfieldTheme {
  TextformfieldTheme._();

  static InputDecorationTheme lightTheme = InputDecorationTheme(
    enabledBorder: OutlineInputBorder(
      
      borderSide: const BorderSide(width: 1, color: Colors.black),
    ),
  );
  static InputDecorationTheme darkTheme = InputDecorationTheme(
    enabledBorder: OutlineInputBorder(
      borderSide: const BorderSide(width: 1, color: Colors.white),
    ),
  );
}
