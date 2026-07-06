import 'package:flutter/material.dart';

import 'package:kasentra/app/theme/kasentra_colors.dart';
import 'package:kasentra/app/theme/kasentra_radius.dart';
import 'package:kasentra/app/theme/kasentra_spacing.dart';

class ReportPeriodFilter extends StatelessWidget {
  const ReportPeriodFilter({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _PeriodChip(label: 'Hari Ini', selected: false),
          SizedBox(width: KasentraSpacing.sm),
          _PeriodChip(label: 'Minggu Ini', selected: false),
          SizedBox(width: KasentraSpacing.sm),
          _PeriodChip(label: 'Bulan Ini', selected: true),
        ],
      ),
    );
  }
}

class _PeriodChip extends StatelessWidget {
  const _PeriodChip({required this.label, required this.selected});

  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      decoration: BoxDecoration(
        color: selected ? KasentraColors.primary : KasentraColors.surface,
        borderRadius: BorderRadius.circular(KasentraRadius.chip),
        border: Border.all(
          color: selected ? KasentraColors.primary : KasentraColors.borderLight,
        ),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: selected ? Colors.white : KasentraColors.textPrimary,
          fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
        ),
      ),
    );
  }
}
