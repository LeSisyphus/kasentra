import 'package:flutter_test/flutter_test.dart';
import 'package:kasentra/features/product/domain/entities/category.dart';
import 'package:kasentra/features/product/domain/repositories/category_repository.dart';
import 'package:kasentra/features/product/domain/usecases/ensure_default_expense_categories_usecase.dart';

void main() {
  group('EnsureDefaultExpenseCategoriesUseCase', () {
    final timestamp = DateTime.utc(2025, 2, 1);

    test('creates all default expense categories', () async {
      final repository = _FakeCategoryRepository();

      final useCase = EnsureDefaultExpenseCategoriesUseCase(repository);

      await useCase(businessId: 'business-1', timestamp: timestamp);

      expect(repository.savedCategories, hasLength(6));

      expect(repository.savedCategories.map((category) => category.name), [
        'Stok Barang',
        'Operasional',
        'Transport',
        'Listrik & Air',
        'Sewa',
        'Lainnya',
      ]);

      expect(
        repository.savedCategories.every(
          (category) =>
              category.businessId == 'business-1' &&
              category.type == CategoryType.expense &&
              category.isDefault,
        ),
        isTrue,
      );

      expect(
        repository.savedCategories.first.id,
        'category-business-1-expense-stock',
      );
    });

    test('does not duplicate existing category names', () async {
      final repository = _FakeCategoryRepository(
        existingCategories: [
          Category(
            id: 'custom-operations',
            businessId: 'business-1',
            type: CategoryType.expense,
            name: '  OPERASIONAL  ',
            isDefault: false,
            createdAt: timestamp,
            updatedAt: timestamp,
          ),
        ],
      );

      final useCase = EnsureDefaultExpenseCategoriesUseCase(repository);

      await useCase(businessId: 'business-1', timestamp: timestamp);

      expect(repository.savedCategories, hasLength(5));

      expect(
        repository.savedCategories.any(
          (category) => category.name == 'Operasional',
        ),
        isFalse,
      );
    });

    test('is idempotent after categories exist', () async {
      final repository = _FakeCategoryRepository();

      final useCase = EnsureDefaultExpenseCategoriesUseCase(repository);

      await useCase(businessId: 'business-1', timestamp: timestamp);

      repository.existingCategories.addAll(repository.savedCategories);

      repository.savedCategories.clear();

      await useCase(businessId: 'business-1', timestamp: timestamp);

      expect(repository.savedCategories, isEmpty);
    });

    test('rejects empty business id', () {
      final repository = _FakeCategoryRepository();

      final useCase = EnsureDefaultExpenseCategoriesUseCase(repository);

      expect(
        () => useCase(businessId: '   ', timestamp: timestamp),
        throwsA(isA<ArgumentError>()),
      );
    });
  });
}

final class _FakeCategoryRepository implements CategoryRepository {
  _FakeCategoryRepository({List<Category>? existingCategories})
    : existingCategories = existingCategories ?? [];

  final List<Category> existingCategories;
  final List<Category> savedCategories = [];

  @override
  Stream<List<Category>> watchCategories({
    required String businessId,
    CategoryType? type,
  }) {
    final result = existingCategories
        .where((category) {
          return category.businessId == businessId &&
              (type == null || category.type == type);
        })
        .toList(growable: false);

    return Stream.value(result);
  }

  @override
  Future<void> saveCategory(Category category) async {
    savedCategories.add(category);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) {
    throw UnimplementedError(
      '${invocation.memberName} tidak digunakan '
      'dalam test ini.',
    );
  }
}
