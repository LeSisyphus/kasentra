import 'package:kasentra/features/product/domain/repositories/product_repository.dart';

class SetProductActiveUseCase {
  const SetProductActiveUseCase(this._repository);

  final ProductRepository _repository;

  Future<void> call({
    required String businessId,
    required String productId,
    required bool isActive,
    required DateTime updatedAt,
  }) {
    if (businessId.trim().isEmpty) {
      throw ArgumentError('Business id tidak boleh kosong.');
    }

    if (productId.trim().isEmpty) {
      throw ArgumentError('Product id tidak boleh kosong.');
    }

    return _repository.setProductActive(
      businessId: businessId,
      productId: productId,
      isActive: isActive,
      updatedAt: updatedAt,
    );
  }
}
