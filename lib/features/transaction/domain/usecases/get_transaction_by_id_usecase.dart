import 'package:kasentra/features/transaction/domain/entities/transaction.dart';
import 'package:kasentra/features/transaction/domain/repositories/transaction_repository.dart';

class GetTransactionByIdUseCase {
  const GetTransactionByIdUseCase(this._repository);

  final TransactionRepository _repository;

  Future<Transaction?> call({
    required String businessId,
    required String transactionId,
  }) {
    if (businessId.trim().isEmpty) {
      throw ArgumentError('Business id tidak boleh kosong.');
    }

    if (transactionId.trim().isEmpty) {
      throw ArgumentError('Transaction id tidak boleh kosong.');
    }

    return _repository.getTransactionById(
      businessId: businessId,
      transactionId: transactionId,
    );
  }
}
