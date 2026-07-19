import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kasentra/core/database/app_database.dart';

void main() {
  group('AppDatabase', () {
    late AppDatabase database;

    setUp(() {
      database = AppDatabase(
        DatabaseConnection(
          NativeDatabase.memory(),
          closeStreamsSynchronously: true,
        ),
      );
    });

    tearDown(() async {
      await database.close();
    });

    test('uses schema version one', () {
      expect(database.schemaVersion, 1);
    });

    test('enables foreign key constraints', () async {
      final result = await database
          .customSelect('PRAGMA foreign_keys')
          .getSingle();

      expect(result.read<int>('foreign_keys'), 1);
    });

    test('creates all initial tables', () async {
      final rows = await database.customSelect('''
            SELECT name
            FROM sqlite_master
            WHERE type = 'table'
            ''').get();

      final tableNames = rows.map((row) => row.read<String>('name')).toSet();

      expect(
        tableNames,
        containsAll(const {
          'businesses',
          'categories',
          'products',
          'transactions',
          'transaction_items',
          'debts',
        }),
      );
    });
  });
}
