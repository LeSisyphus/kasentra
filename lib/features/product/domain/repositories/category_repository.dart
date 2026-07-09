import 'package:kasentra/features/product/domain/entities/category.dart';

abstract class CategoryRepository {
  Stream<List<Category>> watchCategories({
    required String businessId,
    CategoryType? type,
  });

  Future<Category?> getCategoryById({
    required String businessId,
    required String categoryId,
  });

  Future<void> saveCategory(Category category);
}
