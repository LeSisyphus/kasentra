import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kasentra/app/providers/profile_providers.dart';
import 'package:kasentra/app/providers/transaction_providers.dart';
import 'package:kasentra/app/theme/kasentra_theme.dart';
import 'package:kasentra/features/profile/domain/entities/business.dart';
import 'package:kasentra/features/transaction/domain/entities/transaction.dart';
import 'package:kasentra/features/transaction/domain/entities/transaction_item.dart';
import 'package:kasentra/features/transaction/domain/entities/transaction_page.dart';
import 'package:kasentra/features/transaction/domain/repositories/transaction_repository.dart';
import 'package:kasentra/features/transaction/presentation/screens/transaction_screen.dart';

void main() {
  group('TransactionScreen', () {
    final now = DateTime(2025, 1, 15, 10);

    testWidgets(
      'shows missing-business state without requesting transactions',
      (tester) async {
        final repository = _FakeTransactionRepository();

        await _pumpScreen(
          tester,
          repository: repository,
          businessStream: Stream.value(null),
          now: now,
        );

        await tester.pumpAndSettle();

        expect(
          find.byKey(const Key('transaction-missing-business')),
          findsOneWidget,
        );

        expect(find.text('Profil usaha belum tersedia'), findsOneWidget);

        expect(repository.requests, isEmpty);
      },
    );

    testWidgets('loads and renders today transactions for active business', (
      tester,
    ) async {
      final repository = _FakeTransactionRepository()
        ..enqueuePage(
          TransactionPage(
            items: [
              _createTransaction(
                id: 'sale-1',
                type: TransactionType.sale,
                amount: 100000,
                transactionDate: DateTime(2025, 1, 15, 9, 30),
              ),
              _createTransaction(
                id: 'expense-1',
                type: TransactionType.expense,
                title: 'Bayar listrik',
                amount: 30000,
                transactionDate: DateTime(2025, 1, 15, 8),
              ),
            ],
            hasMore: false,
          ),
        );

      await _pumpScreen(
        tester,
        repository: repository,
        businessStream: Stream.value(_createBusiness()),
        now: now,
      );

      await tester.pumpAndSettle();

      expect(repository.requests, hasLength(1));

      final request = repository.requests.single;

      expect(request.businessId, 'business-1');

      expect(request.startDate, DateTime(2025, 1, 15));

      expect(request.endDate, DateTime(2025, 1, 15, 23, 59, 59, 999, 999));

      expect(find.byKey(const Key('transaction-item-sale-1')), findsOneWidget);

      expect(
        find.byKey(const Key('transaction-item-expense-1')),
        findsOneWidget,
      );

      expect(find.text('Bayar listrik'), findsOneWidget);

      expect(find.text('Hari Ini - 15 Jan 2025'), findsOneWidget);

      expect(find.text('Total Hari Ini'), findsOneWidget);

      expect(find.text('2 Transaksi'), findsOneWidget);
    });

    testWidgets('reloads using the selected weekly period', (tester) async {
      final repository = _FakeTransactionRepository()
        ..enqueuePage(TransactionPage(items: const [], hasMore: false))
        ..enqueuePage(TransactionPage(items: const [], hasMore: false));

      await _pumpScreen(
        tester,
        repository: repository,
        businessStream: Stream.value(_createBusiness()),
        now: now,
      );

      await tester.pumpAndSettle();

      await tester.tap(find.text('Minggu Ini'));

      await tester.pumpAndSettle();

      expect(repository.requests, hasLength(2));

      final request = repository.requests[1];

      expect(request.startDate, DateTime(2025, 1, 13));

      expect(request.endDate, DateTime(2025, 1, 19, 23, 59, 59, 999, 999));

      expect(find.text('13 Jan 2025 - 19 Jan 2025'), findsOneWidget);
    });

    testWidgets('shows safe error when initial transaction load fails', (
      tester,
    ) async {
      final repository = _FakeTransactionRepository()
        ..enqueueError(StateError('database failure'));

      await _pumpScreen(
        tester,
        repository: repository,
        businessStream: Stream.value(_createBusiness()),
        now: now,
      );

      await tester.pumpAndSettle();

      expect(find.byKey(const Key('transaction-list-error')), findsOneWidget);

      expect(find.text('Gagal memuat transaksi. Coba lagi.'), findsOneWidget);

      expect(find.text('database failure'), findsNothing);
    });

    testWidgets('loads the next page using cursor', (tester) async {
      final cursor = TransactionCursor(
        transactionDate: DateTime(2025, 1, 15, 9),
        transactionId: 'sale-1',
      );

      final repository = _FakeTransactionRepository()
        ..enqueuePage(
          TransactionPage(
            items: [
              _createTransaction(
                id: 'sale-1',
                type: TransactionType.sale,
                amount: 100000,
                transactionDate: DateTime(2025, 1, 15, 9),
              ),
            ],
            nextCursor: cursor,
            hasMore: true,
          ),
        )
        ..enqueuePage(
          TransactionPage(
            items: [
              _createTransaction(
                id: 'expense-1',
                type: TransactionType.expense,
                title: 'Beli stok',
                amount: 20000,
                transactionDate: DateTime(2025, 1, 15, 8),
              ),
            ],
            hasMore: false,
          ),
        );

      await _pumpScreen(
        tester,
        repository: repository,
        businessStream: Stream.value(_createBusiness()),
        now: now,
      );

      await tester.pumpAndSettle();

      expect(find.text('Total sementara'), findsOneWidget);

      await tester.tap(find.byKey(const Key('transaction-load-more-button')));

      await tester.pumpAndSettle();

      expect(repository.requests, hasLength(2));
      expect(repository.requests[1].cursor, same(cursor));

      expect(find.byKey(const Key('transaction-item-sale-1')), findsOneWidget);

      expect(
        find.byKey(const Key('transaction-item-expense-1')),
        findsOneWidget,
      );

      expect(find.text('Total Hari Ini'), findsOneWidget);

      expect(find.text('2 Transaksi'), findsOneWidget);
    });
  });
}

