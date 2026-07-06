import 'package:flutter/material.dart';

import 'package:kasentra/app/theme/kasentra_colors.dart';
import 'package:kasentra/app/theme/kasentra_spacing.dart';
import 'package:kasentra/shared/widgets/kasentra_card.dart';

class ProfitTrendCard extends StatelessWidget {
  const ProfitTrendCard({super.key});

  @override
  Widget build(BuildContext context) {
    return KasentraCard(
      padding: const EdgeInsets.all(KasentraSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Tren Laba',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
                ),
              ),
              Text(
                'Lihat Detail',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: KasentraColors.primaryDark,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: KasentraSpacing.xl),
          const _SimpleBarChart(),
        ],
      ),
    );
  }
}

class _SimpleBarChart extends StatelessWidget {
  const _SimpleBarChart();

  @override
  Widget build(BuildContext context) {
    final items = [
      const _ChartItem(label: 'M1', salesHeight: 58, profitHeight: 26),
      const _ChartItem(label: 'M2', salesHeight: 72, profitHeight: 36),
      const _ChartItem(label: 'M3', salesHeight: 66, profitHeight: 48),
      const _ChartItem(label: 'M4', salesHeight: 72, profitHeight: 48),
    ];

    return Column(
      children: [
        SizedBox(
          height: 172,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: items.map((item) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: 28,
                    height: item.salesHeight,
                    decoration: BoxDecoration(color: const Color(0xFFFFBD63)),
                  ),
                  Container(
                    width: 28,
                    height: item.profitHeight,
                    decoration: BoxDecoration(
                      color: KasentraColors.primaryDark,
                    ),
                  ),
                  const SizedBox(height: KasentraSpacing.sm),
                  Text(
                    item.label,
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ],
              );
            }).toList(),
          ),
        ),
        const Divider(),
        const SizedBox(height: KasentraSpacing.sm),
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _LegendDot(color: Color(0xFFFFBD63), label: 'Penjualan'),
            SizedBox(width: KasentraSpacing.lg),
            _LegendDot(color: KasentraColors.primaryDark, label: 'Laba'),
          ],
        ),
      ],
    );
  }
}

class _ChartItem {
  const _ChartItem({
    required this.label,
    required this.salesHeight,
    required this.profitHeight,
  });

  final String label;
  final double salesHeight;
  final double profitHeight;
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(radius: 5, backgroundColor: color),
        const SizedBox(width: 6),
        Text(label, style: Theme.of(context).textTheme.labelMedium),
      ],
    );
  }
}
