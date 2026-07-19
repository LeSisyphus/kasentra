import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kasentra/app/providers/profile_providers.dart';
import 'package:kasentra/app/theme/kasentra_theme.dart';
import 'package:kasentra/features/profile/domain/entities/business.dart';
import 'package:kasentra/features/profile/domain/repositories/profile_repository.dart';
import 'package:kasentra/features/profile/domain/usecases/save_business_usecase.dart';
import 'package:kasentra/features/profile/presentation/screens/profile_form_screen.dart';

void main() {
  group('ProfileFormScreen', () {
    testWidgets('creates the first business', (tester) async {
      final repository = _FakeProfileRepository();
      final now = DateTime.utc(2025, 2, 1, 10);

      await _openForm(
        tester,
        repository: repository,
        now: () => now,
        idGenerator: (_) => 'business-generated',
      );

      await tester.enterText(
        find.byKey(const Key('profile-form-name-field')),
        '  Toko Kasentra  ',
      );

      await tester.enterText(
        find.byKey(const Key('profile-form-owner-field')),
        '  Ibu Lina  ',
      );

      await tester.enterText(
        find.byKey(const Key('profile-form-phone-field')),
        ' 081234567890 ',
      );

      await tester.enterText(
        find.byKey(const Key('profile-form-address-field')),
        ' Jalan Mawar ',
      );

      await tester.tap(find.byKey(const Key('profile-form-save-button')));

      await tester.pumpAndSettle();

      expect(repository.savedBusinesses, hasLength(1));

      final saved = repository.savedBusinesses.single;

      expect(saved.id, 'business-generated');
      expect(saved.name, 'Toko Kasentra');
      expect(saved.ownerName, 'Ibu Lina');
      expect(saved.type, BusinessType.groceryStore);
      expect(saved.phoneNumber, '081234567890');
      expect(saved.address, 'Jalan Mawar');

      expect(saved.createdAt.isAtSameMomentAs(now), isTrue);

      expect(saved.updatedAt.isAtSameMomentAs(now), isTrue);

      expect(find.byType(ProfileFormScreen), findsNothing);
    });

    testWidgets('edits business without changing identity', (tester) async {
      final repository = _FakeProfileRepository();

      final createdAt = DateTime.utc(2025, 1, 1);
      final updatedAt = DateTime.utc(2025, 2, 1);

      final initialBusiness = Business(
        id: 'business-1',
        name: 'Toko Lama',
        ownerName: 'Ibu Lina',
        type: BusinessType.retail,
        phoneNumber: '081234567890',
        address: 'Jalan Lama',
        createdAt: createdAt,
        updatedAt: createdAt,
      );

      await _openForm(
        tester,
        repository: repository,
        initialBusiness: initialBusiness,
        now: () => updatedAt,
        idGenerator: (_) {
          throw StateError('Generator ID tidak boleh dipanggil saat edit.');
        },
      );

      expect(find.text('Toko Lama'), findsOneWidget);
      expect(find.text('Ibu Lina'), findsOneWidget);

      await tester.enterText(
        find.byKey(const Key('profile-form-name-field')),
        'Toko Baru',
      );

      await tester.tap(find.byKey(const Key('profile-form-save-button')));

      await tester.pumpAndSettle();

      expect(repository.savedBusinesses, hasLength(1));

      final saved = repository.savedBusinesses.single;

      expect(saved.id, 'business-1');
      expect(saved.name, 'Toko Baru');

      expect(saved.createdAt.isAtSameMomentAs(createdAt), isTrue);

      expect(saved.updatedAt.isAtSameMomentAs(updatedAt), isTrue);
    });

    testWidgets('normalizes empty optional fields to null', (tester) async {
      final repository = _FakeProfileRepository();

      await _openForm(
        tester,
        repository: repository,
        now: () => DateTime.utc(2025, 2, 1),
        idGenerator: (_) => 'business-1',
      );

      await tester.enterText(
        find.byKey(const Key('profile-form-name-field')),
        'Toko Kasentra',
      );

      await tester.enterText(
        find.byKey(const Key('profile-form-owner-field')),
        'Ibu Lina',
      );

      await tester.enterText(
        find.byKey(const Key('profile-form-phone-field')),
        '   ',
      );

      await tester.enterText(
        find.byKey(const Key('profile-form-address-field')),
        '   ',
      );

      await tester.tap(find.byKey(const Key('profile-form-save-button')));

      await tester.pumpAndSettle();

      final saved = repository.savedBusinesses.single;

      expect(saved.phoneNumber, isNull);
      expect(saved.address, isNull);
    });

    testWidgets('rejects invalid required fields', (tester) async {
      final repository = _FakeProfileRepository();

      await _openForm(
        tester,
        repository: repository,
        now: () => DateTime.utc(2025, 2, 1),
        idGenerator: (_) => 'business-1',
      );

      await tester.tap(find.byKey(const Key('profile-form-save-button')));

      await tester.pump();

      expect(find.text('Nama usaha wajib diisi.'), findsOneWidget);

      expect(find.text('Nama pemilik wajib diisi.'), findsOneWidget);

      expect(repository.saveCalls, 0);

      expect(find.byType(ProfileFormScreen), findsOneWidget);
    });

    testWidgets('shows safe message when saving fails', (tester) async {
      final repository = _FakeProfileRepository(
        saveError: StateError('database failure'),
      );

      await _openForm(
        tester,
        repository: repository,
        now: () => DateTime.utc(2025, 2, 1),
        idGenerator: (_) => 'business-1',
      );

      await tester.enterText(
        find.byKey(const Key('profile-form-name-field')),
        'Toko Kasentra',
      );

      await tester.enterText(
        find.byKey(const Key('profile-form-owner-field')),
        'Ibu Lina',
      );

      await tester.tap(find.byKey(const Key('profile-form-save-button')));

      await tester.pumpAndSettle();

      expect(repository.saveCalls, 1);

      expect(find.byKey(const Key('profile-form-error')), findsOneWidget);

      expect(
        find.text('Profil usaha gagal disimpan. Coba lagi.'),
        findsOneWidget,
      );

      expect(find.text('database failure'), findsNothing);

      expect(find.byType(ProfileFormScreen), findsOneWidget);
    });
  });
}

