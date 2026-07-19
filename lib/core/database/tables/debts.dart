import 'package:drift/drift.dart';

import 'businesses.dart';
import 'transactions.dart';

@TableIndex.sql('''
  CREATE INDEX idx_debts_business_status_type_date
  ON debts (
    business_id,
    status,
    type,
    debt_date DESC,
    id DESC
  );
  ''')
@DataClassName('DebtRow')
class Debts extends Table {
  TextColumn get id => text()();

  TextColumn get businessId => text()
      .named('business_id')
      .references(Businesses, #id, onDelete: KeyAction.restrict)();

  TextColumn get sourceTransactionId => text()
      .named('source_transaction_id')
      .nullable()
      .references(Transactions, #id, onDelete: KeyAction.setNull)();

  TextColumn get type => text()();

  TextColumn get contactName => text().named('contact_name')();

  TextColumn get contactPhone => text().named('contact_phone').nullable()();

  IntColumn get amount => integer()();

  IntColumn get remainingAmount => integer().named('remaining_amount')();

  TextColumn get status => text().withDefault(const Constant('unpaid'))();

  DateTimeColumn get debtDate => dateTime().named('debt_date')();

  TextColumn get note => text().nullable()();

  DateTimeColumn get createdAt => dateTime().named('created_at')();

  DateTimeColumn get updatedAt => dateTime().named('updated_at')();

  DateTimeColumn get syncedAt => dateTime().named('synced_at').nullable()();

  @override
  String get tableName => 'debts';

  @override
  Set<Column<Object>> get primaryKey => {id};

  @override
  List<String> get customConstraints => [
    "CHECK (type IN ('debt', 'receivable'))",
    "CHECK (status IN ('paid', 'unpaid'))",
    'CHECK (length(trim(contact_name)) > 0)',
    'CHECK (amount > 0)',
    'CHECK (remaining_amount >= 0)',
    'CHECK (remaining_amount <= amount)',
    '''
        CHECK (
          (status = 'paid' AND remaining_amount = 0)
          OR
          (status = 'unpaid' AND remaining_amount > 0)
        )
        ''',
    '''
        CHECK (
          source_transaction_id IS NULL
          OR type = 'receivable'
        )
        ''',
  ];
}
