import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kasentra/app/providers/database_providers.dart';
import 'package:kasentra/core/database/app_database.dart';

void main() {
  group('database providers', () {
    test('allows database override for tests', () async {
      final database = AppDatabase(
        DatabaseConnection(
          NativeDatabase.memory(),
          closeStreamsSynchronously: true,
        ),
      );

      final container = ProviderContainer.test(
        overrides: [appDatabaseProvider.overrideWithValue(database)],
      );

      expect(container.read(appDatabaseProvider), same(database));

      container.dispose();
      await database.close();
    });
  });
}