Future<void> _openForm(
  WidgetTester tester, {
  required _FakeProfileRepository repository,
  Business? initialBusiness,
  DateTime Function()? now,
  String Function(DateTime timestamp)? idGenerator,
}) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        saveBusinessUseCaseProvider.overrideWithValue(
          SaveBusinessUseCase(repository),
        ),
      ],
      child: MaterialApp(
        theme: KasentraTheme.lightTheme,
        home: Builder(
          builder: (context) {
            return Scaffold(
              body: Center(
                child: FilledButton(
                  key: const Key('open-profile-form'),
                  onPressed: () {
                    Navigator.of(context).push<bool>(
                      MaterialPageRoute<bool>(
                        builder: (_) {
                          return ProfileFormScreen(
                            initialBusiness: initialBusiness,
                            now: now,
                            idGenerator: idGenerator,
                          );
                        },
                      ),
                    );
                  },
                  child: const Text('Buka Form'),
                ),
              ),
            );
          },
        ),
      ),
    ),
  );

  await tester.tap(find.byKey(const Key('open-profile-form')));

  await tester.pumpAndSettle();
}

final class _FakeProfileRepository implements ProfileRepository {
  _FakeProfileRepository({this.saveError});

  final Object? saveError;

  final List<Business> savedBusinesses = [];

  int saveCalls = 0;

  @override
  Future<void> saveBusiness(Business business) async {
    saveCalls++;

    final error = saveError;

    if (error != null) {
      throw error;
    }

    savedBusinesses.add(business);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) {
    throw UnimplementedError(
      '${invocation.memberName} tidak digunakan dalam test ini.',
    );
  }
}
