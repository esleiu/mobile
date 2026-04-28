import 'package:flutter/material.dart';

class AppColors {
  static const primaryBlue = Color(0xFF0A4AA7);
  static const accentBlue = Color(0xFF1A63C6);
  static const canvas = Color(0xFFF2F5FA);
  static const card = Color(0xFFFFFFFF);
  static const success = Color(0xFF2FA45A);
  static const warning = Color(0xFFDAA11D);
  static const danger = Color(0xFFC74D4D);
  static const textPrimary = Color(0xFF1E2A3A);
  static const textSecondary = Color(0xFF667487);
}

ThemeData buildAppTheme() {
  final scheme = ColorScheme.fromSeed(
    seedColor: AppColors.primaryBlue,
    primary: AppColors.primaryBlue,
    surface: AppColors.card,
    brightness: Brightness.light,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: AppColors.canvas,
    cardTheme: CardThemeData(
      color: AppColors.card,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFFE6EBF2)),
      ),
    ),
    textTheme: const TextTheme(
      headlineSmall: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: Colors.white,
      ),
      titleLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
      bodyLarge: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
      ),
      bodyMedium: TextStyle(fontSize: 14, color: AppColors.textSecondary),
      labelMedium: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.accentBlue, width: 1.4),
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      height: 68,
      labelTextStyle: WidgetStateProperty.resolveWith(
        (states) => TextStyle(
          fontSize: 12,
          fontWeight: states.contains(WidgetState.selected)
              ? FontWeight.w700
              : FontWeight.w500,
          color: states.contains(WidgetState.selected)
              ? AppColors.primaryBlue
              : AppColors.textSecondary,
        ),
      ),
      indicatorColor: const Color(0xFFDCE9FF),
      backgroundColor: Colors.white,
    ),
  );
}
