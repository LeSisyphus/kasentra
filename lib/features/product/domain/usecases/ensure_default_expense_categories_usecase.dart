import '../entities/category.dart';
import '../repositories/category_repository.dart';

class EnsureDefaultExpenseCategoriesUseCase {
  const EnsureDefaultExpenseCategoriesUseCase(this._repository);

  final CategoryRepository _repository;

  Future<void> call({
    required String businessId,
    required DateTime timestamp,
  }) async {
    final normalizedBusinessId = businessId.trim();

    if (normalizedBusinessId.isEmpty) {
      throw ArgumentError('Business id tidak boleh kosong.');
    }

    final normalizedTimestamp = timestamp.toUtc();

    final existingCategories = await _repository
        .watchCategories(
          businessId: normalizedBusinessId,
          type: CategoryType.expense,
        )
        .first;

    final existingNames = existingCategories
        .map((category) => _normalizeName(category.name))
        .toSet();

    for (final definition in _defaultDefinitions) {
      if (existingNames.contains(_normalizeName(definition.name))) {
        continue;
      }

      await _repository.saveCategory(
        Category(
          id:
              'category-$normalizedBusinessId-'
              'expense-${definition.idSuffix}',
          businessId: normalizedBusinessId,
          type: CategoryType.expense,
          name: definition.name,
          isDefault: true,
          createdAt: normalizedTimestamp,
          updatedAt: normalizedTimestamp,
        ),
      );
    }
  }
}

String _normalizeName(String value) {
  return value.trim().toLowerCase();
}

class _DefaultCategoryDefinition {
  const _DefaultCategoryDefinition({
    required this.idSuffix,
    required this.name,
  });

  final String idSuffix;
  final String name;
}

const List<_DefaultCategoryDefinition> _defaultDefinitions = [
  _DefaultCategoryDefinition(idSuffix: 'stock', name: 'Stok Barang'),
  _DefaultCategoryDefinition(idSuffix: 'operations', name: 'Operasional'),
  _DefaultCategoryDefinition(idSuffix: 'transport', name: 'Transport'),
  _DefaultCategoryDefinition(idSuffix: 'utilities', name: 'Listrik & Air'),
  _DefaultCategoryDefinition(idSuffix: 'rent', name: 'Sewa'),
  _DefaultCategoryDefinition(idSuffix: 'other', name: 'Lainnya'),
];
