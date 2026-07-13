import 'package:flutter_test/flutter_test.dart';
import 'package:kasentra/features/transaction/domain/entities/sale.dart';
import 'package:kasentra/features/transaction/domain/entities/transaction.dart';
import 'package:kasentra/features/transaction/domain/entities/transaction_item.dart';
import 'package:kasentra/features/transaction/domain/repositories/sale_repository.dart';
import 'package:kasentra/features/transaction/domain/usecases/record_sale_usecase.dart';

void main() {
  group('RecordSaleUseCase', () {
    late _FakeSaleRepository repository;
    late RecordSaleUseCase useCase;

    setUp(() {
      repository = _FakeSaleRepository();
      useCase = RecordSaleUseCase(repository);
    });

    test('records a valid sale through one repository call', () async {
      final sale = _createSale();

      await useCase(sale);

      expect(repository.callCount, 1);
      expect(repository.recordedSale, same(sale));
    });

    test('throws when transaction is not a sale', () {
      final sale = _createSale();

      final invalidSale = Sale(
        transaction: sale.transaction.copyWith(
          type: TransactionType.expense,
          title: 'Bayar listrik',
          categoryId: 'category-operational',
        ),
        items: sale.items,
      );

      expect(() => useCase(invalidSale), throwsA(isA<ArgumentError>()));

      expect(repository.callCount, 0);
    });

    test('throws when unpaid sale has no customer name', () {
      final sale = _createSale();

      final invalidSale = Sale(
        transaction: sale.transaction.copyWith(
          paymentStatus: PaymentStatus.unpaid,
          clearContactName: true,
        ),
        items: sale.items,
      );

      expect(() => useCase(invalidSale), throwsA(isA<ArgumentError>()));

      expect(repository.callCount, 0);
    });

    test('throws when calculated total does not match transaction', () {
      final sale = _createSale();

      final invalidSale = Sale(
        transaction: sale.transaction.copyWith(totalAmount: 120_000),
        items: sale.items,
      );

      expect(() => useCase(invalidSale), throwsA(isA<ArgumentError>()));

      expect(repository.callCount, 0);
    });

    test('throws when item transaction id is different', () {
      final sale = _createSale();

      final invalidItem = sale.items.first.copyWith(
        transactionId: 'another-transaction',
      );

      final invalidSale = Sale(
        transaction: sale.transaction,
        items: [invalidItem],
      );

      expect(() => useCase(invalidSale), throwsA(isA<ArgumentError>()));

      expect(repository.callCount, 0);
    });
  });
}

Sale _createSale() {
  final createdAt = DateTime(2026, 7, 13, 10);

  final transaction = Transaction(
    id: 'transaction-sale-1',
    businessId: 'business-1',
    type: TransactionType.sale,
    totalAmount: 100_000,
    costAmount: 60_000,
    profitAmount: 40_000,
    paymentStatus: PaymentStatus.paid,
    transactionDate: DateTime(2026, 7, 13),
    createdAt: createdAt,
    updatedAt: createdAt,
  );

  final items = [
    const TransactionItem(
      id: 'transaction-item-1',
      transactionId: 'transaction-sale-1',
      productId: 'product-rice',
      itemName: 'Beras 5 kg',
      quantity: 2,
      sellingPrice: 50_000,
      costPrice: 30_000,
      subtotal: 100_000,
    ),
  ];

  return Sale(transaction: transaction, items: items);
}

class _FakeSaleRepository implements SaleRepository {
  Sale? recordedSale;
  int callCount = 0;

  @override
  Future<void> recordSale(Sale sale) async {
    callCount++;
    recordedSale = sale;
  }
}
