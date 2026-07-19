import '../../../../core/database/app_database.dart';

abstract interface class LocalProfileDataSource {
  Stream<BusinessRow?> watchBusiness({required String businessId});

  Future<BusinessRow?> getBusinessById({required String businessId});

  Future<void> saveBusiness(BusinessesCompanion companion);
}

final class DriftLocalProfileDataSource implements LocalProfileDataSource {
  const DriftLocalProfileDataSource(this._database);

  final AppDatabase _database;

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
