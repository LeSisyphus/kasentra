import '../../domain/entities/category.dart';
import '../../domain/repositories/category_repository.dart';
import '../datasources/local_category_data_source.dart';
import '../mappers/category_mapper.dart';

final class CategoryRepositoryImpl implements CategoryRepository {
  const CategoryRepositoryImpl(this._localDataSource);

  final LocalCategoryDataSource _localDataSource;

  @override
  Stream<List<Category>> watchCategories({
    required String businessId,
    CategoryType? type,
  }) {
    return _localDataSource
        .watchCategories(businessId: businessId, type: _typeToStorage(type))
        .map(
          (rows) =>
              List<Category>.unmodifiable(rows.map(CategoryMapper.toDomain)),
        );
  }

  @override
  Future<Category?> getCategoryById({
    required String businessId,
    required String categoryId,
  }) async {
    final row = await _localDataSource.getCategoryById(
      businessId: businessId,
      categoryId: categoryId,
    );

    if (row == null) {
      return null;
    }

    return CategoryMapper.toDomain(row);
  }

  @override
  Future<void> saveCategory(Category category) {
    return _localDataSource.saveCategory(CategoryMapper.toCompanion(category));
  }

  String? _typeToStorage(CategoryType? type) {
    if (type == null) {
      return null;
    }

    return switch (type) {
      CategoryType.product => 'product',
      CategoryType.expense => 'expense',
    };
  }
}
