import 'package:flutter/material.dart';

import '../../app/theme/kasentra_colors.dart';
import '../../app/theme/kasentra_spacing.dart';
import 'kasentra_button.dart';

class KasentraSuccessState extends StatelessWidget {
  const KasentraSuccessState({
    super.key,
    required this.title,
    required this.description,
    this.actionLabel,
    this.onActionPressed,
  });

  final String title;
  final String description;
  final String? actionLabel;
  final VoidCallback? onActionPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(KasentraSpacing.xxl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.check_circle_rounded,
            size: 72,
            color: KasentraColors.success,
          ),
          const SizedBox(height: KasentraSpacing.lg),
          Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: KasentraSpacing.sm),
          Text(
            description,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          if (actionLabel != null && onActionPressed != null) ...[
            const SizedBox(height: KasentraSpacing.xl),
            KasentraButton(label: actionLabel!, onPressed: onActionPressed),
          ],
        ],
      ),
    );
  }
}
