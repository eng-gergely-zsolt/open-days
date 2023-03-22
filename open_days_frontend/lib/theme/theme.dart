import 'package:flutter/material.dart';

import './custom_material_color.dart';

class CustomTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      hintColor: Colors.blueGrey,
      scaffoldBackgroundColor: Colors.white,
      primaryColor: const Color.fromRGBO(1, 30, 65, 1),
      dividerColor: const Color.fromRGBO(170, 170, 170, 0.4),
      primarySwatch: CustomMaterialColor(1, 30, 65).getColor,
      iconTheme: const IconThemeData(
        color: Color.fromRGBO(1, 30, 65, 1),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateProperty.resolveWith(
          (states) {
            if (states.contains(MaterialState.selected)) {
              return const Color.fromRGBO(1, 30, 65, 1);
            }
            return null;
          },
        ),
      ),
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
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        foregroundColor: Colors.white,
        backgroundColor: Color.fromRGBO(1, 30, 65, 1),
      ),
      textTheme: const TextTheme(
        button: TextStyle(
          fontSize: 18.0,
          color: Color.fromRGBO(1, 30, 65, 1),
        ),

        headline5: TextStyle(
          fontSize: 24.0,
          color: Color.fromRGBO(1, 30, 65, 1),
        ),

        // For ex: text on event cards
        headline6: TextStyle(
          fontSize: 20.0,
          color: Color.fromRGBO(1, 30, 65, 1),
        ),

        bodyText1: TextStyle(
          fontSize: 16.0,
          color: Colors.blueGrey,
        ),
      ),
    );
  }
}
