import 'package:flutter/material.dart';
import 'package:open_days_frontend/theme/custom_material_color.dart';

class CustomTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      scaffoldBackgroundColor: Colors.white,
      primarySwatch: CustomMaterialColor(1, 30, 65).getColor,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          side: const BorderSide(
            width: 2.0,
            color: Colors.blueGrey,
          ),
        ),
      ),
    );
  }

  // static var v = ElevatedButton.styleFrom();
}
