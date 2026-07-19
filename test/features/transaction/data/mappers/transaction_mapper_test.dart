import 'package:flutter_test/flutter_test.dart';
import 'package:kasentra/core/database/app_database.dart';
import 'package:kasentra/features/transaction/data/mappers/transaction_item_mapper.dart';
import 'package:kasentra/features/transaction/data/mappers/transaction_mapper.dart';
import 'package:kasentra/features/transaction/domain/entities/transaction.dart';

void main() {
  group('TransactionMapper', () {
    final createdAt = DateTime.utc(2025, 1, 1, 8);
    final updatedAt = DateTime.utc(2025, 1, 1, 9);
    final transactionDate = DateTime.utc(2025, 1, 1);

    TransactionRow createRow({
      String type = 'expense',
      String paymentStatus = 'paid',
    }) {
      return TransactionRow(
        id: 'transaction-1',
        businessId: 'business-1',
        type: type,
        title: 'Bayar listrik',
        categoryId: 'category-expense-1',
        totalAmount: 150000,
        costAmount: 0,
        profitAmount: 0,
        paymentStatus: paymentStatus,
        contactName: null,
        contactPhone: null,
        transactionDate: transactionDate,
        note: 'Tagihan bulan Januari',
        createdAt: createdAt,
        updatedAt: updatedAt,
        syncedAt: null,
      );
    }

    test('maps a database row to a domain entity', () {
      final entity = TransactionMapper.toDomain(createRow());

      expect(entity.id, 'transaction-1');
      expect(entity.businessId, 'business-1');
      expect(entity.type, TransactionType.expense);
      expect(entity.title, 'Bayar listrik');
      expect(entity.categoryId, 'category-expense-1');
      expect(entity.totalAmount, 150000);
      expect(entity.costAmount, 0);
      expect(entity.profitAmount, 0);
      expect(entity.paymentStatus, PaymentStatus.paid);
      expect(entity.transactionDate, transactionDate);
      expect(entity.createdAt, createdAt);
      expect(entity.updatedAt, updatedAt);
    });

    test('maps a domain entity to a database companion', () {
      final entity = TransactionMapper.toDomain(createRow());

      final companion = TransactionMapper.toCompanion(entity);

      expect(companion.id.value, 'transaction-1');
      expect(companion.businessId.value, 'business-1');
      expect(companion.type.value, 'expense');
      expect(companion.paymentStatus.value, 'paid');
      expect(companion.totalAmount.value, 150000);
      expect(companion.syncedAt.present, isTrue);
      expect(companion.syncedAt.value, isNull);
    });

    test('rejects an unknown transaction type', () {
      expect(
        () => TransactionMapper.toDomain(createRow(type: 'refund')),
        throwsA(isA<FormatException>()),
      );
    });

    test('rejects an unknown payment status', () {
      expect(
        () => TransactionMapper.toDomain(createRow(paymentStatus: 'pending')),
        throwsA(isA<FormatException>()),
      );
    });
  });

  group('TransactionItemMapper', () {
    test('maps a nullable database cost price to zero', () {
      const row = TransactionItemRow(
        id: 'item-1',
        transactionId: 'transaction-1',
        productId: null,
        itemName: 'Beras',
        quantity: 2,
        sellingPrice: 15000,
        costPrice: null,
        subtotal: 30000,
      );

      final entity = TransactionItemMapper.toDomain(row);

      expect(entity.id, 'item-1');
      expect(entity.transactionId, 'transaction-1');
      expect(entity.productId, isNull);
      expect(entity.itemName, 'Beras');
      expect(entity.quantity, 2);
      expect(entity.sellingPrice, 15000);
      expect(entity.costPrice, 0);
      expect(entity.subtotal, 30000);
      expect(entity.totalCost, 0);
      expect(entity.profit, 30000);
    });
  });
}
