import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/transaction/data/datasources/local_transaction_data_source.dart';
import '../../features/transaction/data/repositories/transaction_repository_impl.dart';
import '../../features/transaction/domain/repositories/transaction_repository.dart';
import '../../features/transaction/domain/usecases/get_transactions_page_usecase.dart';
import 'database_providers.dart';

final localTransactionDataSourceProvider = Provider<LocalTransactionDataSource>(
  (ref) {
    final database = ref.watch(appDatabaseProvider);

    return DriftLocalTransactionDataSource(database);
  },
  name: 'localTransactionDataSourceProvider',
);

final transactionRepositoryProvider = Provider<TransactionRepository>((ref) {
  final localDataSource = ref.watch(localTransactionDataSourceProvider);

  return TransactionRepositoryImpl(localDataSource);
}, name: 'transactionRepositoryProvider');

final getTransactionsPageUseCaseProvider = Provider<GetTransactionsPageUseCase>(
  (ref) {
    final repository = ref.watch(transactionRepositoryProvider);

    return GetTransactionsPageUseCase(repository);
  },
  name: 'getTransactionsPageUseCaseProvider',
);
