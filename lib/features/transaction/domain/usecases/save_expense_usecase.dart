import 'package:kasentra/features/transaction/domain/entities/transaction.dart';
import 'package:kasentra/features/transaction/domain/repositories/transaction_repository.dart';

class SaveExpenseUseCase {
  const SaveExpenseUseCase(this._repository);

  final TransactionRepository _repository;

  Future<void> call(Transaction expense) {
    _validateExpense(expense);
    return _repository.saveExpense(expense);
  }

  void _validateExpense(Transaction expense) {
    if (!expense.isExpense) {
      throw ArgumentError(
        'SaveExpenseUseCase hanya menerima transaksi pengeluaran.',
      );
    }

    if (expense.id.trim().isEmpty) {
      throw ArgumentError('Transaction id tidak boleh kosong.');
    }

    if (expense.businessId.trim().isEmpty) {
      throw ArgumentError('Business id tidak boleh kosong.');
    }

    final title = expense.title?.trim();

    if (title == null || title.isEmpty) {
      throw ArgumentError('Nama pengeluaran wajib diisi.');
    }

    if (title.length > 100) {
      throw ArgumentError('Nama pengeluaran maksimal 100 karakter.');
    }

    final categoryId = expense.categoryId?.trim();

    if (categoryId == null || categoryId.isEmpty) {
      throw ArgumentError('Kategori pengeluaran wajib dipilih.');
    }

    if (expense.totalAmount <= 0) {
      throw ArgumentError('Nominal pengeluaran harus lebih dari 0.');
    }

    if (expense.costAmount != 0) {
      throw ArgumentError('Cost amount pengeluaran harus bernilai 0.');
    }

    if (expense.profitAmount != 0) {
      throw ArgumentError('Profit amount pengeluaran harus bernilai 0.');
    }

    if (expense.isUnpaid) {
      throw ArgumentError('Pengeluaran harus dicatat sebagai lunas.');
    }

    if (expense.updatedAt.isBefore(expense.createdAt)) {
      throw ArgumentError(
        'Waktu pembaruan tidak boleh sebelum waktu pembuatan.',
      );
    }

    final note = expense.note;

    if (note != null && note.trim().isEmpty) {
      throw ArgumentError('Catatan harus diisi atau dikosongkan sepenuhnya.');
    }
  }
}
