import 'package:drift/drift.dart' show DatabaseConnection, Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kasentra/core/database/app_database.dart';
import 'package:kasentra/features/product/data/datasources/local_product_data_source.dart';
import 'package:kasentra/features/product/data/repositories/product_repository_impl.dart';
import 'package:kasentra/features/product/domain/entities/product.dart';

void main() {
  group('ProductRepositoryImpl', () {
    late AppDatabase database;
    late ProductRepositoryImpl repository;

    final timestamp = DateTime.utc(2025, 1, 1);

    setUp(() async {
      database = AppDatabase(
        DatabaseConnection(
          NativeDatabase.memory(),
          closeStreamsSynchronously: true,
        ),
      );

      repository = ProductRepositoryImpl(DriftLocalProductDataSource(database));

      await _insertBusiness(database, id: 'business-1');

      await _insertBusiness(database, id: 'business-2');

      await _insertCategory(
        database,
        id: 'category-product-1',
        businessId: 'business-1',
        type: 'product',
      );

      await _insertCategory(
        database,
        id: 'category-expense-1',
        businessId: 'business-1',
        type: 'expense',
      );

      await _insertCategory(
        database,
        id: 'category-product-2',
        businessId: 'business-2',
        type: 'product',
      );
    });

    tearDown(() async {
      await database.close();
    });

    Product createProduct({
      required String id,
      String businessId = 'business-1',
      String categoryId = 'category-product-1',
      required String name,
      int sellingPrice = 18000,
      int costPrice = 15000,
      int? stock = 20,
      bool isActive = true,
      DateTime? updatedAt,
    }) {
      return Product(
        id: id,
        businessId: businessId,
        categoryId: categoryId,
        name: name,
        sellingPrice: sellingPrice,
        costPrice: costPrice,
        stock: stock,
        isActive: isActive,
        createdAt: timestamp,
        updatedAt: updatedAt ?? timestamp,
      );
    }

    test('watches products scoped by business '
        'and active status', () async {
      await repository.saveProduct(
        createProduct(id: 'product-rice', name: 'Beras'),
      );

      await repository.saveProduct(
        createProduct(id: 'product-sugar', name: 'Gula'),
      );

      await repository.saveProduct(
        createProduct(
          id: 'product-water',
          name: 'Air Mineral',
          isActive: false,
        ),
      );

      await repository.saveProduct(
        createProduct(
          id: 'other-product',
          businessId: 'business-2',
          categoryId: 'category-product-2',
          name: 'Produk Usaha Lain',
        ),
      );

      final activeProducts = await repository
          .watchProducts(businessId: 'business-1')
          .firstWhere((products) => products.length == 2);

      expect(activeProducts.map((product) => product.id), [
        'product-rice',
        'product-sugar',
      ]);

      expect(
        activeProducts.every(
          (product) => product.businessId == 'business-1' && product.isActive,
        ),
        isTrue,
      );

      final allProducts = await repository
          .watchProducts(businessId: 'business-1', activeOnly: false)
          .firstWhere((products) => products.length == 3);

      expect(allProducts.map((product) => product.id), [
        'product-rice',
        'product-sugar',
        'product-water',
      ]);
    });

    test('returns product owned by active business', () async {
      await repository.saveProduct(
        createProduct(id: 'product-1', name: 'Beras'),
      );

      final result = await repository.getProductById(
        businessId: 'business-1',
        productId: 'product-1',
      );

      expect(result, isNotNull);
      expect(result!.name, 'Beras');
      expect(result.costPrice, 15000);
      expect(result.stock, 20);
    });

    test('returns null when product belongs '
        'to another business', () async {
      await repository.saveProduct(
        createProduct(
          id: 'product-1',
          businessId: 'business-2',
          categoryId: 'category-product-2',
          name: 'Beras',
        ),
      );

      final result = await repository.getProductById(
        businessId: 'business-1',
        productId: 'product-1',
      );

      expect(result, isNull);
    });

    test('upserts product and resets syncedAt', () async {
      await repository.saveProduct(
        createProduct(id: 'product-1', name: 'Beras'),
      );

      await (database.update(database.products)
            ..where((row) => row.id.equals('product-1')))
          .write(ProductsCompanion(syncedAt: Value(DateTime.utc(2025, 1, 2))));

      final newUpdatedAt = DateTime.utc(2025, 1, 3);

      await repository.saveProduct(
        createProduct(
          id: 'product-1',
          name: 'Beras Premium',
          sellingPrice: 20000,
          costPrice: 17000,
          stock: 15,
          updatedAt: newUpdatedAt,
        ),
      );

      final result = await repository.getProductById(
        businessId: 'business-1',
        productId: 'product-1',
      );

      expect(result, isNotNull);
      expect(result!.name, 'Beras Premium');
      expect(result.sellingPrice, 20000);
      expect(result.costPrice, 17000);
      expect(result.stock, 15);

      expect(result.updatedAt.isAtSameMomentAs(newUpdatedAt), isTrue);

      final storedRow = await (database.select(
        database.products,
      )..where((row) => row.id.equals('product-1'))).getSingle();

      expect(storedRow.syncedAt, isNull);
    });

    test('rejects expense category', () async {
      await expectLater(
        repository.saveProduct(
          createProduct(
            id: 'product-1',
            categoryId: 'category-expense-1',
            name: 'Beras',
          ),
        ),
        throwsA(isA<StateError>()),
      );

      final rows = await database.select(database.products).get();

      expect(rows, isEmpty);
    });

    test('rejects category owned by another business', () async {
      await expectLater(
        repository.saveProduct(
          createProduct(
            id: 'product-1',
            categoryId: 'category-product-2',
            name: 'Beras',
          ),
        ),
        throwsA(isA<StateError>()),
      );

      final rows = await database.select(database.products).get();

      expect(rows, isEmpty);
    });

    test('sets product active within active business '
        'and resets syncedAt', () async {
      await repository.saveProduct(
        createProduct(id: 'product-1', name: 'Beras'),
      );

      await (database.update(database.products)
            ..where((row) => row.id.equals('product-1')))
          .write(ProductsCompanion(syncedAt: Value(DateTime.utc(2025, 1, 2))));

      final updatedAt = DateTime.utc(2025, 1, 3);

      await repository.setProductActive(
        businessId: 'business-1',
        productId: 'product-1',
        isActive: false,
        updatedAt: updatedAt,
      );

      final result = await repository.getProductById(
        businessId: 'business-1',
        productId: 'product-1',
      );

      expect(result, isNotNull);
      expect(result!.isActive, isFalse);

      expect(result.updatedAt.isAtSameMomentAs(updatedAt), isTrue);

      final storedRow = await (database.select(
        database.products,
      )..where((row) => row.id.equals('product-1'))).getSingle();

      expect(storedRow.syncedAt, isNull);
    });

    test('rejects active update from another business', () async {
      await repository.saveProduct(
        createProduct(id: 'product-1', name: 'Beras'),
      );

      await expectLater(
        repository.setProductActive(
          businessId: 'business-2',
          productId: 'product-1',
          isActive: false,
          updatedAt: DateTime.utc(2025, 1, 3),
        ),
        throwsA(isA<StateError>()),
      );

      final result = await repository.getProductById(
        businessId: 'business-1',
        productId: 'product-1',
      );

      expect(result, isNotNull);
      expect(result!.isActive, isTrue);
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
          syncedAt: const Value<DateTime?>(null),
        ),
      );
}

Future<void> _insertCategory(
  AppDatabase database, {
  required String id,
  required String businessId,
  required String type,
}) async {
  final timestamp = DateTime.utc(2025, 1, 1);

  await database
      .into(database.categories)
      .insert(
        CategoriesCompanion.insert(
          id: id,
          businessId: businessId,
          type: type,
          name: 'Kategori $id',
          createdAt: timestamp,
          updatedAt: timestamp,
        ),
      );
}
