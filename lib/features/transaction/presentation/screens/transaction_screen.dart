import 'package:flutter/material.dart';

import 'package:kasentra/app/theme/kasentra_colors.dart';
import 'package:kasentra/app/theme/kasentra_spacing.dart';
import 'package:kasentra/features/transaction/presentation/widgets/transaction_daily_total_card.dart';
import 'package:kasentra/features/transaction/presentation/widgets/transaction_list_item.dart';
import 'package:kasentra/features/transaction/presentation/widgets/transaction_search_bar.dart';
import 'package:kasentra/shared/widgets/kasentra_button.dart';
import 'package:kasentra/shared/widgets/kasentra_choice_chip.dart';
import 'package:kasentra/features/transaction/presentation/screens/add_expense_screen.dart';
import 'package:kasentra/features/transaction/presentation/screens/add_sale_screen.dart';

class TransactionScreen extends StatelessWidget {
  const TransactionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
                Text(
                  'Transaksi',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: KasentraSpacing.md),

                const TransactionSearchBar(),

                const SizedBox(height: KasentraSpacing.md),

                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      KasentraChoiceChip(
                        label: 'Hari Ini',
                        selected: true,
                        onSelected: (_) {},
                      ),
                      const SizedBox(width: KasentraSpacing.sm),
                      KasentraChoiceChip(
                        label: 'Minggu Ini',
                        selected: false,
                        onSelected: (_) {},
                      ),
                      const SizedBox(width: KasentraSpacing.sm),
                      KasentraChoiceChip(
                        label: 'Bulan Ini',
                        selected: false,
                        onSelected: (_) {},
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: KasentraSpacing.xxl),

                Text(
                  'Hari Ini - 24 Okt 2023',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
                ),

                const SizedBox(height: KasentraSpacing.md),

                const TransactionListItem(
                  title: 'Beras Sembako',
                  category: 'Penjualan',
                  time: '09:45',
                  amount: 250000,
                  isIncome: true,
                ),
                const TransactionListItem(
                  title: 'Listrik & Air',
                  category: 'Pengeluaran',
                  time: '13:10',
                  amount: 150000,
                  isIncome: false,
                ),
                const TransactionListItem(
                  title: 'Minyak Goreng',
                  category: 'Penjualan',
                  time: '15:30',
                  amount: 75000,
                  isIncome: true,
                ),

                const SizedBox(height: KasentraSpacing.lg),

                const TransactionDailyTotalCard(
                  total: 175000,
                  transactionCount: 3,
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
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 12,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: KasentraButton(
                    label: 'Catat Penjualan',
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const AddSaleScreen(),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: KasentraSpacing.md),
                Expanded(
                  child: KasentraButton(
                    label: 'Catat Pengeluaran',
                    variant: KasentraButtonVariant.danger,
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const AddExpenseScreen(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
