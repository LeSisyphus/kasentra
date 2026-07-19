import 'package:drift/drift.dart';

import 'businesses.dart';
import 'categories.dart';

@TableIndex(name: 'idx_products_business_name', columns: {#businessId, #name})
@DataClassName('ProductRow')
class Products extends Table {
  TextColumn get id => text()();

  TextColumn get businessId => text()
      .named('business_id')
      .references(Businesses, #id, onDelete: KeyAction.restrict)();

  TextColumn get categoryId => text()
      .named('category_id')
      .references(Categories, #id, onDelete: KeyAction.restrict)();

  TextColumn get name => text()();

  IntColumn get sellingPrice => integer().named('selling_price')();

  IntColumn get costPrice => integer().named('cost_price').nullable()();

  IntColumn get stock => integer().nullable()();

  BoolColumn get isActive =>
      boolean().named('is_active').withDefault(const Constant(true))();

  DateTimeColumn get createdAt => dateTime().named('created_at')();

  DateTimeColumn get updatedAt => dateTime().named('updated_at')();

  DateTimeColumn get syncedAt => dateTime().named('synced_at').nullable()();

  @override
  String get tableName => 'products';

  @override
  Set<Column<Object>> get primaryKey => {id};

  @override
  List<String> get customConstraints => [
    'CHECK (length(trim(name)) > 0)',
    'CHECK (selling_price >= 0)',
    'CHECK (cost_price IS NULL OR cost_price >= 0)',
    'CHECK (stock IS NULL OR stock >= 0)',
  ];
}
