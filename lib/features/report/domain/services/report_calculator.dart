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
    final filteredTransactions = transactions
        .where((transaction) {
          return transaction.businessId == businessId &&
              _isWithinRange(transaction.transactionDate, startDate, endDate);
        })
        .toList(growable: false);

    final saleTransactions = filteredTransactions
        .where((transaction) => transaction.isSale)
        .toList(growable: false);

    final expenseTransactions = filteredTransactions
        .where((transaction) => transaction.isExpense)
        .toList(growable: false);

    final totalSales = saleTransactions.fold<int>(
      0,
      (total, transaction) => total + transaction.totalAmount,
    );

    final costOfGoodsSold = saleTransactions.fold<int>(
      0,
      (total, transaction) => total + transaction.costAmount,
    );

    final grossProfit = totalSales - costOfGoodsSold;

    final totalExpenses = expenseTransactions.fold<int>(
      0,
      (total, transaction) => total + transaction.totalAmount,
    );

    final netProfit = grossProfit - totalExpenses;

    final filteredDebts = debts.where((debt) {
      return debt.businessId == businessId;
    });

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
      costOfGoodsSold: costOfGoodsSold,
      grossProfit: grossProfit,
      totalExpenses: totalExpenses,
      netProfit: netProfit,
      totalTransactionCount: filteredTransactions.length,
      totalPayable: totalPayable,
      totalReceivable: totalReceivable,
    );
  }

  bool _isWithinRange(DateTime date, DateTime startDate, DateTime endDate) {
    final normalizedDate = _dateOnly(date);
    final normalizedStartDate = _dateOnly(startDate);
    final normalizedEndDate = _dateOnly(endDate);

    return !normalizedDate.isBefore(normalizedStartDate) &&
        !normalizedDate.isAfter(normalizedEndDate);
  }

  DateTime _dateOnly(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }
}
