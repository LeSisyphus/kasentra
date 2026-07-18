class Product {
  const Product({
    required this.id,
    required this.businessId,
    required this.name,
    required this.categoryId,
    required this.sellingPrice,
    required this.costPrice,
    required this.stock,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String businessId;
  final String name;
  final String categoryId;

  /// Harga jual dalam satuan rupiah.
  /// Jangan gunakan double untuk nominal uang.
  final int sellingPrice;

  /// Harga modal dalam satuan rupiah.
  final int costPrice;

  /// Stok opsional pada MVP.
  /// Null berarti stok belum dikelola.
  final int? stock;

  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  /// Nullable untuk future cloud sync.

  int get estimatedProfitPerItem {
    return sellingPrice - costPrice;
  }

  bool get hasStock {
    return stock != null;
  }

  bool get isOutOfStock {
    return stock != null && stock! <= 0;
  }

  bool get isLowStock {
    return stock != null && stock! > 0 && stock! <= 5;
  }

  Product copyWith({
    String? id,
    String? businessId,
    String? name,
    String? categoryId,
    int? sellingPrice,
    int? costPrice,
    int? stock,
    bool clearStock = false,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Product(
      id: id ?? this.id,
      businessId: businessId ?? this.businessId,
      name: name ?? this.name,
      categoryId: categoryId ?? this.categoryId,
      sellingPrice: sellingPrice ?? this.sellingPrice,
      costPrice: costPrice ?? this.costPrice,
      stock: clearStock ? null : stock ?? this.stock,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
