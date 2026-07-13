import 'package:kasentra/features/transaction/domain/entities/transaction.dart';
import 'package:kasentra/features/transaction/domain/entities/transaction_item.dart';

class Sale {
  Sale({required this.transaction, required List<TransactionItem> items})
    : items = List<TransactionItem>.unmodifiable(items);

  /// Transaction menjadi aggregate root dari penjualan.
  final Transaction transaction;

  /// Immutable agar item tidak berubah setelah penjualan divalidasi.
  final List<TransactionItem> items;

  int get calculatedTotal {
    return items.fold<int>(0, (total, item) => total + item.subtotal);
  }

  int get calculatedCost {
    return items.fold<int>(0, (total, item) => total + item.totalCost);
  }

  int get calculatedProfit {
    return calculatedTotal - calculatedCost;
  }
}
