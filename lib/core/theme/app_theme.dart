import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RPGTheme {
  // Pencil and Paper Colors
  static const Color paperBackground = Color(0xFFF9F6EE); // Off-white paper
  static const Color graphiteDark = Color(0xFF2B2B2B); // Dark pencil lead
  static const Color graphiteMedium = Color(0xFF595959); // Medium pencil stroke
  static const Color graphiteLight = Color(0xFFA9A9A9); // Light sketching
  static const Color redPencil = Color(0xFFD64933); // Red pencil for accents

  static ThemeData get paperTheme {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: paperBackground,
      colorScheme: const ColorScheme.light(
        primary: graphiteDark,
        secondary: graphiteMedium,
        surface: paperBackground,
        error: redPencil,
        onPrimary: paperBackground,
        onSecondary: paperBackground,
        onSurface: graphiteDark,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: paperBackground,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: graphiteDark),
        titleTextStyle: GoogleFonts.architectsDaughter(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: graphiteDark,
          letterSpacing: 1.2,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: paperBackground,
        selectedItemColor: graphiteDark,
        unselectedItemColor: graphiteLight,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        color: paperBackground,
        elevation: 0,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: graphiteMedium, width: 2),
          borderRadius: BorderRadius.circular(4), // Slightly imperfect looking
        ),
      ),
      textTheme: TextTheme(
        headlineLarge: GoogleFonts.architectsDaughter(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: graphiteDark,
        ),
        headlineMedium: GoogleFonts.architectsDaughter(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: graphiteDark,
        ),
        titleLarge: GoogleFonts.patrickHand(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: graphiteDark,
        ),
        bodyLarge: GoogleFonts.patrickHand(
          fontSize: 18,
          color: graphiteDark,
        ),
        bodyMedium: GoogleFonts.patrickHand(
          fontSize: 16,
          color: graphiteMedium,
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: graphiteLight,
        thickness: 1.5,
      ),
    );
  }
}
