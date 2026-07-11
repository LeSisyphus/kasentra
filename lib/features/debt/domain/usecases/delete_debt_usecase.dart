import 'package:kasentra/features/debt/domain/repositories/debt_repository.dart';

class DeleteDebtUseCase {
  const DeleteDebtUseCase(this._repository);

  final DebtRepository _repository;

  Future<void> call({required String businessId, required String debtId}) {
    if (businessId.trim().isEmpty) {
      throw ArgumentError('Business id tidak boleh kosong.');
    }

    if (debtId.trim().isEmpty) {
      throw ArgumentError('Debt id tidak boleh kosong.');
    }

    return _repository.deleteDebt(businessId: businessId, debtId: debtId);
  }
}
