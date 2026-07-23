import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kasentra/app/providers/category_providers.dart';
import 'package:kasentra/app/providers/profile_providers.dart';
import 'package:kasentra/app/providers/transaction_providers.dart';
import 'package:kasentra/app/theme/kasentra_colors.dart';
import 'package:kasentra/app/theme/kasentra_radius.dart';
import 'package:kasentra/app/theme/kasentra_spacing.dart';
import 'package:kasentra/features/product/domain/entities/category.dart';
import 'package:kasentra/features/profile/domain/entities/business.dart';
import 'package:kasentra/features/transaction/domain/entities/transaction.dart';
import 'package:kasentra/features/transaction/presentation/widgets/expense_category_chip.dart';
import 'package:kasentra/features/transaction/presentation/widgets/expense_info_box.dart';
import 'package:kasentra/features/transaction/presentation/widgets/form_date_field.dart';
import 'package:kasentra/features/transaction/presentation/widgets/transaction_form_header.dart';
import 'package:kasentra/shared/formatters/rupiah_formatter.dart';
import 'package:kasentra/shared/widgets/kasentra_button.dart';

class AddExpenseScreen extends ConsumerStatefulWidget {
  const AddExpenseScreen({super.key, this.now, this.idGenerator});

  final DateTime Function()? now;
  final String Function(DateTime timestamp)? idGenerator;

  @override
  ConsumerState<AddExpenseScreen> createState() {
    return _AddExpenseScreenState();
  }
}

