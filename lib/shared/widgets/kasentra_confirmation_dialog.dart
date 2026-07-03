import 'package:flutter/material.dart';

import '../../app/theme/kasentra_colors.dart';
import '../../app/theme/kasentra_radius.dart';
import 'kasentra_button.dart';

Future<bool> showKasentraConfirmationDialog({
  required BuildContext context,
  required String title,
  required String message,
  String cancelLabel = 'Batal',
  String confirmLabel = 'Ya, Lanjutkan',
  bool isDanger = false,
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(KasentraRadius.xl),
        ),
        backgroundColor: KasentraColors.surface,
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(cancelLabel),
          ),
          SizedBox(
            width: 150,
            child: KasentraButton(
              label: confirmLabel,
              isFullWidth: false,
              variant: isDanger
                  ? KasentraButtonVariant.danger
                  : KasentraButtonVariant.primary,
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ),
        ],
      );
    },
  );

  return result ?? false;
}
