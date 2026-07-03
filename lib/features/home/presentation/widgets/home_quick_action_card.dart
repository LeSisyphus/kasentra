import 'package:flutter/material.dart';

import 'package:kasentra/app/theme/kasentra_colors.dart';
import 'package:kasentra/app/theme/kasentra_radius.dart';
import 'package:kasentra/app/theme/kasentra_spacing.dart';

class HomeQuickActionCard extends StatelessWidget {
  const HomeQuickActionCard({
    super.key,
    required this.label,
    required this.icon,
    required this.iconBackgroundColor,
    required this.iconColor,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final Color iconBackgroundColor;
  final Color iconColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: KasentraColors.surfaceWarm,
        borderRadius: BorderRadius.circular(KasentraRadius.lg),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(KasentraRadius.lg),
          child: Container(
            height: 104,
            padding: const EdgeInsets.all(KasentraSpacing.md),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: iconBackgroundColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: iconColor, size: 22),
                ),
                const SizedBox(height: KasentraSpacing.sm),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: KasentraColors.textPrimary,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
