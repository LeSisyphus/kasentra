import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kasentra/app/providers/category_providers.dart';
import 'package:kasentra/app/providers/profile_providers.dart';
import 'package:kasentra/app/providers/transaction_providers.dart';
import 'package:kasentra/app/theme/kasentra_theme.dart';
import 'package:kasentra/features/product/domain/entities/category.dart';
import 'package:kasentra/features/product/domain/repositories/category_repository.dart';
import 'package:kasentra/features/profile/domain/entities/business.dart';
import 'package:kasentra/features/transaction/domain/entities/transaction.dart';
import 'package:kasentra/features/transaction/domain/repositories/transaction_repository.dart';
import 'package:kasentra/features/transaction/presentation/screens/add_expense_screen.dart';

void main() {
  group('AddExpenseScreen', () {
    final now = DateTime(2025, 2, 1, 10, 30);

    testWidgets('bootstraps categories and saves expense', (tester) async {
      final categoryRepository = _FakeCategoryRepository();

      final transactionRepository = _FakeTransactionRepository();

      await _openExpenseScreen(
        tester,
        categoryRepository: categoryRepository,
        transactionRepository: transactionRepository,
        businessStream: Stream.value(_createBusiness()),
        now: now,
        idGenerator: (_) => 'expense-generated',
      );

      expect(categoryRepository.categories, hasLength(6));

      expect(find.text('Stok Barang'), findsOneWidget);

      await tester.enterText(
        find.byKey(const Key('expense-title-field')),
        '  Bayar listrik toko  ',
      );

      await tester.enterText(
        find.byKey(const Key('expense-amount-field')),
        '125000',
      );

      await tester.enterText(
        find.byKey(const Key('expense-note-field')),
        '  Tagihan Februari  ',
      );

      await tester.tap(find.text('Operasional'));

      await tester.pump();

      await tester.tap(find.byKey(const Key('expense-save-button')));

      await tester.pumpAndSettle();

      expect(transactionRepository.savedExpenses, hasLength(1));

      final expense = transactionRepository.savedExpenses.single;

      expect(expense.id, 'expense-generated');

      expect(expense.businessId, 'business-1');

      expect(expense.type, TransactionType.expense);

      expect(expense.title, 'Bayar listrik toko');

      expect(expense.totalAmount, 125000);

      expect(expense.costAmount, 0);
      expect(expense.profitAmount, 0);

      expect(expense.paymentStatus, PaymentStatus.paid);

      expect(expense.note, 'Tagihan Februari');

      final operationCategory = categoryRepository.categories.singleWhere(
        (category) => category.name == 'Operasional',
      );

      expect(expense.categoryId, operationCategory.id);

      expect(expense.createdAt.isAtSameMomentAs(now.toUtc()), isTrue);

      expect(expense.updatedAt.isAtSameMomentAs(now.toUtc()), isTrue);

      final expectedTransactionDate = DateTime(
        now.year,
        now.month,
        now.day,
        now.hour,
        now.minute,
        now.second,
        now.millisecond,
        now.microsecond,
      ).toUtc();

      expect(
        expense.transactionDate.isAtSameMomentAs(expectedTransactionDate),
        isTrue,
      );

      expect(find.byType(AddExpenseScreen), findsNothing);
    });

    testWidgets('uses Stok Barang as default category', (tester) async {
      final categoryRepository = _FakeCategoryRepository(
        categories: [
          _createCategory(id: 'category-operations', name: 'Operasional'),
          _createCategory(id: 'category-stock', name: 'Stok Barang'),
        ],
      );

      final transactionRepository = _FakeTransactionRepository();

      await _openExpenseScreen(
        tester,
        categoryRepository: categoryRepository,
        transactionRepository: transactionRepository,
        businessStream: Stream.value(_createBusiness()),
        now: now,
        idGenerator: (_) => 'expense-generated',
      );

      await tester.enterText(
        find.byKey(const Key('expense-title-field')),
        'Beli beras',
      );

      await tester.enterText(
        find.byKey(const Key('expense-amount-field')),
        '50000',
      );

      await tester.tap(find.byKey(const Key('expense-save-button')));

      await tester.pumpAndSettle();

      final expense = transactionRepository.savedExpenses.single;

      expect(expense.categoryId, 'category-stock');
    });

    testWidgets('rejects empty required fields', (tester) async {
      final categoryRepository = _FakeCategoryRepository();

      final transactionRepository = _FakeTransactionRepository();

      await _openExpenseScreen(
        tester,
        categoryRepository: categoryRepository,
        transactionRepository: transactionRepository,
        businessStream: Stream.value(_createBusiness()),
        now: now,
        idGenerator: (_) => 'expense-generated',
      );

      await tester.tap(find.byKey(const Key('expense-save-button')));

      await tester.pump();

      expect(find.text('Nama pengeluaran wajib diisi.'), findsOneWidget);

      expect(find.text('Nominal wajib diisi.'), findsOneWidget);

      expect(transactionRepository.saveCalls, 0);

      expect(find.byType(AddExpenseScreen), findsOneWidget);
    });

    testWidgets('shows safe error when saving fails', (tester) async {
      final categoryRepository = _FakeCategoryRepository();

      final transactionRepository = _FakeTransactionRepository(
        saveError: StateError('database failure'),
      );

      await _openExpenseScreen(
        tester,
        categoryRepository: categoryRepository,
        transactionRepository: transactionRepository,
        businessStream: Stream.value(_createBusiness()),
        now: now,
        idGenerator: (_) => 'expense-generated',
      );

      await tester.enterText(
        find.byKey(const Key('expense-title-field')),
        'Bayar listrik',
      );

      await tester.enterText(
        find.byKey(const Key('expense-amount-field')),
        '125000',
      );

      await tester.tap(find.byKey(const Key('expense-save-button')));

      await tester.pumpAndSettle();

      expect(transactionRepository.saveCalls, 1);

      expect(find.byKey(const Key('expense-form-error')), findsOneWidget);

      expect(
        find.text(
          'Pengeluaran gagal disimpan. '
          'Coba lagi.',
        ),
        findsOneWidget,
      );

      expect(find.text('database failure'), findsNothing);

      expect(find.byType(AddExpenseScreen), findsOneWidget);
    });

    testWidgets('shows missing-business state', (tester) async {
      final categoryRepository = _FakeCategoryRepository();

      final transactionRepository = _FakeTransactionRepository();

      await _openExpenseScreen(
        tester,
        categoryRepository: categoryRepository,
        transactionRepository: transactionRepository,
        businessStream: Stream.value(null),
        now: now,
        idGenerator: (_) => 'expense-generated',
      );

      expect(find.byKey(const Key('expense-missing-business')), findsOneWidget);

      expect(find.text('Profil usaha belum tersedia'), findsOneWidget);

      expect(categoryRepository.watchCalls, 0);

      expect(transactionRepository.saveCalls, 0);
    });

    testWidgets('shows safe error when category bootstrap fails', (
      tester,
    ) async {
      final categoryRepository = _FakeCategoryRepository(
        watchError: StateError('category database failure'),
      );

      final transactionRepository = _FakeTransactionRepository();

      await _openExpenseScreen(
        tester,
        categoryRepository: categoryRepository,
        transactionRepository: transactionRepository,
        businessStream: Stream.value(_createBusiness()),
        now: now,
        idGenerator: (_) => 'expense-generated',
      );

      expect(
        find.byKey(const Key('expense-category-bootstrap-error')),
        findsOneWidget,
      );

      expect(find.text('Kategori gagal disiapkan'), findsOneWidget);

      expect(find.text('category database failure'), findsNothing);

      expect(transactionRepository.saveCalls, 0);
    });
  });
}

