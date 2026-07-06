import 'package:flutter/material.dart';

import 'package:kasentra/app/theme/kasentra_colors.dart';
import 'package:kasentra/app/theme/kasentra_radius.dart';
import 'package:kasentra/app/theme/kasentra_spacing.dart';
import 'package:kasentra/shared/formatters/rupiah_formatter.dart';
import 'package:kasentra/shared/widgets/kasentra_card.dart';

class TopProductItem extends StatelessWidget {
  const TopProductItem({
    super.key,
    required this.name,
    required this.subtitle,
    required this.amount,
  });

  final String name;
  final String subtitle;
  final int amount;

  @override
  Widget build(BuildContext context) {
    return KasentraCard(
      margin: const EdgeInsets.only(bottom: KasentraSpacing.md),
      padding: const EdgeInsets.all(KasentraSpacing.lg),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: KasentraColors.accentSoft,
              borderRadius: BorderRadius.circular(KasentraRadius.md),
            ),
            child: const Icon(
              Icons.inventory_2_outlined,
              color: KasentraColors.accent,
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
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
          const SizedBox(width: KasentraSpacing.sm),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              RupiahFormatter.format(amount),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: KasentraColors.primaryDark,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
