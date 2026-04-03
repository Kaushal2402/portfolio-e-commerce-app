import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Luxury Palette
  static const Color primaryColor = Color(0xFF1E1E1E); // Deep Midnight
  static const Color accentColor = Color(0xFFD4AF37); // Rose Gold / Metallic Gold
  static const Color secondaryColor = Color(0xFF2C2C2C); // Dark Gray
  static const Color glassColor = Color(0x33FFFFFF); // Translucent White
  static const Color textBodyColor = Color(0xFFE0E0E0);
  static const Color textHeadingColor = Colors.white;

  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: const Color(0xFFF8F8F8),
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        secondary: accentColor,
        surface: Colors.white,
      ),
      textTheme: GoogleFonts.outfitTextTheme(
        ThemeData.light().textTheme,
      ).apply(
        bodyColor: primaryColor,
        displayColor: primaryColor,
      ),
      useMaterial3: true,
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: accentColor,
      scaffoldBackgroundColor: primaryColor,
      colorScheme: const ColorScheme.dark(
        primary: accentColor,
        secondary: Color(0xFFE1B12C),
        surface: secondaryColor,
      ),
      textTheme: GoogleFonts.outfitTextTheme(
        ThemeData.dark().textTheme,
      ).apply(
        bodyColor: textBodyColor,
        displayColor: textHeadingColor,
      ),
      useMaterial3: true,
    );
  }
}
