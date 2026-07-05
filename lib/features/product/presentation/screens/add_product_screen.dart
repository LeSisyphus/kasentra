import 'package:flutter/material.dart';

import 'package:kasentra/app/theme/kasentra_colors.dart';
import 'package:kasentra/app/theme/kasentra_spacing.dart';
import 'package:kasentra/features/product/presentation/widgets/product_active_card.dart';
import 'package:kasentra/features/product/presentation/widgets/product_photo_placeholder.dart';
import 'package:kasentra/features/transaction/presentation/widgets/expense_category_chip.dart';
import 'package:kasentra/features/transaction/presentation/widgets/transaction_form_header.dart';
import 'package:kasentra/shared/widgets/kasentra_button.dart';
import 'package:kasentra/shared/widgets/kasentra_text_field.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  String _selectedCategory = 'Sembako';
  bool _isActive = true;

  final List<String> _categories = const [
    'Sembako',
    'Minuman',
    'Makanan',
    'Rumah Tangga',
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
                  const TransactionFormHeader(title: 'Tambah Produk'),
                  const SizedBox(height: 56),
                  const ProductPhotoPlaceholder(),
                  const SizedBox(height: KasentraSpacing.xxxl),
                  const KasentraTextField(
                    label: 'Nama Produk',
                    hint: 'Contoh: Beras Premium 5kg',
                  ),
                  const SizedBox(height: KasentraSpacing.xl),
                  Text(
                    'Kategori',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: KasentraSpacing.sm),
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
                  const Row(
                    children: [
                      Expanded(
                        child: TextField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Harga Modal',
                            prefixText: 'Rp   ',
                            hintText: '0',
                          ),
                        ),
                      ),
                      SizedBox(width: KasentraSpacing.lg),
                      Expanded(
                        child: TextField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Harga Jual',
                            prefixText: 'Rp   ',
                            hintText: '0',
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: KasentraSpacing.xl),
                  const KasentraTextField(
                    label: 'Stok Opsional',
                    hint: 'Contoh: 25',
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: KasentraSpacing.sm),
                  Text(
                    'Stok boleh dikosongkan jika belum ingin dikelola.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: KasentraSpacing.xxl),
                  ProductActiveCard(
                    value: _isActive,
                    onChanged: (value) {
                      setState(() {
                        _isActive = value;
                      });
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
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 12,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: KasentraButton(label: 'Simpan Produk', onPressed: () {}),
            ),
          ],
        ),
      ),
    );
  }
}
