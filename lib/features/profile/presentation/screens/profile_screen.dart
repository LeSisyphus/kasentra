import 'package:flutter/material.dart';

import 'package:kasentra/app/theme/kasentra_colors.dart';
import 'package:kasentra/app/theme/kasentra_spacing.dart';
import 'package:kasentra/features/profile/presentation/widgets/profile_business_card.dart';
import 'package:kasentra/features/profile/presentation/widgets/profile_section_card.dart';
import 'package:kasentra/shared/widgets/kasentra_badge.dart';
import 'package:kasentra/shared/widgets/kasentra_button.dart';
import 'package:kasentra/features/profile/presentation/screens/edit_profile_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                KasentraSpacing.screenPadding,
                KasentraSpacing.xl,
                KasentraSpacing.screenPadding,
                KasentraSpacing.xxl,
              ),
              children: [
                Text(
                  'Profil Usaha',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: KasentraColors.primaryDark,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: KasentraSpacing.xxxl),
                const ProfileBusinessCard(
                  businessName: 'Toko Sembako Ibu',
                  businessType: 'Toko Sembako',
                ),
                const SizedBox(height: KasentraSpacing.xxxl),
                ProfileSectionCard(
                  title: 'Informasi Detail',
                  icon: Icons.info_rounded,
                  children: [
                    _ProfileInfoRow(label: 'Nama Pemilik', value: 'Ibu Lina'),
                    _ProfileInfoRow(
                      label: 'Nomor Telepon',
                      value: '0812-3456-7890',
                    ),
                    _ProfileInfoRow(
                      label: 'Alamat',
                      value: 'Jl. Mawar Merah No. 42, Jakarta',
                      alignEnd: true,
                    ),
                    const _ProfileInfoRow(
                      label: 'Jenis Usaha',
                      trailing: KasentraBadge(
                        label: 'Ritel / Sembako',
                        variant: KasentraBadgeVariant.warning,
                      ),
                      showDivider: false,
                    ),
                  ],
                ),
                const SizedBox(height: KasentraSpacing.xxxl),
                ProfileSectionCard(
                  title: 'Aplikasi',
                  icon: Icons.settings_rounded,
                  children: [
                    _ProfileInfoRow(label: 'Versi Aplikasi', value: '1.0.0'),
                    _ProfileInfoRow(
                      label: 'Penyimpanan',
                      subtitle: 'Data aman di perangkat Anda',
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.cloud_done_outlined,
                            color: KasentraColors.primaryDark,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Lokal',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  color: KasentraColors.primaryDark,
                                  fontWeight: FontWeight.w800,
                                ),
                          ),
                        ],
                      ),
                      showDivider: false,
                    ),
                  ],
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
              label: 'Edit Profil Usaha',
              icon: Icons.edit_rounded,
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const EditProfileScreen()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileInfoRow extends StatelessWidget {
  const _ProfileInfoRow({
    required this.label,
    this.value,
    this.subtitle,
    this.trailing,
    this.alignEnd = false,
    this.showDivider = true,
  });

  final String label;
  final String? value;
  final String? subtitle;
  final Widget? trailing;
  final bool alignEnd;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final valueWidget =
        trailing ??
        Text(
          value ?? '',
          textAlign: alignEnd ? TextAlign.right : TextAlign.left,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
        );

    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: Theme.of(context).textTheme.bodyLarge),
                  if (subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      subtitle!,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: KasentraSpacing.lg),
            Flexible(child: valueWidget),
          ],
        ),
        if (showDivider)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: KasentraSpacing.lg),
            child: Divider(height: 1),
          ),
      ],
    );
  }
}
