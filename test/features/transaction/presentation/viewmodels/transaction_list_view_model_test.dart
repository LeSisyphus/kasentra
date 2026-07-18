import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kasentra/app/providers/transaction_providers.dart';
import 'package:kasentra/features/transaction/domain/entities/transaction_page.dart';
import 'package:kasentra/features/transaction/domain/repositories/transaction_repository.dart';
import 'package:kasentra/features/transaction/presentation/viewmodels/transaction_list_view_model.dart';

void main() {
  group('TransactionListViewModel', () {
    final startDate = DateTime.utc(2025, 1, 1);
    final endDate = DateTime.utc(2025, 1, 31);

    ProviderContainer createContainer(
      _ControlledTransactionRepository repository,
    ) {
      return ProviderContainer.test(
        overrides: [
          transactionRepositoryProvider.overrideWithValue(repository),
        ],
      );
    }

    test('starts with a safe initial state', () {
      final repository = _ControlledTransactionRepository();
      final container = createContainer(repository);

      final state = container.read(transactionListViewModelProvider);

      expect(state.items, isEmpty);
      expect(state.isInitialLoading, isFalse);
      expect(state.isLoadingMore, isFalse);
      expect(state.hasMore, isFalse);
      expect(state.nextCursor, isNull);
      expect(state.errorMessage, isNull);
    });

    test('emits loading then empty success state', () async {
      final repository = _ControlledTransactionRepository();
      final container = createContainer(repository);

      final viewModel = container.read(
        transactionListViewModelProvider.notifier,
      );

      final loadFuture = viewModel.loadInitial(
        businessId: 'business-1',
        startDate: startDate,
        endDate: endDate,
      );

      final loadingState = container.read(transactionListViewModelProvider);

      expect(repository.requests, hasLength(1));
      expect(loadingState.isInitialLoading, isTrue);
      expect(loadingState.items, isEmpty);
      expect(loadingState.errorMessage, isNull);

      repository.complete(0, TransactionPage(items: const [], hasMore: false));

      await loadFuture;

      final successState = container.read(transactionListViewModelProvider);

      expect(successState.isInitialLoading, isFalse);
      expect(successState.items, isEmpty);
      expect(successState.hasMore, isFalse);
      expect(successState.nextCursor, isNull);
      expect(successState.errorMessage, isNull);
      expect(successState.isEmpty, isTrue);
    });

    test('stores pagination metadata from initial response', () async {
      final repository = _ControlledTransactionRepository();
      final container = createContainer(repository);

      final cursor = TransactionCursor(
        transactionDate: DateTime.utc(2025, 1, 20),
        transactionId: 'transaction-20',
      );

      final viewModel = container.read(
        transactionListViewModelProvider.notifier,
      );

      final loadFuture = viewModel.loadInitial(
        businessId: 'business-1',
        startDate: startDate,
        endDate: endDate,
      );

      repository.complete(
        0,
        TransactionPage(items: const [], nextCursor: cursor, hasMore: true),
      );

      await loadFuture;

      final state = container.read(transactionListViewModelProvider);

      expect(state.isInitialLoading, isFalse);
      expect(state.nextCursor, same(cursor));
      expect(state.hasMore, isTrue);
      expect(state.canLoadMore, isTrue);
      expect(state.errorMessage, isNull);
    });

    test('stores a user-friendly error when initial load fails', () async {
      final repository = _ControlledTransactionRepository();
      final container = createContainer(repository);

      final viewModel = container.read(
        transactionListViewModelProvider.notifier,
      );

      final loadFuture = viewModel.loadInitial(
        businessId: 'business-1',
        startDate: startDate,
        endDate: endDate,
      );

      repository.fail(0, StateError('Database unavailable'));

      await loadFuture;

      final state = container.read(transactionListViewModelProvider);

      expect(state.isInitialLoading, isFalse);
      expect(state.isLoadingMore, isFalse);
      expect(state.items, isEmpty);
      expect(state.hasMore, isFalse);
      expect(state.nextCursor, isNull);
      expect(state.errorMessage, 'Gagal memuat transaksi. Coba lagi.');
      expect(state.hasError, isTrue);
    });
    test('ignores refresh before an initial query is configured', () async {
      final repository = _ControlledTransactionRepository();
      final container = createContainer(repository);

      final viewModel = container.read(
        transactionListViewModelProvider.notifier,
      );

      await viewModel.refresh();

      expect(repository.requests, isEmpty);

      final state = container.read(transactionListViewModelProvider);

      expect(state.isInitialLoading, isFalse);
      expect(state.items, isEmpty);
      expect(state.errorMessage, isNull);
    });
    test('refreshes the first page using the active filters', () async {
      final repository = _ControlledTransactionRepository();
      final container = createContainer(repository);

      final firstCursor = TransactionCursor(
        transactionDate: DateTime.utc(2025, 1, 20),
        transactionId: 'transaction-20',
      );

      final refreshedCursor = TransactionCursor(
        transactionDate: DateTime.utc(2025, 1, 25),
        transactionId: 'transaction-25',
      );

      final viewModel = container.read(
        transactionListViewModelProvider.notifier,
      );

      final initialFuture = viewModel.loadInitial(
        businessId: 'business-1',
        startDate: startDate,
        endDate: endDate,
      );

      repository.complete(
        0,
        TransactionPage(
          items: const [],
          nextCursor: firstCursor,
          hasMore: true,
        ),
      );

      await initialFuture;

      final refreshFuture = viewModel.refresh();

      expect(repository.requests, hasLength(2));

      final refreshRequest = repository.requests[1];

      expect(refreshRequest.businessId, 'business-1');
      expect(refreshRequest.startDate, startDate);
      expect(refreshRequest.endDate, endDate);
      expect(refreshRequest.cursor, isNull);

      final loadingState = container.read(transactionListViewModelProvider);

      expect(loadingState.isInitialLoading, isTrue);
      expect(loadingState.isLoadingMore, isFalse);
      expect(loadingState.nextCursor, isNull);
      expect(loadingState.hasMore, isFalse);
      expect(loadingState.errorMessage, isNull);

      repository.complete(
        1,
        TransactionPage(
          items: const [],
          nextCursor: refreshedCursor,
          hasMore: true,
        ),
      );

      await refreshFuture;

      final refreshedState = container.read(transactionListViewModelProvider);

      expect(refreshedState.isInitialLoading, isFalse);
      expect(refreshedState.isLoadingMore, isFalse);
      expect(refreshedState.nextCursor, same(refreshedCursor));
      expect(refreshedState.hasMore, isTrue);
      expect(refreshedState.canLoadMore, isTrue);
      expect(refreshedState.errorMessage, isNull);
    });
    test('ignores duplicate refresh requests', () async {
      final repository = _ControlledTransactionRepository();
      final container = createContainer(repository);

      final viewModel = container.read(
        transactionListViewModelProvider.notifier,
      );

      final initialFuture = viewModel.loadInitial(
        businessId: 'business-1',
        startDate: startDate,
        endDate: endDate,
      );

      repository.complete(0, TransactionPage(items: const [], hasMore: false));

      await initialFuture;

      final firstRefreshFuture = viewModel.refresh();
      final duplicateRefreshFuture = viewModel.refresh();

      await duplicateRefreshFuture;

      expect(repository.requests, hasLength(2));

      repository.complete(1, TransactionPage(items: const [], hasMore: false));

      await firstRefreshFuture;

      expect(repository.requests, hasLength(2));
    });
    test('loads the next page using the active cursor and filters', () async {
      final repository = _ControlledTransactionRepository();
      final container = createContainer(repository);

      final firstCursor = TransactionCursor(
        transactionDate: DateTime.utc(2025, 1, 20),
        transactionId: 'transaction-20',
      );

      final viewModel = container.read(
        transactionListViewModelProvider.notifier,
      );

      final initialFuture = viewModel.loadInitial(
        businessId: 'business-1',
        startDate: startDate,
        endDate: endDate,
      );

      repository.complete(
        0,
        TransactionPage(
          items: const [],
          nextCursor: firstCursor,
          hasMore: true,
        ),
      );

      await initialFuture;

      final loadMoreFuture = viewModel.loadMore();

      expect(repository.requests, hasLength(2));

      final paginationRequest = repository.requests[1];

      expect(paginationRequest.businessId, 'business-1');
      expect(paginationRequest.startDate, startDate);
      expect(paginationRequest.endDate, endDate);
      expect(paginationRequest.cursor, same(firstCursor));

      final loadingState = container.read(transactionListViewModelProvider);

      expect(loadingState.isInitialLoading, isFalse);
      expect(loadingState.isLoadingMore, isTrue);
      expect(loadingState.hasMore, isTrue);
      expect(loadingState.nextCursor, same(firstCursor));

      repository.complete(1, TransactionPage(items: const [], hasMore: false));

      await loadMoreFuture;

      final successState = container.read(transactionListViewModelProvider);

      expect(successState.isInitialLoading, isFalse);
      expect(successState.isLoadingMore, isFalse);
      expect(successState.hasMore, isFalse);
      expect(successState.nextCursor, isNull);
      expect(successState.errorMessage, isNull);
    });

    test('ignores duplicate load more requests', () async {
      final repository = _ControlledTransactionRepository();
      final container = createContainer(repository);

      final cursor = TransactionCursor(
        transactionDate: DateTime.utc(2025, 1, 20),
        transactionId: 'transaction-20',
      );

      final viewModel = container.read(
        transactionListViewModelProvider.notifier,
      );

      final initialFuture = viewModel.loadInitial(
        businessId: 'business-1',
        startDate: startDate,
        endDate: endDate,
      );

      repository.complete(
        0,
        TransactionPage(items: const [], nextCursor: cursor, hasMore: true),
      );

      await initialFuture;

      final firstLoadMoreFuture = viewModel.loadMore();
      final duplicateLoadMoreFuture = viewModel.loadMore();

      await duplicateLoadMoreFuture;

      expect(repository.requests, hasLength(2));

      repository.complete(1, TransactionPage(items: const [], hasMore: false));

      await firstLoadMoreFuture;

      expect(repository.requests, hasLength(2));
    });

    test('preserves pagination state when load more fails', () async {
      final repository = _ControlledTransactionRepository();
      final container = createContainer(repository);

      final cursor = TransactionCursor(
        transactionDate: DateTime.utc(2025, 1, 20),
        transactionId: 'transaction-20',
      );

      final viewModel = container.read(
        transactionListViewModelProvider.notifier,
      );

      final initialFuture = viewModel.loadInitial(
        businessId: 'business-1',
        startDate: startDate,
        endDate: endDate,
      );

      repository.complete(
        0,
        TransactionPage(items: const [], nextCursor: cursor, hasMore: true),
      );

      await initialFuture;

      final loadMoreFuture = viewModel.loadMore();

      repository.fail(1, StateError('Pagination failed'));

      await loadMoreFuture;

      final state = container.read(transactionListViewModelProvider);

      expect(state.isLoadingMore, isFalse);
      expect(state.hasMore, isTrue);
      expect(state.nextCursor, same(cursor));
      expect(state.canLoadMore, isTrue);
      expect(
        state.errorMessage,
        'Gagal memuat transaksi berikutnya. Coba lagi.',
      );
    });

    test('does not request another page when hasMore is false', () async {
      final repository = _ControlledTransactionRepository();
      final container = createContainer(repository);

      final viewModel = container.read(
        transactionListViewModelProvider.notifier,
      );

      final initialFuture = viewModel.loadInitial(
        businessId: 'business-1',
        startDate: startDate,
        endDate: endDate,
      );

      repository.complete(0, TransactionPage(items: const [], hasMore: false));

      await initialFuture;
      await viewModel.loadMore();

      expect(repository.requests, hasLength(1));
    });
  });
}

class _ControlledTransactionRepository implements TransactionRepository {
  final List<_PendingRequest> requests = [];

  void complete(int requestIndex, TransactionPage page) {
    requests[requestIndex].completer.complete(page);
  }

  void fail(int requestIndex, Object error) {
    requests[requestIndex].completer.completeError(error, StackTrace.current);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) {
    if (invocation.memberName == #getTransactionsPage) {
      final request = _PendingRequest(
        businessId: invocation.namedArguments[#businessId] as String,
        startDate: invocation.namedArguments[#startDate] as DateTime,
        endDate: invocation.namedArguments[#endDate] as DateTime,
        cursor: invocation.namedArguments[#cursor] as TransactionCursor?,
        completer: Completer<TransactionPage>(),
      );

      requests.add(request);

      return request.completer.future;
    }

    return super.noSuchMethod(invocation);
  }
}

class _PendingRequest {
  const _PendingRequest({
    required this.businessId,
    required this.startDate,
    required this.endDate,
    required this.cursor,
    required this.completer,
  });

  final String businessId;
  final DateTime startDate;
  final DateTime endDate;
  final TransactionCursor? cursor;
  final Completer<TransactionPage> completer;
}
