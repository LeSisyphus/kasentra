import 'package:flutter/material.dart';

import 'package:kasentra/app/theme/kasentra_colors.dart';
import 'package:kasentra/app/theme/kasentra_radius.dart';
import 'package:kasentra/app/theme/kasentra_spacing.dart';
import 'package:kasentra/shared/formatters/rupiah_formatter.dart';

class HomeStatCard extends StatelessWidget {
  const HomeStatCard({
    super.key,
    required this.label,
    required this.amount,
    required this.icon,
    required this.accentColor,
  });

  final String label;
  final int amount;
  final IconData icon;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 96),
      decoration: BoxDecoration(
        color: KasentraColors.surface,
        borderRadius: BorderRadius.circular(KasentraRadius.lg),
        border: Border.all(color: KasentraColors.borderLight),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(height: 4, color: accentColor),
          Padding(
            padding: const EdgeInsets.all(KasentraSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(icon, size: 16, color: KasentraColors.textSecondary),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.labelMedium
                            ?.copyWith(color: KasentraColors.textSecondary),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    RupiahFormatter.format(amount),
                    maxLines: 1,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: KasentraColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
