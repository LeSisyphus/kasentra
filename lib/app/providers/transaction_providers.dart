import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/transaction/domain/repositories/transaction_repository.dart';
import '../../features/transaction/domain/usecases/get_transactions_page_usecase.dart';

final transactionRepositoryProvider = Provider<TransactionRepository>(
  (ref) {
    throw UnimplementedError(
      'TransactionRepository belum didaftarkan. '
      'Override transactionRepositoryProvider dengan implementasi data layer.',
    );
  },
  name: 'transactionRepositoryProvider',
  retry: (retryCount, error) => null,
);

final getTransactionsPageUseCaseProvider = Provider<GetTransactionsPageUseCase>(
  (ref) {
    final repository = ref.watch(transactionRepositoryProvider);

    return GetTransactionsPageUseCase(repository);
  },
  name: 'getTransactionsPageUseCaseProvider',
);
