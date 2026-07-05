import 'package:flutter/material.dart';

import 'package:kasentra/app/theme/kasentra_colors.dart';
import 'package:kasentra/app/theme/kasentra_radius.dart';
import 'package:kasentra/app/theme/kasentra_spacing.dart';
import 'package:kasentra/shared/formatters/rupiah_formatter.dart';

class SaleProductCard extends StatelessWidget {
  const SaleProductCard({
    super.key,
    required this.name,
    required this.unitPrice,
    required this.quantity,
    required this.subtotal,
    required this.onRemove,
    required this.onDecrease,
    required this.onIncrease,
  });

  final String name;
  final int unitPrice;
  final int quantity;
  final int subtotal;
  final VoidCallback onRemove;
  final VoidCallback onDecrease;
  final VoidCallback onIncrease;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: KasentraSpacing.md),
      padding: const EdgeInsets.all(KasentraSpacing.lg),
      decoration: BoxDecoration(
        color: KasentraColors.surface,
        borderRadius: BorderRadius.circular(KasentraRadius.card),
        border: Border.all(color: KasentraColors.borderLight),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${RupiahFormatter.format(unitPrice)} / pcs',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: onRemove,
                icon: const Icon(Icons.delete_outline_rounded),
                color: KasentraColors.danger,
              ),
            ],
          ),
          const SizedBox(height: KasentraSpacing.lg),
          Row(
            children: [
              Expanded(
                child: Text(
                  RupiahFormatter.format(subtotal),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: KasentraColors.primaryDark,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Container(
                height: 42,
                decoration: BoxDecoration(
                  color: KasentraColors.surfaceWarm,
                  borderRadius: BorderRadius.circular(KasentraRadius.md),
                  border: Border.all(color: KasentraColors.borderLight),
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: onDecrease,
                      icon: const Icon(Icons.remove_rounded),
                      color: KasentraColors.primaryDark,
                    ),
                    Text(
                      '$quantity',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    IconButton(
                      onPressed: onIncrease,
                      icon: const Icon(Icons.add_rounded),
                      color: KasentraColors.primaryDark,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
