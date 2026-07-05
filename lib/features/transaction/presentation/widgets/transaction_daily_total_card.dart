import 'package:flutter/material.dart';

import 'package:kasentra/app/theme/kasentra_colors.dart';
import 'package:kasentra/app/theme/kasentra_radius.dart';
import 'package:kasentra/app/theme/kasentra_spacing.dart';
import 'package:kasentra/shared/formatters/rupiah_formatter.dart';

class TransactionDailyTotalCard extends StatelessWidget {
  const TransactionDailyTotalCard({
    super.key,
    required this.total,
    required this.transactionCount,
  });

  final int total;
  final int transactionCount;

  @override
  Widget build(BuildContext context) {
    final isPositive = total >= 0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(KasentraSpacing.xl),
      decoration: BoxDecoration(
        color: KasentraColors.surfaceWarm,
        borderRadius: BorderRadius.circular(KasentraRadius.lg),
        border: Border.all(color: KasentraColors.borderLight),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Total Harian',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: KasentraColors.textSecondary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${isPositive ? '+' : '-'}${RupiahFormatter.format(total.abs())}',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: isPositive
                      ? KasentraColors.success
                      : KasentraColors.danger,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '$transactionCount Transaksi',
                style: Theme.of(context).textTheme.labelMedium,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
