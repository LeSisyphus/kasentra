import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kasentra/core/database/app_database.dart';

void main() {
  group('AppDatabase constraints', () {
    late AppDatabase database;
    late DateTime now;

    setUp(() {
      database = AppDatabase(
        DatabaseConnection(
          NativeDatabase.memory(),
          closeStreamsSynchronously: true,
        ),
      );

      now = DateTime.utc(2025, 1, 1);
    });

    tearDown(() async {
      await database.close();
    });

    Future<void> insertBusiness() async {
      await database
          .into(database.businesses)
          .insert(
            BusinessesCompanion.insert(
              id: 'business-1',
              name: 'Toko Kasentra',
              ownerName: 'Ibu',
              createdAt: now,
              updatedAt: now,
            ),
          );
    }

    Future<void> insertProductCategory() async {
      await database
          .into(database.categories)
          .insert(
            CategoriesCompanion.insert(
              id: 'category-product-1',
              businessId: 'business-1',
              type: 'product',
              name: 'Sembako',
              createdAt: now,
              updatedAt: now,
            ),
          );
    }

    test('rejects a category with an unknown business', () async {
      await expectLater(
        database
            .into(database.categories)
            .insert(
              CategoriesCompanion.insert(
                id: 'category-1',
                businessId: 'missing-business',
                type: 'product',
                name: 'Sembako',
                createdAt: now,
                updatedAt: now,
              ),
            ),
        throwsA(isA<Exception>()),
      );
    });

    test('rejects a product with a negative selling price', () async {
      await insertBusiness();
      await insertProductCategory();

      await expectLater(
        database
            .into(database.products)
            .insert(
              ProductsCompanion.insert(
                id: 'product-1',
                businessId: 'business-1',
                categoryId: 'category-product-1',
                name: 'Beras 5kg',
                sellingPrice: -1000,
                createdAt: now,
                updatedAt: now,
              ),
            ),
        throwsA(isA<Exception>()),
      );
    });

    test('rejects an unpaid sale without a contact name', () async {
      await insertBusiness();

      await expectLater(
        database
            .into(database.transactions)
            .insert(
              TransactionsCompanion.insert(
                id: 'transaction-1',
                businessId: 'business-1',
                type: 'sale',
                totalAmount: 10000,
                paymentStatus: const Value('unpaid'),
                transactionDate: now,
                createdAt: now,
                updatedAt: now,
              ),
            ),
        throwsA(isA<Exception>()),
      );
    });

    test(
      'deleting a transaction removes items but preserves linked debt',
      () async {
        await insertBusiness();

        await database
            .into(database.transactions)
            .insert(
              TransactionsCompanion.insert(
                id: 'transaction-1',
                businessId: 'business-1',
                type: 'sale',
                totalAmount: 10000,
                transactionDate: now,
                createdAt: now,
                updatedAt: now,
              ),
            );

        await database
            .into(database.transactionItems)
            .insert(
              TransactionItemsCompanion.insert(
                id: 'item-1',
                transactionId: 'transaction-1',
                itemName: 'Beras',
                quantity: 1,
                sellingPrice: 10000,
                subtotal: 10000,
              ),
            );

        await database
            .into(database.debts)
            .insert(
              DebtsCompanion.insert(
                id: 'debt-1',
                businessId: 'business-1',
                sourceTransactionId: const Value('transaction-1'),
                type: 'receivable',
                contactName: 'Pelanggan',
                amount: 10000,
                remainingAmount: 10000,
                debtDate: now,
                createdAt: now,
                updatedAt: now,
              ),
            );

        await (database.delete(
          database.transactions,
        )..where((transaction) => transaction.id.equals('transaction-1'))).go();

        final remainingItems = await database
            .select(database.transactionItems)
            .get();

        expect(remainingItems, isEmpty);

        final debt = await (database.select(
          database.debts,
        )..where((row) => row.id.equals('debt-1'))).getSingle();

        expect(debt.sourceTransactionId, isNull);
        expect(debt.amount, 10000);
      },
    );
  });
}
