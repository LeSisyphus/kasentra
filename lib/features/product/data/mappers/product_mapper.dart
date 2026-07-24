import 'package:drift/drift.dart' show Value;

import '../../../../core/database/app_database.dart';
import '../../domain/entities/product.dart';

abstract final class ProductMapper {
  static Product toDomain(ProductRow row) {
    return Product(
      id: row.id,
      businessId: row.businessId,
      name: row.name,
      categoryId: row.categoryId,
      sellingPrice: row.sellingPrice,

      // Schema lama mengizinkan cost_price null, sedangkan domain
      // menggunakan integer non-null. Nilai null dibaca sebagai nol.
      costPrice: row.costPrice ?? 0,

      stock: row.stock,
      isActive: row.isActive,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }

  static ProductsCompanion toCompanion(Product product) {
    return ProductsCompanion(
      id: Value(product.id),
      businessId: Value(product.businessId),
      categoryId: Value(product.categoryId),
      name: Value(product.name),
      sellingPrice: Value(product.sellingPrice),
      costPrice: Value<int?>(product.costPrice),
      stock: Value<int?>(product.stock),
      isActive: Value(product.isActive),
      createdAt: Value(product.createdAt),
      updatedAt: Value(product.updatedAt),

      // Setiap perubahan lokal dianggap belum tersinkron.
      syncedAt: const Value<DateTime?>(null),
    );
  }
}
