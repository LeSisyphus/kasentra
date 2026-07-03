import 'package:flutter/material.dart';

import 'package:kasentra/app/theme/kasentra_colors.dart';
import 'package:kasentra/app/theme/kasentra_radius.dart';
import 'package:kasentra/app/theme/kasentra_spacing.dart';
import 'package:kasentra/shared/formatters/rupiah_formatter.dart';

class RecentTransactionItem extends StatelessWidget {
  const RecentTransactionItem({
    super.key,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.isIncome,
    required this.icon,
  });

  final String title;
  final String subtitle;
  final int amount;
  final bool isIncome;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final amountColor = isIncome
        ? KasentraColors.success
        : KasentraColors.textPrimary;

    final amountPrefix = isIncome ? '+ ' : '- ';

    return Container(
      margin: const EdgeInsets.only(bottom: KasentraSpacing.md),
      padding: const EdgeInsets.all(KasentraSpacing.lg),
      decoration: BoxDecoration(
        color: KasentraColors.surface,
        borderRadius: BorderRadius.circular(KasentraRadius.xl),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: isIncome
                  ? KasentraColors.primarySoft
                  : KasentraColors.dangerSoft,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: isIncome
                  ? KasentraColors.primaryDark
                  : KasentraColors.danger,
              size: 22,
            ),
          ),
          const SizedBox(width: KasentraSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 2),
                Text(subtitle, style: Theme.of(context).textTheme.labelMedium),
              ],
            ),
          ),
          const SizedBox(width: KasentraSpacing.sm),
          Text(
            '$amountPrefix${RupiahFormatter.format(amount)}',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: amountColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
