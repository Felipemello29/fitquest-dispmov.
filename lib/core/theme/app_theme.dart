import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RPGTheme {
  // Colors
  static const Color darkParchment = Color(0xFF1E1A15);
  static const Color lightParchment = Color(0xFFF5EFE3);
  
  static const Color inkDark = Color(0xFF2C251E);
  static const Color inkLight = Color(0xFFE8DCC4);
  
  static const Color primaryGold = Color(0xFFD4AF37);
  static const Color accentCrimson = Color(0xFF9E2A2B);
  static const Color forestGreen = Color(0xFF386641);
  static const Color manaBlue = Color(0xFF1D3557);

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: darkParchment,
      colorScheme: const ColorScheme.dark(
        primary: primaryGold,
        secondary: inkLight,
        background: darkParchment,
        error: accentCrimson,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: const Color(0xFF15120E),
        elevation: 4,
        titleTextStyle: GoogleFonts.cinzel(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: primaryGold,
        ),
        iconTheme: const IconThemeData(color: primaryGold),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(0xFF15120E),
        selectedItemColor: primaryGold,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
      ),
      textTheme: TextTheme(
        headlineLarge: GoogleFonts.cinzel(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: primaryGold,
        ),
        headlineMedium: GoogleFonts.cinzel(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: primaryGold,
        ),
        titleLarge: GoogleFonts.cinzel(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: inkLight,
        ),
        bodyLarge: GoogleFonts.specialElite(
          fontSize: 16,
          color: inkLight,
        ),
        bodyMedium: GoogleFonts.specialElite(
          fontSize: 14,
          color: inkLight.withOpacity(0.8),
        ),
      ),
      cardTheme: CardTheme(
        color: const Color(0xFF28231C),
        elevation: 2,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Color(0xFF42372A), width: 1.5),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
