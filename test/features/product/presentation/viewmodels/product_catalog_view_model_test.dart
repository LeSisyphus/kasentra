import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kasentra/app/providers/product_providers.dart';
import 'package:kasentra/features/product/domain/entities/product.dart';
import 'package:kasentra/features/product/domain/repositories/product_repository.dart';
import 'package:kasentra/features/product/presentation/viewmodels/product_catalog_view_model.dart';

void main() {
  group('ProductCatalogViewModel', () {
    ProviderContainer createContainer(_ControlledProductRepository repository) {
      final container = ProviderContainer.test(
        overrides: [productRepositoryProvider.overrideWithValue(repository)],
      );

      addTearDown(() async {
        container.dispose();
        await repository.dispose();
      });

      return container;
    }

    test('starts with a safe state', () {
      final repository = _ControlledProductRepository();

      final container = createContainer(repository);

      final state = container.read(productCatalogViewModelProvider);

      expect(state.products, isEmpty);
      expect(state.isLoading, isFalse);
      expect(state.hasError, isFalse);
      expect(state.searchQuery, isEmpty);
    });

    test('loads active products '
        'for the selected business', () async {
      final repository = _ControlledProductRepository();

      final container = createContainer(repository);

      final viewModel = container.read(
        productCatalogViewModelProvider.notifier,
      );

      await viewModel.load(businessId: 'business-1');

      expect(repository.requests, hasLength(1));

      final request = repository.requests.single;

      expect(request.businessId, 'business-1');
      expect(request.activeOnly, isTrue);

      final loadingState = container.read(productCatalogViewModelProvider);

      expect(loadingState.isInitialLoading, isTrue);
      expect(loadingState.products, isEmpty);

      repository.emit(0, [
        _createProduct(id: 'product-rice', name: 'Beras', stock: 20),
        _createProduct(id: 'product-oil', name: 'Minyak', stock: 3),
        _createProduct(id: 'product-sugar', name: 'Gula', stock: 0),
      ]);

      final successState = container.read(productCatalogViewModelProvider);

      expect(successState.isLoading, isFalse);

      expect(successState.products.map((product) => product.id), [
        'product-rice',
        'product-oil',
        'product-sugar',
      ]);

      expect(successState.totalProducts, 3);
      expect(successState.lowStockCount, 1);
      expect(successState.outOfStockCount, 1);
      expect(successState.errorMessage, isNull);
    });

    test('ignores duplicate load requests '
        'for the same business', () async {
      final repository = _ControlledProductRepository();

      final container = createContainer(repository);

      final viewModel = container.read(
        productCatalogViewModelProvider.notifier,
      );

      await viewModel.load(businessId: 'business-1');

      await viewModel.load(businessId: 'business-1');

      expect(repository.requests, hasLength(1));
    });

    test('filters and clears search '
        'without opening another stream', () async {
      final repository = _ControlledProductRepository();

      final container = createContainer(repository);

      final viewModel = container.read(
        productCatalogViewModelProvider.notifier,
      );

      await viewModel.load(businessId: 'business-1');

      repository.emit(0, [
        _createProduct(id: 'product-rice', name: 'Beras Premium'),
        _createProduct(id: 'product-oil', name: 'Minyak Goreng'),
      ]);

      viewModel.setSearchQuery('  BERAS ');

      var state = container.read(productCatalogViewModelProvider);

      expect(state.visibleProducts.map((product) => product.id), [
        'product-rice',
      ]);

      expect(repository.requests, hasLength(1));

      viewModel.clearSearch();

      state = container.read(productCatalogViewModelProvider);

      expect(state.searchQuery, isEmpty);
      expect(state.visibleProducts, hasLength(2));

      expect(repository.requests, hasLength(1));
    });

    test('updates state when the '
        'database stream changes', () async {
      final repository = _ControlledProductRepository();

      final container = createContainer(repository);

      final viewModel = container.read(
        productCatalogViewModelProvider.notifier,
      );

      await viewModel.load(businessId: 'business-1');

      repository.emit(0, [_createProduct(id: 'product-rice', name: 'Beras')]);

      expect(container.read(productCatalogViewModelProvider).totalProducts, 1);

      repository.emit(0, [
        _createProduct(id: 'product-rice', name: 'Beras'),
        _createProduct(id: 'product-oil', name: 'Minyak'),
      ]);

      final state = container.read(productCatalogViewModelProvider);

      expect(state.totalProducts, 2);
      expect(state.products.map((product) => product.id), [
        'product-rice',
        'product-oil',
      ]);
    });

    test('stores safe error and retries '
        'the active business', () async {
      final repository = _ControlledProductRepository();

      final container = createContainer(repository);

      final viewModel = container.read(
        productCatalogViewModelProvider.notifier,
      );

      await viewModel.load(businessId: 'business-1');

      viewModel.setSearchQuery('beras');

      repository.fail(0, StateError('database connection failed'));

      var state = container.read(productCatalogViewModelProvider);

      expect(state.isLoading, isFalse);
      expect(state.errorMessage, 'Produk gagal dimuat. Coba lagi.');
      expect(state.errorMessage, isNot(contains('database connection failed')));

      await viewModel.retry();

      expect(repository.requests, hasLength(2));

      expect(repository.requests[0].hasListener, isFalse);

      state = container.read(productCatalogViewModelProvider);

      expect(state.isLoading, isTrue);
      expect(state.errorMessage, isNull);
      expect(state.searchQuery, 'beras');

      repository.emit(1, [_createProduct(id: 'product-rice', name: 'Beras')]);

      state = container.read(productCatalogViewModelProvider);

      expect(state.isLoading, isFalse);
      expect(state.errorMessage, isNull);
      expect(state.visibleProducts, hasLength(1));
    });

    test('switches business and ignores '
        'the previous stream', () async {
      final repository = _ControlledProductRepository();

      final container = createContainer(repository);

      final viewModel = container.read(
        productCatalogViewModelProvider.notifier,
      );

      await viewModel.load(businessId: 'business-1');

      repository.emit(0, [
        _createProduct(id: 'product-old', name: 'Beras Lama'),
      ]);

      viewModel.setSearchQuery('beras');

      await viewModel.load(businessId: 'business-2');

      expect(repository.requests, hasLength(2));

      expect(repository.requests[0].hasListener, isFalse);

      var state = container.read(productCatalogViewModelProvider);

      expect(state.products, isEmpty);
      expect(state.searchQuery, isEmpty);
      expect(state.isLoading, isTrue);

      repository.emit(0, [
        _createProduct(id: 'product-stale', name: 'Produk Kedaluwarsa'),
      ]);

      state = container.read(productCatalogViewModelProvider);

      expect(state.products, isEmpty);

      repository.emit(1, [
        _createProduct(
          id: 'product-new',
          name: 'Produk Baru',
          businessId: 'business-2',
        ),
      ]);

      state = container.read(productCatalogViewModelProvider);

      expect(state.products.map((product) => product.id), ['product-new']);
    });

    test('rejects an empty business id '
        'without opening a stream', () async {
      final repository = _ControlledProductRepository();

      final container = createContainer(repository);

      final viewModel = container.read(
        productCatalogViewModelProvider.notifier,
      );

      await viewModel.load(businessId: '   ');

      expect(repository.requests, isEmpty);

      final state = container.read(productCatalogViewModelProvider);

      expect(state.isLoading, isFalse);
      expect(state.errorMessage, 'Usaha aktif tidak valid.');
    });
  });
}