class _AddExpenseScreenState extends ConsumerState<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _titleController;
  late final TextEditingController _amountController;
  late final TextEditingController _noteController;

  late DateTime _selectedDate;

  String? _selectedCategoryId;

  String? _scheduledBootstrapBusinessId;
  String? _bootstrappingBusinessId;
  String? _bootstrappedBusinessId;
  String? _bootstrapErrorBusinessId;
  Object? _bootstrapError;

  bool _isSaving = false;
  String? _saveErrorMessage;

  DateTime get _currentTime {
    return widget.now?.call() ?? DateTime.now();
  }

  @override
  void initState() {
    super.initState();

    final currentTime = _currentTime;

    _selectedDate = DateTime(
      currentTime.year,
      currentTime.month,
      currentTime.day,
    );

    _titleController = TextEditingController();
    _amountController = TextEditingController();
    _noteController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _noteController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final activeBusiness = ref.watch(activeBusinessProvider);

    return Scaffold(
      backgroundColor: KasentraColors.background,
      body: SafeArea(
        child: activeBusiness.when(
          loading: () {
            return const _ExpenseStatusPage(
              statusKey: Key('expense-business-loading'),
              child: CircularProgressIndicator(),
            );
          },
          error: (_, _) {
            return _ExpenseStatusPage(
              statusKey: const Key('expense-business-error'),
              child: _ExpenseStatusMessage(
                icon: Icons.error_outline_rounded,
                title: 'Usaha aktif gagal dimuat',
                description: 'Data usaha belum dapat dibaca.',
                actionLabel: 'Coba Lagi',
                onAction: () {
                  ref.invalidate(activeBusinessProvider);
                },
              ),
            );
          },
          data: (business) {
            if (business == null) {
              return const _ExpenseStatusPage(
                statusKey: Key('expense-missing-business'),
                child: _ExpenseStatusMessage(
                  icon: Icons.storefront_outlined,
                  title: 'Profil usaha belum tersedia',
                  description:
                      'Siapkan profil usaha sebelum '
                      'mencatat pengeluaran.',
                ),
              );
            }

            return _buildBusinessContent(business);
          },
        ),
      ),
    );
  }

  Widget _buildBusinessContent(Business business) {
    _scheduleCategoryBootstrap(business.id);

    final hasBootstrapError =
        _bootstrapErrorBusinessId == business.id && _bootstrapError != null;

    if (hasBootstrapError) {
      return _ExpenseStatusPage(
        statusKey: const Key('expense-category-bootstrap-error'),
        child: _ExpenseStatusMessage(
          icon: Icons.error_outline_rounded,
          title: 'Kategori gagal disiapkan',
          description:
              'Kategori pengeluaran belum dapat '
              'disiapkan.',
          actionLabel: 'Coba Lagi',
          onAction: _retryCategoryBootstrap,
        ),
      );
    }

    if (_bootstrappedBusinessId != business.id) {
      return const _ExpenseStatusPage(
        statusKey: Key('expense-category-bootstrap-loading'),
        child: CircularProgressIndicator(),
      );
    }

    final expenseCategories = ref.watch(expenseCategoriesProvider(business.id));

    return expenseCategories.when(
      loading: () {
        return const _ExpenseStatusPage(
          statusKey: Key('expense-categories-loading'),
          child: CircularProgressIndicator(),
        );
      },
      error: (_, _) {
        return _ExpenseStatusPage(
          statusKey: const Key('expense-categories-error'),
          child: _ExpenseStatusMessage(
            icon: Icons.error_outline_rounded,
            title: 'Kategori gagal dimuat',
            description:
                'Daftar kategori pengeluaran '
                'belum dapat dibaca.',
            actionLabel: 'Coba Lagi',
            onAction: () {
              ref.invalidate(expenseCategoriesProvider(business.id));
            },
          ),
        );
      },
      data: (categories) {
        if (categories.isEmpty) {
          return _ExpenseStatusPage(
            statusKey: const Key('expense-categories-empty'),
            child: _ExpenseStatusMessage(
              icon: Icons.category_outlined,
              title: 'Kategori belum tersedia',
              description:
                  'Siapkan kembali kategori '
                  'pengeluaran.',
              actionLabel: 'Siapkan Kategori',
              onAction: _retryCategoryBootstrap,
            ),
          );
        }

        final selectedCategoryId = _resolveSelectedCategoryId(categories);

        return _buildExpenseForm(
          business: business,
          categories: categories,
          selectedCategoryId: selectedCategoryId,
        );
      },
    );
  }

  Widget _buildExpenseForm({
    required Business business,
    required List<Category> categories,
    required String selectedCategoryId,
  }) {
    return Form(
      key: _formKey,
      child: Column(
        key: const Key('expense-form'),
        children: [
          Expanded(
            child: ListView(
              key: const Key('expense-form-scroll-view'),
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Nama Pengeluaran',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: KasentraSpacing.sm),
                      TextFormField(
                        key: const Key('expense-title-field'),
                        controller: _titleController,
                        enabled: !_isSaving,
                        textInputAction: TextInputAction.next,
                        maxLength: 100,
                        decoration: const InputDecoration(
                          hintText:
                              'Contoh: Pembelian '
                              'stok beras',
                          counterText: '',
                        ),
                        validator: _validateExpenseTitle,
                      ),
                      const SizedBox(height: KasentraSpacing.lg),
                      Text(
                        'Nominal',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: KasentraSpacing.sm),
                      TextFormField(
                        key: const Key('expense-amount-field'),
                        controller: _amountController,
                        enabled: !_isSaving,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(15),
                        ],
                        decoration: const InputDecoration(
                          prefixText: 'Rp   ',
                          hintText: '0',
                        ),
                        validator: _validateExpenseAmount,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: KasentraSpacing.xxxl),
                Text(
                  'Kategori',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: KasentraSpacing.lg),
                Wrap(
                  spacing: KasentraSpacing.sm,
                  runSpacing: KasentraSpacing.sm,
                  children: [
                    for (final category in categories)
                      ExpenseCategoryChip(
                        key: Key(
                          'expense-category-'
                          '${category.id}',
                        ),
                        label: category.name,
                        selected: selectedCategoryId == category.id,
                        onTap: () {
                          if (_isSaving) {
                            return;
                          }

                          setState(() {
                            _selectedCategoryId = category.id;
                          });
                        },
                      ),
                  ],
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
                        key: const Key('expense-date-field'),
                        label: 'Tanggal',
                        value: _formatDate(_selectedDate),
                        onTap: () {
                          if (_isSaving) {
                            return;
                          }

                          unawaited(_selectDate());
                        },
                      ),
                      const SizedBox(height: KasentraSpacing.lg),
                      Text(
                        'Catatan (Opsional)',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: KasentraSpacing.sm),
                      TextFormField(
                        key: const Key('expense-note-field'),
                        controller: _noteController,
                        enabled: !_isSaving,
                        maxLines: 4,
                        textInputAction: TextInputAction.newline,
                        decoration: const InputDecoration(
                          hintText:
                              'Tambahkan keterangan '
                              'tambahan jika perlu...',
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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_saveErrorMessage != null) ...[
                  Container(
                    key: const Key('expense-form-error'),
                    width: double.infinity,
                    padding: const EdgeInsets.all(KasentraSpacing.md),
                    decoration: BoxDecoration(
                      color: KasentraColors.dangerSoft,
                      borderRadius: BorderRadius.circular(KasentraRadius.md),
                    ),
                    child: Text(
                      _saveErrorMessage!,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: KasentraColors.danger,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(height: KasentraSpacing.sm),
                ],
                KasentraButton(
                  key: const Key('expense-save-button'),
                  label: _isSaving ? 'Menyimpan...' : 'Simpan Pengeluaran',
                  icon: Icons.save_rounded,
                  onPressed: _isSaving
                      ? null
                      : () {
                          unawaited(
                            _submit(
                              business: business,
                              categoryId: selectedCategoryId,
                            ),
                          );
                        },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _scheduleCategoryBootstrap(String businessId) {
    if (_bootstrappedBusinessId == businessId ||
        _bootstrappingBusinessId == businessId ||
        _scheduledBootstrapBusinessId == businessId ||
        _bootstrapErrorBusinessId == businessId) {
      return;
    }

    _scheduledBootstrapBusinessId = businessId;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _scheduledBootstrapBusinessId != businessId) {
        return;
      }

      _scheduledBootstrapBusinessId = null;

      unawaited(_bootstrapCategories(businessId));
    });
  }

  Future<void> _bootstrapCategories(String businessId) async {
    setState(() {
      _bootstrappingBusinessId = businessId;
      _bootstrapErrorBusinessId = null;
      _bootstrapError = null;
    });

    try {
      await ref.read(ensureDefaultExpenseCategoriesUseCaseProvider)(
        businessId: businessId,
        timestamp: _currentTime.toUtc(),
      );

      if (!mounted) {
        return;
      }

      ref.invalidate(expenseCategoriesProvider(businessId));

      setState(() {
        _bootstrappingBusinessId = null;
        _bootstrappedBusinessId = businessId;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _bootstrappingBusinessId = null;
        _bootstrapErrorBusinessId = businessId;
        _bootstrapError = error;
      });
    }
  }

  void _retryCategoryBootstrap() {
    setState(() {
      _scheduledBootstrapBusinessId = null;
      _bootstrappingBusinessId = null;
      _bootstrappedBusinessId = null;
      _bootstrapErrorBusinessId = null;
      _bootstrapError = null;
      _selectedCategoryId = null;
    });
  }

  String _resolveSelectedCategoryId(List<Category> categories) {
    final selectedCategoryId = _selectedCategoryId;

    if (selectedCategoryId != null &&
        categories.any((category) => category.id == selectedCategoryId)) {
      return selectedCategoryId;
    }

    for (final category in categories) {
      if (category.name.trim().toLowerCase() == 'stok barang') {
        return category.id;
      }
    }

    return categories.first.id;
  }

  Future<void> _selectDate() async {
    final currentTime = _currentTime;

    final selectedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(currentTime.year - 10),
      lastDate: DateTime(currentTime.year + 1, 12, 31),
    );

    if (selectedDate == null || !mounted) {
      return;
    }

    setState(() {
      _selectedDate = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
      );
    });
  }

  Future<void> _submit({
    required Business business,
    required String categoryId,
  }) async {
    if (_isSaving) {
      return;
    }

    FocusScope.of(context).unfocus();

    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    final currentTime = _currentTime;
    final timestamp = currentTime.toUtc();

    final transactionDate = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      currentTime.hour,
      currentTime.minute,
      currentTime.second,
      currentTime.millisecond,
      currentTime.microsecond,
    ).toUtc();

    final expense = Transaction(
      id: _createExpenseId(timestamp),
      businessId: business.id,
      type: TransactionType.expense,
      title: _titleController.text.trim(),
      categoryId: categoryId,
      totalAmount: RupiahFormatter.parse(_amountController.text),
      costAmount: 0,
      profitAmount: 0,
      paymentStatus: PaymentStatus.paid,
      transactionDate: transactionDate,
      note: _normalizeOptionalText(_noteController.text),
      createdAt: timestamp,
      updatedAt: timestamp,
    );

    setState(() {
      _isSaving = true;
      _saveErrorMessage = null;
    });

    try {
      await ref.read(saveExpenseUseCaseProvider)(expense);

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
        _saveErrorMessage =
            'Pengeluaran gagal disimpan. '
            'Coba lagi.';
      });
    }
  }

  String _createExpenseId(DateTime timestamp) {
    final generator = widget.idGenerator;

    if (generator != null) {
      return generator(timestamp);
    }

    return 'expense-'
        '${timestamp.microsecondsSinceEpoch}';
  }
}

