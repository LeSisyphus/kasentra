import 'package:flutter/material.dart';

import 'package:kasentra/app/theme/kasentra_colors.dart';
import 'package:kasentra/app/theme/kasentra_spacing.dart';
import 'package:kasentra/features/home/presentation/widgets/home_header.dart';
import 'package:kasentra/features/home/presentation/widgets/home_profit_card.dart';
import 'package:kasentra/features/home/presentation/widgets/home_quick_action_card.dart';
import 'package:kasentra/features/home/presentation/widgets/home_stat_card.dart';
import 'package:kasentra/features/home/presentation/widgets/recent_transaction_item.dart';
import 'package:kasentra/shared/widgets/kasentra_section_header.dart';
import 'package:kasentra/features/transaction/presentation/screens/add_expense_screen.dart';
import 'package:kasentra/features/transaction/presentation/screens/add_sale_screen.dart';
import 'package:kasentra/features/report/presentation/screens/report_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(
          KasentraSpacing.screenPadding,
          KasentraSpacing.lg,
          KasentraSpacing.screenPadding,
          110,
        ),
        children: [
          const HomeHeader(),
          const SizedBox(height: KasentraSpacing.xxxl),

          Text('Halo,', style: Theme.of(context).textTheme.bodyMedium),
          Text(
            'Toko Berkah',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: KasentraSpacing.xxl),

          HomeProfitCard(
            totalProfit: 8450000,
            onReportTap: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => const ReportScreen()));
            },
          ),

          const SizedBox(height: KasentraSpacing.xxl),

          const Row(
            children: [
              Expanded(
                child: HomeStatCard(
                  label: 'Penjualan',
                  amount: 12500000,
                  icon: Icons.arrow_downward_rounded,
                  accentColor: KasentraColors.primaryDark,
                ),
              ),
              SizedBox(width: KasentraSpacing.md),
              Expanded(
                child: HomeStatCard(
                  label: 'Pengeluaran',
                  amount: 4050000,
                  icon: Icons.arrow_upward_rounded,
                  accentColor: KasentraColors.danger,
                ),
              ),
            ],
          ),

          const SizedBox(height: KasentraSpacing.xxl),

          Row(
            children: [
              HomeQuickActionCard(
                label: 'Catat\nPenjualan',
                icon: Icons.add_circle_rounded,
                iconBackgroundColor: KasentraColors.primaryDark,
                iconColor: Colors.white,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const AddSaleScreen()),
                  );
                },
              ),
              const SizedBox(width: KasentraSpacing.md),
              HomeQuickActionCard(
                label: 'Catat\nPengeluaran',
                icon: Icons.remove_circle_rounded,
                iconBackgroundColor: KasentraColors.primarySoft,
                iconColor: KasentraColors.primaryDark,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const AddExpenseScreen()),
                  );
                },
              ),
              const SizedBox(width: KasentraSpacing.md),
              HomeQuickActionCard(
                label: 'Catat\nUtang',
                icon: Icons.account_balance_wallet_rounded,
                iconBackgroundColor: KasentraColors.accentSoft,
                iconColor: KasentraColors.accent,
                onTap: () {
                  // TODO: buka form catat utang.
                },
              ),
            ],
          ),

          const SizedBox(height: KasentraSpacing.xxl),

          KasentraSectionHeader(
            title: 'Transaksi Terbaru',
            actionLabel: 'Lihat Semua',
            onActionTap: () {
              // TODO: pindah ke tab Transaksi.
            },
          ),

          const SizedBox(height: KasentraSpacing.md),

          const RecentTransactionItem(
            title: 'Penjualan Beras 5kg',
            subtitle: 'Hari ini, 09:30',
            amount: 75000,
            isIncome: true,
            icon: Icons.shopping_bag_outlined,
          ),
          const RecentTransactionItem(
            title: 'Bayar Listrik Toko',
            subtitle: 'Kemarin, 15:45',
            amount: 250000,
            isIncome: false,
            icon: Icons.bolt_rounded,
          ),
          const RecentTransactionItem(
            title: 'Penjualan Gula 1kg',
            subtitle: 'Kemarin, 10:15',
            amount: 18000,
            isIncome: true,
            icon: Icons.shopping_bag_outlined,
          ),
        ],
      ),
    );
  }
}
