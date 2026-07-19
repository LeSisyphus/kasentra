import '../../domain/entities/business.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/local_profile_data_source.dart';
import '../mappers/business_mapper.dart';

final class ProfileRepositoryImpl implements ProfileRepository {
  const ProfileRepositoryImpl(this._localDataSource);

  final LocalProfileDataSource _localDataSource;

  @override
  Stream<Business?> watchBusiness({required String businessId}) {
    return _localDataSource
        .watchBusiness(businessId: businessId)
        .map((row) => row == null ? null : BusinessMapper.toDomain(row));
  }

  @override
  Future<Business?> getBusinessById({required String businessId}) async {
    final row = await _localDataSource.getBusinessById(businessId: businessId);

    if (row == null) {
      return null;
    }

    return BusinessMapper.toDomain(row);
  }

  @override
  Future<void> saveBusiness(Business business) {
    return _localDataSource.saveBusiness(BusinessMapper.toCompanion(business));
  }
}
