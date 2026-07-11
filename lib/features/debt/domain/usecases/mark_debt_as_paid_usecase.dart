import 'package:kasentra/features/debt/domain/repositories/debt_repository.dart';

class MarkDebtAsPaidUseCase {
  const MarkDebtAsPaidUseCase(this._repository);

  final DebtRepository _repository;

  Future<void> call({
    required String businessId,
    required String debtId,
    required DateTime paidAt,
    required DateTime updatedAt,
  }) {
    if (businessId.trim().isEmpty) {
      throw ArgumentError('Business id tidak boleh kosong.');
    }

    if (debtId.trim().isEmpty) {
      throw ArgumentError('Debt id tidak boleh kosong.');
    }

    if (paidAt.isAfter(updatedAt)) {
      throw ArgumentError(
        'Tanggal pelunasan tidak boleh setelah waktu pembaruan.',
      );
    }

    return _repository.markDebtAsPaid(
      businessId: businessId,
      debtId: debtId,
      paidAt: paidAt,
      updatedAt: updatedAt,
    );
  }
}
