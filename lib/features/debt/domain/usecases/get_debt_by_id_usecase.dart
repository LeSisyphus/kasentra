import 'package:kasentra/features/debt/domain/entities/debt.dart';
import 'package:kasentra/features/debt/domain/repositories/debt_repository.dart';

class GetDebtByIdUseCase {
  const GetDebtByIdUseCase(this._repository);

  final DebtRepository _repository;

  Future<Debt?> call({required String businessId, required String debtId}) {
    if (businessId.trim().isEmpty) {
      throw ArgumentError('Business id tidak boleh kosong.');
    }

    if (debtId.trim().isEmpty) {
      throw ArgumentError('Debt id tidak boleh kosong.');
    }

    return _repository.getDebtById(businessId: businessId, debtId: debtId);
  }
}
