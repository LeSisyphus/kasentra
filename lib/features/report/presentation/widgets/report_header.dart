import 'package:flutter/material.dart';

import 'package:kasentra/app/theme/kasentra_colors.dart';
import 'package:kasentra/app/theme/kasentra_spacing.dart';

class ReportHeader extends StatelessWidget {
  const ReportHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const CircleAvatar(
          radius: 22,
          backgroundColor: KasentraColors.primarySoft,
          child: Icon(Icons.person_rounded, color: KasentraColors.primaryDark),
        ),
        const SizedBox(width: KasentraSpacing.md),
        Expanded(
          child: Text(
            'Laporan',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: KasentraColors.primaryDark,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.notifications_none_rounded),
          color: KasentraColors.primaryDark,
        ),
      ],
    );
  }
}
