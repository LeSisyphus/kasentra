import 'package:flutter/material.dart';

class KasentraColors {
  static const primary = Color(0xFF647C5D);
  static const primaryDark = Color(0xFF40513B);
  static const primarySoft = Color(0xFFE8EFE4);

  static const background = Color(0xFFFAF7F0);
  static const surface = Color(0xFFFFFFFF);
  static const surfaceWarm = Color(0xFFFFFDF8);

  static const accent = Color(0xFFD89C45);
  static const accentSoft = Color(0xFFF4E4C7);

  static const textPrimary = Color(0xFF1F2933);
  static const textSecondary = Color(0xFF6B7280);
  static const textMuted = Color(0xFF9CA3AF);

  static const success = Color(0xFF2F855A);
  static const danger = Color(0xFFC24141);
  static const warning = Color(0xFFD89C45);

  static const borderLight = Color(0xFFE5E0D8);
  static const divider = Color(0xFFEEE8DD);
}

class KasentraTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: KasentraColors.background,
    colorScheme: ColorScheme.fromSeed(
      seedColor: KasentraColors.primary,
      primary: KasentraColors.primary,
      surface: KasentraColors.surface,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: KasentraColors.background,
      foregroundColor: KasentraColors.textPrimary,
      elevation: 0,
      centerTitle: false,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: KasentraColors.primary,
      unselectedItemColor: KasentraColors.textMuted,
      backgroundColor: KasentraColors.surface,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: KasentraColors.textPrimary,
      ),
      headlineMedium: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: KasentraColors.textPrimary,
      ),
      titleLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: KasentraColors.textPrimary,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: KasentraColors.textPrimary,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: KasentraColors.textSecondary,
      ),
      labelMedium: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: KasentraColors.textMuted,
      ),
    ),
  );
}
