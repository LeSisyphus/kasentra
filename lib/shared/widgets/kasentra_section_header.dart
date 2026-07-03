import 'package:flutter/material.dart';

import '../../app/theme/kasentra_colors.dart';

class KasentraSectionHeader extends StatelessWidget {
  const KasentraSectionHeader({
    super.key,
    required this.title,
    this.actionLabel,
    this.onActionTap,
  });

  final String title;
  final String? actionLabel;
  final VoidCallback? onActionTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        if (actionLabel != null && onActionTap != null)
          TextButton(
            onPressed: onActionTap,
            child: Text(
              actionLabel!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: KasentraColors.primaryDark,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }
}
