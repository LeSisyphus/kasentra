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

  Future<void> saveTransaction({
    required Transaction transaction,
    required List<TransactionItem> items,
  });

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
