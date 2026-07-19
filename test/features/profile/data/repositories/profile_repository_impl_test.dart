import 'package:drift/drift.dart' show DatabaseConnection, Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kasentra/core/database/app_database.dart';
import 'package:kasentra/features/profile/data/datasources/local_profile_data_source.dart';
import 'package:kasentra/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:kasentra/features/profile/domain/entities/business.dart';

void main() {
  group('ProfileRepositoryImpl', () {
    late AppDatabase database;
    late ProfileRepositoryImpl repository;

    final createdAt = DateTime.utc(2025, 1, 1);

    setUp(() {
      database = AppDatabase(
        DatabaseConnection(
          NativeDatabase.memory(),
          closeStreamsSynchronously: true,
        ),
      );

      repository = ProfileRepositoryImpl(DriftLocalProfileDataSource(database));
    });

    tearDown(() async {
      await database.close();
    });

    Business createBusiness({
      String id = 'business-1',
      String name = 'Toko Kasentra',
      BusinessType type = BusinessType.groceryStore,
      DateTime? businessCreatedAt,
      DateTime? updatedAt,
    }) {
      final resolvedCreatedAt = businessCreatedAt ?? createdAt;

      return Business(
        id: id,
        name: name,
        ownerName: 'Yanti Ariani',
        type: type,
        phoneNumber: '081649353732',
        address: 'Jl. Pekapuran Raya, Gg. Timor-Timur',
        createdAt: resolvedCreatedAt,
        updatedAt: updatedAt ?? resolvedCreatedAt,
      );
    }

    test('returns null when business does not exist', () async {
      final result = await repository.getBusinessById(
        businessId: 'missing-business',
      );

      expect(result, isNull);
    });

    test('saves and reads a business', () async {
      await repository.saveBusiness(createBusiness());

      final result = await repository.getBusinessById(businessId: 'business-1');

      expect(result, isNotNull);
      expect(result!.id, 'business-1');
      expect(result.name, 'Toko Kasentra');
      expect(result.ownerName, 'Yanti Ariani');
      expect(result.type, BusinessType.groceryStore);
      expect(result.phoneNumber, '081649353732');
    });

    test('watch emits a saved business', () async {
      final emittedFuture = repository
          .watchBusiness(businessId: 'business-1')
          .firstWhere((business) => business != null);

      await repository.saveBusiness(createBusiness());

      final emitted = await emittedFuture;

      expect(emitted, isNotNull);
      expect(emitted!.name, 'Toko Kasentra');
      expect(emitted.type, BusinessType.groceryStore);
    });

    test('upserts an existing business and resets syncedAt', () async {
      await repository.saveBusiness(createBusiness());

      await (database.update(
        database.businesses,
      )..where((row) => row.id.equals('business-1'))).write(
        BusinessesCompanion(syncedAt: Value(DateTime.utc(2025, 1, 2))),
      );

      final newUpdatedAt = DateTime.utc(2025, 1, 3);

      await repository.saveBusiness(
        createBusiness(
          name: 'Toko Kasentra Baru',
          type: BusinessType.retail,
          updatedAt: newUpdatedAt,
        ),
      );

      final result = await repository.getBusinessById(businessId: 'business-1');

      expect(result, isNotNull);
      expect(result!.name, 'Toko Kasentra Baru');
      expect(result.type, BusinessType.retail);
      expect(result.updatedAt.isAtSameMomentAs(newUpdatedAt), isTrue);

      final storedRow = await (database.select(
        database.businesses,
      )..where((row) => row.id.equals('business-1'))).getSingle();

      expect(storedRow.businessType, 'retail');
      expect(storedRow.syncedAt, isNull);
    });
    test('watches the oldest business as the active business', () async {
      await repository.saveBusiness(
        createBusiness(
          id: 'business-later',
          name: 'Usaha Kedua',
          businessCreatedAt: DateTime.utc(2025, 1, 2),
        ),
      );

      await repository.saveBusiness(
        createBusiness(
          id: 'business-first',
          name: 'Usaha Pertama',
          businessCreatedAt: DateTime.utc(2025, 1, 1),
        ),
      );

      final result = await repository.watchActiveBusiness().firstWhere(
        (business) => business != null,
      );

      expect(result, isNotNull);
      expect(result!.id, 'business-first');
      expect(result.name, 'Usaha Pertama');
    });
  });
}
