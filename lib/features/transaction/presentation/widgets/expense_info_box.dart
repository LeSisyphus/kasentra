import 'package:flutter/material.dart';

import 'package:kasentra/app/theme/kasentra_colors.dart';
import 'package:kasentra/app/theme/kasentra_radius.dart';
import 'package:kasentra/app/theme/kasentra_spacing.dart';

class ExpenseInfoBox extends StatelessWidget {
  const ExpenseInfoBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(KasentraSpacing.lg),
      decoration: BoxDecoration(
        color: KasentraColors.warningSoft.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(KasentraRadius.lg),
        border: Border.all(color: KasentraColors.accentSoft),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline_rounded, color: Color(0xFF9A6A00)),
          const SizedBox(width: KasentraSpacing.md),
          Expanded(
            child: Text(
              'Pengeluaran akan mengurangi estimasi laba pada laporan.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: const Color(0xFF7A5200),
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
