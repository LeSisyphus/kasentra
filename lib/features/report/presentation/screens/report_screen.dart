import 'package:flutter/material.dart';

import 'package:kasentra/app/theme/kasentra_colors.dart';
import 'package:kasentra/app/theme/kasentra_radius.dart';
import 'package:kasentra/app/theme/kasentra_spacing.dart';
import 'package:kasentra/features/report/presentation/widgets/debt_receivable_summary_card.dart';
import 'package:kasentra/features/report/presentation/widgets/net_profit_card.dart';
import 'package:kasentra/features/report/presentation/widgets/profit_trend_card.dart';
import 'package:kasentra/features/report/presentation/widgets/report_header.dart';
import 'package:kasentra/features/report/presentation/widgets/report_metric_card.dart';
import 'package:kasentra/features/report/presentation/widgets/report_period_filter.dart';
import 'package:kasentra/features/report/presentation/widgets/top_product_item.dart';
import 'package:kasentra/features/report/presentation/widgets/total_transaction_card.dart';
import 'package:kasentra/shared/widgets/kasentra_badge.dart';

class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KasentraColors.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            KasentraSpacing.screenPadding,
            KasentraSpacing.lg,
            KasentraSpacing.screenPadding,
            KasentraSpacing.xxxl,
          ),
          children: [
            const ReportHeader(),
            const SizedBox(height: KasentraSpacing.xxl),
            const ReportPeriodFilter(),
            const SizedBox(height: KasentraSpacing.xxl),
            const NetProfitCard(amount: 6100000),
            const SizedBox(height: KasentraSpacing.md),
            const Row(
              children: [
                Expanded(
                  child: ReportMetricCard(
                    title: 'Total Penjualan',
                    amount: 8450000,
                    badgeLabel: '↑ Income',
                    badgeVariant: KasentraBadgeVariant.warning,
                  ),
                ),
                SizedBox(width: KasentraSpacing.md),
                Expanded(
                  child: ReportMetricCard(
                    title: 'Total Pengeluaran',
                    amount: 2350000,
                    badgeLabel: '↓ Outcome',
                    badgeVariant: KasentraBadgeVariant.danger,
                  ),
                ),
              ],
            ),
            const SizedBox(height: KasentraSpacing.md),
            const TotalTransactionCard(total: 28),
            const SizedBox(height: KasentraSpacing.xxl),
            const ProfitTrendCard(),
            const SizedBox(height: KasentraSpacing.xxl),
            const DebtReceivableSummaryCard(
              debtAmount: 620000,
              receivableAmount: 1230000,
            ),
            const SizedBox(height: KasentraSpacing.xxl),
            Text(
              'Produk Terlaris',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: KasentraSpacing.md),
            const TopProductItem(
              name: 'Beras Premium 5kg',
              subtitle: 'Terjual 42 unit',
              amount: 3150000,
            ),
            const TopProductItem(
              name: 'Minyak Goreng 2L',
              subtitle: 'Terjual 35 unit',
              amount: 1225000,
            ),
            const TopProductItem(
              name: 'Gula Pasir 1kg',
              subtitle: 'Terjual 28 unit',
              amount: 420000,
            ),
            const SizedBox(height: KasentraSpacing.md),
            Center(
              child: TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  backgroundColor: KasentraColors.primarySoft,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(KasentraRadius.md),
                  ),
                ),
                child: Text(
                  'Lihat Semua Produk',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: KasentraColors.primaryDark,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
