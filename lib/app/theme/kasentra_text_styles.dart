import 'package:flutter/material.dart';

import 'kasentra_colors.dart';

class KasentraTextStyles {
  const KasentraTextStyles._();

  static const TextStyle moneyLarge = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: KasentraColors.textPrimary,
    height: 1.15,
  );

  static const TextStyle pageTitle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: KasentraColors.textPrimary,
    height: 1.25,
  );

  static const TextStyle sectionTitle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: KasentraColors.textPrimary,
  );

  static const TextStyle cardTitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: KasentraColors.textPrimary,
  );

  static const TextStyle body = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: KasentraColors.textSecondary,
    height: 1.4,
  );

  static const TextStyle bodyStrong = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: KasentraColors.textPrimary,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: KasentraColors.textMuted,
  );

  static const TextStyle bottomNavLabel = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
  );
}
