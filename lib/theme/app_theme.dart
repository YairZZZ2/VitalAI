import 'package:flutter/material.dart';

class AppTheme {
  // Color principal
  static const Color primaryColor = Color(0xFF9C27B0); // morado pastel

  // Paleta de colores pastel
  static const Color secondaryColor = Color(0xFF81D4FA); // azul pastel
  static const Color accentColor = Color(0xFFFFB74D);    // naranja pastel
  static const Color backgroundColor = Color(0xFFF3E5F5); // fondo lila muy claro

  // Tema claro
  static final ThemeData lightTheme = ThemeData(
    colorScheme: ColorScheme.light(
      primary: primaryColor,
      secondary: secondaryColor,
      surface: backgroundColor,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      elevation: 2,
    ),
    cardTheme: CardThemeData(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 3,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
  );
}
