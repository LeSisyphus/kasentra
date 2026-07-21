import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kasentra/app/providers/profile_providers.dart';
import 'package:kasentra/app/theme/kasentra_colors.dart';
import 'package:kasentra/app/theme/kasentra_spacing.dart';
import 'package:kasentra/features/transaction/domain/entities/transaction.dart';
import 'package:kasentra/features/transaction/presentation/screens/add_expense_screen.dart';
import 'package:kasentra/features/transaction/presentation/screens/add_sale_screen.dart';
import 'package:kasentra/features/transaction/presentation/state/transaction_list_state.dart';
import 'package:kasentra/features/transaction/presentation/viewmodels/transaction_list_view_model.dart';
import 'package:kasentra/features/transaction/presentation/widgets/transaction_daily_total_card.dart';
import 'package:kasentra/features/transaction/presentation/widgets/transaction_list_content.dart';
import 'package:kasentra/features/transaction/presentation/widgets/transaction_list_item.dart';
import 'package:kasentra/shared/widgets/kasentra_button.dart';
import 'package:kasentra/shared/widgets/kasentra_choice_chip.dart';

enum TransactionPeriod { today, week, month }

class TransactionScreen extends ConsumerStatefulWidget {
  const TransactionScreen({super.key, this.now});

  /// Dependency waktu agar widget test tetap deterministik.
  final DateTime Function()? now;

  @override
  ConsumerState<TransactionScreen> createState() {
    return _TransactionScreenState();
  }
}

class _TransactionScreenState extends ConsumerState<TransactionScreen> {
  TransactionPeriod _selectedPeriod = TransactionPeriod.today;

  String? _loadedBusinessId;
  TransactionPeriod? _loadedPeriod;
  bool _loadScheduled = false;

  DateTime get _currentTime {
    return widget.now?.call() ?? DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    final activeBusiness = ref.watch(activeBusinessProvider);

    final transactionState = ref.watch(transactionListViewModelProvider);

    return SafeArea(
      child: activeBusiness.when(
        loading: () {
          return const _TransactionStatusPage(
            child: CircularProgressIndicator(
              key: Key('transaction-business-loading'),
            ),
          );
        },
        error: (_, _) {
          return _TransactionStatusPage(
            child: _TransactionBusinessError(
              onRetry: () {
                ref.invalidate(activeBusinessProvider);
              },
            ),
          );
        },
        data: (business) {
          if (business == null) {
            _loadedBusinessId = null;
            _loadedPeriod = null;

            return const _MissingBusinessPage();
          }

          _scheduleInitialLoad(businessId: business.id);

          final range = _rangeForPeriod(
            period: _selectedPeriod,
            now: _currentTime,
          );

          return _TransactionDataPage(
            state: transactionState,
            selectedPeriod: _selectedPeriod,
            range: range,
            onPeriodSelected: _selectPeriod,
            onRefresh: () {
              return ref
                  .read(transactionListViewModelProvider.notifier)
                  .refresh();
            },
            onRetry: () {
              unawaited(
                ref.read(transactionListViewModelProvider.notifier).refresh(),
              );
            },
            onLoadMore: () {
              unawaited(
                ref.read(transactionListViewModelProvider.notifier).loadMore(),
              );
            },
            onAddSale: _openSaleForm,
            onAddExpense: _openExpenseForm,
          );
        },
      ),
    );
  }

  void _scheduleInitialLoad({required String businessId}) {
    final alreadyLoaded =
        _loadedBusinessId == businessId && _loadedPeriod == _selectedPeriod;

    if (_loadScheduled || alreadyLoaded) {
      return;
    }

    _loadScheduled = true;

    final periodToLoad = _selectedPeriod;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadScheduled = false;

      if (!mounted || _selectedPeriod != periodToLoad) {
        return;
      }

      final range = _rangeForPeriod(period: periodToLoad, now: _currentTime);

      _loadedBusinessId = businessId;
      _loadedPeriod = periodToLoad;

      unawaited(
        ref
            .read(transactionListViewModelProvider.notifier)
            .loadInitial(
              businessId: businessId,
              startDate: range.start,
              endDate: range.end,
            ),
      );
    });
  }

  void _selectPeriod(TransactionPeriod period) {
    if (period == _selectedPeriod) {
      return;
    }

    final transactionState = ref.read(transactionListViewModelProvider);

    if (transactionState.isInitialLoading || transactionState.isLoadingMore) {
      return;
    }

    setState(() {
      _selectedPeriod = period;
      _loadedPeriod = null;
    });
  }

  Future<void> _openSaleForm() async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) {
          return const AddSaleScreen();
        },
      ),
    );

    if (!mounted) {
      return;
    }

    await ref.read(transactionListViewModelProvider.notifier).refresh();
  }

  Future<void> _openExpenseForm() async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) {
          return const AddExpenseScreen();
        },
      ),
    );

    if (!mounted) {
      return;
    }

    await ref.read(transactionListViewModelProvider.notifier).refresh();
  }
}

