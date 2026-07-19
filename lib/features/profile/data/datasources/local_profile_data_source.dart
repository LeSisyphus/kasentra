import 'package:drift/drift.dart' show OrderingTerm;

import '../../../../core/database/app_database.dart';

abstract interface class LocalProfileDataSource {
  Stream<BusinessRow?> watchActiveBusiness();

  Stream<BusinessRow?> watchBusiness({required String businessId});

  Future<BusinessRow?> getBusinessById({required String businessId});

  Future<void> saveBusiness(BusinessesCompanion companion);
}

final class DriftLocalProfileDataSource implements LocalProfileDataSource {
  const DriftLocalProfileDataSource(this._database);

  final AppDatabase _database;

  @override
  Stream<BusinessRow?> watchActiveBusiness() {
    final query = _database.select(_database.businesses)
      ..orderBy([
        (row) => OrderingTerm.asc(row.createdAt),
        (row) => OrderingTerm.asc(row.id),
      ])
      ..limit(1);

    return query.watchSingleOrNull();
  }

  @override
  Stream<BusinessRow?> watchBusiness({required String businessId}) {
    final query = _database.select(_database.businesses)
      ..where((row) => row.id.equals(businessId));

    return query.watchSingleOrNull();
  }

  @override
  Future<BusinessRow?> getBusinessById({required String businessId}) {
    final query = _database.select(_database.businesses)
      ..where((row) => row.id.equals(businessId));

    return query.getSingleOrNull();
  }

  @override
  Future<void> saveBusiness(BusinessesCompanion companion) async {
    await _database
        .into(_database.businesses)
        .insertOnConflictUpdate(companion);
  }
}
