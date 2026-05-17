import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color primary = Color(0xFF322115); // Dark Brown
  static const Color background = Color(0xFFFCF8F5); // Warm Cream
  static const Color surface = Colors.white;
  static const Color accent = Color(0xFFD4A373); // Muted Gold/Brown
  static const Color accentLight = Color(0xFFE9D7C3);
  static const Color textMain = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF757575);
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      textTheme: GoogleFonts.montserratTextTheme().copyWith(
        headlineLarge: GoogleFonts.playfairDisplay(
          color: AppColors.textMain,
          fontWeight: FontWeight.w900,
          fontSize: 28,
          letterSpacing: -0.5,
        ),
        headlineMedium: GoogleFonts.playfairDisplay(
          color: AppColors.textMain,
          fontWeight: FontWeight.bold,
          fontSize: 22,
        ),
        titleLarge: GoogleFonts.montserrat(
          color: AppColors.textMain,
          fontWeight: FontWeight.w700,
          fontSize: 16,
        ),
        bodyLarge: GoogleFonts.montserrat(
          color: AppColors.textMain,
          fontSize: 14,
        ),
        bodyMedium: GoogleFonts.montserrat(
          color: AppColors.textSecondary,
          fontSize: 12,
        ),
      ),
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        surface: AppColors.background,
      ),
      scaffoldBackgroundColor: AppColors.background,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: AppColors.textMain),
        titleTextStyle: GoogleFonts.playfairDisplay(
          color: AppColors.textMain,
          fontSize: 22,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}