class _TransactionDataPage extends StatelessWidget {
  const _TransactionDataPage({
    required this.state,
    required this.selectedPeriod,
    required this.range,
    required this.onPeriodSelected,
    required this.onRefresh,
    required this.onRetry,
    required this.onLoadMore,
    required this.onAddSale,
    required this.onAddExpense,
  });

  final TransactionListState state;
  final TransactionPeriod selectedPeriod;
  final TransactionDateRange range;
  final ValueChanged<TransactionPeriod> onPeriodSelected;
  final Future<void> Function() onRefresh;
  final VoidCallback onRetry;
  final VoidCallback onLoadMore;
  final VoidCallback onAddSale;
  final VoidCallback onAddExpense;

  @override
  Widget build(BuildContext context) {
    final loadedTotal = _calculateNetTotal(state.items);

    final totalLabel = state.hasMore
        ? 'Total sementara'
        : _periodTotalLabel(selectedPeriod);

    return Column(
      children: [
        Expanded(
          child: RefreshIndicator(
            onRefresh: onRefresh,
            child: ListView(
              key: const Key('transaction-list-scroll-view'),
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(
                KasentraSpacing.screenPadding,
                KasentraSpacing.lg,
                KasentraSpacing.screenPadding,
                KasentraSpacing.xxl,
              ),
              children: [
                Text(
                  'Transaksi',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: KasentraSpacing.lg),
                _PeriodSelector(
                  selectedPeriod: selectedPeriod,
                  onSelected: onPeriodSelected,
                ),
                const SizedBox(height: KasentraSpacing.xxl),
                Text(
                  _periodHeading(period: selectedPeriod, range: range),
                  key: const Key('transaction-period-heading'),
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: KasentraSpacing.md),
                SizedBox(
                  height: state.items.isEmpty ? 260 : null,
                  child: TransactionListContent(
                    state: state,
                    onRetry: onRetry,
                    contentBuilder: (_) {
                      return Column(
                        children: [
                          for (final transaction in state.items)
                            TransactionListItem(
                              key: Key(
                                'transaction-item-'
                                '${transaction.id}',
                              ),
                              title: _transactionTitle(transaction),
                              category: _transactionCategory(transaction),
                              time: _formatTime(transaction.transactionDate),
                              amount: transaction.totalAmount,
                              isIncome: transaction.isSale,
                            ),
                        ],
                      );
                    },
                  ),
                ),
                if (state.items.isNotEmpty) ...[
                  const SizedBox(height: KasentraSpacing.lg),
                  TransactionDailyTotalCard(
                    label: totalLabel,
                    total: loadedTotal,
                    transactionCount: state.items.length,
                  ),
                ],
                if (state.items.isNotEmpty && state.hasError) ...[
                  const SizedBox(height: KasentraSpacing.md),
                  _PaginationError(message: state.errorMessage!),
                ],
                if (state.hasMore) ...[
                  const SizedBox(height: KasentraSpacing.lg),
                  OutlinedButton.icon(
                    key: const Key('transaction-load-more-button'),
                    onPressed: state.isLoadingMore ? null : onLoadMore,
                    icon: state.isLoadingMore
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.expand_more_rounded),
                    label: Text(
                      state.isLoadingMore ? 'Memuat...' : 'Muat Lebih Banyak',
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
        _TransactionActionBar(onAddSale: onAddSale, onAddExpense: onAddExpense),
      ],
    );
  }
}

class _PeriodSelector extends StatelessWidget {
  const _PeriodSelector({
    required this.selectedPeriod,
    required this.onSelected,
  });

  final TransactionPeriod selectedPeriod;
  final ValueChanged<TransactionPeriod> onSelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (
            var index = 0;
            index < TransactionPeriod.values.length;
            index++
          ) ...[
            if (index > 0) const SizedBox(width: KasentraSpacing.sm),
            KasentraChoiceChip(
              label: _periodLabel(TransactionPeriod.values[index]),
              selected: selectedPeriod == TransactionPeriod.values[index],
              onSelected: (selected) {
                if (!selected) {
                  return;
                }

                onSelected(TransactionPeriod.values[index]);
              },
            ),
          ],
        ],
      ),
    );
  }
}

class _TransactionActionBar extends StatelessWidget {
  const _TransactionActionBar({
    required this.onAddSale,
    required this.onAddExpense,
  });

  final VoidCallback onAddSale;
  final VoidCallback onAddExpense;

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
      child: Row(
        children: [
          Expanded(
            child: KasentraButton(
              label: 'Catat Penjualan',
              onPressed: onAddSale,
            ),
          ),
          const SizedBox(width: KasentraSpacing.md),
          Expanded(
            child: KasentraButton(
              label: 'Catat Pengeluaran',
              variant: KasentraButtonVariant.danger,
              onPressed: onAddExpense,
            ),
          ),
        ],
      ),
    );
  }
}

class _MissingBusinessPage extends StatelessWidget {
  const _MissingBusinessPage();

