import 'package:flutter/material.dart';

import 'package:kasentra/app/theme/kasentra_colors.dart';
import 'package:kasentra/app/theme/kasentra_radius.dart';
import 'package:kasentra/app/theme/kasentra_spacing.dart';
import 'package:kasentra/shared/formatters/rupiah_formatter.dart';
import 'package:kasentra/shared/widgets/kasentra_badge.dart';

class ProductListItem extends StatelessWidget {
  const ProductListItem({
    super.key,
    required this.name,
    required this.category,
    required this.stock,
    required this.price,
    required this.icon,
    required this.isLowStock,
    required this.onTap,
  });

  final String name;
  final String category;
  final int stock;
  final int price;
  final IconData icon;
  final bool isLowStock;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final statusLabel = isLowStock ? 'Hampir Habis' : 'Aman';

    return Container(
      margin: const EdgeInsets.only(bottom: KasentraSpacing.md),
      decoration: BoxDecoration(
        color: KasentraColors.surface,
        borderRadius: BorderRadius.circular(KasentraRadius.xl),
        border: Border.all(
          color: isLowStock
              ? const Color(0xFFEFA6A6)
              : KasentraColors.borderLight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Row(
            children: [
              if (isLowStock)
                Container(width: 5, height: 96, color: KasentraColors.danger),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(KasentraSpacing.lg),
                  child: Row(
                    children: [
                      Container(
                        width: 58,
                        height: 58,
                        decoration: BoxDecoration(
                          color: isLowStock
                              ? KasentraColors.dangerSoft
                              : KasentraColors.surfaceWarm,
                          borderRadius: BorderRadius.circular(
                            KasentraRadius.md,
                          ),
                        ),
                        child: Icon(
                          icon,
                          color: isLowStock
                              ? KasentraColors.danger
                              : KasentraColors.textSecondary,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: KasentraSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w800),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                Text(
                                  'Stok: $stock',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                const SizedBox(width: 8),
                                KasentraBadge(
                                  label: statusLabel,
                                  variant: isLowStock
                                      ? KasentraBadgeVariant.danger
                                      : KasentraBadgeVariant.success,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: KasentraSpacing.sm),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            RupiahFormatter.format(price),
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w800),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.more_vert_rounded),
                            color: KasentraColors.textSecondary,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
