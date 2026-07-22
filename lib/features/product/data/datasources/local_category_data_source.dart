import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart';

abstract interface class LocalCategoryDataSource {
  Stream<List<CategoryRow>> watchCategories({
    required String businessId,
    String? type,
  });

  Future<CategoryRow?> getCategoryById({
    required String businessId,
    required String categoryId,
  });

  Future<void> saveCategory(CategoriesCompanion companion);
}

final class DriftLocalCategoryDataSource implements LocalCategoryDataSource {
  const DriftLocalCategoryDataSource(this._database);

  final AppDatabase _database;

  @override
  Stream<List<CategoryRow>> watchCategories({
    required String businessId,
    String? type,
  }) {
    final query = _database.select(_database.categories)
      ..where((row) {
        final businessExpression = row.businessId.equals(businessId);

        if (type == null) {
          return businessExpression;
        }

        return businessExpression & row.type.equals(type);
      })
      ..orderBy([
        (row) => OrderingTerm.desc(row.isDefault),
        (row) => OrderingTerm.asc(row.name),
        (row) => OrderingTerm.asc(row.id),
      ]);

    return query.watch();
  }

  @override
  Future<CategoryRow?> getCategoryById({
    required String businessId,
    required String categoryId,
  }) {
    final query = _database.select(_database.categories)
      ..where(
        (row) => row.businessId.equals(businessId) & row.id.equals(categoryId),
      );

    return query.getSingleOrNull();
  }

  @override
  Future<void> saveCategory(CategoriesCompanion companion) async {
    await _database
        .into(_database.categories)
        .insertOnConflictUpdate(companion);
  }
}
