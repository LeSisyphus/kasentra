import 'package:kasentra/features/debt/domain/entities/debt.dart';

abstract class DebtRepository {
  Stream<List<Debt>> watchDebts({
    required String businessId,
    DebtType? type,
    DebtStatus? status,
  });

  Future<Debt?> getDebtById({
    required String businessId,
    required String debtId,
  });

  Future<void> saveDebt(Debt debt);

  Future<void> markDebtAsPaid({
    required String businessId,
    required String debtId,
    required DateTime paidAt,
    required DateTime updatedAt,
  });

  Future<void> markDebtAsUnpaid({
    required String businessId,
    required String debtId,
    required DateTime updatedAt,
  });

  Future<void> deleteDebt({required String businessId, required String debtId});

  Future<Debt?> getDebtBySourceTransactionId({
    required String businessId,
    required String sourceTransactionId,
  });
}
