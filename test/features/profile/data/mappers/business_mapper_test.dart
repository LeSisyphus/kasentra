import 'package:flutter_test/flutter_test.dart';
import 'package:kasentra/core/database/app_database.dart';
import 'package:kasentra/features/profile/data/mappers/business_mapper.dart';
import 'package:kasentra/features/profile/domain/entities/business.dart';

void main() {
  group('BusinessMapper', () {
    final createdAt = DateTime.utc(2025, 1, 1);
    final updatedAt = DateTime.utc(2025, 1, 2);

    BusinessRow createRow({String businessType = 'grocery_store'}) {
      return BusinessRow(
        id: 'business-1',
        name: 'Toko Kasentra',
        ownerName: 'Ibu Lina',
        phone: '081234567890',
        address: 'Jalan Mawar',
        businessType: businessType,
        createdAt: createdAt,
        updatedAt: updatedAt,
        syncedAt: null,
      );
    }

    test('maps a database row to a domain entity', () {
      final business = BusinessMapper.toDomain(createRow());

      expect(business.id, 'business-1');
      expect(business.name, 'Toko Kasentra');
      expect(business.ownerName, 'Ibu Lina');
      expect(business.type, BusinessType.groceryStore);
      expect(business.phoneNumber, '081234567890');
      expect(business.address, 'Jalan Mawar');
      expect(business.createdAt.isAtSameMomentAs(createdAt), isTrue);
      expect(business.updatedAt.isAtSameMomentAs(updatedAt), isTrue);
    });

    test('maps a domain entity to a database companion', () {
      final business = BusinessMapper.toDomain(createRow());

      final companion = BusinessMapper.toCompanion(business);

      expect(companion.id.value, 'business-1');
      expect(companion.name.value, 'Toko Kasentra');
      expect(companion.ownerName.value, 'Ibu Lina');
      expect(companion.businessType.value, 'grocery_store');
      expect(companion.phone.value, '081234567890');
      expect(companion.syncedAt.present, isTrue);
      expect(companion.syncedAt.value, isNull);
    });

    test('supports the legacy database label', () {
      final business = BusinessMapper.toDomain(
        createRow(businessType: 'Toko Sembako'),
      );

      expect(business.type, BusinessType.groceryStore);
    });

    test('rejects an unknown database value', () {
      expect(
        () => BusinessMapper.toDomain(createRow(businessType: 'unknown')),
        throwsA(isA<FormatException>()),
      );
    });
  });
}
