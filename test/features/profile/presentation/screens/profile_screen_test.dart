import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kasentra/app/providers/profile_providers.dart';
import 'package:kasentra/app/theme/kasentra_theme.dart';
import 'package:kasentra/features/profile/domain/entities/business.dart';
import 'package:kasentra/features/profile/presentation/screens/profile_screen.dart';

void main() {
  group('ProfileScreen', () {
    testWidgets('shows loading state', (tester) async {
      final controller = StreamController<Business?>();

      addTearDown(controller.close);

      await _pumpProfileScreen(tester, stream: controller.stream);

      expect(find.byKey(const Key('profile-loading')), findsOneWidget);
    });

    testWidgets('shows empty state when business does not exist', (
      tester,
    ) async {
      await _pumpProfileScreen(tester, stream: Stream.value(null));

      await tester.pumpAndSettle();

      expect(find.byKey(const Key('profile-empty')), findsOneWidget);

      expect(find.text('Profil usaha belum disiapkan'), findsOneWidget);

      expect(find.text('Siapkan Profil Usaha'), findsOneWidget);
    });

    testWidgets('passes null when setting up the first business', (
      tester,
    ) async {
      Business? callbackValue;
      var callbackCalled = false;

      await _pumpProfileScreen(
        tester,
        stream: Stream.value(null),
        onEditBusiness: (business) {
          callbackCalled = true;
          callbackValue = business;
        },
      );

      await tester.pumpAndSettle();

      await tester.tap(find.text('Siapkan Profil Usaha'));

      await tester.pump();

      expect(callbackCalled, isTrue);
      expect(callbackValue, isNull);
    });

    testWidgets('shows active business data', (tester) async {
      final business = Business(
        id: 'business-1',
        name: 'Toko Kasentra',
        ownerName: 'Ibu Lina',
        type: BusinessType.groceryStore,
        phoneNumber: '081234567890',
        address: 'Jalan Mawar',
        createdAt: DateTime.utc(2025, 1, 1),
        updatedAt: DateTime.utc(2025, 1, 1),
      );

      await _pumpProfileScreen(tester, stream: Stream.value(business));

      await tester.pumpAndSettle();

      expect(find.byKey(const Key('profile-content')), findsOneWidget);

      expect(find.text('Toko Kasentra'), findsOneWidget);
      expect(find.text('Ibu Lina'), findsOneWidget);
      expect(find.text('081234567890'), findsOneWidget);
      expect(find.text('Jalan Mawar'), findsOneWidget);
      expect(find.text('Toko Sembako'), findsNWidgets(2));
    });

    testWidgets('shows fallback text for optional fields', (tester) async {
      final business = Business(
        id: 'business-1',
        name: 'Toko Kasentra',
        ownerName: 'Ibu Lina',
        type: BusinessType.retail,
        createdAt: DateTime.utc(2025, 1, 1),
        updatedAt: DateTime.utc(2025, 1, 1),
      );

      await _pumpProfileScreen(tester, stream: Stream.value(business));

      await tester.pumpAndSettle();

      expect(find.text('Belum diisi'), findsNWidgets(2));
    });

    testWidgets('shows error state', (tester) async {
      await _pumpProfileScreen(
        tester,
        stream: Stream<Business?>.error(StateError('database failure')),
      );

      await tester.pumpAndSettle();

      expect(find.byKey(const Key('profile-error')), findsOneWidget);

      expect(find.text('Profil usaha gagal dimuat.'), findsOneWidget);

      expect(find.text('database failure'), findsNothing);
    });

    testWidgets('passes active business to edit callback', (tester) async {
      Business? selectedBusiness;

      final business = Business(
        id: 'business-1',
        name: 'Toko Kasentra',
        ownerName: 'Ibu Lina',
        type: BusinessType.groceryStore,
        createdAt: DateTime.utc(2025, 1, 1),
        updatedAt: DateTime.utc(2025, 1, 1),
      );

      await _pumpProfileScreen(
        tester,
        stream: Stream.value(business),
        onEditBusiness: (value) {
          selectedBusiness = value;
        },
      );

      await tester.pumpAndSettle();

      await tester.tap(find.text('Edit Profil Usaha'));

      await tester.pump();

      expect(selectedBusiness, same(business));
    });
  });
}

Future<void> _pumpProfileScreen(
  WidgetTester tester, {
  required Stream<Business?> stream,
  ValueChanged<Business?>? onEditBusiness,
}) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [activeBusinessProvider.overrideWith((ref) => stream)],
      child: MaterialApp(
        theme: KasentraTheme.lightTheme,
        home: Scaffold(body: ProfileScreen(onEditBusiness: onEditBusiness)),
      ),
    ),
  );

  await tester.pump();
}
