import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/product/data/datasources/local_category_data_source.dart';
import '../../features/product/data/repositories/category_repository_impl.dart';
import '../../features/product/domain/entities/category.dart';
import '../../features/product/domain/repositories/category_repository.dart';
import '../../features/product/domain/usecases/ensure_default_expense_categories_usecase.dart';
import '../../features/product/domain/usecases/get_category_by_id_usecase.dart';
import '../../features/product/domain/usecases/save_category_usecase.dart';
import '../../features/product/domain/usecases/watch_categories_usecase.dart';
import 'database_providers.dart';

final localCategoryDataSourceProvider = Provider<LocalCategoryDataSource>((
  ref,
) {
  final database = ref.watch(appDatabaseProvider);

  return DriftLocalCategoryDataSource(database);
}, name: 'localCategoryDataSourceProvider');

final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  final localDataSource = ref.watch(localCategoryDataSourceProvider);

  return CategoryRepositoryImpl(localDataSource);
}, name: 'categoryRepositoryProvider');

final watchCategoriesUseCaseProvider = Provider<WatchCategoriesUseCase>((ref) {
  final repository = ref.watch(categoryRepositoryProvider);

  return WatchCategoriesUseCase(repository);
}, name: 'watchCategoriesUseCaseProvider');

final getCategoryByIdUseCaseProvider = Provider<GetCategoryByIdUseCase>((ref) {
  final repository = ref.watch(categoryRepositoryProvider);

  return GetCategoryByIdUseCase(repository);
}, name: 'getCategoryByIdUseCaseProvider');

final saveCategoryUseCaseProvider = Provider<SaveCategoryUseCase>((ref) {
  final repository = ref.watch(categoryRepositoryProvider);

  return SaveCategoryUseCase(repository);
}, name: 'saveCategoryUseCaseProvider');

final ensureDefaultExpenseCategoriesUseCaseProvider =
    Provider<EnsureDefaultExpenseCategoriesUseCase>((ref) {
      final repository = ref.watch(categoryRepositoryProvider);

      return EnsureDefaultExpenseCategoriesUseCase(repository);
    }, name: 'ensureDefaultExpenseCategoriesUseCaseProvider');

final expenseCategoriesProvider = StreamProvider.family<List<Category>, String>(
  (ref, businessId) {
    final watchCategories = ref.watch(watchCategoriesUseCaseProvider);

    return watchCategories(businessId: businessId, type: CategoryType.expense);
  },
  name: 'expenseCategoriesProvider',
);
