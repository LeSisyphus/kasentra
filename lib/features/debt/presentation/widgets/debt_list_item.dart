import 'package:flutter/material.dart';

import 'package:kasentra/app/theme/kasentra_colors.dart';
import 'package:kasentra/app/theme/kasentra_radius.dart';
import 'package:kasentra/app/theme/kasentra_spacing.dart';
import 'package:kasentra/shared/formatters/rupiah_formatter.dart';
import 'package:kasentra/shared/widgets/kasentra_badge.dart';

enum DebtListStatus { unpaid, overdue, paid }

class DebtListItem extends StatelessWidget {
  const DebtListItem({
    super.key,
    required this.name,
    required this.subtitle,
    required this.initial,
    required this.amount,
    required this.status,
    required this.onTap,
  });

  final String name;
  final String subtitle;
  final String initial;
  final int amount;
  final DebtListStatus status;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isOverdue = status == DebtListStatus.overdue;
    final isPaid = status == DebtListStatus.paid;

    final statusLabel = switch (status) {
      DebtListStatus.unpaid => 'BELUM LUNAS',
      DebtListStatus.overdue => 'JATUH TEMPO',
      DebtListStatus.paid => 'LUNAS',
    };

    final badgeVariant = switch (status) {
      DebtListStatus.unpaid => KasentraBadgeVariant.warning,
      DebtListStatus.overdue => KasentraBadgeVariant.danger,
      DebtListStatus.paid => KasentraBadgeVariant.success,
    };

    return Container(
      margin: const EdgeInsets.only(bottom: KasentraSpacing.md),
      decoration: BoxDecoration(
        color: KasentraColors.surface,
        borderRadius: BorderRadius.circular(KasentraRadius.xl),
        border: Border.all(
          color: isOverdue
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
              if (isOverdue)
                Container(width: 5, height: 86, color: KasentraColors.danger),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(KasentraSpacing.lg),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 26,
                        backgroundColor: isPaid
                            ? KasentraColors.surfaceWarm
                            : isOverdue
                            ? KasentraColors.primarySoft
                            : KasentraColors.accentSoft,
                        child: Text(
                          initial,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                fontWeight: FontWeight.w800,
                                color: isPaid
                                    ? KasentraColors.textMuted
                                    : KasentraColors.primaryDark,
                              ),
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
                                  ?.copyWith(
                                    fontWeight: FontWeight.w800,
                                    decoration: isPaid
                                        ? TextDecoration.lineThrough
                                        : null,
                                    color: isPaid
                                        ? KasentraColors.textMuted
                                        : KasentraColors.textPrimary,
                                  ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              subtitle,
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    color: isOverdue
                                        ? KasentraColors.danger
                                        : KasentraColors.textSecondary,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: KasentraSpacing.sm),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            RupiahFormatter.format(amount),
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  color: isOverdue
                                      ? KasentraColors.danger
                                      : isPaid
                                      ? KasentraColors.textMuted
                                      : KasentraColors.textPrimary,
                                  fontWeight: FontWeight.w800,
                                ),
                          ),
                          const SizedBox(height: KasentraSpacing.sm),
                          KasentraBadge(
                            label: statusLabel,
                            variant: badgeVariant,
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
