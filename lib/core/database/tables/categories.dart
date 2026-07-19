import 'package:drift/drift.dart';

import 'businesses.dart';

@DataClassName('CategoryRow')
class Categories extends Table {
  TextColumn get id => text()();

  TextColumn get businessId => text()
      .named('business_id')
      .references(Businesses, #id, onDelete: KeyAction.restrict)();

  TextColumn get type => text()();

  TextColumn get name => text()();

  BoolColumn get isDefault =>
      boolean().named('is_default').withDefault(const Constant(false))();

  DateTimeColumn get createdAt => dateTime().named('created_at')();

  DateTimeColumn get updatedAt => dateTime().named('updated_at')();

  DateTimeColumn get syncedAt => dateTime().named('synced_at').nullable()();

  @override
  String get tableName => 'categories';

  @override
  Set<Column<Object>> get primaryKey => {id};

  @override
  List<String> get customConstraints => [
    "CHECK (type IN ('product', 'expense'))",
    'CHECK (length(trim(name)) > 0)',
    'UNIQUE (business_id, type, name)',
  ];
}
