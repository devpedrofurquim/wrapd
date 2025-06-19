// app_theme.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  static final _baseTextTheme = GoogleFonts.interTextTheme();

  static final light = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.indigo,
      brightness: Brightness.light,
    ),
    extensions: const [
      AppColors(
        brandPrimary: Color(0xFF7C3AED), // Purple
        textSecondary: Color(0xFF9CA3AF), // Gray
        surfaceCard: Color(0xFFF3F4F6), // Card light surface
        success: Color(0xFF10B981), // Green
        warning: Color(0xFFF59E0B),
      ),
    ],
    scaffoldBackgroundColor: Colors.white,
    textTheme: _baseTextTheme.apply(
      bodyColor: Colors.black, // for light theme
      displayColor: Colors.black,
    ),
  );

  static final dark = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.indigo,
      brightness: Brightness.dark,
    ),
    extensions: const [
      AppColors(
        brandPrimary: Color(0xFF9F7AEA),
        textSecondary: Color(0xFFCBD5E1),
        surfaceCard: Color(0xFF1F2937),
        success: Color(0xFF10B981),
        warning: Color(0xFFF59E0B),
      ),
    ],
    scaffoldBackgroundColor: const Color(0xFF121212),
    textTheme: _baseTextTheme.apply(
      bodyColor: Colors.white, // for light theme
      displayColor: Colors.white,
    ),
  );
}
