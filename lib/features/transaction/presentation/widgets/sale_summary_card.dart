import 'package:flutter/material.dart';

import 'package:kasentra/app/theme/kasentra_colors.dart';
import 'package:kasentra/app/theme/kasentra_radius.dart';
import 'package:kasentra/app/theme/kasentra_spacing.dart';
import 'package:kasentra/shared/formatters/rupiah_formatter.dart';

class SaleSummaryCard extends StatelessWidget {
  const SaleSummaryCard({
    super.key,
    required this.subtotal,
    required this.estimatedCost,
    required this.estimatedProfit,
  });

  final int subtotal;
  final int estimatedCost;
  final int estimatedProfit;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(KasentraSpacing.xl),
      decoration: BoxDecoration(
        color: KasentraColors.surface,
        borderRadius: BorderRadius.circular(KasentraRadius.card),
        border: Border.all(color: KasentraColors.borderLight),
      ),
      child: Column(
        children: [
          _SummaryRow(label: 'Subtotal', amount: subtotal),
          const SizedBox(height: KasentraSpacing.md),
          _SummaryRow(label: 'Estimasi Modal', amount: estimatedCost),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: KasentraSpacing.lg),
            child: Divider(),
          ),
          _SummaryRow(
            label: 'Estimasi Laba',
            amount: estimatedProfit,
            amountColor: KasentraColors.success,
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.amount,
    this.amountColor,
  });

  final String label;
  final int amount;
  final Color? amountColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(label, style: Theme.of(context).textTheme.bodyLarge),
        ),
        Text(
          RupiahFormatter.format(amount),
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w800,
            color: amountColor ?? KasentraColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
