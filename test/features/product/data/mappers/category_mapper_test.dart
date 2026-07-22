import 'package:flutter_test/flutter_test.dart';
import 'package:kasentra/core/database/app_database.dart';
import 'package:kasentra/features/product/data/mappers/category_mapper.dart';
import 'package:kasentra/features/product/domain/entities/category.dart';

void main() {
  group('CategoryMapper', () {
    final createdAt = DateTime.utc(2025, 1, 1);
    final updatedAt = DateTime.utc(2025, 1, 2);

    CategoryRow createRow({String type = 'expense'}) {
      return CategoryRow(
        id: 'category-1',
        businessId: 'business-1',
        type: type,
        name: 'Operasional',
        isDefault: true,
        createdAt: createdAt,
        updatedAt: updatedAt,
        syncedAt: null,
      );
    }

    test('maps database row to domain entity', () {
      final category = CategoryMapper.toDomain(createRow());

      expect(category.id, 'category-1');
      expect(category.businessId, 'business-1');
      expect(category.type, CategoryType.expense);
      expect(category.name, 'Operasional');
      expect(category.isDefault, isTrue);

      expect(category.createdAt.isAtSameMomentAs(createdAt), isTrue);

      expect(category.updatedAt.isAtSameMomentAs(updatedAt), isTrue);
    });

    test('maps domain entity to database companion', () {
      final category = CategoryMapper.toDomain(createRow());

      final companion = CategoryMapper.toCompanion(category);

      expect(companion.id.value, 'category-1');
      expect(companion.businessId.value, 'business-1');
      expect(companion.type.value, 'expense');
      expect(companion.name.value, 'Operasional');
      expect(companion.isDefault.value, isTrue);
      expect(companion.syncedAt.present, isTrue);
      expect(companion.syncedAt.value, isNull);
    });

    test('maps product category type', () {
      final category = CategoryMapper.toDomain(createRow(type: 'product'));

      expect(category.type, CategoryType.product);
    });

    test('rejects unknown storage type', () {
      expect(
        () => CategoryMapper.toDomain(createRow(type: 'unknown')),
        throwsA(isA<FormatException>()),
      );
    });
  });
}
