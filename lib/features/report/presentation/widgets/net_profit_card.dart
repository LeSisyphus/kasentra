import 'package:flutter/material.dart';

import 'package:kasentra/app/theme/kasentra_colors.dart';
import 'package:kasentra/app/theme/kasentra_spacing.dart';
import 'package:kasentra/shared/formatters/rupiah_formatter.dart';
import 'package:kasentra/shared/widgets/kasentra_card.dart';

class NetProfitCard extends StatelessWidget {
  const NetProfitCard({super.key, required this.amount});

  final int amount;

  @override
  Widget build(BuildContext context) {
    return KasentraCard(
      padding: const EdgeInsets.all(KasentraSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 18,
                backgroundColor: KasentraColors.primarySoft,
                child: Icon(
                  Icons.account_balance_wallet_outlined,
                  color: KasentraColors.primaryDark,
                  size: 20,
                ),
              ),
              const SizedBox(width: KasentraSpacing.md),
              Text('Laba Bersih', style: Theme.of(context).textTheme.bodyLarge),
            ],
          ),
          const SizedBox(height: KasentraSpacing.lg),
          Text(
            RupiahFormatter.format(amount),
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              color: KasentraColors.primaryDark,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: KasentraSpacing.sm),
          Text(
            '↗ +12% dari bulan lalu',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: KasentraColors.primaryDark,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
