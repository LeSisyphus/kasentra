import 'package:kasentra/features/debt/domain/repositories/debt_repository.dart';

class MarkDebtAsUnpaidUseCase {
  const MarkDebtAsUnpaidUseCase(this._repository);

  final DebtRepository _repository;

  Future<void> call({
    required String businessId,
    required String debtId,
    required DateTime updatedAt,
  }) {
    if (businessId.trim().isEmpty) {
      throw ArgumentError('Business id tidak boleh kosong.');
    }

    if (debtId.trim().isEmpty) {
      throw ArgumentError('Debt id tidak boleh kosong.');
    }

    return _repository.markDebtAsUnpaid(
      businessId: businessId,
      debtId: debtId,
      updatedAt: updatedAt,
    );
  }
}
