import 'package:kasentra/features/product/domain/entities/category.dart';
import 'package:kasentra/features/product/domain/repositories/category_repository.dart';

class GetCategoryByIdUseCase {
  const GetCategoryByIdUseCase(this._repository);

  final CategoryRepository _repository;

  Future<Category?> call({
    required String businessId,
    required String categoryId,
  }) {
    if (businessId.trim().isEmpty) {
      throw ArgumentError('Business id tidak boleh kosong.');
    }

    if (categoryId.trim().isEmpty) {
      throw ArgumentError('Category id tidak boleh kosong.');
    }

    return _repository.getCategoryById(
      businessId: businessId,
      categoryId: categoryId,
    );
  }
}
