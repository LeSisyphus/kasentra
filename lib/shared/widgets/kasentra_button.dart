import 'package:flutter/material.dart';

import '../../app/theme/kasentra_colors.dart';
import '../../app/theme/kasentra_radius.dart';

enum KasentraButtonVariant { primary, secondary, danger, ghost }

class KasentraButton extends StatelessWidget {
  const KasentraButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isFullWidth = true,
    this.variant = KasentraButtonVariant.primary,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isFullWidth;
  final KasentraButtonVariant variant;

  @override
  Widget build(BuildContext context) {
    final colors = _buttonColors(variant);

    final child = Row(
      mainAxisSize: isFullWidth ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null) ...[Icon(icon, size: 18), const SizedBox(width: 8)],
        Text(label),
      ],
    );

    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      height: 48,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.background,
          foregroundColor: colors.foreground,
          disabledBackgroundColor: KasentraColors.borderLight,
          disabledForegroundColor: KasentraColors.textMuted,
          elevation: 0,
          side: colors.borderColor == null
              ? null
              : BorderSide(color: colors.borderColor!),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(KasentraRadius.button),
          ),
        ),
        child: child,
      ),
    );
  }

  _KasentraButtonColors _buttonColors(KasentraButtonVariant variant) {
    switch (variant) {
      case KasentraButtonVariant.primary:
        return const _KasentraButtonColors(
          background: KasentraColors.primary,
          foreground: Colors.white,
        );
      case KasentraButtonVariant.secondary:
        return const _KasentraButtonColors(
          background: KasentraColors.primarySoft,
          foreground: KasentraColors.primaryDark,
        );
      case KasentraButtonVariant.danger:
        return const _KasentraButtonColors(
          background: KasentraColors.danger,
          foreground: Colors.white,
        );
      case KasentraButtonVariant.ghost:
        return const _KasentraButtonColors(
          background: Colors.transparent,
          foreground: KasentraColors.primaryDark,
          borderColor: KasentraColors.borderLight,
        );
    }
  }
}

class _KasentraButtonColors {
  const _KasentraButtonColors({
    required this.background,
    required this.foreground,
    this.borderColor,
  });

  final Color background;
  final Color foreground;
  final Color? borderColor;
}
