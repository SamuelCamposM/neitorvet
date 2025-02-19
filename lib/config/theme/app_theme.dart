import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const colorSeed = Color(0xff424CB8);
const scaffoldBackgroundColor = Color(0xFFF8F7F7);

class AppTheme {
  final String primary;
  final String secondary;
  AppTheme({this.primary = '', this.secondary = ''});

  ThemeData getTheme(Brightness brightness) {
    Color primaryColor =
        Color(int.parse(primary.substring(1, 7), radix: 16) + 0xFF000000);
    Color secondaryColor =
        Color(int.parse(secondary.substring(1, 7), radix: 16) + 0xFF000000);

    return ThemeData(
      brightness: brightness,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        secondary: secondaryColor,
        brightness: brightness, // Asegura que coincida con ThemeData.brightness
      ),

      ///* General
      useMaterial3: true,

      ///* Texts
      textTheme: TextTheme(
          titleLarge: GoogleFonts.montserratAlternates()
              .copyWith(fontSize: 40, fontWeight: FontWeight.bold),
          titleMedium: GoogleFonts.montserratAlternates()
              .copyWith(fontSize: 30, fontWeight: FontWeight.bold),
          titleSmall:
              GoogleFonts.montserratAlternates().copyWith(fontSize: 20)),
      // scaffoldBackgroundColor:
      //     Color(int.parse(primary.substring(1, 7), radix: 16) + 0xFF000000),

      ///* Buttons
      filledButtonTheme: FilledButtonThemeData(
          style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(Color(
                  int.parse(primary.substring(1, 7), radix: 16) + 0xFF000000)),
              textStyle: WidgetStatePropertyAll(
                  GoogleFonts.montserratAlternates()
                      .copyWith(fontWeight: FontWeight.w700)))),

      ///* AppBar
      appBarTheme: AppBarTheme(
        titleTextStyle: GoogleFonts.montserratAlternates().copyWith(
          fontSize: 25,
          fontWeight: FontWeight.bold,
          color: brightness == Brightness.dark ? Colors.white : Colors.black,
        ),
      ),

      ///* FloatingActionButton
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        elevation: 4, // Elevación del FAB
      ),
    );
  }

  AppTheme copyWith({String? primary, String? secondary}) => AppTheme(
      primary: primary ?? this.primary, secondary: secondary ?? this.secondary);
}