Future<void> _openExpenseScreen(
  WidgetTester tester, {
  required _FakeCategoryRepository categoryRepository,
  required _FakeTransactionRepository transactionRepository,
  required Stream<Business?> businessStream,
  required DateTime now,
  required String Function(DateTime timestamp) idGenerator,
}) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        activeBusinessProvider.overrideWith((ref) => businessStream),
        categoryRepositoryProvider.overrideWithValue(categoryRepository),
        transactionRepositoryProvider.overrideWithValue(transactionRepository),
      ],
      child: MaterialApp(
        theme: KasentraTheme.lightTheme,
        home: Builder(
          builder: (context) {
            return Scaffold(
              body: Center(
                child: FilledButton(
                  key: const Key('open-expense-screen'),
                  onPressed: () {
                    Navigator.of(context).push<bool>(
                      MaterialPageRoute<bool>(
                        builder: (_) {
                          return AddExpenseScreen(
                            now: () => now,
                            idGenerator: idGenerator,
                          );
                        },
                      ),
                    );
                  },
                  child: const Text('Buka Pengeluaran'),
                ),
              ),
            );
          },
        ),
      ),
    ),
  );

  await tester.tap(find.byKey(const Key('open-expense-screen')));

  await tester.pumpAndSettle();
}

Business _createBusiness() {
  return Business(
    id: 'business-1',
    name: 'Toko Kasentra',
    ownerName: 'Ibu Lina',
    type: BusinessType.groceryStore,
    createdAt: DateTime.utc(2025, 1, 1),
    updatedAt: DateTime.utc(2025, 1, 1),
  );
}

Category _createCategory({required String id, required String name}) {
  final timestamp = DateTime.utc(2025, 1, 1);

  return Category(
    id: id,
    businessId: 'business-1',
    type: CategoryType.expense,
    name: name,
    isDefault: true,
    createdAt: timestamp,
    updatedAt: timestamp,
  );
}

final class _FakeCategoryRepository implements CategoryRepository {
  _FakeCategoryRepository({List<Category>? categories, this.watchError})
    : categories = categories ?? [];

  final List<Category> categories;
  final Object? watchError;

  int watchCalls = 0;

  @override
  Stream<List<Category>> watchCategories({
    required String businessId,
    CategoryType? type,
  }) {
    watchCalls++;

    final error = watchError;

    if (error != null) {
      return Stream<List<Category>>.error(error);
    }

    final result = categories
        .where((category) {
          return category.businessId == businessId &&
              (type == null || category.type == type);
        })
        .toList(growable: false);

    return Stream.value(result);
  }

  @override
  Future<void> saveCategory(Category category) async {
    categories.add(category);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) {
    throw UnimplementedError(
      '${invocation.memberName} tidak digunakan '
      'dalam widget test.',
    );
  }
}

final class _FakeTransactionRepository implements TransactionRepository {
  _FakeTransactionRepository({this.saveError});

  final Object? saveError;

  final List<Transaction> savedExpenses = [];

  int saveCalls = 0;

  @override
  Future<void> saveExpense(Transaction expense) async {
    saveCalls++;

    final error = saveError;

    if (error != null) {
      throw error;
    }

    savedExpenses.add(expense);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) {
    throw UnimplementedError(
      '${invocation.memberName} tidak digunakan '
      'dalam widget test.',
    );
  }
}
