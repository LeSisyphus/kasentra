import 'package:kasentra/features/profile/domain/entities/business.dart';

abstract class ProfileRepository {
  /// Mengamati usaha aktif pada instalasi lokal.
  ///
  /// MVP hanya mendukung satu usaha. Implementasi lokal harus memilih row
  /// pertama secara deterministik ketika database belum memiliki konsep
  /// pemilihan usaha aktif.
  Stream<Business?> watchActiveBusiness();

  Stream<Business?> watchBusiness({required String businessId});

  Future<Business?> getBusinessById({required String businessId});

  Future<void> saveBusiness(Business business);
}
