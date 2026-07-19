import 'package:drift/drift.dart' show DatabaseConnection;
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kasentra/app/providers/database_providers.dart';
import 'package:kasentra/app/providers/profile_providers.dart';
import 'package:kasentra/core/database/app_database.dart';
import 'package:kasentra/features/profile/data/datasources/local_profile_data_source.dart';
import 'package:kasentra/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:kasentra/features/profile/domain/usecases/get_business_by_id_usecase.dart';
import 'package:kasentra/features/profile/domain/usecases/save_business_usecase.dart';
import 'package:kasentra/features/profile/domain/usecases/watch_business_usecase.dart';

void main() {
  group('profile providers', () {
    test('creates local profile dependencies', () async {
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
        container.read(localProfileDataSourceProvider),
        isA<DriftLocalProfileDataSource>(),
      );

      expect(
        container.read(profileRepositoryProvider),
        isA<ProfileRepositoryImpl>(),
      );

      expect(
        container.read(watchBusinessUseCaseProvider),
        isA<WatchBusinessUseCase>(),
      );

      expect(
        container.read(getBusinessByIdUseCaseProvider),
        isA<GetBusinessByIdUseCase>(),
      );

      expect(
        container.read(saveBusinessUseCaseProvider),
        isA<SaveBusinessUseCase>(),
      );
    });
  });
}
