class TransactionItem {
  const TransactionItem({
    required this.id,
    required this.transactionId,
    required this.itemName,
    required this.quantity,
    required this.sellingPrice,
    required this.costPrice,
    required this.subtotal,
    this.productId,
  });

  final String id;
  final String transactionId;

  /// Nullable karena item bisa berasal dari input manual,
  /// bukan dari produk yang sudah terdaftar.
  final String? productId;

  final String itemName;
  final int quantity;

  /// Harga jual satuan dalam rupiah.
  final int sellingPrice;

  /// Harga modal satuan dalam rupiah.
  final int costPrice;

  /// quantity x sellingPrice.
  final int subtotal;

  int get totalCost {
    return quantity * costPrice;
  }

  int get profit {
    return subtotal - totalCost;
  }

  TransactionItem copyWith({
    String? id,
    String? transactionId,
    String? productId,
    bool clearProductId = false,
    String? itemName,
    int? quantity,
    int? sellingPrice,
    int? costPrice,
    int? subtotal,
  }) {
    return TransactionItem(
      id: id ?? this.id,
      transactionId: transactionId ?? this.transactionId,
      productId: clearProductId ? null : productId ?? this.productId,
      itemName: itemName ?? this.itemName,
      quantity: quantity ?? this.quantity,
      sellingPrice: sellingPrice ?? this.sellingPrice,
      costPrice: costPrice ?? this.costPrice,
      subtotal: subtotal ?? this.subtotal,
    );
  }
}
