import 'package:flutter/material.dart';

import 'package:kasentra/app/theme/kasentra_colors.dart';
import 'package:kasentra/app/theme/kasentra_radius.dart';
import 'package:kasentra/app/theme/kasentra_spacing.dart';
import 'package:kasentra/shared/formatters/rupiah_formatter.dart';
import 'package:kasentra/shared/widgets/kasentra_card.dart';

class HomeProfitCard extends StatelessWidget {
  const HomeProfitCard({
    super.key,
    required this.totalProfit,
    required this.onReportTap,
  });

  final int totalProfit;
  final VoidCallback onReportTap;

  @override
  Widget build(BuildContext context) {
    return KasentraCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Total Laba',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: KasentraColors.surfaceWarm,
                  borderRadius: BorderRadius.circular(KasentraRadius.chip),
                  border: Border.all(color: KasentraColors.borderLight),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Bulan Ini',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: KasentraColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 2),
                    const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 18,
                      color: KasentraColors.textSecondary,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: KasentraSpacing.md),
          Text(
            RupiahFormatter.format(totalProfit),
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const SizedBox(height: KasentraSpacing.lg),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: KasentraColors.primarySoft,
              borderRadius: BorderRadius.circular(KasentraRadius.chip),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.trending_up_rounded,
                  size: 14,
                  color: KasentraColors.primaryDark,
                ),
                const SizedBox(width: 4),
                Text(
                  '+12% vs bulan lalu',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: KasentraColors.primaryDark,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: KasentraSpacing.lg),
          InkWell(
            onTap: onReportTap,
            borderRadius: BorderRadius.circular(KasentraRadius.md),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.insert_chart_outlined_rounded,
                  size: 18,
                  color: KasentraColors.primaryDark,
                ),
                const SizedBox(width: 4),
                Text(
                  'Lihat Laporan Detail',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: KasentraColors.primaryDark,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Icon(
                  Icons.chevron_right_rounded,
                  size: 18,
                  color: KasentraColors.primaryDark,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
