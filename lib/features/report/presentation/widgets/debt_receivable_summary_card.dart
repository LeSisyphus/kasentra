import 'package:flutter/material.dart';

import 'package:kasentra/app/theme/kasentra_colors.dart';
import 'package:kasentra/app/theme/kasentra_spacing.dart';
import 'package:kasentra/shared/formatters/rupiah_formatter.dart';
import 'package:kasentra/shared/widgets/kasentra_card.dart';

class DebtReceivableSummaryCard extends StatelessWidget {
  const DebtReceivableSummaryCard({
    super.key,
    required this.debtAmount,
    required this.receivableAmount,
  });

  final int debtAmount;
  final int receivableAmount;

  @override
  Widget build(BuildContext context) {
    return KasentraCard(
      padding: const EdgeInsets.all(KasentraSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ringkasan Utang & Piutang',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: KasentraSpacing.lg),
          Row(
            children: [
              Expanded(
                child: _DebtAmount(
                  label: 'Utang Saya',
                  amount: debtAmount,
                  color: KasentraColors.danger,
                ),
              ),
              Expanded(
                child: _DebtAmount(
                  label: 'Piutang Pelanggan',
                  amount: receivableAmount,
                  color: KasentraColors.primaryDark,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DebtAmount extends StatelessWidget {
  const _DebtAmount({
    required this.label,
    required this.amount,
    required this.color,
  });

  final String label;
  final int amount;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: KasentraSpacing.xs),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(
            RupiahFormatter.format(amount),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }
}
