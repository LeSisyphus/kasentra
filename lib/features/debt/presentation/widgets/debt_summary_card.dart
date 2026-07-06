import 'package:flutter/material.dart';

import 'package:kasentra/app/theme/kasentra_colors.dart';
import 'package:kasentra/app/theme/kasentra_radius.dart';
import 'package:kasentra/app/theme/kasentra_spacing.dart';
import 'package:kasentra/shared/formatters/rupiah_formatter.dart';

class DebtSummaryCard extends StatelessWidget {
  const DebtSummaryCard({super.key, required this.title, required this.amount});

  final String title;
  final int amount;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(KasentraSpacing.xl),
      decoration: BoxDecoration(
        color: KasentraColors.surface,
        borderRadius: BorderRadius.circular(KasentraRadius.xl),
        border: Border.all(color: KasentraColors.borderLight),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: KasentraSpacing.md),
          Text(
            RupiahFormatter.format(amount),
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              color: KasentraColors.primaryDark,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: KasentraSpacing.md),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
            decoration: BoxDecoration(
              color: KasentraColors.surfaceWarm,
              borderRadius: BorderRadius.circular(KasentraRadius.chip),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.arrow_upward_rounded,
                  size: 18,
                  color: KasentraColors.textSecondary,
                ),
                const SizedBox(width: 4),
                Text(
                  'Uang yang akan masuk',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: KasentraColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
