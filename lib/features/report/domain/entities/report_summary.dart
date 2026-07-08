class ReportSummary {
  const ReportSummary({
    required this.businessId,
    required this.startDate,
    required this.endDate,
    required this.totalSales,
    required this.totalExpenses,
    required this.netProfit,
    required this.totalTransactionCount,
    required this.totalPayable,
    required this.totalReceivable,
  });

  final String businessId;
  final DateTime startDate;
  final DateTime endDate;

  /// Total pemasukan dari transaksi penjualan.
  final int totalSales;

  /// Total pengeluaran usaha.
  final int totalExpenses;

  /// Laba bersih sederhana.
  /// Rumus MVP: totalSales - totalExpenses.
  final int netProfit;

  final int totalTransactionCount;

  /// Utang usaha ke pihak lain.
  final int totalPayable;

  /// Piutang pelanggan ke usaha.
  final int totalReceivable;

  bool get isProfitable {
    return netProfit > 0;
  }

  bool get hasDebtOrReceivable {
    return totalPayable > 0 || totalReceivable > 0;
  }
}
