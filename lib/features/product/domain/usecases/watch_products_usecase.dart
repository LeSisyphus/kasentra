import 'package:kasentra/features/product/domain/entities/product.dart';
import 'package:kasentra/features/product/domain/repositories/product_repository.dart';

class WatchProductsUseCase {
  const WatchProductsUseCase(this._repository);

  final ProductRepository _repository;

  Stream<List<Product>> call({
    required String businessId,
    bool activeOnly = true,
  }) {
    return _repository.watchProducts(
      businessId: businessId,
      activeOnly: activeOnly,
    );
  }
}
