import 'package:kasentra/features/product/domain/entities/category.dart';
import 'package:kasentra/features/product/domain/repositories/category_repository.dart';

class SaveCategoryUseCase {
  const SaveCategoryUseCase(this._repository);

  final CategoryRepository _repository;

  Future<void> call(Category category) {
    _validateCategory(category);
    return _repository.saveCategory(category);
  }

  void _validateCategory(Category category) {
    if (category.id.trim().isEmpty) {
      throw ArgumentError('Category id tidak boleh kosong.');
    }

    if (category.businessId.trim().isEmpty) {
      throw ArgumentError('Business id tidak boleh kosong.');
    }

    if (category.name.trim().isEmpty) {
      throw ArgumentError('Nama kategori tidak boleh kosong.');
    }

    if (category.name.trim().length < 2) {
      throw ArgumentError('Nama kategori minimal 2 karakter.');
    }
  }
}
