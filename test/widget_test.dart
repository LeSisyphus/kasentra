import 'package:drift/drift.dart' show DatabaseConnection;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kasentra/app/app.dart';
import 'package:kasentra/app/providers/database_providers.dart';
import 'package:kasentra/core/database/app_database.dart';

void main() {
  testWidgets('Kasentra app renders home screen', (tester) async {
    final database = AppDatabase(
      DatabaseConnection(
        NativeDatabase.memory(),
        closeStreamsSynchronously: true,
      ),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [appDatabaseProvider.overrideWithValue(database)],
        child: const KasentraApp(),
      ),
    );

    expect(find.text('Kasentra'), findsOneWidget);
    expect(find.text('Toko Berkah'), findsOneWidget);

    // Lepaskan ProviderScope dan subscription Drift sebelum database ditutup.
    await tester.pumpWidget(const SizedBox.shrink());
    await database.close();
  });
}
