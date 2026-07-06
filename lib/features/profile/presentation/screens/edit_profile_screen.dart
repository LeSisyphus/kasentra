import 'package:flutter/material.dart';

import 'package:kasentra/app/theme/kasentra_colors.dart';
import 'package:kasentra/app/theme/kasentra_radius.dart';
import 'package:kasentra/app/theme/kasentra_spacing.dart';
import 'package:kasentra/features/transaction/presentation/widgets/transaction_form_header.dart';
import 'package:kasentra/shared/widgets/kasentra_button.dart';
import 'package:kasentra/shared/widgets/kasentra_choice_chip.dart';
import 'package:kasentra/shared/widgets/kasentra_text_field.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  String _selectedBusinessType = 'Toko Sembako';

  final List<String> _businessTypes = const [
    'Toko Sembako',
    'Ritel',
    'Warung',
    'Makanan',
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
                  const TransactionFormHeader(title: 'Edit Profil Usaha'),
                  const SizedBox(height: KasentraSpacing.xxxl),

                  Container(
                    padding: const EdgeInsets.all(KasentraSpacing.xl),
                    decoration: BoxDecoration(
                      color: KasentraColors.surface,
                      borderRadius: BorderRadius.circular(KasentraRadius.xl),
                      border: Border.all(color: KasentraColors.borderLight),
                    ),
                    child: const Column(
                      children: [
                        KasentraTextField(
                          label: 'Nama Usaha',
                          initialValue: 'Toko Sembako Ibu',
                          prefixIcon: Icons.storefront_outlined,
                        ),
                        SizedBox(height: KasentraSpacing.lg),
                        KasentraTextField(
                          label: 'Nama Pemilik',
                          initialValue: 'Ibu Lina',
                          prefixIcon: Icons.person_outline_rounded,
                        ),
                        SizedBox(height: KasentraSpacing.lg),
                        KasentraTextField(
                          label: 'Nomor Telepon',
                          initialValue: '0812-3456-7890',
                          prefixIcon: Icons.phone_outlined,
                          keyboardType: TextInputType.phone,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: KasentraSpacing.xxl),

                  Container(
                    padding: const EdgeInsets.all(KasentraSpacing.xl),
                    decoration: BoxDecoration(
                      color: KasentraColors.surface,
                      borderRadius: BorderRadius.circular(KasentraRadius.xl),
                      border: Border.all(color: KasentraColors.borderLight),
                    ),
                    child: const KasentraTextField(
                      label: 'Alamat Usaha',
                      initialValue: 'Jl. Mawar Merah No. 42, Jakarta',
                      prefixIcon: Icons.location_on_outlined,
                      maxLines: 3,
                    ),
                  ),

                  const SizedBox(height: KasentraSpacing.xxl),

                  Text(
                    'Jenis Usaha',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: KasentraSpacing.md),

                  Wrap(
                    spacing: KasentraSpacing.sm,
                    runSpacing: KasentraSpacing.sm,
                    children: _businessTypes.map((type) {
                      return KasentraChoiceChip(
                        label: type,
                        selected: _selectedBusinessType == type,
                        onSelected: (_) {
                          setState(() {
                            _selectedBusinessType = type;
                          });
                        },
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: KasentraSpacing.xxxl),

                  Container(
                    padding: const EdgeInsets.all(KasentraSpacing.lg),
                    decoration: BoxDecoration(
                      color: KasentraColors.primarySoft,
                      borderRadius: BorderRadius.circular(KasentraRadius.lg),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.lock_outline_rounded,
                          color: KasentraColors.primaryDark,
                        ),
                        const SizedBox(width: KasentraSpacing.md),
                        Expanded(
                          child: Text(
                            'Data usaha disimpan secara lokal di perangkat Anda.',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: KasentraColors.primaryDark,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
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
              child: KasentraButton(
                label: 'Simpan Profil',
                icon: Icons.save_rounded,
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
