import 'package:drift/drift.dart' show Value;

import '../../../../core/database/app_database.dart';
import '../../domain/entities/transaction.dart';

abstract final class TransactionMapper {
  static Transaction toDomain(TransactionRow row) {
    return Transaction(
      id: row.id,
      businessId: row.businessId,
      type: _transactionTypeFromStorage(row.type),
      title: row.title,
      categoryId: row.categoryId,
      totalAmount: row.totalAmount,
      costAmount: row.costAmount,
      profitAmount: row.profitAmount,
      paymentStatus: _paymentStatusFromStorage(row.paymentStatus),
      contactName: row.contactName,
      contactPhone: row.contactPhone,
      transactionDate: row.transactionDate,
      note: row.note,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }

  static TransactionsCompanion toCompanion(Transaction transaction) {
    return TransactionsCompanion(
      id: Value(transaction.id),
      businessId: Value(transaction.businessId),
      type: Value(transaction.type.name),
      title: Value(transaction.title),
      categoryId: Value(transaction.categoryId),
      totalAmount: Value(transaction.totalAmount),
      costAmount: Value(transaction.costAmount),
      profitAmount: Value(transaction.profitAmount),
      paymentStatus: Value(transaction.paymentStatus.name),
      contactName: Value(transaction.contactName),
      contactPhone: Value(transaction.contactPhone),
      transactionDate: Value(transaction.transactionDate),
      note: Value(transaction.note),
      createdAt: Value(transaction.createdAt),
      updatedAt: Value(transaction.updatedAt),

      // Setiap perubahan lokal harus dianggap belum tersinkron.
      syncedAt: const Value(null),
    );
  }

  static TransactionType _transactionTypeFromStorage(String value) {
    return switch (value) {
      'sale' => TransactionType.sale,
      'expense' => TransactionType.expense,
      _ => throw FormatException(
        'Tipe transaksi database tidak dikenali: $value',
      ),
    };
  }

  static PaymentStatus _paymentStatusFromStorage(String value) {
    return switch (value) {
      'paid' => PaymentStatus.paid,
      'unpaid' => PaymentStatus.unpaid,
      _ => throw FormatException(
        'Status pembayaran database tidak dikenali: $value',
      ),
    };
  }
}
