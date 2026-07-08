import 'package:flutter_test/flutter_test.dart';
import 'package:kasentra/features/debt/domain/entities/debt.dart';
import 'package:kasentra/features/report/domain/services/report_calculator.dart';
import 'package:kasentra/features/transaction/domain/entities/transaction.dart';

void main() {
  group('ReportCalculator', () {
    test('calculates report summary for selected business and date range', () {
      final calculator = ReportCalculator();

      final startDate = DateTime(2026, 7, 1);
      final endDate = DateTime(2026, 7, 31);

      final transactions = [
        Transaction(
          id: 'trx-1',
          businessId: 'business-1',
          type: TransactionType.sale,
          totalAmount: 100000,
          costAmount: 60000,
          profitAmount: 40000,
          paymentStatus: PaymentStatus.paid,
          transactionDate: DateTime(2026, 7, 5),
          createdAt: DateTime(2026, 7, 5),
          updatedAt: DateTime(2026, 7, 5),
        ),
        Transaction(
          id: 'trx-2',
          businessId: 'business-1',
          type: TransactionType.expense,
          totalAmount: 25000,
          costAmount: 0,
          profitAmount: 0,
          paymentStatus: PaymentStatus.paid,
          transactionDate: DateTime(2026, 7, 6),
          createdAt: DateTime(2026, 7, 6),
          updatedAt: DateTime(2026, 7, 6),
        ),
        Transaction(
          id: 'trx-3',
          businessId: 'business-2',
          type: TransactionType.sale,
          totalAmount: 999000,
          costAmount: 0,
          profitAmount: 0,
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
          amount: 50000,
          createdAt: DateTime(2026, 7, 1),
          updatedAt: DateTime(2026, 7, 1),
        ),
        Debt(
          id: 'debt-2',
          businessId: 'business-1',
          type: DebtType.receivable,
          status: DebtStatus.unpaid,
          contactName: 'Bu Rina',
          amount: 75000,
          createdAt: DateTime(2026, 7, 1),
          updatedAt: DateTime(2026, 7, 1),
        ),
        Debt(
          id: 'debt-3',
          businessId: 'business-1',
          type: DebtType.receivable,
          status: DebtStatus.paid,
          contactName: 'Pak Budi',
          amount: 120000,
          createdAt: DateTime(2026, 7, 1),
          updatedAt: DateTime(2026, 7, 1),
        ),
      ];

      final summary = calculator.calculate(
        businessId: 'business-1',
        startDate: startDate,
        endDate: endDate,
        transactions: transactions,
        debts: debts,
      );

      expect(summary.totalSales, 100000);
      expect(summary.totalExpenses, 25000);
      expect(summary.netProfit, 75000);
      expect(summary.totalTransactionCount, 2);
      expect(summary.totalPayable, 50000);
      expect(summary.totalReceivable, 75000);
      expect(summary.isProfitable, true);
      expect(summary.hasDebtOrReceivable, true);
    });
  });
}
