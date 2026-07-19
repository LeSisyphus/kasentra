import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/profile/data/datasources/local_profile_data_source.dart';
import '../../features/profile/data/repositories/profile_repository_impl.dart';
import '../../features/profile/domain/entities/business.dart';
import '../../features/profile/domain/repositories/profile_repository.dart';
import '../../features/profile/domain/usecases/get_business_by_id_usecase.dart';
import '../../features/profile/domain/usecases/save_business_usecase.dart';
import '../../features/profile/domain/usecases/watch_active_business_usecase.dart';
import '../../features/profile/domain/usecases/watch_business_usecase.dart';
import 'database_providers.dart';

final localProfileDataSourceProvider = Provider<LocalProfileDataSource>((ref) {
  final database = ref.watch(appDatabaseProvider);

  return DriftLocalProfileDataSource(database);
}, name: 'localProfileDataSourceProvider');

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  final localDataSource = ref.watch(localProfileDataSourceProvider);

  return ProfileRepositoryImpl(localDataSource);
}, name: 'profileRepositoryProvider');

final watchActiveBusinessUseCaseProvider = Provider<WatchActiveBusinessUseCase>(
  (ref) {
    final repository = ref.watch(profileRepositoryProvider);

    return WatchActiveBusinessUseCase(repository);
  },
  name: 'watchActiveBusinessUseCaseProvider',
);

final activeBusinessProvider = StreamProvider<Business?>((ref) {
  final watchActiveBusiness = ref.watch(watchActiveBusinessUseCaseProvider);

  return watchActiveBusiness();
}, name: 'activeBusinessProvider');

final watchBusinessUseCaseProvider = Provider<WatchBusinessUseCase>((ref) {
  final repository = ref.watch(profileRepositoryProvider);

  return WatchBusinessUseCase(repository);
}, name: 'watchBusinessUseCaseProvider');

final getBusinessByIdUseCaseProvider = Provider<GetBusinessByIdUseCase>((ref) {
  final repository = ref.watch(profileRepositoryProvider);

  return GetBusinessByIdUseCase(repository);
}, name: 'getBusinessByIdUseCaseProvider');

final saveBusinessUseCaseProvider = Provider<SaveBusinessUseCase>((ref) {
  final repository = ref.watch(profileRepositoryProvider);

  return SaveBusinessUseCase(repository);
}, name: 'saveBusinessUseCaseProvider');
