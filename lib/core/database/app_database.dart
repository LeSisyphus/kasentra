import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'tables/businesses.dart';
import 'tables/categories.dart';
import 'tables/debts.dart';
import 'tables/products.dart';
import 'tables/transaction_items.dart';
import 'tables/transactions.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Businesses,
    Categories,
    Products,
    Transactions,
    TransactionItems,
    Debts,
  ],
)
final class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
    : super(executor ?? driftDatabase(name: 'kasentra'));

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (migrator) async {
        await migrator.createAll();
      },
      beforeOpen: (_) async {
        await customStatement('PRAGMA foreign_keys = ON');
      },
    );
  }
}
