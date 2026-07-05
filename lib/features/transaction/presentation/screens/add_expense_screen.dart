import 'package:flutter/material.dart';

import 'package:kasentra/app/theme/kasentra_colors.dart';
import 'package:kasentra/app/theme/kasentra_radius.dart';
import 'package:kasentra/app/theme/kasentra_spacing.dart';
import 'package:kasentra/features/transaction/presentation/widgets/expense_category_chip.dart';
import 'package:kasentra/features/transaction/presentation/widgets/expense_info_box.dart';
import 'package:kasentra/features/transaction/presentation/widgets/form_date_field.dart';
import 'package:kasentra/features/transaction/presentation/widgets/transaction_form_header.dart';
import 'package:kasentra/shared/widgets/kasentra_button.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  String _selectedCategory = 'Stok Barang';

  final List<String> _categories = const [
    'Stok Barang',
    'Operasional',
    'Transport',
    'Listrik & Air',
    'Sewa',
    'Lainnya',
  ];

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
                  const TransactionFormHeader(title: 'Catat Pengeluaran'),
                  const SizedBox(height: 56),

                  Container(
                    padding: const EdgeInsets.all(KasentraSpacing.xl),
                    decoration: BoxDecoration(
                      color: KasentraColors.surface,
                      borderRadius: BorderRadius.circular(KasentraRadius.lg),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Nama Pengeluaran'),
                        SizedBox(height: KasentraSpacing.sm),
                        TextField(
                          decoration: InputDecoration(
                            hintText: 'Contoh: Pembelian stok beras',
                          ),
                        ),
                        SizedBox(height: KasentraSpacing.lg),
                        Text('Nominal'),
                        SizedBox(height: KasentraSpacing.sm),
                        TextField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            prefixText: 'Rp   ',
                            hintText: '0',
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: KasentraSpacing.xxxl),

                  Text(
                    'Kategori',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: KasentraSpacing.lg),

                  Wrap(
                    spacing: KasentraSpacing.sm,
                    runSpacing: KasentraSpacing.sm,
                    children: _categories.map((category) {
                      return ExpenseCategoryChip(
                        label: category,
                        selected: _selectedCategory == category,
                        onTap: () {
                          setState(() {
                            _selectedCategory = category;
                          });
                        },
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: KasentraSpacing.xxxl),

                  Container(
                    padding: const EdgeInsets.all(KasentraSpacing.xl),
                    decoration: BoxDecoration(
                      color: KasentraColors.surface,
                      borderRadius: BorderRadius.circular(KasentraRadius.lg),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FormDateField(
                          label: 'Tanggal',
                          value: '27/10/2023',
                          onTap: () {},
                        ),
                        const SizedBox(height: KasentraSpacing.lg),
                        Text(
                          'Catatan (Opsional)',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: KasentraSpacing.sm),
                        const TextField(
                          maxLines: 4,
                          decoration: InputDecoration(
                            hintText:
                                'Tambahkan keterangan tambahan jika perlu...',
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: KasentraSpacing.xxxl),

                  const ExpenseInfoBox(),
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
              child: KasentraButton(
                label: 'Simpan Pengeluaran',
                icon: Icons.save_rounded,
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
