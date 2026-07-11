import 'package:kasentra/features/profile/domain/entities/business.dart';

abstract class ProfileRepository {
  Stream<Business?> watchBusiness({required String businessId});

  Future<Business?> getBusinessById({required String businessId});

  Future<void> saveBusiness(Business business);
}
