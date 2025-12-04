import 'package:flutter/material.dart';

class AppColors {
  static const Color pink = Color(0xFFFF8FB1);
  static const Color lightBlue = Color(0xFF8FD9FF);
  static const Color yellow = Color(0xFFFFE68F);
  static const Color mint = Color(0xFF9FFFCB);
  static const Color lilac = Color(0xFFCDA8FF);
  static const Color dark = Color(0xFF2A2137);
}

ThemeData buildAppTheme() {
  final base = ThemeData.light();
  return base.copyWith(
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.pink,
      brightness: Brightness.light,
      primary: AppColors.pink,
      secondary: AppColors.lilac,
      tertiary: AppColors.mint,
    ),
    scaffoldBackgroundColor: const Color(0xFFFDF9FF),
    textTheme: base.textTheme.copyWith(
      headlineLarge: const TextStyle(
        fontFamily: 'Fredoka',
        fontWeight: FontWeight.w700,
        fontSize: 32,
        color: AppColors.dark,
      ),
      bodyMedium: const TextStyle(
        fontFamily: 'Fredoka',
        fontSize: 16,
        color: AppColors.dark,
      ),
      labelLarge: const TextStyle(
        fontFamily: 'Fredoka',
        fontWeight: FontWeight.w600,
        fontSize: 14,
        color: AppColors.dark,
      ),
    ),
    cardTheme: const CardTheme(
      elevation: 6,
      shadowColor: AppColors.lilac,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(24))),
      color: Colors.white,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.pink,
      foregroundColor: Colors.white,
      centerTitle: true,
      elevation: 2,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.pink,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        textStyle: const TextStyle(
          fontFamily: 'Fredoka',
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    ),
  );
}
