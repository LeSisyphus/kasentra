import 'package:flutter/material.dart';

import 'package:kasentra/app/theme/kasentra_colors.dart';
import 'package:kasentra/app/theme/kasentra_spacing.dart';
import 'package:kasentra/shared/formatters/rupiah_formatter.dart';
import 'package:kasentra/shared/widgets/kasentra_badge.dart';
import 'package:kasentra/shared/widgets/kasentra_button.dart';
import 'package:kasentra/shared/widgets/kasentra_card.dart';
import 'package:kasentra/shared/widgets/kasentra_section_header.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key});

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
                          'Detail Produk',
                          style: Theme.of(context).textTheme.headlineMedium
                              ?.copyWith(
                                color: KasentraColors.primaryDark,
                                fontWeight: FontWeight.w800,
                              ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: KasentraSpacing.xxl),
                  KasentraCard(
                    child: Row(
                      children: [
                        Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            color: KasentraColors.surfaceWarm,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(
                            Icons.inventory_2_outlined,
                            color: KasentraColors.textSecondary,
                            size: 32,
                          ),
                        ),
                        const SizedBox(width: KasentraSpacing.lg),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Beras Premium 5kg',
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(fontWeight: FontWeight.w800),
                              ),
                              const SizedBox(height: KasentraSpacing.sm),
                              const Wrap(
                                spacing: KasentraSpacing.sm,
                                children: [
                                  KasentraBadge(
                                    label: 'Aman',
                                    variant: KasentraBadgeVariant.success,
                                  ),
                                  KasentraBadge(
                                    label: 'Sembako',
                                    variant: KasentraBadgeVariant.warning,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: KasentraSpacing.xxl),
                  Text(
                    'Informasi Harga',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: KasentraSpacing.md),
                  KasentraCard(
                    child: Column(
                      children: [
                        _InfoRow(
                          label: 'Harga Jual',
                          value: RupiahFormatter.format(75000),
                        ),
                        const Divider(),
                        _InfoRow(
                          label: 'Harga Modal',
                          value: RupiahFormatter.format(54000),
                        ),
                        const Divider(),
                        _InfoRow(
                          label: 'Estimasi Laba per Item',
                          value: RupiahFormatter.format(21000),
                          valueColor: KasentraColors.success,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: KasentraSpacing.xxl),
                  Text(
                    'Informasi Stok',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: KasentraSpacing.md),
                  KasentraCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.inventory_2_outlined,
                              color: KasentraColors.primaryDark,
                            ),
                            const SizedBox(width: KasentraSpacing.md),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Stok Saat Ini',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                Text(
                                  '25',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium
                                      ?.copyWith(fontWeight: FontWeight.w800),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: KasentraSpacing.lg),
                        const Divider(),
                        Text(
                          '* Stok dicatat opsional pada MVP',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: KasentraSpacing.xxl),
                  KasentraSectionHeader(
                    title: 'Transaksi Terakhir',
                    actionLabel: 'Lihat Semua',
                    onActionTap: () {},
                  ),
                  const SizedBox(height: KasentraSpacing.md),
                  const _ProductTransactionItem(
                    title: 'Penjualan',
                    subtitle: '2 item • Hari ini',
                    amount: 150000,
                  ),
                  const _ProductTransactionItem(
                    title: 'Penjualan',
                    subtitle: '1 item • Kemarin',
                    amount: 75000,
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
                  KasentraButton(label: 'Edit Produk', onPressed: () {}),
                  const SizedBox(height: KasentraSpacing.sm),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        foregroundColor: KasentraColors.danger,
                        side: const BorderSide(color: KasentraColors.danger),
                      ),
                      child: const Text('Nonaktifkan Produk'),
                    ),
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

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value, this.valueColor});

  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: KasentraSpacing.sm),
      child: Row(
        children: [
          Expanded(
            child: Text(label, style: Theme.of(context).textTheme.bodyLarge),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
              color: valueColor ?? KasentraColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductTransactionItem extends StatelessWidget {
  const _ProductTransactionItem({
    required this.title,
    required this.subtitle,
    required this.amount,
  });

  final String title;
  final String subtitle;
  final int amount;

  @override
  Widget build(BuildContext context) {
    return KasentraCard(
      margin: const EdgeInsets.only(bottom: KasentraSpacing.md),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: const BoxDecoration(
              color: KasentraColors.successSoft,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.arrow_outward_rounded,
              color: KasentraColors.success,
            ),
          ),
          const SizedBox(width: KasentraSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleMedium),
                Text(subtitle, style: Theme.of(context).textTheme.labelMedium),
              ],
            ),
          ),
          Text(
            '+ ${RupiahFormatter.format(amount)}',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }
}
