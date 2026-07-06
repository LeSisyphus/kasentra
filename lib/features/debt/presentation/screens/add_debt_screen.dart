import 'package:flutter/material.dart';

import 'package:kasentra/app/theme/kasentra_colors.dart';
import 'package:kasentra/app/theme/kasentra_spacing.dart';
import 'package:kasentra/features/debt/presentation/widgets/debt_status_card.dart';
import 'package:kasentra/features/debt/presentation/widgets/debt_type_segmented_control.dart';
import 'package:kasentra/features/transaction/presentation/widgets/form_date_field.dart';
import 'package:kasentra/features/transaction/presentation/widgets/transaction_form_header.dart';
import 'package:kasentra/shared/widgets/kasentra_button.dart';
import 'package:kasentra/shared/widgets/kasentra_text_field.dart';

class AddDebtScreen extends StatefulWidget {
  const AddDebtScreen({super.key});

  @override
  State<AddDebtScreen> createState() => _AddDebtScreenState();
}

class _AddDebtScreenState extends State<AddDebtScreen> {
  bool _isReceivable = true;

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
                  const TransactionFormHeader(title: 'Catat Utang'),
                  const SizedBox(height: KasentraSpacing.xxxl),
                  DebtTypeSegmentedControl(
                    isReceivable: _isReceivable,
                    onChanged: (value) {
                      setState(() {
                        _isReceivable = value;
                      });
                    },
                  ),
                  const SizedBox(height: KasentraSpacing.xxl),
                  Text(
                    _isReceivable
                        ? 'Pelanggan memiliki utang kepada usaha'
                        : 'Usaha memiliki utang kepada pihak lain',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: KasentraSpacing.xxl),
                  const KasentraTextField(
                    label: 'Nama Kontak',
                    hint: 'Contoh: Bu Siti',
                    prefixIcon: Icons.person_outline_rounded,
                  ),
                  const SizedBox(height: KasentraSpacing.lg),
                  const KasentraTextField(
                    label: 'Nomor HP (Opsional)',
                    hint: '08...',
                    prefixIcon: Icons.phone_outlined,
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: KasentraSpacing.lg),
                  const TextField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Nominal',
                      prefixText: 'Rp   ',
                      hintText: '0',
                    ),
                  ),
                  const SizedBox(height: KasentraSpacing.lg),
                  FormDateField(
                    label: 'Tanggal',
                    value: '15/05/2024',
                    onTap: () {},
                  ),
                  const SizedBox(height: KasentraSpacing.lg),
                  const KasentraTextField(
                    label: 'Catatan (Opsional)',
                    hint: 'Tulis rincian...',
                    maxLines: 4,
                  ),
                  const SizedBox(height: KasentraSpacing.xxl),
                  const DebtStatusCard(),
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
                label: 'Simpan Utang',
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
