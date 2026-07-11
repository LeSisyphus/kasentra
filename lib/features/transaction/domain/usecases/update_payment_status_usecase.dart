import 'package:kasentra/features/transaction/domain/entities/transaction.dart';
import 'package:kasentra/features/transaction/domain/repositories/transaction_repository.dart';

class UpdatePaymentStatusUseCase {
  const UpdatePaymentStatusUseCase(this._repository);

  final TransactionRepository _repository;

  Future<void> call({
    required String businessId,
    required String transactionId,
    required PaymentStatus paymentStatus,
    required DateTime updatedAt,
  }) {
    if (businessId.trim().isEmpty) {
      throw ArgumentError('Business id tidak boleh kosong.');
    }

    if (transactionId.trim().isEmpty) {
      throw ArgumentError('Transaction id tidak boleh kosong.');
    }

    return _repository.updatePaymentStatus(
      businessId: businessId,
      transactionId: transactionId,
      paymentStatus: paymentStatus,
      updatedAt: updatedAt,
    );
  }
}
