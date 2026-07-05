import 'package:flutter/material.dart';

import 'package:kasentra/app/theme/kasentra_colors.dart';
import 'package:kasentra/app/theme/kasentra_radius.dart';

class TransactionSearchBar extends StatelessWidget {
  const TransactionSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: KasentraColors.surface,
        borderRadius: BorderRadius.circular(KasentraRadius.md),
        border: Border.all(color: KasentraColors.borderLight),
      ),
      child: Row(
        children: [
          const Icon(Icons.search_rounded, color: KasentraColors.textMuted),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Cari transaksi...',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: KasentraColors.textSecondary,
              ),
            ),
          ),
          const Icon(Icons.tune_rounded, color: KasentraColors.primaryDark),
        ],
      ),
    );
  }
}
