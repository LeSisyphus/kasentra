import '../../domain/entities/transaction.dart';
import '../../domain/entities/transaction_page.dart';

class TransactionListState {
  TransactionListState({
    List<Transaction> items = const [],
    this.nextCursor,
    this.hasMore = false,
    this.isInitialLoading = false,
    this.isLoadingMore = false,
    this.errorMessage,
  }) : assert(
         !(isInitialLoading && isLoadingMore),
         'Initial loading dan loading more tidak boleh aktif bersamaan.',
       ),
       assert(
         !hasMore || nextCursor != null,
         'nextCursor wajib tersedia ketika hasMore bernilai true.',
       ),
       items = List.unmodifiable(items);

  final List<Transaction> items;
  final TransactionCursor? nextCursor;
  final bool hasMore;
  final bool isInitialLoading;
  final bool isLoadingMore;
  final String? errorMessage;

  bool get canLoadMore {
    return hasMore && nextCursor != null && !isInitialLoading && !isLoadingMore;
  }

  bool get hasError => errorMessage != null;

  bool get isEmpty => items.isEmpty && !isInitialLoading;

  TransactionListState copyWith({
    List<Transaction>? items,
    TransactionCursor? nextCursor,
    bool clearNextCursor = false,
    bool? hasMore,
    bool? isInitialLoading,
    bool? isLoadingMore,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return TransactionListState(
      items: items ?? this.items,
      nextCursor: clearNextCursor ? null : nextCursor ?? this.nextCursor,
      hasMore: hasMore ?? this.hasMore,
      isInitialLoading: isInitialLoading ?? this.isInitialLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      errorMessage: clearErrorMessage
          ? null
          : errorMessage ?? this.errorMessage,
    );
  }
}
