import 'package:drift/drift.dart';

@DataClassName('BusinessRow')
class Businesses extends Table {
  TextColumn get id => text()();

  TextColumn get name => text()();

  TextColumn get ownerName => text().named('owner_name')();

  TextColumn get phone => text().nullable()();

  TextColumn get address => text().nullable()();

  TextColumn get businessType => text()
      .named('business_type')
      .withDefault(const Constant('Toko Sembako'))();

  DateTimeColumn get createdAt => dateTime().named('created_at')();

  DateTimeColumn get updatedAt => dateTime().named('updated_at')();

  DateTimeColumn get syncedAt => dateTime().named('synced_at').nullable()();

  @override
  String get tableName => 'businesses';

  @override
  Set<Column<Object>> get primaryKey => {id};

  @override
  List<String> get customConstraints => [
    'CHECK (length(trim(name)) > 0)',
    'CHECK (length(trim(owner_name)) > 0)',
    'CHECK (length(trim(business_type)) > 0)',
  ];
}
