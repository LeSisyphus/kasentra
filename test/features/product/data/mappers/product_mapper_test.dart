import 'package:flutter_test/flutter_test.dart';
import 'package:kasentra/core/database/app_database.dart';
import 'package:kasentra/features/product/data/mappers/product_mapper.dart';
import 'package:kasentra/features/product/domain/entities/product.dart';

void main() {
  group('ProductMapper', () {
    final createdAt = DateTime.utc(2025, 1, 1);

    final updatedAt = DateTime.utc(2025, 1, 2);

    test('maps database row to domain entity', () {
      final row = ProductRow(
        id: 'product-1',
        businessId: 'business-1',
        categoryId: 'category-product-1',
        name: 'Beras Premium',
        sellingPrice: 18000,
        costPrice: 15000,
        stock: 20,
        isActive: true,
        createdAt: createdAt,
        updatedAt: updatedAt,
        syncedAt: DateTime.utc(2025, 1, 3),
      );

      final product = ProductMapper.toDomain(row);

      expect(product.id, 'product-1');
      expect(product.businessId, 'business-1');
      expect(product.categoryId, 'category-product-1');
      expect(product.name, 'Beras Premium');
      expect(product.sellingPrice, 18000);
      expect(product.costPrice, 15000);
      expect(product.stock, 20);
      expect(product.isActive, isTrue);
      expect(product.createdAt, createdAt);
      expect(product.updatedAt, updatedAt);
    });

    test('maps nullable database cost price to zero', () {
      final row = ProductRow(
        id: 'product-1',
        businessId: 'business-1',
        categoryId: 'category-product-1',
        name: 'Beras Premium',
        sellingPrice: 18000,
        isActive: true,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

      final product = ProductMapper.toDomain(row);

      expect(product.costPrice, 0);
      expect(product.stock, isNull);
    });

    test('maps domain entity to database companion', () {
      final product = Product(
        id: 'product-1',
        businessId: 'business-1',
        categoryId: 'category-product-1',
        name: 'Beras Premium',
        sellingPrice: 18000,
        costPrice: 15000,
        stock: null,
        isActive: true,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

      final companion = ProductMapper.toCompanion(product);

      expect(companion.id.value, 'product-1');
      expect(companion.businessId.value, 'business-1');
      expect(companion.categoryId.value, 'category-product-1');
      expect(companion.name.value, 'Beras Premium');
      expect(companion.sellingPrice.value, 18000);
      expect(companion.costPrice.value, 15000);

      expect(companion.stock.present, isTrue);
      expect(companion.stock.value, isNull);

      expect(companion.isActive.value, isTrue);
      expect(companion.createdAt.value, createdAt);
      expect(companion.updatedAt.value, updatedAt);

      expect(companion.syncedAt.present, isTrue);
      expect(companion.syncedAt.value, isNull);
    });
  });
}
