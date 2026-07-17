import 'package:flutter_test/flutter_test.dart';
import 'package:kasentra/features/transaction/domain/entities/transaction.dart';
import 'package:kasentra/features/transaction/domain/entities/transaction_item.dart';
import 'package:kasentra/features/transaction/domain/entities/transaction_page.dart';
import 'package:kasentra/features/transaction/domain/repositories/transaction_repository.dart';
import 'package:kasentra/features/transaction/domain/usecases/get_transactions_page_usecase.dart';

void main() {
  group('GetTransactionsPageUseCase', () {
    late _FakeTransactionRepository repository;
    late GetTransactionsPageUseCase useCase;

    setUp(() {
      repository = _FakeTransactionRepository();
      useCase = GetTransactionsPageUseCase(repository);
    });

    test('requests a transaction page using the supplied cursor', () async {
      final startDate = DateTime(2026, 7, 1);
      final endDate = DateTime(2026, 7, 31);

      final cursor = TransactionCursor(
        transactionDate: DateTime(2026, 7, 15, 10),
        transactionId: 'transaction-previous',
      );

      final result = await useCase(
        businessId: ' business-1 ',
        startDate: startDate,
        endDate: endDate,
        type: TransactionType.sale,
        limit: 25,
        cursor: cursor,
      );

      expect(result.items, hasLength(1));
      expect(repository.receivedBusinessId, 'business-1');
      expect(repository.receivedStartDate, startDate);
      expect(repository.receivedEndDate, endDate);
      expect(repository.receivedType, TransactionType.sale);
      expect(repository.receivedLimit, 25);
      expect(repository.receivedCursor, same(cursor));
      expect(repository.callCount, 1);
    });

    test('uses default page size', () async {
      await useCase(businessId: 'business-1');

      expect(
        repository.receivedLimit,
        GetTransactionsPageUseCase.defaultPageSize,
      );
    });

    test('throws when business id is empty', () {
      expect(() => useCase(businessId: '   '), throwsA(isA<ArgumentError>()));

      expect(repository.callCount, 0);
    });

    test('throws when limit is zero', () {
      expect(
        () => useCase(businessId: 'business-1', limit: 0),
        throwsA(isA<ArgumentError>()),
      );

      expect(repository.callCount, 0);
    });

    test('throws when limit exceeds maximum page size', () {
      expect(
        () => useCase(businessId: 'business-1', limit: 101),
        throwsA(isA<ArgumentError>()),
      );

      expect(repository.callCount, 0);
    });

    test('throws when date range is invalid', () {
      expect(
        () => useCase(
          businessId: 'business-1',
          startDate: DateTime(2026, 8, 1),
          endDate: DateTime(2026, 7, 31),
        ),
        throwsA(isA<ArgumentError>()),
      );

      expect(repository.callCount, 0);
    });

    test('throws when cursor transaction id is empty', () {
      final cursor = TransactionCursor(
        transactionDate: DateTime(2026, 7, 15),
        transactionId: '   ',
      );

      expect(
        () => useCase(businessId: 'business-1', cursor: cursor),
        throwsA(isA<ArgumentError>()),
      );

      expect(repository.callCount, 0);
    });
  });
}

class _FakeTransactionRepository implements TransactionRepository {
  String? receivedBusinessId;
  DateTime? receivedStartDate;
  DateTime? receivedEndDate;
  TransactionType? receivedType;
  int? receivedLimit;
  TransactionCursor? receivedCursor;
  int callCount = 0;

  @override
  Future<TransactionPage> getTransactionsPage({
    required String businessId,
    DateTime? startDate,
    DateTime? endDate,
    TransactionType? type,
    required int limit,
    TransactionCursor? cursor,
  }) async {
    callCount++;
    receivedBusinessId = businessId;
    receivedStartDate = startDate;
    receivedEndDate = endDate;
    receivedType = type;
    receivedLimit = limit;
    receivedCursor = cursor;

    final transactionDate = DateTime(2026, 7, 20, 10);

    return TransactionPage(
      items: [
        Transaction(
          id: 'transaction-1',
          businessId: businessId,
          type: TransactionType.sale,
          totalAmount: 100_000,
          costAmount: 60_000,
          profitAmount: 40_000,
          paymentStatus: PaymentStatus.paid,
          transactionDate: transactionDate,
          createdAt: transactionDate,
          updatedAt: transactionDate,
        ),
      ],
      hasMore: false,
    );
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
  Future<void> saveExpense(Transaction expense) async {}

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
