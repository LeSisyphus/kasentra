import 'package:flutter/material.dart';

import 'package:kasentra/app/theme/kasentra_colors.dart';
import 'package:kasentra/app/theme/kasentra_spacing.dart';
import 'package:kasentra/features/debt/presentation/widgets/debt_info_item.dart';
import 'package:kasentra/shared/formatters/rupiah_formatter.dart';
import 'package:kasentra/shared/widgets/kasentra_badge.dart';
import 'package:kasentra/shared/widgets/kasentra_button.dart';
import 'package:kasentra/shared/widgets/kasentra_card.dart';

class DebtDetailScreen extends StatelessWidget {
  const DebtDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KasentraColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(
                  KasentraSpacing.screenPadding,
                  KasentraSpacing.lg,
                  KasentraSpacing.screenPadding,
                  KasentraSpacing.xxl,
                ),
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.arrow_back_rounded),
                        color: KasentraColors.primaryDark,
                      ),
                      Expanded(
                        child: Text(
                          'Detail Utang',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineMedium
                              ?.copyWith(
                                color: KasentraColors.primaryDark,
                                fontWeight: FontWeight.w800,
                              ),
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                  const SizedBox(height: KasentraSpacing.xxxl),
                  KasentraCard(
                    padding: const EdgeInsets.all(KasentraSpacing.xl),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const CircleAvatar(
                              radius: 34,
                              backgroundColor: KasentraColors.primarySoft,
                              child: Text(
                                'S',
                                style: TextStyle(
                                  color: KasentraColors.textPrimary,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            const SizedBox(width: KasentraSpacing.lg),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Bu Siti',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(fontWeight: FontWeight.w800),
                                  ),
                                  Text(
                                    'Piutang Pelanggan',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodyLarge,
                                  ),
                                ],
                              ),
                            ),
                            const KasentraBadge(
                              label: 'Belum Lunas',
                              variant: KasentraBadgeVariant.warning,
                            ),
                          ],
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: KasentraSpacing.xl,
                          ),
                          child: Divider(),
                        ),
                        Text(
                          'Total Utang',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(height: KasentraSpacing.sm),
                        Text(
                          RupiahFormatter.format(250000),
                          style: Theme.of(context).textTheme.headlineLarge
                              ?.copyWith(fontWeight: FontWeight.w800),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: KasentraSpacing.xxxl),
                  KasentraCard(
                    padding: const EdgeInsets.all(KasentraSpacing.xl),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Informasi Utang',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(height: KasentraSpacing.xl),
                        const DebtInfoItem(
                          icon: Icons.calendar_today_outlined,
                          label: 'Tanggal',
                          value: '26 Mei 2026',
                        ),
                        const DebtInfoItem(
                          icon: Icons.phone_outlined,
                          label: 'Nomor HP',
                          value: '0812-xxxx-xxxx',
                        ),
                        const DebtInfoItem(
                          icon: Icons.description_outlined,
                          label: 'Catatan',
                          value: 'Belanja sembako belum dibayar.',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: KasentraSpacing.xxxl),
                  Text(
                    'Transaksi Terkait',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: KasentraSpacing.md),
                  KasentraCard(
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: const BoxDecoration(
                            color: KasentraColors.primarySoft,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.receipt_long_outlined,
                            color: KasentraColors.primaryDark,
                          ),
                        ),
                        const SizedBox(width: KasentraSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Penjualan Sembako',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              Text(
                                'INV-2605-001',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                        Text(
                          RupiahFormatter.format(250000),
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w800),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(
                KasentraSpacing.screenPadding,
                KasentraSpacing.md,
                KasentraSpacing.screenPadding,
                KasentraSpacing.lg,
              ),
              decoration: BoxDecoration(
                color: KasentraColors.background,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 12,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  KasentraButton(
                    label: 'Tandai Lunas',
                    icon: Icons.check_circle_outline_rounded,
                    onPressed: () {},
                  ),
                  const SizedBox(height: KasentraSpacing.sm),
                  Row(
                    children: [
                      Expanded(
                        child: KasentraButton(
                          label: 'Edit',
                          icon: Icons.edit_rounded,
                          variant: KasentraButtonVariant.secondary,
                          onPressed: () {},
                        ),
                      ),
                      const SizedBox(width: KasentraSpacing.md),
                      Expanded(
                        child: KasentraButton(
                          label: 'Hapus',
                          icon: Icons.delete_outline_rounded,
                          variant: KasentraButtonVariant.danger,
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
