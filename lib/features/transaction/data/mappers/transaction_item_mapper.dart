import '../../../../core/database/app_database.dart';
import '../../domain/entities/transaction_item.dart';

abstract final class TransactionItemMapper {
  static TransactionItem toDomain(TransactionItemRow row) {
    return TransactionItem(
      id: row.id,
      transactionId: row.transactionId,
      productId: row.productId,
      itemName: row.itemName,
      quantity: row.quantity,
      sellingPrice: row.sellingPrice,

      // Domain memakai int non-null. Produk tanpa harga modal dianggap 0.
      costPrice: row.costPrice ?? 0,
      subtotal: row.subtotal,
    );
  }
}
