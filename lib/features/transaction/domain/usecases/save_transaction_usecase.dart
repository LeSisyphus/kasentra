import 'package:kasentra/features/transaction/domain/entities/transaction.dart';
import 'package:kasentra/features/transaction/domain/entities/transaction_item.dart';
import 'package:kasentra/features/transaction/domain/repositories/transaction_repository.dart';

class SaveTransactionUseCase {
  const SaveTransactionUseCase(this._repository);

  final TransactionRepository _repository;

  Future<void> call({
    required Transaction transaction,
    required List<TransactionItem> items,
  }) {
    _validateTransaction(transaction);

    if (transaction.isSale) {
      _validateSale(transaction: transaction, items: items);
    } else {
      _validateExpense(transaction: transaction, items: items);
    }

    return _repository.saveTransaction(transaction: transaction, items: items);
  }

  void _validateTransaction(Transaction transaction) {
    if (transaction.id.trim().isEmpty) {
      throw ArgumentError('Transaction id tidak boleh kosong.');
    }

    if (transaction.businessId.trim().isEmpty) {
      throw ArgumentError('Business id tidak boleh kosong.');
    }

    if (transaction.totalAmount <= 0) {
      throw ArgumentError('Total transaksi harus lebih dari 0.');
    }

    if (transaction.costAmount < 0) {
      throw ArgumentError('Total modal tidak boleh negatif.');
    }

    if (transaction.updatedAt.isBefore(transaction.createdAt)) {
      throw ArgumentError(
        'Waktu pembaruan tidak boleh sebelum waktu pembuatan.',
      );
    }
  }

  void _validateSale({
    required Transaction transaction,
    required List<TransactionItem> items,
  }) {
    if (items.isEmpty) {
      throw ArgumentError(
        'Transaksi penjualan harus memiliki minimal satu item.',
      );
    }

    if (transaction.isUnpaid &&
        (transaction.contactName == null ||
            transaction.contactName!.trim().isEmpty)) {
      throw ArgumentError(
        'Nama pelanggan wajib diisi untuk transaksi belum lunas.',
      );
    }

    for (final item in items) {
      _validateSaleItem(transactionId: transaction.id, item: item);
    }

    final calculatedTotal = items.fold<int>(
      0,
      (total, item) => total + item.subtotal,
    );

    final calculatedCost = items.fold<int>(
      0,
      (total, item) => total + item.totalCost,
    );

    final calculatedProfit = calculatedTotal - calculatedCost;

    if (transaction.totalAmount != calculatedTotal) {
      throw ArgumentError(
        'Total transaksi tidak sesuai dengan subtotal seluruh item.',
      );
    }

    if (transaction.costAmount != calculatedCost) {
      throw ArgumentError(
        'Total modal tidak sesuai dengan modal seluruh item.',
      );
    }

    if (transaction.profitAmount != calculatedProfit) {
      throw ArgumentError(
        'Estimasi laba tidak sesuai dengan perhitungan item.',
      );
    }
  }

  void _validateSaleItem({
    required String transactionId,
    required TransactionItem item,
  }) {
    if (item.id.trim().isEmpty) {
      throw ArgumentError('Transaction item id tidak boleh kosong.');
    }

    if (item.transactionId != transactionId) {
      throw ArgumentError(
        'Transaction id pada item tidak sesuai dengan transaksi.',
      );
    }

    if (item.itemName.trim().isEmpty) {
      throw ArgumentError('Nama item tidak boleh kosong.');
    }

    if (item.quantity <= 0) {
      throw ArgumentError('Jumlah item harus lebih dari 0.');
    }

    if (item.sellingPrice < 0) {
      throw ArgumentError('Harga jual item tidak boleh negatif.');
    }

    if (item.costPrice < 0) {
      throw ArgumentError('Harga modal item tidak boleh negatif.');
    }

    final expectedSubtotal = item.quantity * item.sellingPrice;

    if (item.subtotal != expectedSubtotal) {
      throw ArgumentError(
        'Subtotal item harus sama dengan jumlah dikali harga jual.',
      );
    }
  }

  void _validateExpense({
    required Transaction transaction,
    required List<TransactionItem> items,
  }) {
    if (items.isNotEmpty) {
      throw ArgumentError(
        'Transaksi pengeluaran tidak menggunakan item penjualan.',
      );
    }

    final title = transaction.title?.trim();

    if (title == null || title.isEmpty) {
      throw ArgumentError('Nama pengeluaran wajib diisi.');
    }

    if (title.length > 100) {
      throw ArgumentError('Nama pengeluaran maksimal 100 karakter.');
    }

    final categoryId = transaction.categoryId?.trim();

    if (categoryId == null || categoryId.isEmpty) {
      throw ArgumentError('Kategori pengeluaran wajib dipilih.');
    }

    if (transaction.costAmount != 0) {
      throw ArgumentError('Cost amount pengeluaran harus bernilai 0.');
    }

    if (transaction.profitAmount != 0) {
      throw ArgumentError('Profit amount pengeluaran harus bernilai 0.');
    }

    if (transaction.isUnpaid) {
      throw ArgumentError(
        'Transaksi pengeluaran MVP harus dicatat sebagai lunas.',
      );
    }
  }
}
