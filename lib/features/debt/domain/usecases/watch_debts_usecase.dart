import 'package:kasentra/features/debt/domain/entities/debt.dart';
import 'package:kasentra/features/debt/domain/repositories/debt_repository.dart';

class WatchDebtsUseCase {
  const WatchDebtsUseCase(this._repository);

  final DebtRepository _repository;

  Stream<List<Debt>> call({
    required String businessId,
    DebtType? type,
    DebtStatus? status,
  }) {
    if (businessId.trim().isEmpty) {
      throw ArgumentError('Business id tidak boleh kosong.');
    }

    return _repository.watchDebts(
      businessId: businessId,
      type: type,
      status: status,
    );
  }
}
