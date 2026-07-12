class ReportSummary {
  const ReportSummary({
    required this.businessId,
    required this.startDate,
    required this.endDate,
    required this.totalSales,
    required this.costOfGoodsSold,
    required this.grossProfit,
    required this.totalExpenses,
    required this.netProfit,
    required this.totalTransactionCount,
    required this.totalPayable,
    required this.totalReceivable,
  });

  final String businessId;
  final DateTime startDate;
  final DateTime endDate;

  /// Total pendapatan dari transaksi penjualan.
  final int totalSales;

  /// Total harga modal barang yang terjual.
  ///
  /// Dalam laporan keuangan umum dikenal sebagai HPP
  /// atau cost of goods sold.
  final int costOfGoodsSold;

  /// Laba sebelum dikurangi pengeluaran operasional.
  ///
  /// Rumus:
  /// totalSales - costOfGoodsSold.
  final int grossProfit;

  /// Total pengeluaran operasional usaha.
  final int totalExpenses;

  /// Laba setelah modal barang dan pengeluaran operasional.
  ///
  /// Rumus:
  /// grossProfit - totalExpenses.
  final int netProfit;

  final int totalTransactionCount;

  /// Utang usaha yang belum lunas kepada pihak lain.
  final int totalPayable;

  /// Piutang pelanggan yang belum dilunasi.
  final int totalReceivable;

  bool get isProfitable {
    return netProfit > 0;
  }

  bool get hasDebtOrReceivable {
    return totalPayable > 0 || totalReceivable > 0;
  }
}
