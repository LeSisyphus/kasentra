import 'package:kasentra/features/debt/domain/entities/debt.dart';
import 'package:kasentra/features/debt/domain/repositories/debt_repository.dart';

class GetDebtBySourceTransactionIdUseCase {
  const GetDebtBySourceTransactionIdUseCase(this._repository);

  final DebtRepository _repository;

  Future<Debt?> call({
    required String businessId,
    required String sourceTransactionId,
  }) {
    if (businessId.trim().isEmpty) {
      throw ArgumentError('Business id tidak boleh kosong.');
    }

    if (sourceTransactionId.trim().isEmpty) {
      throw ArgumentError('Source transaction id tidak boleh kosong.');
    }

    return _repository.getDebtBySourceTransactionId(
      businessId: businessId,
      sourceTransactionId: sourceTransactionId,
    );
  }
}
