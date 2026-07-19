import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart';

abstract interface class LocalTransactionDataSource {
  Future<List<TransactionRow>> getTransactionsPage({
    required String businessId,
    DateTime? startDate,
    DateTime? endDate,
    String? type,
    required int fetchLimit,
    DateTime? cursorDate,
    String? cursorId,
  });

  Future<TransactionRow?> getTransactionById({
    required String businessId,
    required String transactionId,
  });

  Stream<List<TransactionItemRow>> watchTransactionItems({
    required String transactionId,
  });

  Future<void> saveExpense(TransactionsCompanion companion);

  Future<int> updatePaymentStatus({
    required String businessId,
    required String transactionId,
    required String paymentStatus,
    required DateTime updatedAt,
  });

  Future<int> deleteTransaction({
    required String businessId,
    required String transactionId,
  });
}

final class DriftLocalTransactionDataSource
    implements LocalTransactionDataSource {
  const DriftLocalTransactionDataSource(this._database);

  final AppDatabase _database;

  @override
  Future<List<TransactionRow>> getTransactionsPage({
    required String businessId,
    DateTime? startDate,
    DateTime? endDate,
    String? type,
    required int fetchLimit,
    DateTime? cursorDate,
    String? cursorId,
  }) {
    if (fetchLimit <= 0) {
      throw ArgumentError('Fetch limit harus lebih dari 0.');
    }

    if ((cursorDate == null) != (cursorId == null)) {
      throw ArgumentError('Tanggal dan id cursor harus diberikan bersamaan.');
    }

    final sql = StringBuffer('''
      SELECT *
      FROM transactions
      WHERE business_id = ?
      ''');

    final variables = <Variable<Object>>[Variable.withString(businessId)];

    if (startDate != null) {
      sql.write(' AND transaction_date >= ?');
      variables.add(Variable.withDateTime(startDate));
    }

    if (endDate != null) {
      sql.write(' AND transaction_date <= ?');
      variables.add(Variable.withDateTime(endDate));
    }

    if (type != null) {
      sql.write(' AND type = ?');
      variables.add(Variable.withString(type));
    }

    if (cursorDate != null && cursorId != null) {
      sql.write('''
        AND (
          transaction_date < ?
          OR (
            transaction_date = ?
            AND id < ?
          )
        )
        ''');

      variables
        ..add(Variable.withDateTime(cursorDate))
        ..add(Variable.withDateTime(cursorDate))
        ..add(Variable.withString(cursorId));
    }

    sql.write('''
      ORDER BY transaction_date DESC, id DESC
      LIMIT ?
      ''');

    variables.add(Variable.withInt(fetchLimit));

    return _database
        .customSelect(
          sql.toString(),
          variables: variables,
          readsFrom: {_database.transactions},
        )
        .map((row) => _database.transactions.map(row.data))
        .get();
  }

  @override
  Future<TransactionRow?> getTransactionById({
    required String businessId,
    required String transactionId,
  }) {
    final query = _database.select(_database.transactions)
      ..where(
        (row) =>
            row.businessId.equals(businessId) & row.id.equals(transactionId),
      );

    return query.getSingleOrNull();
  }

  @override
  Stream<List<TransactionItemRow>> watchTransactionItems({
    required String transactionId,
  }) {
    final query = _database.select(_database.transactionItems)
      ..where((row) => row.transactionId.equals(transactionId))
      ..orderBy([(row) => OrderingTerm.asc(row.id)]);

    return query.watch();
  }

  @override
  Future<void> saveExpense(TransactionsCompanion companion) async {
    await _database
        .into(_database.transactions)
        .insertOnConflictUpdate(companion);
  }

  @override
  Future<int> updatePaymentStatus({
    required String businessId,
    required String transactionId,
    required String paymentStatus,
    required DateTime updatedAt,
  }) {
    final statement = _database.update(_database.transactions)
      ..where(
        (row) =>
            row.businessId.equals(businessId) & row.id.equals(transactionId),
      );

    return statement.write(
      TransactionsCompanion(
        paymentStatus: Value(paymentStatus),
        updatedAt: Value(updatedAt),

        // Perubahan lokal harus dikirim kembali saat sync tersedia.
        syncedAt: const Value(null),
      ),
    );
  }

  @override
  Future<int> deleteTransaction({
    required String businessId,
    required String transactionId,
  }) {
    final statement = _database.delete(_database.transactions)
      ..where(
        (row) =>
            row.businessId.equals(businessId) & row.id.equals(transactionId),
      );

    return statement.go();
  }
}
