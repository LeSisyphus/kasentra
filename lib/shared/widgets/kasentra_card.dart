import 'package:flutter/material.dart';

import '../../app/theme/kasentra_colors.dart';
import '../../app/theme/kasentra_radius.dart';
import '../../app/theme/kasentra_spacing.dart';

class KasentraCard extends StatelessWidget {
  const KasentraCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(KasentraSpacing.cardPadding),
    this.margin,
    this.onTap,
    this.backgroundColor = KasentraColors.surface,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    final card = Container(
      width: double.infinity,
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
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
      child: child,
    );

    if (onTap == null) {
      return card;
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(KasentraRadius.card),
        child: card,
      ),
    );
  }
}
