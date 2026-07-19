import 'package:flutter_test/flutter_test.dart';
import 'package:kasentra/features/profile/domain/entities/business.dart';
import 'package:kasentra/features/profile/domain/repositories/profile_repository.dart';
import 'package:kasentra/features/profile/domain/usecases/get_business_by_id_usecase.dart';

void main() {
  group('GetBusinessByIdUseCase', () {
    late _FakeProfileRepository repository;
    late GetBusinessByIdUseCase useCase;

    setUp(() {
      repository = _FakeProfileRepository();
      useCase = GetBusinessByIdUseCase(repository);
    });

    test('trims the business id before reading the repository', () async {
      final expected = Business(
        id: 'business-1',
        name: 'Toko Kasentra',
        ownerName: 'Ibu Lina',
        type: BusinessType.groceryStore,
        createdAt: DateTime.utc(2025, 1, 1),
        updatedAt: DateTime.utc(2025, 1, 1),
      );

      repository.result = expected;

      final result = await useCase(businessId: '  business-1  ');

      expect(repository.requestedBusinessId, 'business-1');
      expect(result, same(expected));
    });

    test('rejects an empty business id', () {
      expect(() => useCase(businessId: '   '), throwsA(isA<ArgumentError>()));
    });
  });
}

final class _FakeProfileRepository implements ProfileRepository {
  String? requestedBusinessId;
  Business? result;

  @override
  Future<Business?> getBusinessById({required String businessId}) async {
    requestedBusinessId = businessId;
    return result;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) {
    throw UnimplementedError(
      '${invocation.memberName} tidak digunakan dalam test ini.',
    );
  }
}
