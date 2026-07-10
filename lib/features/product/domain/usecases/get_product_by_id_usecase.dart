import 'package:kasentra/features/product/domain/entities/product.dart';
import 'package:kasentra/features/product/domain/repositories/product_repository.dart';

class GetProductByIdUseCase {
  const GetProductByIdUseCase(this._repository);

  final ProductRepository _repository;

  Future<Product?> call({
    required String businessId,
    required String productId,
  }) {
    return _repository.getProductById(
      businessId: businessId,
      productId: productId,
    );
  }
}
