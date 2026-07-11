import 'package:kasentra/features/product/domain/entities/category.dart';
import 'package:kasentra/features/product/domain/repositories/category_repository.dart';

class WatchCategoriesUseCase {
  const WatchCategoriesUseCase(this._repository);

  final CategoryRepository _repository;

  Stream<List<Category>> call({
    required String businessId,
    CategoryType? type,
  }) {
    if (businessId.trim().isEmpty) {
      throw ArgumentError('Business id tidak boleh kosong.');
    }

    return _repository.watchCategories(businessId: businessId, type: type);
  }
}
