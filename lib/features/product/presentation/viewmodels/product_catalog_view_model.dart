import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/providers/product_providers.dart';
import '../../domain/entities/product.dart';
import '../state/product_catalog_state.dart';

final productCatalogViewModelProvider =
    NotifierProvider<ProductCatalogViewModel, ProductCatalogState>(
      ProductCatalogViewModel.new,
      name: 'productCatalogViewModelProvider',
    );

class ProductCatalogViewModel extends Notifier<ProductCatalogState> {
  StreamSubscription<List<Product>>? _subscription;

  String? _businessId;
  int _subscriptionVersion = 0;

  @override
  ProductCatalogState build() {
    ref.onDispose(() {
      _subscriptionVersion++;

      final subscription = _subscription;
      _subscription = null;

      if (subscription != null) {
        unawaited(subscription.cancel());
      }
    });

    return ProductCatalogState();
  }

  Future<void> load({required String businessId}) async {
    final normalizedBusinessId = businessId.trim();

    if (normalizedBusinessId.isEmpty) {
      await _showInvalidBusiness();
      return;
    }

    final isSameBusiness = _businessId == normalizedBusinessId;

    if (isSameBusiness && (_subscription != null || state.isLoading)) {
      return;
    }

    final businessChanged = !isSameBusiness;

    _businessId = normalizedBusinessId;

    await _subscribe(
      businessId: normalizedBusinessId,
      clearProducts: businessChanged,
      clearSearch: businessChanged,
    );
  }

  Future<void> retry() async {
    final businessId = _businessId;

    if (businessId == null || state.isLoading) {
      return;
    }

    await _subscribe(
      businessId: businessId,
      clearProducts: false,
      clearSearch: false,
    );
  }

  void setSearchQuery(String value) {
    if (state.searchQuery == value) {
      return;
    }

    state = state.copyWith(searchQuery: value);
  }

  void clearSearch() {
    if (!state.isSearchActive) {
      return;
    }

    state = state.copyWith(searchQuery: '');
  }

  Future<void> _subscribe({
    required String businessId,
    required bool clearProducts,
    required bool clearSearch,
  }) async {
    final subscriptionVersion = ++_subscriptionVersion;

    final previousSubscription = _subscription;

    _subscription = null;

    state = ProductCatalogState(
      products: clearProducts ? const [] : state.products,
      searchQuery: clearSearch ? '' : state.searchQuery,
      isLoading: true,
    );

    await previousSubscription?.cancel();

    if (subscriptionVersion != _subscriptionVersion) {
      return;
    }

    try {
      final productStream = ref.read(watchProductsUseCaseProvider)(
        businessId: businessId,
        activeOnly: true,
      );

      final subscription = productStream.listen(
        (products) {
          if (subscriptionVersion != _subscriptionVersion) {
            return;
          }

          state = state.copyWith(
            products: products,
            isLoading: false,
            clearErrorMessage: true,
          );
        },
        onError: (Object _, StackTrace __) {
          if (subscriptionVersion != _subscriptionVersion) {
            return;
          }

          state = state.copyWith(
            isLoading: false,
            errorMessage:
                'Produk gagal dimuat. '
                'Coba lagi.',
          );
        },
      );

      if (subscriptionVersion != _subscriptionVersion) {
        await subscription.cancel();
        return;
      }

      _subscription = subscription;
    } catch (_) {
      if (subscriptionVersion != _subscriptionVersion) {
        return;
      }

      state = state.copyWith(
        isLoading: false,
        errorMessage:
            'Produk gagal dimuat. '
            'Coba lagi.',
      );
    }
  }

  Future<void> _showInvalidBusiness() async {
    final subscriptionVersion = ++_subscriptionVersion;

    final previousSubscription = _subscription;

    _subscription = null;
    _businessId = null;

    state = ProductCatalogState(errorMessage: 'Usaha aktif tidak valid.');

    await previousSubscription?.cancel();

    if (subscriptionVersion != _subscriptionVersion) {
      return;
    }
  }
}
