import 'package:drift/drift.dart' show DatabaseConnection, Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kasentra/core/database/app_database.dart';
import 'package:kasentra/features/product/data/datasources/local_category_data_source.dart';
import 'package:kasentra/features/product/data/repositories/category_repository_impl.dart';
import 'package:kasentra/features/product/domain/entities/category.dart';

void main() {
  group('CategoryRepositoryImpl', () {
    late AppDatabase database;
    late CategoryRepositoryImpl repository;

    final timestamp = DateTime.utc(2025, 1, 1);

    setUp(() async {
      database = AppDatabase(
        DatabaseConnection(
          NativeDatabase.memory(),
          closeStreamsSynchronously: true,
        ),
      );

      repository = CategoryRepositoryImpl(
        DriftLocalCategoryDataSource(database),
      );

      await _insertBusiness(database, id: 'business-1');

      await _insertBusiness(database, id: 'business-2');
    });

    tearDown(() async {
      await database.close();
    });

    Category createCategory({
      required String id,
      String businessId = 'business-1',
      CategoryType type = CategoryType.expense,
      required String name,
      bool isDefault = false,
      DateTime? updatedAt,
    }) {
      return Category(
        id: id,
        businessId: businessId,
        type: type,
        name: name,
        isDefault: isDefault,
        createdAt: timestamp,
        updatedAt: updatedAt ?? timestamp,
      );
    }

    test('watches categories scoped by business and type', () async {
      await repository.saveCategory(
        createCategory(id: 'expense-transport', name: 'Transport'),
      );

      await repository.saveCategory(
        createCategory(
          id: 'expense-operations',
          name: 'Operasional',
          isDefault: true,
        ),
      );

      await repository.saveCategory(
        createCategory(
          id: 'product-drinks',
          name: 'Minuman',
          type: CategoryType.product,
        ),
      );

      await repository.saveCategory(
        createCategory(
          id: 'other-business-expense',
          businessId: 'business-2',
          name: 'Sewa',
        ),
      );

      final result = await repository
          .watchCategories(businessId: 'business-1', type: CategoryType.expense)
          .firstWhere((categories) => categories.length == 2);

      expect(result.map((category) => category.id), [
        'expense-operations',
        'expense-transport',
      ]);

      expect(
        result.every(
          (category) =>
              category.businessId == 'business-1' &&
              category.type == CategoryType.expense,
        ),
        isTrue,
      );
    });

    test('returns category owned by active business', () async {
      await repository.saveCategory(
        createCategory(id: 'expense-1', name: 'Operasional'),
      );

      final result = await repository.getCategoryById(
        businessId: 'business-1',
        categoryId: 'expense-1',
      );

      expect(result, isNotNull);
      expect(result!.name, 'Operasional');
    });

    test('returns null when category belongs to another business', () async {
      await repository.saveCategory(
        createCategory(
          id: 'expense-1',
          businessId: 'business-2',
          name: 'Operasional',
        ),
      );

      final result = await repository.getCategoryById(
        businessId: 'business-1',
        categoryId: 'expense-1',
      );

      expect(result, isNull);
    });

    test('upserts category and resets syncedAt', () async {
      await repository.saveCategory(
        createCategory(id: 'expense-1', name: 'Operasional'),
      );

      await (database.update(
        database.categories,
      )..where((row) => row.id.equals('expense-1'))).write(
        CategoriesCompanion(syncedAt: Value(DateTime.utc(2025, 1, 2))),
      );

      final newUpdatedAt = DateTime.utc(2025, 1, 3);

      await repository.saveCategory(
        createCategory(
          id: 'expense-1',
          name: 'Operasional Toko',
          isDefault: true,
          updatedAt: newUpdatedAt,
        ),
      );

      final result = await repository.getCategoryById(
        businessId: 'business-1',
        categoryId: 'expense-1',
      );

      expect(result, isNotNull);
      expect(result!.name, 'Operasional Toko');
      expect(result.isDefault, isTrue);

      expect(result.updatedAt.isAtSameMomentAs(newUpdatedAt), isTrue);

      final storedRow = await (database.select(
        database.categories,
      )..where((row) => row.id.equals('expense-1'))).getSingle();

      expect(storedRow.syncedAt, isNull);
    });
  });
}

Future<void> _insertBusiness(AppDatabase database, {required String id}) async {
  final timestamp = DateTime.utc(2025, 1, 1);

  await database
      .into(database.businesses)
      .insert(
        BusinessesCompanion(
          id: Value(id),
          name: Value('Toko $id'),
          ownerName: const Value('Pemilik'),
          businessType: const Value('grocery_store'),
          createdAt: Value(timestamp),
          updatedAt: Value(timestamp),
          syncedAt: const Value(null),
        ),
      );
}
