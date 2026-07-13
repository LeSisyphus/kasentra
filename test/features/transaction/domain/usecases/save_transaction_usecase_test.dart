import 'package:flutter_test/flutter_test.dart';
import 'package:kasentra/features/transaction/domain/entities/transaction.dart';
import 'package:kasentra/features/transaction/domain/entities/transaction_item.dart';
import 'package:kasentra/features/transaction/domain/repositories/transaction_repository.dart';
import 'package:kasentra/features/transaction/domain/usecases/save_transaction_usecase.dart';

void main() {
  group('SaveTransactionUseCase expense validation', () {
    late _FakeTransactionRepository repository;
    late SaveTransactionUseCase useCase;

    setUp(() {
      repository = _FakeTransactionRepository();
      useCase = SaveTransactionUseCase(repository);
    });

    test('saves valid expense with title and category', () async {
      final transaction = _createExpense();

      await useCase(transaction: transaction, items: const []);

      expect(repository.savedTransaction, same(transaction));
      expect(repository.savedItems, isEmpty);
    });

    test('throws when expense title is empty', () {
      final transaction = _createExpense().copyWith(clearTitle: true);

      expect(
        () => useCase(transaction: transaction, items: const []),
        throwsA(isA<ArgumentError>()),
      );

      expect(repository.savedTransaction, isNull);
    });

    test('throws when expense category is empty', () {
      final transaction = _createExpense().copyWith(clearCategoryId: true);

      expect(
        () => useCase(transaction: transaction, items: const []),
        throwsA(isA<ArgumentError>()),
      );

      expect(repository.savedTransaction, isNull);
    });

    test('throws when expense contains sale items', () {
      final transaction = _createExpense();

      final items = [
        TransactionItem(
          id: 'item-1',
          transactionId: transaction.id,
          itemName: 'Beras',
          quantity: 1,
          sellingPrice: 50_000,
          costPrice: 40_000,
          subtotal: 50_000,
        ),
      ];

      expect(
        () => useCase(transaction: transaction, items: items),
        throwsA(isA<ArgumentError>()),
      );

      expect(repository.savedTransaction, isNull);
    });
  });
}

Transaction _createExpense() {
  final createdAt = DateTime(2026, 7, 13, 10);

  return Transaction(
    id: 'transaction-expense-1',
    businessId: 'business-1',
    type: TransactionType.expense,
    title: 'Pembelian stok beras',
    categoryId: 'category-stock',
    totalAmount: 250_000,
    costAmount: 0,
    profitAmount: 0,
    paymentStatus: PaymentStatus.paid,
    transactionDate: DateTime(2026, 7, 13),
    createdAt: createdAt,
    updatedAt: createdAt,
  );
}

class _FakeTransactionRepository implements TransactionRepository {
  Transaction? savedTransaction;
  List<TransactionItem>? savedItems;

  @override
  Future<void> saveTransaction({
    required Transaction transaction,
    required List<TransactionItem> items,
  }) async {
    savedTransaction = transaction;
    savedItems = List<TransactionItem>.unmodifiable(items);
  }

  @override
  Stream<List<Transaction>> watchTransactions({
    required String businessId,
    DateTime? startDate,
    DateTime? endDate,
    TransactionType? type,
  }) {
    return const Stream<List<Transaction>>.empty();
  }

  @override
  Future<Transaction?> getTransactionById({
    required String businessId,
    required String transactionId,
  }) async {
    return null;
  }

  @override
  Stream<List<TransactionItem>> watchTransactionItems({
    required String transactionId,
  }) {
    return const Stream<List<TransactionItem>>.empty();
  }

  @override
  Future<void> updatePaymentStatus({
    required String businessId,
    required String transactionId,
    required PaymentStatus paymentStatus,
    required DateTime updatedAt,
  }) async {}

  @override
  Future<void> deleteTransaction({
    required String businessId,
    required String transactionId,
  }) async {}
}
