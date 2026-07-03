import 'package:flutter/material.dart';

import 'package:kasentra/app/theme/kasentra_colors.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const CircleAvatar(
          radius: 16,
          backgroundColor: KasentraColors.accentSoft,
          child: Text(
            'K',
            style: TextStyle(
              color: KasentraColors.primaryDark,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            'Kasentra',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(color: KasentraColors.primaryDark),
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
