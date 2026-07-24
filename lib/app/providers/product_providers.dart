import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/product/data/datasources/local_product_data_source.dart';
import '../../features/product/data/repositories/product_repository_impl.dart';
import '../../features/product/domain/repositories/product_repository.dart';
import '../../features/product/domain/usecases/get_product_by_id_usecase.dart';
import '../../features/product/domain/usecases/save_product_usecase.dart';
import '../../features/product/domain/usecases/set_product_active_usecase.dart';
import '../../features/product/domain/usecases/watch_products_usecase.dart';
import 'database_providers.dart';

final localProductDataSourceProvider = Provider<LocalProductDataSource>((ref) {
  final database = ref.watch(appDatabaseProvider);

  return DriftLocalProductDataSource(database);
}, name: 'localProductDataSourceProvider');

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  final localDataSource = ref.watch(localProductDataSourceProvider);

  return ProductRepositoryImpl(localDataSource);
}, name: 'productRepositoryProvider');

final watchProductsUseCaseProvider = Provider<WatchProductsUseCase>((ref) {
  final repository = ref.watch(productRepositoryProvider);

  return WatchProductsUseCase(repository);
}, name: 'watchProductsUseCaseProvider');

final getProductByIdUseCaseProvider = Provider<GetProductByIdUseCase>((ref) {
  final repository = ref.watch(productRepositoryProvider);

  return GetProductByIdUseCase(repository);
}, name: 'getProductByIdUseCaseProvider');

final saveProductUseCaseProvider = Provider<SaveProductUseCase>((ref) {
  final repository = ref.watch(productRepositoryProvider);

  return SaveProductUseCase(repository);
}, name: 'saveProductUseCaseProvider');

final setProductActiveUseCaseProvider = Provider<SetProductActiveUseCase>((
  ref,
) {
  final repository = ref.watch(productRepositoryProvider);

  return SetProductActiveUseCase(repository);
}, name: 'setProductActiveUseCaseProvider');
