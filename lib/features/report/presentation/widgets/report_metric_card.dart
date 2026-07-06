import 'package:flutter/material.dart';

import 'package:kasentra/app/theme/kasentra_spacing.dart';
import 'package:kasentra/shared/formatters/rupiah_formatter.dart';
import 'package:kasentra/shared/widgets/kasentra_badge.dart';
import 'package:kasentra/shared/widgets/kasentra_card.dart';

class ReportMetricCard extends StatelessWidget {
  const ReportMetricCard({
    super.key,
    required this.title,
    required this.amount,
    required this.badgeLabel,
    required this.badgeVariant,
  });

  final String title;
  final int amount;
  final String badgeLabel;
  final KasentraBadgeVariant badgeVariant;

  @override
  Widget build(BuildContext context) {
    return KasentraCard(
      padding: const EdgeInsets.all(KasentraSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: KasentraSpacing.sm),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              RupiahFormatter.format(amount),
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
            ),
          ),
          const SizedBox(height: KasentraSpacing.md),
          KasentraBadge(label: badgeLabel, variant: badgeVariant),
        ],
      ),
    );
  }
}
