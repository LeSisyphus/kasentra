import 'package:flutter/material.dart';

import 'package:kasentra/app/theme/kasentra_colors.dart';
import 'package:kasentra/app/theme/kasentra_radius.dart';
import 'package:kasentra/app/theme/kasentra_spacing.dart';

class ProductPhotoPlaceholder extends StatelessWidget {
  const ProductPhotoPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 108,
          height: 108,
          decoration: BoxDecoration(
            color: KasentraColors.surfaceWarm,
            borderRadius: BorderRadius.circular(KasentraRadius.lg),
            border: Border.all(color: KasentraColors.borderLight, width: 1.5),
          ),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add_a_photo_outlined,
                color: KasentraColors.textSecondary,
                size: 34,
              ),
              SizedBox(height: KasentraSpacing.sm),
              Text(
                'Tambah Foto',
                style: TextStyle(color: KasentraColors.textSecondary),
              ),
            ],
          ),
        ),
        const SizedBox(height: KasentraSpacing.md),
        Text(
          'Foto produk ditunda pada MVP',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: KasentraColors.textMuted),
        ),
      ],
    );
  }
}
