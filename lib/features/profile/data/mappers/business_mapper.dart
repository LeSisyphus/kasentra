import 'package:drift/drift.dart' show Value;

import '../../../../core/database/app_database.dart';
import '../../domain/entities/business.dart';

abstract final class BusinessMapper {
  static const Map<String, BusinessType> _typesByStorageValue = {
    'grocery_store': BusinessType.groceryStore,
    'groceryStore': BusinessType.groceryStore,
    'Toko Sembako': BusinessType.groceryStore,
    'retail': BusinessType.retail,
    'Ritel': BusinessType.retail,
    'food': BusinessType.food,
    'Makanan': BusinessType.food,
    'service': BusinessType.service,
    'Jasa': BusinessType.service,
    'other': BusinessType.other,
    'Lainnya': BusinessType.other,
  };

  static Business toDomain(BusinessRow row) {
    return Business(
      id: row.id,
      name: row.name,
      ownerName: row.ownerName,
      type: _typeFromStorage(row.businessType),
      phoneNumber: row.phone,
      address: row.address,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }

  static BusinessesCompanion toCompanion(Business business) {
    return BusinessesCompanion(
      id: Value(business.id),
      name: Value(business.name),
      ownerName: Value(business.ownerName),
      phone: Value(business.phoneNumber),
      address: Value(business.address),
      businessType: Value(_typeToStorage(business.type)),
      createdAt: Value(business.createdAt),
      updatedAt: Value(business.updatedAt),

      // Setiap perubahan lokal perlu dianggap belum tersinkron.
      syncedAt: const Value(null),
    );
  }

  static BusinessType _typeFromStorage(String value) {
    final normalizedValue = value.trim();
    final type = _typesByStorageValue[normalizedValue];

    if (type == null) {
      throw FormatException('Jenis usaha database tidak dikenali: $value');
    }

    return type;
  }

  static String _typeToStorage(BusinessType type) {
    return switch (type) {
      BusinessType.groceryStore => 'grocery_store',
      BusinessType.retail => 'retail',
      BusinessType.food => 'food',
      BusinessType.service => 'service',
      BusinessType.other => 'other',
    };
  }
}
