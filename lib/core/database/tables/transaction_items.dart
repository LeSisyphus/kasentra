import 'package:drift/drift.dart';

import 'products.dart';
import 'transactions.dart';

@TableIndex(
  name: 'idx_transaction_items_transaction',
  columns: {#transactionId},
)
@DataClassName('TransactionItemRow')
class TransactionItems extends Table {
  TextColumn get id => text()();

  TextColumn get transactionId => text()
      .named('transaction_id')
      .references(Transactions, #id, onDelete: KeyAction.cascade)();

  TextColumn get productId => text()
      .named('product_id')
      .nullable()
      .references(Products, #id, onDelete: KeyAction.setNull)();

  TextColumn get itemName => text().named('item_name')();

  IntColumn get quantity => integer()();

  IntColumn get sellingPrice => integer().named('selling_price')();

  IntColumn get costPrice => integer().named('cost_price').nullable()();

  IntColumn get subtotal => integer()();

  @override
  String get tableName => 'transaction_items';

  @override
  Set<Column<Object>> get primaryKey => {id};

  @override
  List<String> get customConstraints => [
    'CHECK (length(trim(item_name)) > 0)',
    'CHECK (quantity > 0)',
    'CHECK (selling_price >= 0)',
    'CHECK (cost_price IS NULL OR cost_price >= 0)',
    'CHECK (subtotal >= 0)',
    'CHECK (subtotal = quantity * selling_price)',
  ];
}
