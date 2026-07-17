import 'package:flutter_test/flutter_test.dart';
import 'package:kasentra/features/transaction/domain/entities/transaction.dart';
import 'package:kasentra/features/transaction/domain/entities/transaction_item.dart';
import 'package:kasentra/features/transaction/domain/repositories/transaction_repository.dart';
import 'package:kasentra/features/transaction/domain/usecases/save_expense_usecase.dart';
import 'package:kasentra/features/transaction/domain/entities/transaction_page.dart';

void main() {
  group('SaveExpenseUseCase', () {
    late _FakeTransactionRepository repository;
    late SaveExpenseUseCase useCase;

    setUp(() {
      repository = _FakeTransactionRepository();
      useCase = SaveExpenseUseCase(repository);
    });

    test('saves a valid expense', () async {
      final expense = _createExpense();

      await useCase(expense);

      expect(repository.callCount, 1);
      expect(repository.savedExpense, same(expense));
    });

    test('throws when transaction is a sale', () {
      final expense = _createExpense();

      final sale = expense.copyWith(
        type: TransactionType.sale,
        clearTitle: true,
        clearCategoryId: true,
      );

      expect(() => useCase(sale), throwsA(isA<ArgumentError>()));

      expect(repository.callCount, 0);
    });

    test('throws when expense title is empty', () {
      final expense = _createExpense().copyWith(clearTitle: true);

      expect(() => useCase(expense), throwsA(isA<ArgumentError>()));

      expect(repository.callCount, 0);
    });

    test('throws when expense category is empty', () {
      final expense = _createExpense().copyWith(clearCategoryId: true);

      expect(() => useCase(expense), throwsA(isA<ArgumentError>()));

      expect(repository.callCount, 0);
    });

    test('throws when expense amount is not positive', () {
      final expense = _createExpense().copyWith(totalAmount: 0);

      expect(() => useCase(expense), throwsA(isA<ArgumentError>()));

      expect(repository.callCount, 0);
    });

    test('throws when expense is unpaid', () {
      final expense = _createExpense().copyWith(
        paymentStatus: PaymentStatus.unpaid,
      );

      expect(() => useCase(expense), throwsA(isA<ArgumentError>()));

      expect(repository.callCount, 0);
    });
  });
}

Transaction _createExpense() {
  final createdAt = DateTime(2026, 7, 13, 10);

  return Transaction(
    id: 'transaction-expense-1',
    businessId: 'business-1',
    type: TransactionType.expense,
    title: 'Bayar listrik',
    categoryId: 'category-operational',
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
  Transaction? savedExpense;
  int callCount = 0;

  @override
  Future<void> saveExpense(Transaction expense) async {
    callCount++;
    savedExpense = expense;
  }

  @override
  Future<TransactionPage> getTransactionsPage({
    required String businessId,
    DateTime? startDate,
    DateTime? endDate,
    TransactionType? type,
    required int limit,
    TransactionCursor? cursor,
  }) async {
    return TransactionPage(items: const [], hasMore: false);
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
