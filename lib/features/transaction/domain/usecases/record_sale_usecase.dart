import 'package:kasentra/features/transaction/domain/entities/sale.dart';
import 'package:kasentra/features/transaction/domain/entities/transaction_item.dart';
import 'package:kasentra/features/transaction/domain/repositories/sale_repository.dart';

class RecordSaleUseCase {
  const RecordSaleUseCase(this._repository);

  final SaleRepository _repository;

  Future<void> call(Sale sale) {
    _validateSale(sale);
    return _repository.recordSale(sale);
  }

  void _validateSale(Sale sale) {
    final transaction = sale.transaction;

    if (!transaction.isSale) {
      throw ArgumentError(
        'RecordSaleUseCase hanya menerima transaksi penjualan.',
      );
    }

    if (transaction.id.trim().isEmpty) {
      throw ArgumentError('Transaction id tidak boleh kosong.');
    }

    if (transaction.businessId.trim().isEmpty) {
      throw ArgumentError('Business id tidak boleh kosong.');
    }

    if (transaction.totalAmount <= 0) {
      throw ArgumentError('Total penjualan harus lebih dari 0.');
    }

    if (transaction.costAmount < 0) {
      throw ArgumentError('Total modal penjualan tidak boleh negatif.');
    }

    if (transaction.updatedAt.isBefore(transaction.createdAt)) {
      throw ArgumentError(
        'Waktu pembaruan tidak boleh sebelum waktu pembuatan.',
      );
    }

    if (sale.items.isEmpty) {
      throw ArgumentError('Penjualan harus memiliki minimal satu item.');
    }

    if (transaction.isUnpaid) {
      final contactName = transaction.contactName?.trim();

      if (contactName == null || contactName.isEmpty) {
        throw ArgumentError(
          'Nama pelanggan wajib diisi untuk penjualan belum lunas.',
        );
      }
    }

    final itemIds = <String>{};

    for (final item in sale.items) {
      _validateItem(transactionId: transaction.id, item: item);

      if (!itemIds.add(item.id)) {
        throw ArgumentError('Transaction item id tidak boleh duplikat.');
      }
    }

    if (transaction.totalAmount != sale.calculatedTotal) {
      throw ArgumentError(
        'Total penjualan tidak sesuai dengan subtotal seluruh item.',
      );
    }

    if (transaction.costAmount != sale.calculatedCost) {
      throw ArgumentError(
        'Total modal tidak sesuai dengan modal seluruh item.',
      );
    }

    if (transaction.profitAmount != sale.calculatedProfit) {
      throw ArgumentError(
        'Laba penjualan tidak sesuai dengan perhitungan item.',
      );
    }
  }

  void _validateItem({
    required String transactionId,
    required TransactionItem item,
  }) {
    if (item.id.trim().isEmpty) {
      throw ArgumentError('Transaction item id tidak boleh kosong.');
    }

    if (item.transactionId != transactionId) {
      throw ArgumentError(
        'Transaction id pada item tidak sesuai dengan penjualan.',
      );
    }

    final productId = item.productId;

    if (productId != null && productId.trim().isEmpty) {
      throw ArgumentError(
        'Product id harus diisi atau dikosongkan sepenuhnya.',
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
}
