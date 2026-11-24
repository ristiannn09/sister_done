import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get light => ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
        ),
        // Tambahkan google_fonts (Poppins/Inter) bila ingin font seperti desain.
        textTheme: const TextTheme(
          headlineMedium: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: AppColors.primary,
            height: 1.05,
            letterSpacing: 0.5,
          ),
          titleSmall: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textDark,
          ),
          bodyMedium: TextStyle(fontSize: 14, color: AppColors.textDark),
        ),
      );
}
