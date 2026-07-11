import 'package:kasentra/features/debt/domain/entities/debt.dart';
import 'package:kasentra/features/debt/domain/repositories/debt_repository.dart';

class SaveDebtUseCase {
  const SaveDebtUseCase(this._repository);

  final DebtRepository _repository;

  Future<void> call(Debt debt) {
    _validateDebt(debt);
    return _repository.saveDebt(debt);
  }

  void _validateDebt(Debt debt) {
    if (debt.id.trim().isEmpty) {
      throw ArgumentError('Debt id tidak boleh kosong.');
    }

    if (debt.businessId.trim().isEmpty) {
      throw ArgumentError('Business id tidak boleh kosong.');
    }

    if (debt.contactName.trim().isEmpty) {
      throw ArgumentError('Nama kontak tidak boleh kosong.');
    }

    if (debt.amount <= 0) {
      throw ArgumentError('Nominal utang atau piutang harus lebih dari 0.');
    }

    if (debt.updatedAt.isBefore(debt.createdAt)) {
      throw ArgumentError(
        'Waktu pembaruan tidak boleh sebelum waktu pembuatan.',
      );
    }

    final sourceTransactionId = debt.sourceTransactionId;

    if (sourceTransactionId != null && sourceTransactionId.trim().isEmpty) {
      throw ArgumentError(
        'Source transaction id tidak boleh berupa teks kosong.',
      );
    }

    if (debt.isPayable && sourceTransactionId != null) {
      throw ArgumentError(
        'Source transaction hanya dapat digunakan untuk piutang.',
      );
    }

    if (debt.isPaid && debt.paidAt == null) {
      throw ArgumentError(
        'Utang atau piutang yang lunas harus memiliki tanggal pelunasan.',
      );
    }

    if (debt.isUnpaid && debt.paidAt != null) {
      throw ArgumentError(
        'Utang atau piutang belum lunas tidak boleh memiliki tanggal pelunasan.',
      );
    }

    if (debt.paidAt != null && debt.paidAt!.isAfter(debt.updatedAt)) {
      throw ArgumentError(
        'Tanggal pelunasan tidak boleh setelah waktu pembaruan.',
      );
    }
  }
}
