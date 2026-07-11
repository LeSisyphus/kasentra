import 'package:kasentra/features/profile/domain/entities/business.dart';
import 'package:kasentra/features/profile/domain/repositories/profile_repository.dart';

class SaveBusinessUseCase {
  const SaveBusinessUseCase(this._repository);

  final ProfileRepository _repository;

  Future<void> call(Business business) {
    _validateBusiness(business);
    return _repository.saveBusiness(business);
  }

  void _validateBusiness(Business business) {
    if (business.id.trim().isEmpty) {
      throw ArgumentError('Business id tidak boleh kosong.');
    }

    if (business.name.trim().isEmpty) {
      throw ArgumentError('Nama usaha tidak boleh kosong.');
    }

    if (business.ownerName.trim().isEmpty) {
      throw ArgumentError('Nama pemilik tidak boleh kosong.');
    }

    if (business.name.trim().length < 2) {
      throw ArgumentError('Nama usaha minimal 2 karakter.');
    }

    if (business.ownerName.trim().length < 2) {
      throw ArgumentError('Nama pemilik minimal 2 karakter.');
    }

    final phoneNumber = business.phoneNumber;

    if (phoneNumber != null && phoneNumber.trim().isEmpty) {
      throw ArgumentError(
        'Nomor telepon harus diisi atau dikosongkan sepenuhnya.',
      );
    }

    final address = business.address;

    if (address != null && address.trim().isEmpty) {
      throw ArgumentError('Alamat harus diisi atau dikosongkan sepenuhnya.');
    }

    if (business.updatedAt.isBefore(business.createdAt)) {
      throw ArgumentError(
        'Waktu pembaruan tidak boleh sebelum waktu pembuatan.',
      );
    }
  }
}
