import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kasentra/app/providers/profile_providers.dart';
import 'package:kasentra/app/theme/kasentra_colors.dart';
import 'package:kasentra/app/theme/kasentra_spacing.dart';
import 'package:kasentra/features/profile/domain/entities/business.dart';
import 'package:kasentra/features/profile/presentation/widgets/profile_business_card.dart';
import 'package:kasentra/features/profile/presentation/widgets/profile_section_card.dart';
import 'package:kasentra/shared/widgets/kasentra_badge.dart';
import 'package:kasentra/shared/widgets/kasentra_button.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key, this.onEditBusiness});

  final ValueChanged<Business?>? onEditBusiness;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeBusiness = ref.watch(activeBusinessProvider);

    return SafeArea(
      child: activeBusiness.when(
        loading: () {
          return const _ProfileStatusPage(
            child: CircularProgressIndicator(key: Key('profile-loading')),
          );
        },
        error: (_, _) {
          return _ProfileStatusPage(
            child: _ProfileError(
              onRetry: () {
                ref.invalidate(activeBusinessProvider);
              },
            ),
          );
        },
        data: (business) {
          return _ProfileDataPage(
            business: business,
            onEditBusiness: onEditBusiness,
          );
        },
      ),
    );
  }
}

class _ProfileDataPage extends StatelessWidget {
  const _ProfileDataPage({
    required this.business,
    required this.onEditBusiness,
  });

  final Business? business;
  final ValueChanged<Business?>? onEditBusiness;

  @override
  Widget build(BuildContext context) {
    return Column(
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
              const _ProfileTitle(),
              const SizedBox(height: KasentraSpacing.xxxl),
              if (business == null)
                const _ProfileEmpty()
              else
                _BusinessProfileContent(business: business!),
              const SizedBox(height: KasentraSpacing.xxxl),
              const _ApplicationSection(),
            ],
          ),
        ),
        _ProfileActionBar(
          label: business == null
              ? 'Siapkan Profil Usaha'
              : 'Edit Profil Usaha',
          onPressed: onEditBusiness == null
              ? null
              : () {
                  onEditBusiness!(business);
                },
        ),
      ],
    );
  }
}

class _BusinessProfileContent extends StatelessWidget {
  const _BusinessProfileContent({required this.business});

  final Business business;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const Key('profile-content'),
      children: [
        ProfileBusinessCard(
          businessName: business.name,
          businessType: business.typeLabel,
        ),
        const SizedBox(height: KasentraSpacing.xxxl),
        ProfileSectionCard(
          title: 'Informasi Detail',
          icon: Icons.info_rounded,
          children: [
            _ProfileInfoRow(label: 'Nama Pemilik', value: business.ownerName),
            _ProfileInfoRow(
              label: 'Nomor Telepon',
              value: _displayOptionalValue(business.phoneNumber),
            ),
            _ProfileInfoRow(
              label: 'Alamat',
              value: _displayOptionalValue(business.address),
              alignEnd: true,
            ),
            _ProfileInfoRow(
              label: 'Jenis Usaha',
              trailing: KasentraBadge(
                label: business.typeLabel,
                variant: KasentraBadgeVariant.warning,
              ),
              showDivider: false,
            ),
          ],
        ),
      ],
    );
  }
}

class _ProfileEmpty extends StatelessWidget {
  const _ProfileEmpty();

  @override
  Widget build(BuildContext context) {
    return Center(
      key: const Key('profile-empty'),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: KasentraSpacing.xxxl),
        child: Column(
          children: [
            const Icon(
              Icons.storefront_outlined,
              size: 64,
              color: KasentraColors.textMuted,
            ),
            const SizedBox(height: KasentraSpacing.lg),
            Text(
              'Profil usaha belum disiapkan',
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: KasentraSpacing.sm),
            Text(
              'Isi nama usaha dan informasi pemilik sebelum mulai mencatat data.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}

class _ApplicationSection extends StatelessWidget {
  const _ApplicationSection();

  @override
  Widget build(BuildContext context) {
    return ProfileSectionCard(
      title: 'Aplikasi',
      icon: Icons.settings_rounded,
      children: [
        const _ProfileInfoRow(label: 'Versi Aplikasi', value: '1.0.0'),
        _ProfileInfoRow(
          label: 'Penyimpanan',
          subtitle: 'Data tersimpan di perangkat Anda',
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.phone_android_rounded,
                color: KasentraColors.primaryDark,
              ),
              const SizedBox(width: 6),
              Text(
                'Lokal',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: KasentraColors.primaryDark,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          showDivider: false,
        ),
      ],
    );
  }
}

class _ProfileStatusPage extends StatelessWidget {
  const _ProfileStatusPage({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(
        KasentraSpacing.screenPadding,
        KasentraSpacing.xl,
        KasentraSpacing.screenPadding,
        KasentraSpacing.xxl,
      ),
      children: [
        const _ProfileTitle(),
        const SizedBox(height: 180),
        Center(child: child),
      ],
    );
  }
}

class _ProfileError extends StatelessWidget {
  const _ProfileError({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const Key('profile-error'),
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.error_outline_rounded,
          size: 56,
          color: Theme.of(context).colorScheme.error,
        ),
        const SizedBox(height: KasentraSpacing.md),
        Text(
          'Profil usaha gagal dimuat.',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: KasentraSpacing.lg),
        FilledButton(
          key: const Key('profile-retry-button'),
          onPressed: onRetry,
          child: const Text('Coba Lagi'),
        ),
      ],
    );
  }
}

class _ProfileTitle extends StatelessWidget {
  const _ProfileTitle();

  @override
  Widget build(BuildContext context) {
    return Text(
      'Profil Usaha',
      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
        color: KasentraColors.primaryDark,
        fontWeight: FontWeight.w800,
      ),
    );
  }
}

class _ProfileActionBar extends StatelessWidget {
  const _ProfileActionBar({required this.label, required this.onPressed});

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
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
        label: label,
        icon: Icons.edit_rounded,
        onPressed: onPressed,
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

String _displayOptionalValue(String? value) {
  final normalizedValue = value?.trim();

  if (normalizedValue == null || normalizedValue.isEmpty) {
    return 'Belum diisi';
  }

  return normalizedValue;
}
