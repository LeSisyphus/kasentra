import 'package:flutter/material.dart';

import '../../app/theme/kasentra_colors.dart';
import '../../app/theme/kasentra_radius.dart';

enum KasentraBadgeVariant { success, warning, danger, info, primary, neutral }

class KasentraBadge extends StatelessWidget {
  const KasentraBadge({
    super.key,
    required this.label,
    this.variant = KasentraBadgeVariant.neutral,
    this.icon,
  });

  final String label;
  final KasentraBadgeVariant variant;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final colors = _badgeColors(variant);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: BorderRadius.circular(KasentraRadius.chip),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: colors.foreground),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: colors.foreground,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  _KasentraBadgeColors _badgeColors(KasentraBadgeVariant variant) {
    switch (variant) {
      case KasentraBadgeVariant.success:
        return const _KasentraBadgeColors(
          background: KasentraColors.successSoft,
          foreground: KasentraColors.success,
        );
      case KasentraBadgeVariant.warning:
        return const _KasentraBadgeColors(
          background: KasentraColors.warningSoft,
          foreground: KasentraColors.warning,
        );
      case KasentraBadgeVariant.danger:
        return const _KasentraBadgeColors(
          background: KasentraColors.dangerSoft,
          foreground: KasentraColors.danger,
        );
      case KasentraBadgeVariant.info:
        return const _KasentraBadgeColors(
          background: KasentraColors.infoSoft,
          foreground: KasentraColors.info,
        );
      case KasentraBadgeVariant.primary:
        return const _KasentraBadgeColors(
          background: KasentraColors.primarySoft,
          foreground: KasentraColors.primaryDark,
        );
      case KasentraBadgeVariant.neutral:
        return const _KasentraBadgeColors(
          background: KasentraColors.surfaceWarm,
          foreground: KasentraColors.textSecondary,
        );
    }
  }
}

class _KasentraBadgeColors {
  const _KasentraBadgeColors({
    required this.background,
    required this.foreground,
  });

  final Color background;
  final Color foreground;
}
