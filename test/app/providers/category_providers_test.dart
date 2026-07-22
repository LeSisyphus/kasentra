import 'package:drift/drift.dart' show DatabaseConnection;
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kasentra/app/providers/category_providers.dart';
import 'package:kasentra/app/providers/database_providers.dart';
import 'package:kasentra/core/database/app_database.dart';
import 'package:kasentra/features/product/data/datasources/local_category_data_source.dart';
import 'package:kasentra/features/product/data/repositories/category_repository_impl.dart';
import 'package:kasentra/features/product/domain/usecases/ensure_default_expense_categories_usecase.dart';
import 'package:kasentra/features/product/domain/usecases/get_category_by_id_usecase.dart';
import 'package:kasentra/features/product/domain/usecases/save_category_usecase.dart';
import 'package:kasentra/features/product/domain/usecases/watch_categories_usecase.dart';

void main() {
  group('category providers', () {
    test('creates local category dependencies', () async {
      final database = AppDatabase(
        DatabaseConnection(
          NativeDatabase.memory(),
          closeStreamsSynchronously: true,
        ),
      );

      final container = ProviderContainer(
        overrides: [appDatabaseProvider.overrideWithValue(database)],
      );

      addTearDown(() async {
        container.dispose();
        await database.close();
      });

      expect(
        container.read(localCategoryDataSourceProvider),
        isA<DriftLocalCategoryDataSource>(),
      );

      expect(
        container.read(categoryRepositoryProvider),
        isA<CategoryRepositoryImpl>(),
      );

      expect(
        container.read(watchCategoriesUseCaseProvider),
        isA<WatchCategoriesUseCase>(),
      );

      expect(
        container.read(getCategoryByIdUseCaseProvider),
        isA<GetCategoryByIdUseCase>(),
      );

      expect(
        container.read(saveCategoryUseCaseProvider),
        isA<SaveCategoryUseCase>(),
      );

      expect(
        container.read(ensureDefaultExpenseCategoriesUseCaseProvider),
        isA<EnsureDefaultExpenseCategoriesUseCase>(),
      );
    });
  });
}
