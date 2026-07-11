import 'package:kasentra/features/transaction/domain/repositories/transaction_repository.dart';

class DeleteTransactionUseCase {
  const DeleteTransactionUseCase(this._repository);

  final TransactionRepository _repository;

  Future<void> call({
    required String businessId,
    required String transactionId,
  }) {
    if (businessId.trim().isEmpty) {
      throw ArgumentError('Business id tidak boleh kosong.');
    }

    if (transactionId.trim().isEmpty) {
      throw ArgumentError('Transaction id tidak boleh kosong.');
    }

    return _repository.deleteTransaction(
      businessId: businessId,
      transactionId: transactionId,
    );
  }
}