Product _createProduct({
  required String id,
  required String name,
  String businessId = 'business-1',
  int? stock = 10,
}) {
  final timestamp = DateTime.utc(2025, 1, 1);

  return Product(
    id: id,
    businessId: businessId,
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

final class _ControlledProductRepository implements ProductRepository {
  final List<_WatchRequest> requests = [];

  @override
  Stream<List<Product>> watchProducts({
    required String businessId,
    bool activeOnly = true,
  }) {
    final controller = StreamController<List<Product>>(sync: true);

    requests.add(
      _WatchRequest(
        businessId: businessId,
        activeOnly: activeOnly,
        controller: controller,
      ),
    );

    return controller.stream;
  }

  void emit(int requestIndex, List<Product> products) {
    requests[requestIndex].controller.add(List<Product>.unmodifiable(products));
  }

  void fail(int requestIndex, Object error) {
    requests[requestIndex].controller.addError(error, StackTrace.current);
  }

  Future<void> dispose() async {
    for (final request in requests) {
      if (!request.controller.isClosed) {
        await request.controller.close();
      }
    }
  }

  @override
  dynamic noSuchMethod(Invocation invocation) {
    throw UnimplementedError(
      '${invocation.memberName} tidak digunakan '
      'dalam view model test.',
    );
  }
}

final class _WatchRequest {
  const _WatchRequest({
    required this.businessId,
    required this.activeOnly,
    required this.controller,
  });

  final String businessId;
  final bool activeOnly;

  final StreamController<List<Product>> controller;

  bool get hasListener {
    return controller.hasListener;
  }
}
