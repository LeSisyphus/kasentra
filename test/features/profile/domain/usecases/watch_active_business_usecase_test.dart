import 'package:flutter_test/flutter_test.dart';
import 'package:kasentra/features/profile/domain/entities/business.dart';
import 'package:kasentra/features/profile/domain/repositories/profile_repository.dart';
import 'package:kasentra/features/profile/domain/usecases/watch_active_business_usecase.dart';

void main() {
  test('delegates active business stream to repository', () async {
    final business = Business(
      id: 'business-1',
      name: 'Toko Kasentra',
      ownerName: 'Ibu Lina',
      type: BusinessType.groceryStore,
      createdAt: DateTime.utc(2025, 1, 1),
      updatedAt: DateTime.utc(2025, 1, 1),
    );

    final repository = _FakeProfileRepository(
      activeBusinessStream: Stream.value(business),
    );

    final useCase = WatchActiveBusinessUseCase(repository);

    final result = await useCase().first;

    expect(result, same(business));
  });
}

final class _FakeProfileRepository implements ProfileRepository {
  _FakeProfileRepository({required this.activeBusinessStream});

  final Stream<Business?> activeBusinessStream;

  @override
  Stream<Business?> watchActiveBusiness() {
    return activeBusinessStream;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) {
    throw UnimplementedError(
      '${invocation.memberName} tidak digunakan dalam test ini.',
    );
  }
}
