import 'package:kasentra/features/transaction/domain/entities/transaction.dart';
import 'package:kasentra/features/transaction/domain/entities/transaction_item.dart';

abstract class TransactionRepository {
  Stream<List<Transaction>> watchTransactions({
    required String businessId,
    DateTime? startDate,
    DateTime? endDate,
    TransactionType? type,
  });

  Future<Transaction?> getTransactionById({
    required String businessId,
    required String transactionId,
  });

  Stream<List<TransactionItem>> watchTransactionItems({
    required String transactionId,
  });

  /// Menyimpan transaksi pengeluaran.
  ///
  /// Penjualan tidak boleh disimpan melalui method ini.
  /// Penjualan harus menggunakan SaleRepository.recordSale()
  /// agar transaksi, item, stok, dan piutang diproses secara atomik.
  Future<void> saveExpense(Transaction expense);

  Future<void> updatePaymentStatus({
    required String businessId,
    required String transactionId,
    required PaymentStatus paymentStatus,
    required DateTime updatedAt,
  });

  Future<void> deleteTransaction({
    required String businessId,
    required String transactionId,
  });
}
