import 'package:drift/drift.dart' show Value;

import '../../../../core/database/app_database.dart';
import '../../domain/entities/category.dart';

abstract final class CategoryMapper {
  static Category toDomain(CategoryRow row) {
    return Category(
      id: row.id,
      businessId: row.businessId,
      type: _typeFromStorage(row.type),
      name: row.name,
      isDefault: row.isDefault,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }

  static CategoriesCompanion toCompanion(Category category) {
    return CategoriesCompanion(
      id: Value(category.id),
      businessId: Value(category.businessId),
      type: Value(_typeToStorage(category.type)),
      name: Value(category.name),
      isDefault: Value(category.isDefault),
      createdAt: Value(category.createdAt),
      updatedAt: Value(category.updatedAt),

      // Setiap perubahan lokal dianggap belum tersinkron.
      syncedAt: const Value(null),
    );
  }

  static CategoryType _typeFromStorage(String value) {
    return switch (value.trim()) {
      'product' => CategoryType.product,
      'expense' => CategoryType.expense,
      _ => throw FormatException(
        'Tipe kategori database tidak dikenali: $value',
      ),
    };
  }

  static String _typeToStorage(CategoryType type) {
    return switch (type) {
      CategoryType.product => 'product',
      CategoryType.expense => 'expense',
    };
  }
}
