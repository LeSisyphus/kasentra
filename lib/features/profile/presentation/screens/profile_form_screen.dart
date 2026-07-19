import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kasentra/app/providers/profile_providers.dart';
import 'package:kasentra/app/theme/kasentra_colors.dart';
import 'package:kasentra/app/theme/kasentra_spacing.dart';
import 'package:kasentra/features/profile/domain/entities/business.dart';
import 'package:kasentra/shared/widgets/kasentra_button.dart';

class ProfileFormScreen extends ConsumerStatefulWidget {
  const ProfileFormScreen({
    super.key,
    this.initialBusiness,
    this.now,
    this.idGenerator,
  });

  final Business? initialBusiness;

  /// Dependency waktu untuk membuat test deterministik.
  final DateTime Function()? now;

  /// Dependency pembuat ID untuk membuat test deterministik.
  final String Function(DateTime timestamp)? idGenerator;

  @override
  ConsumerState<ProfileFormScreen> createState() {
    return _ProfileFormScreenState();
  }
}

class _ProfileFormScreenState extends ConsumerState<ProfileFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _ownerNameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _addressController;

  late BusinessType _businessType;

  bool _isSaving = false;
  String? _errorMessage;

  bool get _isEditing => widget.initialBusiness != null;

  @override
  void initState() {
    super.initState();

    final business = widget.initialBusiness;

    _nameController = TextEditingController(text: business?.name ?? '');

    _ownerNameController = TextEditingController(
      text: business?.ownerName ?? '',
    );

    _phoneController = TextEditingController(text: business?.phoneNumber ?? '');

    _addressController = TextEditingController(text: business?.address ?? '');

    _businessType = business?.type ?? BusinessType.groceryStore;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ownerNameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Profil Usaha' : 'Siapkan Profil Usaha'),
      ),
      body: SafeArea(
        top: false,
        child: Form(
          key: _formKey,
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
                      _isEditing
                          ? 'Perbarui informasi usaha Anda.'
                          : 'Lengkapi informasi usaha sebelum mulai mencatat transaksi.',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: KasentraSpacing.xxl),
                    TextFormField(
                      key: const Key('profile-form-name-field'),
                      controller: _nameController,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'Nama Usaha',
                        hintText: 'Contoh: Toko Kasentra',
                      ),
                      validator: (value) {
                        return _validateRequiredName(
                          value,
                          fieldLabel: 'Nama usaha',
                        );
                      },
                    ),
                    const SizedBox(height: KasentraSpacing.lg),
                    TextFormField(
                      key: const Key('profile-form-owner-field'),
                      controller: _ownerNameController,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'Nama Pemilik',
                        hintText: 'Contoh: Ibu Lina',
                      ),
                      validator: (value) {
                        return _validateRequiredName(
                          value,
                          fieldLabel: 'Nama pemilik',
                        );
                      },
                    ),
                    const SizedBox(height: KasentraSpacing.lg),
                    DropdownButtonFormField<BusinessType>(
                      key: const Key('profile-form-type-field'),
                      initialValue: _businessType,
                      decoration: const InputDecoration(
                        labelText: 'Jenis Usaha',
                      ),
                      items: BusinessType.values
                          .map((type) {
                            return DropdownMenuItem<BusinessType>(
                              value: type,
                              child: Text(_businessTypeLabel(type)),
                            );
                          })
                          .toList(growable: false),
                      onChanged: _isSaving
                          ? null
                          : (value) {
                              if (value == null) {
                                return;
                              }

                              setState(() {
                                _businessType = value;
                              });
                            },
                    ),
                    const SizedBox(height: KasentraSpacing.lg),
                    TextFormField(
                      key: const Key('profile-form-phone-field'),
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'Nomor Telepon',
                        hintText: 'Opsional',
                      ),
                    ),
                    const SizedBox(height: KasentraSpacing.lg),
                    TextFormField(
                      key: const Key('profile-form-address-field'),
                      controller: _addressController,
                      keyboardType: TextInputType.streetAddress,
                      textInputAction: TextInputAction.newline,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'Alamat',
                        hintText: 'Opsional',
                        alignLabelWithHint: true,
                      ),
                    ),
                    if (_errorMessage != null) ...[
                      const SizedBox(height: KasentraSpacing.lg),
                      Container(
                        key: const Key('profile-form-error'),
                        width: double.infinity,
                        padding: const EdgeInsets.all(KasentraSpacing.lg),
                        decoration: BoxDecoration(
                          color: KasentraColors.dangerSoft,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _errorMessage!,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: KasentraColors.danger,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                      ),
                    ],
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
                  key: const Key('profile-form-save-button'),
                  label: _isSaving ? 'Menyimpan...' : 'Simpan Profil Usaha',
                  icon: Icons.save_rounded,
                  onPressed: _isSaving ? null : _submit,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (_isSaving) {
      return;
    }

    FocusScope.of(context).unfocus();

    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    final timestamp = (widget.now?.call() ?? DateTime.now()).toUtc();

    final initialBusiness = widget.initialBusiness;
    final createdAt = initialBusiness?.createdAt ?? timestamp;

    final updatedAt = timestamp.isBefore(createdAt) ? createdAt : timestamp;

    final business = Business(
      id: initialBusiness?.id ?? _createBusinessId(timestamp),
      name: _nameController.text.trim(),
      ownerName: _ownerNameController.text.trim(),
      type: _businessType,
      phoneNumber: _nullableText(_phoneController.text),
      address: _nullableText(_addressController.text),
      createdAt: createdAt,
      updatedAt: updatedAt,
    );

    setState(() {
      _isSaving = true;
      _errorMessage = null;
    });

    try {
      await ref.read(saveBusinessUseCaseProvider)(business);

      if (!mounted) {
        return;
      }

      Navigator.of(context).pop(true);
    } catch (_) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isSaving = false;
        _errorMessage = 'Profil usaha gagal disimpan. Coba lagi.';
      });
    }
  }

  String _createBusinessId(DateTime timestamp) {
    final generator = widget.idGenerator;

    if (generator != null) {
      return generator(timestamp);
    }

    return 'business-${timestamp.microsecondsSinceEpoch}';
  }
}

String? _validateRequiredName(String? value, {required String fieldLabel}) {
  final normalizedValue = value?.trim() ?? '';

  if (normalizedValue.isEmpty) {
    return '$fieldLabel wajib diisi.';
  }

  if (normalizedValue.length < 2) {
    return '$fieldLabel minimal 2 karakter.';
  }

  return null;
}

String? _nullableText(String value) {
  final normalizedValue = value.trim();

  if (normalizedValue.isEmpty) {
    return null;
  }

  return normalizedValue;
}

String _businessTypeLabel(BusinessType type) {
  return switch (type) {
    BusinessType.groceryStore => 'Toko Sembako',
    BusinessType.retail => 'Ritel',
    BusinessType.food => 'Makanan',
    BusinessType.service => 'Jasa',
    BusinessType.other => 'Lainnya',
  };
}
