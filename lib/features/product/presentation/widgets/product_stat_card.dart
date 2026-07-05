import 'package:flutter/material.dart';

import 'package:kasentra/app/theme/kasentra_colors.dart';
import 'package:kasentra/app/theme/kasentra_radius.dart';
import 'package:kasentra/app/theme/kasentra_spacing.dart';

class ProductStatCard extends StatelessWidget {
  const ProductStatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    this.isWarning = false,
  });

  final String title;
  final String value;
  final IconData icon;
  final bool isWarning;

  @override
  Widget build(BuildContext context) {
    final background = isWarning
        ? KasentraColors.dangerSoft
        : KasentraColors.surface;
    final borderColor = isWarning
        ? const Color(0xFFEFA6A6)
        : KasentraColors.borderLight;
    final foreground = isWarning
        ? KasentraColors.danger
        : KasentraColors.textPrimary;

    return Container(
      constraints: const BoxConstraints(minHeight: 140),
      padding: const EdgeInsets.all(KasentraSpacing.xl),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(KasentraRadius.xl),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: foreground, size: 30),
              const Spacer(),
              Text(
                title,
                textAlign: TextAlign.right,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: foreground,
                  fontWeight: FontWeight.w700,
                  height: 1.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: KasentraSpacing.lg),
          Align(
            alignment: Alignment.centerLeft,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                value,
                maxLines: 1,
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  color: foreground,
                  fontSize: 42,
                  fontWeight: FontWeight.w800,
                  height: 1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
