import 'package:flutter_test/flutter_test.dart';
import 'package:kasentra/features/transaction/domain/entities/transaction_page.dart';
import 'package:kasentra/features/transaction/presentation/state/transaction_list_state.dart';

void main() {
  group('TransactionListState', () {
    test('has safe initial values', () {
      final state = TransactionListState();

      expect(state.items, isEmpty);
      expect(state.nextCursor, isNull);
      expect(state.hasMore, isFalse);
      expect(state.isInitialLoading, isFalse);
      expect(state.isLoadingMore, isFalse);
      expect(state.errorMessage, isNull);
      expect(state.hasError, isFalse);
      expect(state.canLoadMore, isFalse);
      expect(state.isEmpty, isTrue);
    });

    test('exposes an unmodifiable item list', () {
      final state = TransactionListState();

      expect(() => state.items.clear(), throwsUnsupportedError);
    });

    test('copyWith updates values and preserves unchanged values', () {
      final cursor = TransactionCursor(
        transactionDate: DateTime.utc(2025, 1, 10),
        transactionId: 'transaction-10',
      );

      final initialState = TransactionListState(
        nextCursor: cursor,
        hasMore: true,
        errorMessage: 'Gagal memuat transaksi.',
      );

      final updatedState = initialState.copyWith(
        isLoadingMore: true,
        clearErrorMessage: true,
      );

      expect(updatedState.nextCursor, same(cursor));
      expect(updatedState.hasMore, isTrue);
      expect(updatedState.isLoadingMore, isTrue);
      expect(updatedState.errorMessage, isNull);
      expect(updatedState.hasError, isFalse);
      expect(updatedState.canLoadMore, isFalse);
    });

    test('can clear pagination cursor', () {
      final cursor = TransactionCursor(
        transactionDate: DateTime.utc(2025, 1, 10),
        transactionId: 'transaction-10',
      );

      final initialState = TransactionListState(
        nextCursor: cursor,
        hasMore: true,
      );

      final updatedState = initialState.copyWith(
        clearNextCursor: true,
        hasMore: false,
      );

      expect(updatedState.nextCursor, isNull);
      expect(updatedState.hasMore, isFalse);
      expect(updatedState.canLoadMore, isFalse);
    });

    test('rejects simultaneous initial and pagination loading', () {
      expect(
        () => TransactionListState(isInitialLoading: true, isLoadingMore: true),
        throwsAssertionError,
      );
    });

    test('requires cursor when more pages are available', () {
      expect(() => TransactionListState(hasMore: true), throwsAssertionError);
    });
  });
}
