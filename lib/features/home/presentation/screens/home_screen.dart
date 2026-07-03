import 'package:flutter/material.dart';

import 'package:kasentra/app/theme/kasentra_colors.dart';
import 'package:kasentra/app/theme/kasentra_spacing.dart';
import 'package:kasentra/shared/widgets/kasentra_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(child: _HomeContent());
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(KasentraSpacing.screenPadding),
      children: [
        Text(
          'Kasentra',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(color: KasentraColors.primaryDark),
        ),
        const SizedBox(height: KasentraSpacing.xxxl),

        Text('Halo,', style: Theme.of(context).textTheme.bodyMedium),
        Text('Toko Berkah', style: Theme.of(context).textTheme.titleLarge),

        const SizedBox(height: KasentraSpacing.xxl),

        KasentraCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Total Laba', style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: KasentraSpacing.md),
              Text(
                'Rp 8.450.000',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: KasentraSpacing.lg),
              Text(
                'Lihat Laporan Detail >',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: KasentraColors.primaryDark,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
