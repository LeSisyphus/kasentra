import 'package:flutter/material.dart';

import 'kasentra_colors.dart';
import 'kasentra_radius.dart';
import 'kasentra_text_styles.dart';

class KasentraTheme {
  const KasentraTheme._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'PlusJakartaSans',
    scaffoldBackgroundColor: KasentraColors.background,
    colorScheme: ColorScheme.fromSeed(
      seedColor: KasentraColors.primary,
      primary: KasentraColors.primary,
      surface: KasentraColors.surface,
      error: KasentraColors.danger,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: KasentraColors.background,
      foregroundColor: KasentraColors.textPrimary,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: KasentraTextStyles.pageTitle,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: KasentraColors.primary,
      unselectedItemColor: KasentraColors.textMuted,
      backgroundColor: KasentraColors.surface,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
      selectedLabelStyle: KasentraTextStyles.bottomNavLabel,
      unselectedLabelStyle: KasentraTextStyles.bottomNavLabel,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: KasentraColors.surface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      hintStyle: KasentraTextStyles.body.copyWith(
        color: KasentraColors.textMuted,
      ),
      labelStyle: KasentraTextStyles.body,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(KasentraRadius.input),
        borderSide: const BorderSide(color: KasentraColors.borderLight),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(KasentraRadius.input),
        borderSide: const BorderSide(color: KasentraColors.primary, width: 1.4),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(KasentraRadius.input),
        borderSide: const BorderSide(color: KasentraColors.danger),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(KasentraRadius.input),
        borderSide: const BorderSide(color: KasentraColors.danger, width: 1.4),
      ),
    ),
    dividerTheme: const DividerThemeData(
      color: KasentraColors.divider,
      thickness: 1,
    ),
    textTheme: const TextTheme(
      headlineLarge: KasentraTextStyles.moneyLarge,
      headlineMedium: KasentraTextStyles.pageTitle,
      titleLarge: KasentraTextStyles.sectionTitle,
      titleMedium: KasentraTextStyles.cardTitle,
      bodyLarge: KasentraTextStyles.body,
      bodyMedium: KasentraTextStyles.body,
      labelMedium: KasentraTextStyles.caption,
    ),
  );
}
