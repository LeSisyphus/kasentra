import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/local_product_data_source.dart';
import '../mappers/product_mapper.dart';

final class ProductRepositoryImpl implements ProductRepository {
  const ProductRepositoryImpl(this._localDataSource);

  final LocalProductDataSource _localDataSource;

  @override
  Stream<List<Product>> watchProducts({
    required String businessId,
    bool activeOnly = true,
  }) {
    return _localDataSource
        .watchProducts(businessId: businessId, activeOnly: activeOnly)
        .map(
          (rows) =>
              List<Product>.unmodifiable(rows.map(ProductMapper.toDomain)),
        );
  }

  @override
  Future<Product?> getProductById({
    required String businessId,
    required String productId,
  }) async {
    final row = await _localDataSource.getProductById(
      businessId: businessId,
      productId: productId,
    );

    if (row == null) {
      return null;
    }

    return ProductMapper.toDomain(row);
  }

  @override
  Future<void> saveProduct(Product product) {
    return _localDataSource.saveProduct(ProductMapper.toCompanion(product));
  }

  @override
  Future<void> setProductActive({
    required String businessId,
    required String productId,
    required bool isActive,
    required DateTime updatedAt,
  }) async {
    final affectedRows = await _localDataSource.setProductActive(
      businessId: businessId,
      productId: productId,
      isActive: isActive,
      updatedAt: updatedAt,
    );

    if (affectedRows == 0) {
      throw StateError(
        'Produk tidak ditemukan atau '
        'bukan milik usaha aktif.',
      );
    }
  }
}
