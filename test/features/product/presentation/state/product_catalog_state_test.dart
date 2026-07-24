import 'package:flutter_test/flutter_test.dart';
import 'package:kasentra/features/product/domain/entities/product.dart';
import 'package:kasentra/features/product/presentation/state/product_catalog_state.dart';

void main() {
  group('ProductCatalogState', () {
    test('starts with a safe initial state', () {
      final state = ProductCatalogState();

      expect(state.products, isEmpty);
      expect(state.visibleProducts, isEmpty);
      expect(state.totalProducts, 0);
      expect(state.lowStockCount, 0);
      expect(state.outOfStockCount, 0);
      expect(state.searchQuery, isEmpty);
      expect(state.isLoading, isFalse);
      expect(state.isInitialLoading, isFalse);
      expect(state.isRefreshing, isFalse);
      expect(state.hasError, isFalse);
      expect(state.isCatalogEmpty, isTrue);
      expect(state.hasNoSearchResults, isFalse);
    });

    test('calculates catalog statistics', () {
      final products = [
        _createProduct(id: 'product-normal', name: 'Beras', stock: 20),
        _createProduct(id: 'product-low', name: 'Minyak', stock: 3),
        _createProduct(id: 'product-empty', name: 'Gula', stock: 0),
        _createProduct(id: 'product-unmanaged', name: 'Kopi', stock: null),
      ];

      final state = ProductCatalogState(products: products);

      expect(state.totalProducts, 4);
      expect(state.lowStockCount, 1);
      expect(state.outOfStockCount, 1);
      expect(state.isCatalogEmpty, isFalse);

      expect(
        () => state.products.add(
          _createProduct(id: 'product-extra', name: 'Produk Baru'),
        ),
        throwsUnsupportedError,
      );
    });

    test('filters products by trimmed '
        'case-insensitive name', () {
      final state = ProductCatalogState(
        products: [
          _createProduct(id: 'product-rice', name: 'Beras Premium'),
          _createProduct(id: 'product-oil', name: 'Minyak Goreng'),
          _createProduct(id: 'product-sugar', name: 'Gula Pasir'),
        ],
        searchQuery: '  BERAS  ',
      );

      expect(state.visibleProducts.map((product) => product.id), [
        'product-rice',
      ]);

      expect(state.isSearchActive, isTrue);
      expect(state.hasNoSearchResults, isFalse);
    });

    test('distinguishes empty catalog '
        'from empty search result', () {
      final searchState = ProductCatalogState(
        products: [_createProduct(id: 'product-rice', name: 'Beras')],
        searchQuery: 'kopi',
      );

      expect(searchState.visibleProducts, isEmpty);
      expect(searchState.isCatalogEmpty, isFalse);
      expect(searchState.hasNoSearchResults, isTrue);

      final emptyState = ProductCatalogState();

      expect(emptyState.isCatalogEmpty, isTrue);
      expect(emptyState.hasNoSearchResults, isFalse);
    });

    test('copyWith can clear an error', () {
      final state = ProductCatalogState(errorMessage: 'Produk gagal dimuat.');

      final result = state.copyWith(isLoading: true, clearErrorMessage: true);

      expect(result.isLoading, isTrue);
      expect(result.errorMessage, isNull);
      expect(result.hasError, isFalse);
    });
  });
}

Product _createProduct({
  required String id,
  required String name,
  int? stock = 10,
}) {
  final timestamp = DateTime.utc(2025, 1, 1);

  return Product(
    id: id,
    businessId: 'business-1',
    name: name,
    categoryId: 'category-product-1',
    sellingPrice: 18000,
    costPrice: 15000,
    stock: stock,
    isActive: true,
    createdAt: timestamp,
    updatedAt: timestamp,
  );
}
