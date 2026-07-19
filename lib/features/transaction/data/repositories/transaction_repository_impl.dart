import '../../domain/entities/transaction.dart';
import '../../domain/entities/transaction_item.dart';
import '../../domain/entities/transaction_page.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../datasources/local_transaction_data_source.dart';
import '../mappers/transaction_item_mapper.dart';
import '../mappers/transaction_mapper.dart';

final class TransactionRepositoryImpl implements TransactionRepository {
  const TransactionRepositoryImpl(this._localDataSource);

  final LocalTransactionDataSource _localDataSource;

  @override
  Future<TransactionPage> getTransactionsPage({
    required String businessId,
    DateTime? startDate,
    DateTime? endDate,
    TransactionType? type,
    required int limit,
    TransactionCursor? cursor,
  }) async {
    final rows = await _localDataSource.getTransactionsPage(
      businessId: businessId,
      startDate: startDate,
      endDate: endDate,
      type: type?.name,

      // Ambil satu row tambahan untuk mengetahui apakah masih ada halaman.
      fetchLimit: limit + 1,
      cursorDate: cursor?.transactionDate,
      cursorId: cursor?.transactionId,
    );

    final hasMore = rows.length > limit;
    final visibleRows = hasMore ? rows.take(limit) : rows;

    final items = visibleRows
        .map(TransactionMapper.toDomain)
        .toList(growable: false);

    final nextCursor = hasMore && items.isNotEmpty
        ? TransactionCursor(
            transactionDate: items.last.transactionDate,
            transactionId: items.last.id,
          )
        : null;

    return TransactionPage(
      items: items,
      hasMore: hasMore,
      nextCursor: nextCursor,
    );
  }

  @override
  Future<Transaction?> getTransactionById({
    required String businessId,
    required String transactionId,
  }) async {
    final row = await _localDataSource.getTransactionById(
      businessId: businessId,
      transactionId: transactionId,
    );

    if (row == null) {
      return null;
    }

    return TransactionMapper.toDomain(row);
  }

  @override
  Stream<List<TransactionItem>> watchTransactionItems({
    required String transactionId,
  }) {
    return _localDataSource
        .watchTransactionItems(transactionId: transactionId)
        .map(
          (rows) => List<TransactionItem>.unmodifiable(
            rows.map(TransactionItemMapper.toDomain),
          ),
        );
  }

  @override
  Future<void> saveExpense(Transaction expense) {
    if (!expense.isExpense) {
      throw ArgumentError(
        'TransactionRepository.saveExpense hanya menerima pengeluaran.',
      );
    }

    return _localDataSource.saveExpense(TransactionMapper.toCompanion(expense));
  }

  @override
  Future<void> updatePaymentStatus({
    required String businessId,
    required String transactionId,
    required PaymentStatus paymentStatus,
    required DateTime updatedAt,
  }) async {
    final affectedRows = await _localDataSource.updatePaymentStatus(
      businessId: businessId,
      transactionId: transactionId,
      paymentStatus: paymentStatus.name,
      updatedAt: updatedAt,
    );

    if (affectedRows == 0) {
      throw StateError(
        'Transaksi tidak ditemukan atau bukan milik usaha aktif.',
      );
    }
  }

  @override
  Future<void> deleteTransaction({
    required String businessId,
    required String transactionId,
  }) async {
    final affectedRows = await _localDataSource.deleteTransaction(
      businessId: businessId,
      transactionId: transactionId,
    );

    if (affectedRows == 0) {
      throw StateError(
        'Transaksi tidak ditemukan atau bukan milik usaha aktif.',
      );
    }
  }
}