  @override
  Widget build(BuildContext context) {
    return ListView(
      key: const Key('transaction-missing-business'),
      padding: const EdgeInsets.all(KasentraSpacing.screenPadding),
      children: [
        Text(
          'Transaksi',
          style: Theme.of(
            context,
          ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 160),
        const Icon(
          Icons.storefront_outlined,
          size: 64,
          color: KasentraColors.textMuted,
        ),
        const SizedBox(height: KasentraSpacing.lg),
        Text(
          'Profil usaha belum tersedia',
          textAlign: TextAlign.center,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: KasentraSpacing.sm),
        Text(
          'Siapkan profil usaha melalui tab Profil sebelum mencatat transaksi.',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }
}

class _TransactionStatusPage extends StatelessWidget {
  const _TransactionStatusPage({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(KasentraSpacing.screenPadding),
      children: [
        Text(
          'Transaksi',
          style: Theme.of(
            context,
          ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 180),
        Center(child: child),
      ],
    );
  }
}

class _TransactionBusinessError extends StatelessWidget {
  const _TransactionBusinessError({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const Key('transaction-business-error'),
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.error_outline_rounded,
          size: 56,
          color: Theme.of(context).colorScheme.error,
        ),
        const SizedBox(height: KasentraSpacing.md),
        Text(
          'Usaha aktif gagal dimuat.',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: KasentraSpacing.lg),
        FilledButton(
          key: const Key('transaction-business-retry'),
          onPressed: onRetry,
          child: const Text('Coba Lagi'),
        ),
      ],
    );
  }
}

class _PaginationError extends StatelessWidget {
  const _PaginationError({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const Key('transaction-pagination-error'),
      width: double.infinity,
      padding: const EdgeInsets.all(KasentraSpacing.md),
      decoration: BoxDecoration(
        color: KasentraColors.dangerSoft,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: KasentraColors.danger,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class TransactionDateRange {
  const TransactionDateRange({required this.start, required this.end});

  final DateTime start;
  final DateTime end;
}

TransactionDateRange _rangeForPeriod({
  required TransactionPeriod period,
  required DateTime now,
}) {
  final localNow = now.toLocal();

  final today = DateTime(localNow.year, localNow.month, localNow.day);

  switch (period) {
    case TransactionPeriod.today:
      return TransactionDateRange(
        start: today,
        end: today
            .add(const Duration(days: 1))
            .subtract(const Duration(microseconds: 1)),
      );

    case TransactionPeriod.week:
      final start = today.subtract(Duration(days: today.weekday - 1));

      return TransactionDateRange(
        start: start,
        end: start
            .add(const Duration(days: 7))
            .subtract(const Duration(microseconds: 1)),
      );

    case TransactionPeriod.month:
      final start = DateTime(today.year, today.month);

      final nextMonth = DateTime(today.year, today.month + 1);

      return TransactionDateRange(
        start: start,
        end: nextMonth.subtract(const Duration(microseconds: 1)),
      );
  }
}

int _calculateNetTotal(List<Transaction> transactions) {
  return transactions.fold<int>(0, (total, transaction) {
    if (transaction.isSale) {
      return total + transaction.totalAmount;
    }

    return total - transaction.totalAmount;
  });
}

String _transactionTitle(Transaction transaction) {
  final title = transaction.title?.trim();

  if (title != null && title.isNotEmpty) {
    return title;
  }

  return transaction.isSale ? 'Penjualan' : 'Pengeluaran';
}

String _transactionCategory(Transaction transaction) {
  return transaction.isSale ? 'Penjualan' : 'Pengeluaran';
}

String _formatTime(DateTime value) {
  final localValue = value.toLocal();

  return '${_twoDigits(localValue.hour)}:'
      '${_twoDigits(localValue.minute)}';
}

String _twoDigits(int value) {
  return value.toString().padLeft(2, '0');
}

String _periodLabel(TransactionPeriod period) {
  return switch (period) {
    TransactionPeriod.today => 'Hari Ini',
    TransactionPeriod.week => 'Minggu Ini',
    TransactionPeriod.month => 'Bulan Ini',
  };
}

String _periodTotalLabel(TransactionPeriod period) {
  return switch (period) {
    TransactionPeriod.today => 'Total Hari Ini',
    TransactionPeriod.week => 'Total Minggu Ini',
    TransactionPeriod.month => 'Total Bulan Ini',
  };
}

String _periodHeading({
  required TransactionPeriod period,
  required TransactionDateRange range,
}) {
  return switch (period) {
    TransactionPeriod.today => 'Hari Ini - ${_formatDate(range.start)}',
    TransactionPeriod.week =>
      '${_formatDate(range.start)} - '
          '${_formatDate(range.end)}',
    TransactionPeriod.month =>
      'Bulan Ini - ${_monthNames[range.start.month - 1]} '
          '${range.start.year}',
  };
}

String _formatDate(DateTime value) {
  return '${value.day} '
      '${_monthNames[value.month - 1]} '
      '${value.year}';
}

const List<String> _monthNames = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'Mei',
  'Jun',
  'Jul',
  'Agu',
  'Sep',
  'Okt',
  'Nov',
  'Des',
];
