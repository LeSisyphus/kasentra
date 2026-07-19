import '../entities/business.dart';
import '../repositories/profile_repository.dart';

class WatchActiveBusinessUseCase {
  const WatchActiveBusinessUseCase(this._repository);

  final ProfileRepository _repository;

  Stream<Business?> call() {
    return _repository.watchActiveBusiness();
  }
}
