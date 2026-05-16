import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF4A4A4A); // Modern Roast Primary
  static const Color background = Color(0xFFFBF9F8); // Warm Cream
  static const Color surface = Colors.white;
  static const Color accent = Color(0xFFD4A373); // Subtle coffee accent
  static const Color textMain = Color(0xFF2D2D2D);
  static const Color textSecondary = Color(0xFF757575);
  static const Color cardBg = Color(0xFFFFFFFF);
  static const Color shadow = Color(0x0A000000);
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Roboto', // Using Roboto as a standard high-quality clean font
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        surface: AppColors.background,
      ),
      scaffoldBackgroundColor: AppColors.background,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.textMain),
        centerTitle: false,
      ),
      textTheme: const TextTheme(
        headlineMedium: TextStyle(
          color: AppColors.textMain,
          fontWeight: FontWeight.bold,
          fontSize: 24,
        ),
        titleLarge: TextStyle(
          color: AppColors.textMain,
          fontWeight: FontWeight.w600,
          fontSize: 18,
        ),
        bodyLarge: TextStyle(
          color: AppColors.textMain,
          fontSize: 16,
        ),
        bodyMedium: TextStyle(
          color: AppColors.textSecondary,
          fontSize: 14,
        ),
      ),
    );
  }
}
