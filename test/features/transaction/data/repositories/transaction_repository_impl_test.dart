import 'package:drift/drift.dart' show DatabaseConnection, Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kasentra/core/database/app_database.dart';
import 'package:kasentra/features/transaction/data/datasources/local_transaction_data_source.dart';
import 'package:kasentra/features/transaction/data/mappers/transaction_mapper.dart';
import 'package:kasentra/features/transaction/data/repositories/transaction_repository_impl.dart';
import 'package:kasentra/features/transaction/domain/entities/transaction.dart';

void main() {
  group('TransactionRepositoryImpl', () {
    late AppDatabase database;
    late TransactionRepositoryImpl repository;

    final createdAt = DateTime.utc(2025, 1, 1, 8);
    final updatedAt = DateTime.utc(2025, 1, 1, 9);

    setUp(() async {
      database = AppDatabase(
        DatabaseConnection(
          NativeDatabase.memory(),
          closeStreamsSynchronously: true,
        ),
      );

      repository = TransactionRepositoryImpl(
        DriftLocalTransactionDataSource(database),
      );

      await database
          .into(database.businesses)
          .insert(
            BusinessesCompanion.insert(
              id: 'business-1',
              name: 'Toko Kasentra',
              ownerName: 'Ibu',
              createdAt: createdAt,
              updatedAt: updatedAt,
            ),
          );

      await database
          .into(database.businesses)
          .insert(
            BusinessesCompanion.insert(
              id: 'business-2',
              name: 'Toko Lain',
              ownerName: 'Pemilik Lain',
              createdAt: createdAt,
              updatedAt: updatedAt,
            ),
          );

      await database
          .into(database.categories)
          .insert(
            CategoriesCompanion.insert(
              id: 'category-expense-1',
              businessId: 'business-1',
              type: 'expense',
              name: 'Operasional',
              createdAt: createdAt,
              updatedAt: updatedAt,
            ),
          );
    });

    tearDown(() async {
      await database.close();
    });

    Transaction expense({
      required String id,
      required DateTime transactionDate,
      int totalAmount = 10000,
    }) {
      return Transaction(
        id: id,
        businessId: 'business-1',
        type: TransactionType.expense,
        title: 'Pengeluaran $id',
        categoryId: 'category-expense-1',
        totalAmount: totalAmount,
        costAmount: 0,
        profitAmount: 0,
        paymentStatus: PaymentStatus.paid,
        transactionDate: transactionDate,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
    }

    Transaction sale({
      required String id,
      required DateTime transactionDate,
      PaymentStatus paymentStatus = PaymentStatus.paid,
    }) {
      return Transaction(
        id: id,
        businessId: 'business-1',
        type: TransactionType.sale,
        totalAmount: 25000,
        costAmount: 15000,
        profitAmount: 10000,
        paymentStatus: paymentStatus,
        contactName: paymentStatus == PaymentStatus.unpaid ? 'Pelanggan' : null,
        transactionDate: transactionDate,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
    }

    Future<void> insertSale(Transaction transaction) {
      return database
          .into(database.transactions)
          .insert(TransactionMapper.toCompanion(transaction));
    }

    test('saves and reads an expense', () async {
      final transaction = expense(
        id: 'expense-1',
        transactionDate: DateTime.utc(2025, 1, 10),
        totalAmount: 150000,
      );

      await repository.saveExpense(transaction);

      final result = await repository.getTransactionById(
        businessId: 'business-1',
        transactionId: 'expense-1',
      );

      expect(result, isNotNull);
      expect(result!.id, 'expense-1');
      expect(result.type, TransactionType.expense);
      expect(result.title, 'Pengeluaran expense-1');
      expect(result.totalAmount, 150000);

      final storedRow = await (database.select(
        database.transactions,
      )..where((row) => row.id.equals('expense-1'))).getSingle();

      expect(storedRow.syncedAt, isNull);
    });

    test('rejects saving a sale through saveExpense', () async {
      expect(
        () => repository.saveExpense(
          sale(id: 'sale-1', transactionDate: DateTime.utc(2025, 1, 10)),
        ),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('uses deterministic cursor pagination', () async {
      final date = DateTime.utc(2025, 1, 20);

      await repository.saveExpense(
        expense(id: 'transaction-1', transactionDate: date),
      );
      await repository.saveExpense(
        expense(id: 'transaction-3', transactionDate: date),
      );
      await repository.saveExpense(
        expense(id: 'transaction-2', transactionDate: date),
      );

      final firstPage = await repository.getTransactionsPage(
        businessId: 'business-1',
        limit: 2,
      );

      expect(firstPage.items.map((item) => item.id), [
        'transaction-3',
        'transaction-2',
      ]);
      expect(firstPage.hasMore, isTrue);
      expect(firstPage.nextCursor, isNotNull);
      expect(firstPage.nextCursor!.transactionId, 'transaction-2');

      final secondPage = await repository.getTransactionsPage(
        businessId: 'business-1',
        limit: 2,
        cursor: firstPage.nextCursor,
      );

      expect(secondPage.items.map((item) => item.id), ['transaction-1']);
      expect(secondPage.hasMore, isFalse);
      expect(secondPage.nextCursor, isNull);
    });

    test('filters by date and transaction type', () async {
      await repository.saveExpense(
        expense(id: 'expense-old', transactionDate: DateTime.utc(2025, 1, 5)),
      );

      await repository.saveExpense(
        expense(
          id: 'expense-current',
          transactionDate: DateTime.utc(2025, 1, 20),
        ),
      );

      await insertSale(
        sale(id: 'sale-current', transactionDate: DateTime.utc(2025, 1, 21)),
      );

      final page = await repository.getTransactionsPage(
        businessId: 'business-1',
        startDate: DateTime.utc(2025, 1, 10),
        endDate: DateTime.utc(2025, 1, 31),
        type: TransactionType.expense,
        limit: 20,
      );

      expect(page.items.map((item) => item.id), ['expense-current']);
    });

    test('updates payment status within the active business', () async {
      await insertSale(
        sale(
          id: 'sale-unpaid',
          transactionDate: DateTime.utc(2025, 1, 20),
          paymentStatus: PaymentStatus.unpaid,
        ),
      );

      final newUpdatedAt = DateTime.utc(2025, 1, 25);

      await repository.updatePaymentStatus(
        businessId: 'business-1',
        transactionId: 'sale-unpaid',
        paymentStatus: PaymentStatus.paid,
        updatedAt: newUpdatedAt,
      );

      final result = await repository.getTransactionById(
        businessId: 'business-1',
        transactionId: 'sale-unpaid',
      );

      expect(result, isNotNull);
      expect(result!.paymentStatus, PaymentStatus.paid);
      expect(result.updatedAt.isAtSameMomentAs(newUpdatedAt), isTrue);
    });

    test('rejects updating a transaction from another business', () async {
      await insertSale(
        sale(id: 'sale-1', transactionDate: DateTime.utc(2025, 1, 20)),
      );

      await expectLater(
        repository.updatePaymentStatus(
          businessId: 'business-2',
          transactionId: 'sale-1',
          paymentStatus: PaymentStatus.paid,
          updatedAt: DateTime.utc(2025, 1, 25),
        ),
        throwsA(isA<StateError>()),
      );
    });

    test('watches and maps transaction items', () async {
      await insertSale(
        sale(id: 'sale-items', transactionDate: DateTime.utc(2025, 1, 20)),
      );

      await database
          .into(database.transactionItems)
          .insert(
            const TransactionItemsCompanion(
              id: Value('item-1'),
              transactionId: Value('sale-items'),
              productId: Value(null),
              itemName: Value('Beras'),
              quantity: Value(2),
              sellingPrice: Value(15000),
              costPrice: Value(null),
              subtotal: Value(30000),
            ),
          );

      final items = await repository
          .watchTransactionItems(transactionId: 'sale-items')
          .first;

      expect(items, hasLength(1));
      expect(items.single.id, 'item-1');
      expect(items.single.itemName, 'Beras');
      expect(items.single.costPrice, 0);
      expect(items.single.subtotal, 30000);

      expect(() => items.clear(), throwsUnsupportedError);
    });

    test('deletes only a transaction owned by the active business', () async {
      await repository.saveExpense(
        expense(
          id: 'expense-delete',
          transactionDate: DateTime.utc(2025, 1, 20),
        ),
      );

      await repository.deleteTransaction(
        businessId: 'business-1',
        transactionId: 'expense-delete',
      );

      final result = await repository.getTransactionById(
        businessId: 'business-1',
        transactionId: 'expense-delete',
      );

      expect(result, isNull);
    });

    test('rejects deleting a transaction from another business', () async {
      await repository.saveExpense(
        expense(id: 'expense-1', transactionDate: DateTime.utc(2025, 1, 20)),
      );

      await expectLater(
        repository.deleteTransaction(
          businessId: 'business-2',
          transactionId: 'expense-1',
        ),
        throwsA(isA<StateError>()),
      );
    });
  });
}
