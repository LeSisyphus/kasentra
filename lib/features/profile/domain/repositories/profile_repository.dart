import 'package:kasentra/features/profile/domain/entities/business.dart';

abstract class ProfileRepository {
  Stream<Business?> watchBusiness();

  Future<Business?> getBusiness();

  Future<void> saveBusiness(Business business);
}
