import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/providers/transaction_providers.dart';
import '../state/transaction_list_state.dart';

final transactionListViewModelProvider =
    NotifierProvider<TransactionListViewModel, TransactionListState>(
      TransactionListViewModel.new,
      name: 'transactionListViewModelProvider',
    );

class TransactionListViewModel extends Notifier<TransactionListState> {
  String? _businessId;
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  TransactionListState build() {
    return TransactionListState();
  }

  Future<void> loadInitial({
    required String businessId,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    if (state.isInitialLoading || state.isLoadingMore) {
      return;
    }

    _businessId = businessId;
    _startDate = startDate;
    _endDate = endDate;

    state = state.copyWith(
      items: const [],
      clearNextCursor: true,
      hasMore: false,
      isInitialLoading: true,
      isLoadingMore: false,
      clearErrorMessage: true,
    );

    try {
      final page = await ref.read(getTransactionsPageUseCaseProvider)(
        businessId: businessId,
        startDate: startDate,
        endDate: endDate,
      );

      state = TransactionListState(
        items: page.items,
        nextCursor: page.nextCursor,
        hasMore: page.hasMore,
      );
    } catch (_) {
      state = TransactionListState(
        errorMessage: 'Gagal memuat transaksi. Coba lagi.',
      );
    }
  }

  Future<void> refresh() async {
    final businessId = _businessId;
    final startDate = _startDate;
    final endDate = _endDate;

    if (businessId == null || startDate == null || endDate == null) {
      return;
    }

    await loadInitial(
      businessId: businessId,
      startDate: startDate,
      endDate: endDate,
    );
  }

  Future<void> loadMore() async {
    final businessId = _businessId;
    final startDate = _startDate;
    final endDate = _endDate;
    final cursor = state.nextCursor;

    if (!state.canLoadMore ||
        businessId == null ||
        startDate == null ||
        endDate == null ||
        cursor == null) {
      return;
    }

    final currentItems = state.items;

    state = state.copyWith(isLoadingMore: true, clearErrorMessage: true);

    try {
      final page = await ref.read(getTransactionsPageUseCaseProvider)(
        businessId: businessId,
        startDate: startDate,
        endDate: endDate,
        cursor: cursor,
      );

      state = TransactionListState(
        items: [...currentItems, ...page.items],
        nextCursor: page.nextCursor,
        hasMore: page.hasMore,
      );
    } catch (_) {
      state = state.copyWith(
        isLoadingMore: false,
        errorMessage: 'Gagal memuat transaksi berikutnya. Coba lagi.',
      );
    }
  }
}
