import 'package:kasentra/features/product/domain/entities/product.dart';

abstract class ProductRepository {
  Stream<List<Product>> watchProducts({
    required String businessId,
    bool activeOnly = true,
  });

  Future<Product?> getProductById({
    required String businessId,
    required String productId,
  });

  Future<void> saveProduct(Product product);

  Future<void> setProductActive({
    required String businessId,
    required String productId,
    required bool isActive,
    required DateTime updatedAt,
  });
}
