import 'package:drift/drift.dart' show DatabaseConnection;
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kasentra/app/providers/database_providers.dart';
import 'package:kasentra/app/providers/product_providers.dart';
import 'package:kasentra/core/database/app_database.dart';
import 'package:kasentra/features/product/data/datasources/local_product_data_source.dart';
import 'package:kasentra/features/product/data/repositories/product_repository_impl.dart';
import 'package:kasentra/features/product/domain/repositories/product_repository.dart';
import 'package:kasentra/features/product/domain/usecases/get_product_by_id_usecase.dart';
import 'package:kasentra/features/product/domain/usecases/save_product_usecase.dart';
import 'package:kasentra/features/product/domain/usecases/set_product_active_usecase.dart';
import 'package:kasentra/features/product/domain/usecases/watch_products_usecase.dart';

void main() {
  group('product providers', () {
    test('creates local product dependencies', () async {
      final database = AppDatabase(
        DatabaseConnection(
          NativeDatabase.memory(),
          closeStreamsSynchronously: true,
        ),
      );

      final container = ProviderContainer.test(
        overrides: [appDatabaseProvider.overrideWithValue(database)],
      );

      addTearDown(() async {
        container.dispose();
        await database.close();
      });

      expect(
        container.read(localProductDataSourceProvider),
        isA<DriftLocalProductDataSource>(),
      );

      expect(
        container.read(productRepositoryProvider),
        isA<ProductRepositoryImpl>(),
      );

      expect(
        container.read(watchProductsUseCaseProvider),
        isA<WatchProductsUseCase>(),
      );

      expect(
        container.read(getProductByIdUseCaseProvider),
        isA<GetProductByIdUseCase>(),
      );

      expect(
        container.read(saveProductUseCaseProvider),
        isA<SaveProductUseCase>(),
      );

      expect(
        container.read(setProductActiveUseCaseProvider),
        isA<SetProductActiveUseCase>(),
      );
    });

    test('allows product repository override', () {
      final repository = _FakeProductRepository();

      final container = ProviderContainer.test(
        overrides: [productRepositoryProvider.overrideWithValue(repository)],
      );

      addTearDown(container.dispose);

      expect(container.read(productRepositoryProvider), same(repository));

      expect(
        container.read(watchProductsUseCaseProvider),
        isA<WatchProductsUseCase>(),
      );

      expect(
        container.read(getProductByIdUseCaseProvider),
        isA<GetProductByIdUseCase>(),
      );

      expect(
        container.read(saveProductUseCaseProvider),
        isA<SaveProductUseCase>(),
      );

      expect(
        container.read(setProductActiveUseCaseProvider),
        isA<SetProductActiveUseCase>(),
      );
    });
  });
}

final class _FakeProductRepository implements ProductRepository {
  @override
  dynamic noSuchMethod(Invocation invocation) {
    throw UnimplementedError(
      '${invocation.memberName} tidak digunakan '
      'pada provider test.',
    );
  }
}
