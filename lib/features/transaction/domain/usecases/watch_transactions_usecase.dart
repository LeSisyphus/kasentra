import 'package:kasentra/features/transaction/domain/entities/transaction.dart';
import 'package:kasentra/features/transaction/domain/repositories/transaction_repository.dart';

class WatchTransactionsUseCase {
  const WatchTransactionsUseCase(this._repository);

  final TransactionRepository _repository;

  Stream<List<Transaction>> call({
    required String businessId,
    DateTime? startDate,
    DateTime? endDate,
    TransactionType? type,
  }) {
    if (businessId.trim().isEmpty) {
      throw ArgumentError('Business id tidak boleh kosong.');
    }

    if (startDate != null && endDate != null && startDate.isAfter(endDate)) {
      throw ArgumentError('Tanggal mulai tidak boleh setelah tanggal selesai.');
    }

    return _repository.watchTransactions(
      businessId: businessId,
      startDate: startDate,
      endDate: endDate,
      type: type,
    );
  }
}
