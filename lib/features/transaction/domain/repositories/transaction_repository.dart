import 'package:kasentra/features/transaction/domain/entities/transaction.dart';
import 'package:kasentra/features/transaction/domain/entities/transaction_item.dart';
import 'package:kasentra/features/transaction/domain/entities/transaction_page.dart';

abstract class TransactionRepository {
  /// Mengambil histori transaksi menggunakan keyset pagination.
  ///
  /// Urutan wajib:
  /// transactionDate descending, lalu transactionId descending.
  Future<TransactionPage> getTransactionsPage({
    required String businessId,
    DateTime? startDate,
    DateTime? endDate,
    TransactionType? type,
    required int limit,
    TransactionCursor? cursor,
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
