import 'package:flutter/material.dart';

import 'package:kasentra/app/theme/kasentra_colors.dart';
import 'package:kasentra/app/theme/kasentra_radius.dart';

class ProductSearchBar extends StatelessWidget {
  const ProductSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: KasentraColors.surface,
        borderRadius: BorderRadius.circular(KasentraRadius.md),
        border: Border.all(color: KasentraColors.borderLight),
      ),
      child: Row(
        children: [
          const Icon(Icons.search_rounded, color: KasentraColors.textMuted),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Cari nama produk...',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: KasentraColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
