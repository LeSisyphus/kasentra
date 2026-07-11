import 'package:kasentra/features/transaction/domain/entities/transaction_item.dart';
import 'package:kasentra/features/transaction/domain/repositories/transaction_repository.dart';

class WatchTransactionItemsUseCase {
  const WatchTransactionItemsUseCase(this._repository);

  final TransactionRepository _repository;

  Stream<List<TransactionItem>> call({required String transactionId}) {
    if (transactionId.trim().isEmpty) {
      throw ArgumentError('Transaction id tidak boleh kosong.');
    }

    return _repository.watchTransactionItems(transactionId: transactionId);
  }
}
