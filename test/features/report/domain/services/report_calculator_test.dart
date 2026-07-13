import 'package:flutter_test/flutter_test.dart';
import 'package:kasentra/features/debt/domain/entities/debt.dart';
import 'package:kasentra/features/report/domain/services/report_calculator.dart';
import 'package:kasentra/features/transaction/domain/entities/transaction.dart';

void main() {
  group('ReportCalculator', () {
    test('calculates gross and net profit using sales cost and expenses', () {
      const calculator = ReportCalculator();

      final startDate = DateTime(2026, 7, 1);
      final endDate = DateTime(2026, 7, 31);

      final transactions = [
        Transaction(
          id: 'trx-1',
          businessId: 'business-1',
          type: TransactionType.sale,
          totalAmount: 100_000,
          costAmount: 60_000,
          profitAmount: 40_000,
          paymentStatus: PaymentStatus.paid,
          transactionDate: DateTime(2026, 7, 5),
          createdAt: DateTime(2026, 7, 5),
          updatedAt: DateTime(2026, 7, 5),
        ),
        Transaction(
          id: 'trx-2',
          businessId: 'business-1',
          type: TransactionType.expense,
          title: 'Pembelian stok beras',
          categoryId: 'category-stock',
          totalAmount: 25_000,
          costAmount: 0,
          profitAmount: 0,
          paymentStatus: PaymentStatus.paid,
          transactionDate: DateTime(2026, 7, 6),
          createdAt: DateTime(2026, 7, 6),
          updatedAt: DateTime(2026, 7, 6),
        ),
        Transaction(
          id: 'trx-outside-period',
          businessId: 'business-1',
          type: TransactionType.sale,
          totalAmount: 500_000,
          costAmount: 200_000,
          profitAmount: 300_000,
          paymentStatus: PaymentStatus.paid,
          transactionDate: DateTime(2026, 8, 1),
          createdAt: DateTime(2026, 8, 1),
          updatedAt: DateTime(2026, 8, 1),
        ),
        Transaction(
          id: 'trx-other-business',
          businessId: 'business-2',
          type: TransactionType.sale,
          totalAmount: 999_000,
          costAmount: 100_000,
          profitAmount: 899_000,
          paymentStatus: PaymentStatus.paid,
          transactionDate: DateTime(2026, 7, 7),
          createdAt: DateTime(2026, 7, 7),
          updatedAt: DateTime(2026, 7, 7),
        ),
      ];

      final debts = [
        Debt(
          id: 'debt-1',
          businessId: 'business-1',
          type: DebtType.payable,
          status: DebtStatus.unpaid,
          contactName: 'Supplier Beras',
          amount: 50_000,
          createdAt: DateTime(2026, 7, 1),
          updatedAt: DateTime(2026, 7, 1),
        ),
        Debt(
          id: 'debt-2',
          businessId: 'business-1',
          type: DebtType.receivable,
          status: DebtStatus.unpaid,
          contactName: 'Bu Rina',
          amount: 75_000,
          createdAt: DateTime(2026, 7, 1),
          updatedAt: DateTime(2026, 7, 1),
        ),
        Debt(
          id: 'debt-paid',
          businessId: 'business-1',
          type: DebtType.receivable,
          status: DebtStatus.paid,
          contactName: 'Pak Budi',
          amount: 120_000,
          paidAt: DateTime(2026, 7, 10),
          createdAt: DateTime(2026, 7, 1),
          updatedAt: DateTime(2026, 7, 10),
        ),
      ];

      final summary = calculator.calculate(
        businessId: 'business-1',
        startDate: startDate,
        endDate: endDate,
        transactions: transactions,
        debts: debts,
      );

      expect(summary.totalSales, 100_000);
      expect(summary.costOfGoodsSold, 60_000);
      expect(summary.grossProfit, 40_000);
      expect(summary.totalExpenses, 25_000);
      expect(summary.netProfit, 15_000);

      expect(summary.grossProfit, summary.totalSales - summary.costOfGoodsSold);

      expect(summary.netProfit, summary.grossProfit - summary.totalExpenses);

      expect(summary.totalTransactionCount, 2);
      expect(summary.totalPayable, 50_000);
      expect(summary.totalReceivable, 75_000);
      expect(summary.isProfitable, true);
      expect(summary.hasDebtOrReceivable, true);
    });
  });
}
