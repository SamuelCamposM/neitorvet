import 'package:flutter/material.dart';

const colorSeed = Color(0xff424CB8);
const scaffoldBackgroundColor = Colors.blue;

class AppTheme {
  final String primary;
  final String secondary;
  AppTheme({this.primary = '', this.secondary = ''});

  ThemeData getTheme(Brightness brightness) {
    Color primaryColor =
        Color(int.parse(primary.substring(1, 7), radix: 16) + 0xFF000000);
    Color secondaryColor =
        Color(int.parse(secondary.substring(1, 7), radix: 16) + 0xFF000000);

    Color defaultTextColor =
        brightness == Brightness.dark ? Colors.white : Colors.black;

    return ThemeData(
      brightness: brightness,
      fontFamily: 'Roboto',

      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        secondary: secondaryColor,
        brightness: brightness,
      ),

      ///* General
      useMaterial3: true,

      ///* Texts
      textTheme: TextTheme(
        titleLarge: TextStyle(
          fontFamily: 'Roboto',
          fontSize: 40,
          fontWeight: FontWeight.bold,
          color: defaultTextColor,
        ),
        titleMedium: TextStyle(
          fontFamily: 'Roboto',
          fontSize: 30,
          fontWeight: FontWeight.bold,
          color: defaultTextColor,
        ),
        titleSmall: TextStyle(
          fontFamily: 'Roboto',
          fontSize: 20,
          color: defaultTextColor,
        ),
        bodyLarge: TextStyle(
          fontFamily: 'Roboto',
          color: defaultTextColor,
        ),
        bodyMedium: TextStyle(
          fontFamily: 'Roboto',
          color: defaultTextColor,
        ),
        bodySmall: TextStyle(
          fontFamily: 'Roboto',
          color: defaultTextColor,
        ),
      ),

      ///* Buttons
      filledButtonTheme: FilledButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(primaryColor),
          textStyle: WidgetStateProperty.all(
            const TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),

      ///* AppBar
      appBarTheme: AppBarTheme(
        titleTextStyle: TextStyle(
          fontFamily: 'Roboto',
          fontSize: 25,
          fontWeight: FontWeight.bold,
          color: defaultTextColor,
        ),
      ),

      ///* FloatingActionButton
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        elevation: 4, // Elevación del FAB
      ),
    );
  }

  AppTheme copyWith({String? primary, String? secondary}) => AppTheme(
        primary: primary ?? this.primary,
        secondary: secondary ?? this.secondary,
      );
}
