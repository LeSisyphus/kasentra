import 'package:kasentra/features/transaction/domain/entities/transaction.dart';
import 'package:kasentra/features/transaction/domain/entities/transaction_page.dart';
import 'package:kasentra/features/transaction/domain/repositories/transaction_repository.dart';

class GetTransactionsPageUseCase {
  const GetTransactionsPageUseCase(this._repository);

  static const int defaultPageSize = 20;
  static const int maximumPageSize = 100;

  final TransactionRepository _repository;

  Future<TransactionPage> call({
    required String businessId,
    DateTime? startDate,
    DateTime? endDate,
    TransactionType? type,
    int limit = defaultPageSize,
    TransactionCursor? cursor,
  }) {
    final normalizedBusinessId = businessId.trim();

    if (normalizedBusinessId.isEmpty) {
      throw ArgumentError('Business id tidak boleh kosong.');
    }

    if (limit <= 0) {
      throw ArgumentError('Jumlah transaksi per halaman harus lebih dari 0.');
    }

    if (limit > maximumPageSize) {
      throw ArgumentError(
        'Jumlah transaksi per halaman maksimal $maximumPageSize.',
      );
    }

    if (startDate != null && endDate != null && startDate.isAfter(endDate)) {
      throw ArgumentError('Tanggal mulai tidak boleh setelah tanggal selesai.');
    }

    final cursorTransactionId = cursor?.transactionId.trim();

    if (cursor != null &&
        (cursorTransactionId == null || cursorTransactionId.isEmpty)) {
      throw ArgumentError('Transaction id pada cursor tidak boleh kosong.');
    }

    return _repository.getTransactionsPage(
      businessId: normalizedBusinessId,
      startDate: startDate,
      endDate: endDate,
      type: type,
      limit: limit,
      cursor: cursor,
    );
  }
}
