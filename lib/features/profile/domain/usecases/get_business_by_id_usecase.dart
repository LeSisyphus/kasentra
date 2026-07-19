import 'package:kasentra/features/profile/domain/entities/business.dart';
import 'package:kasentra/features/profile/domain/repositories/profile_repository.dart';

class GetBusinessByIdUseCase {
  const GetBusinessByIdUseCase(this._repository);

  final ProfileRepository _repository;

  Future<Business?> call({required String businessId}) {
    final normalizedBusinessId = businessId.trim();

    if (normalizedBusinessId.isEmpty) {
      throw ArgumentError('Business id tidak boleh kosong.');
    }

    return _repository.getBusinessById(businessId: normalizedBusinessId);
  }
}
