import 'package:kasentra/features/product/domain/entities/product.dart';
import 'package:kasentra/features/product/domain/repositories/product_repository.dart';

class SaveProductUseCase {
  const SaveProductUseCase(this._repository);

  final ProductRepository _repository;

  Future<void> call(Product product) {
    _validateProduct(product);
    return _repository.saveProduct(product);
  }

  void _validateProduct(Product product) {
    if (product.businessId.trim().isEmpty) {
      throw ArgumentError('Business id tidak boleh kosong.');
    }

    if (product.name.trim().isEmpty) {
      throw ArgumentError('Nama produk tidak boleh kosong.');
    }

    if (product.categoryId.trim().isEmpty) {
      throw ArgumentError('Kategori produk tidak boleh kosong.');
    }

    if (product.sellingPrice < 0) {
      throw ArgumentError('Harga jual tidak boleh negatif.');
    }

    if (product.costPrice < 0) {
      throw ArgumentError('Harga modal tidak boleh negatif.');
    }

    if (product.stock != null && product.stock! < 0) {
      throw ArgumentError('Stok tidak boleh negatif.');
    }
  }
}
