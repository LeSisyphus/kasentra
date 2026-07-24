import '../../domain/entities/product.dart';

class ProductCatalogState {
  ProductCatalogState({
    List<Product> products = const [],
    this.searchQuery = '',
    this.isLoading = false,
    this.errorMessage,
  }) : products = List<Product>.unmodifiable(products);

  final List<Product> products;
  final String searchQuery;
  final bool isLoading;
  final String? errorMessage;

  List<Product> get visibleProducts {
    final normalizedQuery = searchQuery.trim().toLowerCase();

    if (normalizedQuery.isEmpty) {
      return products;
    }

    return List<Product>.unmodifiable(
      products.where((product) {
        return product.name.trim().toLowerCase().contains(normalizedQuery);
      }),
    );
  }

  int get totalProducts {
    return products.length;
  }

  int get lowStockCount {
    return products.where((product) {
      return product.isLowStock;
    }).length;
  }

  int get outOfStockCount {
    return products.where((product) {
      return product.isOutOfStock;
    }).length;
  }

  bool get hasError {
    return errorMessage != null;
  }

  bool get isSearchActive {
    return searchQuery.trim().isNotEmpty;
  }

  bool get isInitialLoading {
    return isLoading && products.isEmpty;
  }

  bool get isRefreshing {
    return isLoading && products.isNotEmpty;
  }

  bool get isCatalogEmpty {
    return !isLoading && !hasError && products.isEmpty;
  }

  bool get hasNoSearchResults {
    return !isLoading &&
        !hasError &&
        isSearchActive &&
        products.isNotEmpty &&
        visibleProducts.isEmpty;
  }

  ProductCatalogState copyWith({
    List<Product>? products,
    String? searchQuery,
    bool? isLoading,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return ProductCatalogState(
      products: products ?? this.products,
      searchQuery: searchQuery ?? this.searchQuery,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearErrorMessage
          ? null
          : errorMessage ?? this.errorMessage,
    );
  }
}
