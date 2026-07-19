import 'package:drift/drift.dart';

import 'businesses.dart';
import 'categories.dart';

@TableIndex.sql('''
  CREATE INDEX idx_transactions_business_date_id
  ON transactions (
    business_id,
    transaction_date DESC,
    id DESC
  );
  ''')
@TableIndex(
  name: 'idx_transactions_business_type_date',
  columns: {#businessId, #type, #transactionDate},
)
@DataClassName('TransactionRow')
class Transactions extends Table {
  TextColumn get id => text()();

  TextColumn get businessId => text()
      .named('business_id')
      .references(Businesses, #id, onDelete: KeyAction.restrict)();

  TextColumn get type => text()();

  TextColumn get title => text().nullable()();

  TextColumn get categoryId => text()
      .named('category_id')
      .nullable()
      .references(Categories, #id, onDelete: KeyAction.restrict)();

  IntColumn get totalAmount => integer().named('total_amount')();

  IntColumn get costAmount =>
      integer().named('cost_amount').withDefault(const Constant(0))();

  IntColumn get profitAmount =>
      integer().named('profit_amount').withDefault(const Constant(0))();

  TextColumn get paymentStatus =>
      text().named('payment_status').withDefault(const Constant('paid'))();

  TextColumn get contactName => text().named('contact_name').nullable()();

  TextColumn get contactPhone => text().named('contact_phone').nullable()();

  DateTimeColumn get transactionDate => dateTime().named('transaction_date')();

  TextColumn get note => text().nullable()();

  DateTimeColumn get createdAt => dateTime().named('created_at')();

  DateTimeColumn get updatedAt => dateTime().named('updated_at')();

  DateTimeColumn get syncedAt => dateTime().named('synced_at').nullable()();

  @override
  String get tableName => 'transactions';

  @override
  Set<Column<Object>> get primaryKey => {id};

  @override
  List<String> get customConstraints => [
    "CHECK (type IN ('sale', 'expense'))",
    "CHECK (payment_status IN ('paid', 'unpaid'))",
    'CHECK (total_amount > 0)',
    'CHECK (cost_amount >= 0)',
    '''
        CHECK (
          type != 'expense'
          OR (
            title IS NOT NULL
            AND length(trim(title)) > 0
          )
        )
        ''',
    '''
        CHECK (
          type != 'expense'
          OR category_id IS NOT NULL
        )
        ''',
    '''
        CHECK (
          type != 'expense'
          OR payment_status = 'paid'
        )
        ''',
    '''
        CHECK (
          payment_status != 'unpaid'
          OR (
            type = 'sale'
            AND contact_name IS NOT NULL
            AND length(trim(contact_name)) > 0
          )
        )
        ''',
  ];
}
