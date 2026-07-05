import 'package:flutter/material.dart';

import 'package:kasentra/app/theme/kasentra_colors.dart';
import 'package:kasentra/app/theme/kasentra_radius.dart';
import 'package:kasentra/app/theme/kasentra_spacing.dart';
import 'package:kasentra/shared/formatters/rupiah_formatter.dart';

class TransactionListItem extends StatelessWidget {
  const TransactionListItem({
    super.key,
    required this.title,
    required this.category,
    required this.time,
    required this.amount,
    required this.isIncome,
  });

  final String title;
  final String category;
  final String time;
  final int amount;
  final bool isIncome;

  @override
  Widget build(BuildContext context) {
    final amountColor = isIncome
        ? KasentraColors.success
        : KasentraColors.danger;

    final iconColor = isIncome ? KasentraColors.success : KasentraColors.danger;

    final iconBackground = isIncome
        ? const Color(0xFFD8F1CF)
        : KasentraColors.dangerSoft;

    final amountPrefix = isIncome ? '+' : '-';

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
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: iconBackground,
              borderRadius: BorderRadius.circular(KasentraRadius.md),
            ),
            child: Icon(
              isIncome
                  ? Icons.arrow_downward_rounded
                  : Icons.arrow_upward_rounded,
              color: iconColor,
              size: 24,
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
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '$category • $time WIB',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ],
            ),
          ),
          const SizedBox(width: KasentraSpacing.sm),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              '$amountPrefix${RupiahFormatter.format(amount)}',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: amountColor,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
