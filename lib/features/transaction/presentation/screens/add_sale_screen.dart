import 'package:flutter/material.dart';

import 'package:kasentra/app/theme/kasentra_colors.dart';
import 'package:kasentra/app/theme/kasentra_spacing.dart';
import 'package:kasentra/features/transaction/presentation/widgets/form_date_field.dart';
import 'package:kasentra/features/transaction/presentation/widgets/payment_status_selector.dart';
import 'package:kasentra/features/transaction/presentation/widgets/sale_product_card.dart';
import 'package:kasentra/features/transaction/presentation/widgets/sale_summary_card.dart';
import 'package:kasentra/features/transaction/presentation/widgets/transaction_form_header.dart';
import 'package:kasentra/shared/widgets/kasentra_button.dart';

class AddSaleScreen extends StatefulWidget {
  const AddSaleScreen({super.key});

  @override
  State<AddSaleScreen> createState() => _AddSaleScreenState();
}

class _AddSaleScreenState extends State<AddSaleScreen> {
  bool _isPaid = true;

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
                  const TransactionFormHeader(title: 'Catat Penjualan'),
                  const SizedBox(height: 52),

                  Text(
                    'Produk Terpilih',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: KasentraSpacing.lg),

                  SaleProductCard(
                    name: 'Beras Premium 5kg',
                    unitPrice: 75000,
                    quantity: 1,
                    subtotal: 75000,
                    onRemove: () {},
                    onDecrease: () {},
                    onIncrease: () {},
                  ),
                  SaleProductCard(
                    name: 'Minyak Goreng 2L',
                    unitPrice: 32000,
                    quantity: 2,
                    subtotal: 64000,
                    onRemove: () {},
                    onDecrease: () {},
                    onIncrease: () {},
                  ),

                  const SizedBox(height: KasentraSpacing.sm),

                  KasentraButton(
                    label: 'Tambah Produk',
                    icon: Icons.add_rounded,
                    variant: KasentraButtonVariant.secondary,
                    onPressed: () {},
                  ),

                  const SizedBox(height: KasentraSpacing.xxl),

                  const SaleSummaryCard(
                    subtotal: 139000,
                    estimatedCost: 102000,
                    estimatedProfit: 37000,
                  ),

                  const SizedBox(height: KasentraSpacing.xxl),

                  FormDateField(
                    label: 'Tanggal Penjualan',
                    value: '27/10/2023',
                    onTap: () {},
                  ),

                  const SizedBox(height: KasentraSpacing.xxl),

                  Text(
                    'Status Pembayaran',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: KasentraSpacing.sm),
                  PaymentStatusSelector(
                    isPaid: _isPaid,
                    onChanged: (value) {
                      setState(() {
                        _isPaid = value;
                      });
                    },
                  ),

                  const SizedBox(height: KasentraSpacing.xxl),

                  Text(
                    'Catatan (Opsional)',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: KasentraSpacing.sm),
                  const TextField(
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: 'Tambahkan catatan jika perlu...',
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
              child: KasentraButton(
                label: 'Simpan Penjualan',
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