Future<void> _pumpScreen(
  WidgetTester tester, {
  required _FakeTransactionRepository repository,
  required Stream<Business?> businessStream,
  required DateTime now,
}) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        activeBusinessProvider.overrideWith((ref) => businessStream),
        transactionRepositoryProvider.overrideWithValue(repository),
      ],
      child: MaterialApp(
        theme: KasentraTheme.lightTheme,
        home: Scaffold(body: TransactionScreen(now: () => now)),
      ),
    ),
  );

  await tester.pump();
}

Business _createBusiness() {
  return Business(
    id: 'business-1',
    name: 'Toko Kasentra',
    ownerName: 'Ibu Lina',
    type: BusinessType.groceryStore,
    createdAt: DateTime(2025, 1, 1),
    updatedAt: DateTime(2025, 1, 1),
  );
}

Transaction _createTransaction({
  required String id,
  required TransactionType type,
  required int amount,
  required DateTime transactionDate,
  String? title,
}) {
  return Transaction(
    id: id,
    businessId: 'business-1',
    type: type,
    title: title,
    totalAmount: amount,
    costAmount: type == TransactionType.sale ? amount ~/ 2 : 0,
    profitAmount: type == TransactionType.sale ? amount ~/ 2 : 0,
    paymentStatus: PaymentStatus.paid,
    transactionDate: transactionDate,
    createdAt: transactionDate,
    updatedAt: transactionDate,
  );
}

final class _FakeTransactionRepository implements TransactionRepository {
  final List<_TransactionRequest> requests = [];
  final List<_QueuedResult> _results = [];

  void enqueuePage(TransactionPage page) {
    _results.add(_QueuedResult(page: page));
  }

  void enqueueError(Object error) {
    _results.add(_QueuedResult(error: error));
  }

  @override
  Future<TransactionPage> getTransactionsPage({
    required String businessId,
    DateTime? startDate,
    DateTime? endDate,
    TransactionType? type,
    required int limit,
    TransactionCursor? cursor,
  }) {
    requests.add(
      _TransactionRequest(
        businessId: businessId,
        startDate: startDate,
        endDate: endDate,
        type: type,
        limit: limit,
        cursor: cursor,
      ),
    );

    if (_results.isEmpty) {
      return Future<TransactionPage>.error(
        StateError('Tidak ada hasil test yang disiapkan.'),
      );
    }

    final result = _results.removeAt(0);

    if (result.error != null) {
      return Future<TransactionPage>.error(result.error!);
    }

    return Future<TransactionPage>.value(result.page!);
  }

  @override
  Future<void> deleteTransaction({
    required String businessId,
    required String transactionId,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<Transaction?> getTransactionById({
    required String businessId,
    required String transactionId,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<void> saveExpense(Transaction expense) {
    throw UnimplementedError();
  }

  @override
  Future<void> updatePaymentStatus({
    required String businessId,
    required String transactionId,
    required PaymentStatus paymentStatus,
    required DateTime updatedAt,
  }) {
    throw UnimplementedError();
  }

  @override
  Stream<List<TransactionItem>> watchTransactionItems({
    required String transactionId,
  }) {
    throw UnimplementedError();
  }
}

class _QueuedResult {
  const _QueuedResult({this.page, this.error})
    : assert(
        (page == null) != (error == null),
        'Hasil harus memiliki page atau error.',
      );

  final TransactionPage? page;
  final Object? error;
}

class _TransactionRequest {
  const _TransactionRequest({
    required this.businessId,
    required this.startDate,
    required this.endDate,
    required this.type,
    required this.limit,
    required this.cursor,
  });

  final String businessId;
  final DateTime? startDate;
  final DateTime? endDate;
  final TransactionType? type;
  final int limit;
  final TransactionCursor? cursor;
}
