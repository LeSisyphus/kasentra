import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart';

abstract interface class LocalProductDataSource {
  Stream<List<ProductRow>> watchProducts({
    required String businessId,
    bool activeOnly = true,
  });

  Future<ProductRow?> getProductById({
    required String businessId,
    required String productId,
  });

  Future<void> saveProduct(ProductsCompanion companion);

  Future<int> setProductActive({
    required String businessId,
    required String productId,
    required bool isActive,
    required DateTime updatedAt,
  });
}

final class DriftLocalProductDataSource implements LocalProductDataSource {
  const DriftLocalProductDataSource(this._database);

  final AppDatabase _database;

  @override
  Stream<List<ProductRow>> watchProducts({
    required String businessId,
    bool activeOnly = true,
  }) {
    final query = _database.select(_database.products)
      ..where((row) {
        final businessExpression = row.businessId.equals(businessId);

        if (!activeOnly) {
          return businessExpression;
        }

        return businessExpression & row.isActive.equals(true);
      })
      ..orderBy([
        (row) => OrderingTerm.desc(row.isActive),
        (row) => OrderingTerm.asc(row.name),
        (row) => OrderingTerm.asc(row.id),
      ]);

    return query.watch();
  }

  @override
  Future<ProductRow?> getProductById({
    required String businessId,
    required String productId,
  }) {
    final query = _database.select(_database.products)
      ..where(
        (row) => row.businessId.equals(businessId) & row.id.equals(productId),
      );

    return query.getSingleOrNull();
  }

  @override
  Future<void> saveProduct(ProductsCompanion companion) async {
    if (!companion.businessId.present || !companion.categoryId.present) {
      throw ArgumentError('Business dan kategori produk wajib tersedia.');
    }

    final businessId = companion.businessId.value.trim();

    final categoryId = companion.categoryId.value.trim();

    final categoryQuery = _database.select(_database.categories)
      ..where(
        (row) =>
            row.id.equals(categoryId) &
            row.businessId.equals(businessId) &
            row.type.equals('product'),
      );

    final category = await categoryQuery.getSingleOrNull();

    if (category == null) {
      throw StateError(
        'Kategori produk tidak ditemukan '
        'atau bukan milik usaha aktif.',
      );
    }

    await _database.into(_database.products).insertOnConflictUpdate(companion);
  }

  @override
  Future<int> setProductActive({
    required String businessId,
    required String productId,
    required bool isActive,
    required DateTime updatedAt,
  }) {
    final query = _database.update(_database.products)
      ..where(
        (row) => row.businessId.equals(businessId) & row.id.equals(productId),
      );

    return query.write(
      ProductsCompanion(
        isActive: Value(isActive),
        updatedAt: Value(updatedAt),

        // Perubahan lokal harus dikirim ulang
        // saat sinkronisasi tersedia nanti.
        syncedAt: const Value<DateTime?>(null),
      ),
    );
  }
}
