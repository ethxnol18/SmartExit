import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'constants.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      primaryColor: AppColors.primary,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        surface: AppColors.surface,
        error: AppColors.error,
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.sora(
            color: AppColors.textPrimary, fontWeight: FontWeight.bold),
        displayMedium: GoogleFonts.sora(
            color: AppColors.textPrimary, fontWeight: FontWeight.bold),
        displaySmall: GoogleFonts.sora(
            color: AppColors.textPrimary, fontWeight: FontWeight.bold),
        headlineLarge: GoogleFonts.sora(
            color: AppColors.textPrimary, fontWeight: FontWeight.bold),
        headlineMedium: GoogleFonts.sora(
            color: AppColors.textPrimary, fontWeight: FontWeight.bold),
        headlineSmall: GoogleFonts.sora(
            color: AppColors.textPrimary, fontWeight: FontWeight.bold),
        titleLarge: GoogleFonts.sora(
            color: AppColors.textPrimary, fontWeight: FontWeight.w600),
        titleMedium: GoogleFonts.sora(
            color: AppColors.textPrimary, fontWeight: FontWeight.w600),
        titleSmall: GoogleFonts.sora(
            color: AppColors.textPrimary, fontWeight: FontWeight.w600),
        bodyLarge: GoogleFonts.dmSans(color: AppColors.textPrimary),
        bodyMedium: GoogleFonts.dmSans(color: AppColors.textPrimary),
        bodySmall: GoogleFonts.dmSans(color: AppColors.textSecondary),
        labelLarge: GoogleFonts.dmSans(
            color: AppColors.primary, fontWeight: FontWeight.bold),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.black,
          textStyle: GoogleFonts.sora(fontWeight: FontWeight.bold),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }
}
