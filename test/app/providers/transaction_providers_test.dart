import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kasentra/app/providers/database_providers.dart';
import 'package:kasentra/app/providers/transaction_providers.dart';
import 'package:kasentra/core/database/app_database.dart';
import 'package:kasentra/features/transaction/data/datasources/local_transaction_data_source.dart';
import 'package:kasentra/features/transaction/data/repositories/transaction_repository_impl.dart';
import 'package:kasentra/features/transaction/domain/repositories/transaction_repository.dart';
import 'package:kasentra/features/transaction/domain/usecases/get_transactions_page_usecase.dart';

void main() {
  group('transaction providers', () {
    test('creates local data source, repository, and use case', () async {
      final database = AppDatabase(
        DatabaseConnection(
          NativeDatabase.memory(),
          closeStreamsSynchronously: true,
        ),
      );

      final container = ProviderContainer.test(
        overrides: [appDatabaseProvider.overrideWithValue(database)],
      );

      addTearDown(() async {
        container.dispose();
        await database.close();
      });

      expect(
        container.read(localTransactionDataSourceProvider),
        isA<DriftLocalTransactionDataSource>(),
      );

      expect(
        container.read(transactionRepositoryProvider),
        isA<TransactionRepositoryImpl>(),
      );

      expect(
        container.read(getTransactionsPageUseCaseProvider),
        isA<GetTransactionsPageUseCase>(),
      );
    });

    test('allows the transaction repository to be overridden', () {
      final repository = _FakeTransactionRepository();

      final container = ProviderContainer.test(
        overrides: [
          transactionRepositoryProvider.overrideWithValue(repository),
        ],
      );

      addTearDown(container.dispose);

      expect(container.read(transactionRepositoryProvider), same(repository));

      expect(
        container.read(getTransactionsPageUseCaseProvider),
        isA<GetTransactionsPageUseCase>(),
      );
    });
  });
}

class _FakeTransactionRepository implements TransactionRepository {
  @override
  dynamic noSuchMethod(Invocation invocation) {
    throw UnimplementedError(
      '${invocation.memberName} tidak digunakan pada provider test.',
    );
  }
}
