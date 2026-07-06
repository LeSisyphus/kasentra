import 'package:flutter/material.dart';

import 'package:kasentra/app/theme/kasentra_colors.dart';
import 'package:kasentra/app/theme/kasentra_spacing.dart';
import 'package:kasentra/features/debt/presentation/screens/add_debt_screen.dart';
import 'package:kasentra/features/debt/presentation/screens/debt_detail_screen.dart';
import 'package:kasentra/features/debt/presentation/widgets/debt_list_item.dart';
import 'package:kasentra/features/debt/presentation/widgets/debt_stat_card.dart';
import 'package:kasentra/features/debt/presentation/widgets/debt_summary_card.dart';
import 'package:kasentra/features/debt/presentation/widgets/debt_type_segmented_control.dart';
import 'package:kasentra/features/product/presentation/widgets/product_search_bar.dart';
import 'package:kasentra/shared/widgets/kasentra_button.dart';
import 'package:kasentra/shared/widgets/kasentra_choice_chip.dart';

class DebtScreen extends StatefulWidget {
  const DebtScreen({super.key});

  @override
  State<DebtScreen> createState() => _DebtScreenState();
}

class _DebtScreenState extends State<DebtScreen> {
  bool _isReceivable = true;

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
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 22,
                      backgroundColor: KasentraColors.primary,
                      child: Icon(Icons.person_rounded, color: Colors.white),
                    ),
                    const SizedBox(width: KasentraSpacing.md),
                    Expanded(
                      child: Text(
                        'Utang',
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(
                              color: KasentraColors.primaryDark,
                              fontWeight: FontWeight.w800,
                            ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.notifications_none_rounded),
                    ),
                  ],
                ),
                const SizedBox(height: KasentraSpacing.xxxl),
                const DebtSummaryCard(
                  title: 'Total Piutang Pelanggan',
                  amount: 1230000,
                ),
                const SizedBox(height: KasentraSpacing.lg),
                const Row(
                  children: [
                    Expanded(
                      child: DebtStatCard(
                        title: 'Total Utang Saya',
                        amount: 620000,
                      ),
                    ),
                    SizedBox(width: KasentraSpacing.lg),
                    Expanded(
                      child: DebtStatCard(
                        title: 'Jatuh Tempo',
                        amount: 450000,
                        icon: Icons.warning_amber_rounded,
                        isDanger: true,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: KasentraSpacing.xxl),
                DebtTypeSegmentedControl(
                  isReceivable: _isReceivable,
                  onChanged: (value) {
                    setState(() {
                      _isReceivable = value;
                    });
                  },
                ),
                const SizedBox(height: KasentraSpacing.xl),
                const ProductSearchBar(),
                const SizedBox(height: KasentraSpacing.md),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      KasentraChoiceChip(
                        label: 'Semua',
                        selected: true,
                        onSelected: (_) {},
                      ),
                      const SizedBox(width: KasentraSpacing.sm),
                      KasentraChoiceChip(
                        label: 'Belum Lunas',
                        selected: false,
                        onSelected: (_) {},
                      ),
                      const SizedBox(width: KasentraSpacing.sm),
                      KasentraChoiceChip(
                        label: 'Lunas',
                        selected: false,
                        onSelected: (_) {},
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: KasentraSpacing.xxxl),
                Text(
                  'Daftar Tagihan',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: KasentraSpacing.lg),
                DebtListItem(
                  name: 'Bu Siti',
                  subtitle: 'Hari ini',
                  initial: 'B',
                  amount: 250000,
                  status: DebtListStatus.unpaid,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const DebtDetailScreen(),
                      ),
                    );
                  },
                ),
                DebtListItem(
                  name: 'Pak Agus',
                  subtitle: 'Telat 3 hari',
                  initial: 'P',
                  amount: 150000,
                  status: DebtListStatus.overdue,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const DebtDetailScreen(),
                      ),
                    );
                  },
                ),
                DebtListItem(
                  name: 'Warung Makmur',
                  subtitle: 'Kemarin',
                  initial: 'W',
                  amount: 300000,
                  status: DebtListStatus.unpaid,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const DebtDetailScreen(),
                      ),
                    );
                  },
                ),
                DebtListItem(
                  name: 'Supplier Beras',
                  subtitle: '5 hari lalu',
                  initial: 'S',
                  amount: 530000,
                  status: DebtListStatus.paid,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const DebtDetailScreen(),
                      ),
                    );
                  },
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
            child: KasentraButton(
              label: 'Catat Utang / Piutang',
              icon: Icons.add_rounded,
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const AddDebtScreen()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
