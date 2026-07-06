import 'package:flutter/material.dart';

import 'package:kasentra/app/theme/kasentra_colors.dart';
import 'package:kasentra/app/theme/kasentra_radius.dart';
import 'package:kasentra/app/theme/kasentra_spacing.dart';
import 'package:kasentra/shared/widgets/kasentra_badge.dart';

class DebtStatusCard extends StatelessWidget {
  const DebtStatusCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(KasentraSpacing.xl),
      decoration: BoxDecoration(
        color: KasentraColors.surface,
        borderRadius: BorderRadius.circular(KasentraRadius.lg),
        border: Border.all(color: KasentraColors.borderLight),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Status',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
            ),
          ),
          const KasentraBadge(
            label: 'Belum Lunas',
            variant: KasentraBadgeVariant.warning,
          ),
        ],
      ),
    );
  }
}
