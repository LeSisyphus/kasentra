import 'package:kasentra/features/debt/domain/entities/debt.dart';
import 'package:kasentra/features/report/domain/entities/report_summary.dart';
import 'package:kasentra/features/transaction/domain/entities/transaction.dart';

class ReportCalculator {
  const ReportCalculator();

  ReportSummary calculate({
    required String businessId,
    required DateTime startDate,
    required DateTime endDate,
    required List<Transaction> transactions,
    required List<Debt> debts,
  }) {
    final filteredTransactions = transactions.where((transaction) {
      return transaction.businessId == businessId &&
          _isWithinRange(transaction.transactionDate, startDate, endDate);
    }).toList();

    final filteredDebts = debts.where((debt) {
      return debt.businessId == businessId;
    }).toList();

    final totalSales = filteredTransactions
        .where((transaction) => transaction.isSale)
        .fold<int>(0, (total, transaction) => total + transaction.totalAmount);

    final totalExpenses = filteredTransactions
        .where((transaction) => transaction.isExpense)
        .fold<int>(0, (total, transaction) => total + transaction.totalAmount);

    final totalPayable = filteredDebts
        .where((debt) => debt.isPayable && debt.isUnpaid)
        .fold<int>(0, (total, debt) => total + debt.amount);

    final totalReceivable = filteredDebts
        .where((debt) => debt.isReceivable && debt.isUnpaid)
        .fold<int>(0, (total, debt) => total + debt.amount);

    return ReportSummary(
      businessId: businessId,
      startDate: startDate,
      endDate: endDate,
      totalSales: totalSales,
      totalExpenses: totalExpenses,
      netProfit: totalSales - totalExpenses,
      totalTransactionCount: filteredTransactions.length,
      totalPayable: totalPayable,
      totalReceivable: totalReceivable,
    );
  }

  bool _isWithinRange(DateTime date, DateTime startDate, DateTime endDate) {
    final normalizedDate = DateTime(date.year, date.month, date.day);
    final normalizedStart = DateTime(
      startDate.year,
      startDate.month,
      startDate.day,
    );
    final normalizedEnd = DateTime(endDate.year, endDate.month, endDate.day);

    return !normalizedDate.isBefore(normalizedStart) &&
        !normalizedDate.isAfter(normalizedEnd);
  }
}
