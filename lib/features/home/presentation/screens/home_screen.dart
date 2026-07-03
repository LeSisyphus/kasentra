import 'package:flutter/material.dart';

import '../../../../app/theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Padding(padding: EdgeInsets.all(16), child: _HomeContent()),
    );
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Kasentra',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(color: KasentraColors.primaryDark),
        ),
        const SizedBox(height: 32),
        Text('Halo,', style: Theme.of(context).textTheme.bodyMedium),
        Text('Toko Berkah', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 24),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: KasentraColors.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: KasentraColors.borderLight),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Total Laba', style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 12),
              Text(
                'Rp 8.450.000',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: 16),
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
