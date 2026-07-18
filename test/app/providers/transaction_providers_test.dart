import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kasentra/app/providers/transaction_providers.dart';
import 'package:kasentra/features/transaction/domain/repositories/transaction_repository.dart';
import 'package:kasentra/features/transaction/domain/usecases/get_transactions_page_usecase.dart';
import 'package:flutter_riverpod/misc.dart';

void main() {
  group('transaction providers', () {
    test('throws when transaction repository is not registered', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      expect(
        () => container.read(transactionRepositoryProvider),
        throwsA(
          isA<ProviderException>().having(
            (error) => error.exception,
            'exception',
            isA<UnimplementedError>(),
          ),
        ),
      );
    });

    test('creates use case when repository is overridden', () {
      final repository = _FakeTransactionRepository();

      final container = ProviderContainer(
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
