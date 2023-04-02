import 'package:flutter/material.dart';

import './custom_material_color.dart';

class CustomTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      scaffoldBackgroundColor: Colors.white,
      hintColor: const Color.fromRGBO(191, 191, 191, 1),
      primaryColor: const Color.fromRGBO(38, 70, 83, 1),
      cardColor: const Color.fromRGBO(234, 234, 234, 1),
      dividerColor: const Color.fromRGBO(38, 70, 83, 0.2),
      primarySwatch: CustomMaterialColor(38, 70, 83).getColor,

      //
      appBarTheme: const AppBarTheme(
        titleTextStyle: TextStyle(
          fontSize: 22,
          fontFamily: 'Tahoma',
          color: Colors.white,
        ),
      ),

      iconTheme: const IconThemeData(
        color: Color.fromRGBO(138, 138, 138, 1),
      ),

      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateProperty.resolveWith(
          (states) {
            if (states.contains(MaterialState.selected)) {
              return const Color.fromRGBO(38, 70, 83, 1);
            }
            return null;
          },
        ),
      ),

      inputDecorationTheme: const InputDecorationTheme(
        counterStyle: TextStyle(
          fontFamily: 'Tahoma',
          color: Color.fromRGBO(191, 191, 191, 1),
        ),
        labelStyle: TextStyle(
          color: Color.fromRGBO(191, 191, 191, 1),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Color.fromRGBO(38, 70, 83, 0.2)),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          textStyle: const TextStyle(
            fontSize: 18,
            fontFamily: 'Tahoma',
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          textStyle: const TextStyle(
            fontSize: 18,
            fontFamily: 'Tahoma',
            fontWeight: FontWeight.w500,
            color: Color.fromRGBO(38, 70, 83, 1),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          side: const BorderSide(
            width: 2.0,
            color: Color.fromRGBO(38, 70, 83, 1),
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: Colors.white,
          textStyle: const TextStyle(
            fontFamily: 'Tahoma',
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),

      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
      ),

      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        foregroundColor: Colors.white,
        backgroundColor: Color.fromRGBO(38, 70, 83, 1),
      ),

      textTheme: const TextTheme(
        button: TextStyle(
          fontSize: 18.0,
          color: Color.fromRGBO(38, 70, 83, 1),
        ),

        headline5: TextStyle(
          fontSize: 24.0,
          fontFamily: 'Tahoma',
        ),

        // For ex: text on event cards
        headline6: TextStyle(
          fontSize: 20.0,
          fontFamily: 'Tahoma',
        ),

        bodyText1: TextStyle(
          fontSize: 16.0,
          fontFamily: 'Tahoma',
        ),

        bodyText2: TextStyle(
          fontSize: 14.0,
          fontFamily: 'Tahoma',
        ),
      ),
    );
  }
}
