import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF1B5E20);
  static const Color surfaceColor = Color(0xFFFAFAFA);
  static const Color onSurfaceColor = Color(0xFF1C1B1F);
  static const Color arabicTextColor = Color(0xFF212121);
  static const Color accentColor = Color(0xFF4CAF50);

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.light(
      primary: primaryColor,
      surface: surfaceColor,
      onSurface: onSurfaceColor,
      secondary: accentColor,
    ),
    fontFamily: 'ScheherazadeNew',
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: onSurfaceColor,
      ),
      headlineMedium: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: onSurfaceColor,
      ),
      bodyLarge: TextStyle(
        fontSize: 18,
        color: onSurfaceColor,
      ),
      bodyMedium: TextStyle(
        fontSize: 16,
        color: onSurfaceColor,
      ),
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: onSurfaceColor,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 48),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    cardTheme: CardThemeData(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
    ),
  );

  static const double previewWidth = 270;
  static const double previewHeight = 480;
  static const double videoWidth = 1080.0;
  static const double videoHeight = 1920.0;
}