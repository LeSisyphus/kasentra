import 'package:kasentra/features/profile/domain/entities/business.dart';
import 'package:kasentra/features/profile/domain/repositories/profile_repository.dart';

class WatchBusinessUseCase {
  const WatchBusinessUseCase(this._repository);

  final ProfileRepository _repository;

  Stream<Business?> call({required String businessId}) {
    if (businessId.trim().isEmpty) {
      throw ArgumentError('Business id tidak boleh kosong.');
    }

    return _repository.watchBusiness(businessId: businessId);
  }
}