class _ExpenseStatusPage extends StatelessWidget {
  const _ExpenseStatusPage({required this.statusKey, required this.child});

  final Key statusKey;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ListView(
      key: statusKey,
      padding: const EdgeInsets.fromLTRB(
        KasentraSpacing.screenPadding,
        KasentraSpacing.lg,
        KasentraSpacing.screenPadding,
        KasentraSpacing.xxl,
      ),
      children: [
        const TransactionFormHeader(title: 'Catat Pengeluaran'),
        const SizedBox(height: 180),
        Center(child: child),
      ],
    );
  }
}

class _ExpenseStatusMessage extends StatelessWidget {
  const _ExpenseStatusMessage({
    required this.icon,
    required this.title,
    required this.description,
    this.actionLabel,
    this.onAction,
  });

  final IconData icon;
  final String title;
  final String description;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 56, color: KasentraColors.textMuted),
        const SizedBox(height: KasentraSpacing.md),
        Text(
          title,
          textAlign: TextAlign.center,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: KasentraSpacing.sm),
        Text(
          description,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        if (actionLabel != null && onAction != null) ...[
          const SizedBox(height: KasentraSpacing.lg),
          FilledButton(onPressed: onAction, child: Text(actionLabel!)),
        ],
      ],
    );
  }
}

String? _validateExpenseTitle(String? value) {
  final normalized = value?.trim() ?? '';

  if (normalized.isEmpty) {
    return 'Nama pengeluaran wajib diisi.';
  }

  if (normalized.length > 100) {
    return 'Nama pengeluaran maksimal '
        '100 karakter.';
  }

  return null;
}

String? _validateExpenseAmount(String? value) {
  final normalized = value?.trim() ?? '';

  if (normalized.isEmpty) {
    return 'Nominal wajib diisi.';
  }

  final amount = RupiahFormatter.parse(normalized);

  if (amount <= 0) {
    return 'Nominal harus lebih dari 0.';
  }

  return null;
}

String? _normalizeOptionalText(String value) {
  final normalized = value.trim();

  if (normalized.isEmpty) {
    return null;
  }

  return normalized;
}

String _formatDate(DateTime value) {
  return '${_twoDigits(value.day)}/'
      '${_twoDigits(value.month)}/'
      '${value.year}';
}

String _twoDigits(int value) {
  return value.toString().padLeft(2, '0');
}
