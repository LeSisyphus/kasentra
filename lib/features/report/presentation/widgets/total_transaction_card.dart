import 'package:flutter/material.dart';

import 'package:kasentra/app/theme/kasentra_colors.dart';
import 'package:kasentra/app/theme/kasentra_spacing.dart';
import 'package:kasentra/shared/widgets/kasentra_card.dart';

class TotalTransactionCard extends StatelessWidget {
  const TotalTransactionCard({super.key, required this.total});

  final int total;

  @override
  Widget build(BuildContext context) {
    return KasentraCard(
      padding: const EdgeInsets.all(KasentraSpacing.lg),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total Transaksi',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: KasentraSpacing.sm),
                Text(
                  '$total Transaksi',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          const CircleAvatar(
            radius: 24,
            backgroundColor: KasentraColors.surfaceWarm,
            child: Icon(
              Icons.receipt_long_outlined,
              color: KasentraColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
