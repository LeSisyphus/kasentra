enum TransactionType { sale, expense }

enum PaymentStatus { paid, unpaid }

class Transaction {
  const Transaction({
    required this.id,
    required this.businessId,
    required this.type,
    required this.totalAmount,
    required this.costAmount,
    required this.profitAmount,
    required this.paymentStatus,
    required this.transactionDate,
    required this.createdAt,
    required this.updatedAt,
    this.title,
    this.categoryId,
    this.contactName,
    this.contactPhone,
    this.note,
    this.syncedAt,
  });

  final String id;
  final String businessId;
  final TransactionType type;

  /// Nama singkat transaksi.
  ///
  /// Wajib untuk transaksi pengeluaran, misalnya:
  /// "Pembelian stok beras" atau "Bayar listrik".
  final String? title;

  /// Referensi kategori transaksi.
  ///
  /// Wajib untuk pengeluaran. Nullable untuk penjualan karena kategori
  /// penjualan berasal dari masing-masing produk atau item.
  final String? categoryId;

  /// Total transaksi dalam rupiah.
  final int totalAmount;

  /// Total modal barang yang terjual.
  ///
  /// Untuk transaksi pengeluaran nilainya 0 karena nominal pengeluaran
  /// disimpan pada totalAmount.
  final int costAmount;

  /// Estimasi laba transaksi penjualan.
  ///
  /// Untuk transaksi pengeluaran nilainya 0.
  final int profitAmount;

  final PaymentStatus paymentStatus;

  /// Dipakai saat penjualan belum lunas.
  final String? contactName;
  final String? contactPhone;

  final DateTime transactionDate;
  final String? note;

  final DateTime createdAt;
  final DateTime updatedAt;

  /// Metadata sementara untuk sinkronisasi.
  ///
  /// Field ini akan dipindahkan ke data model pada refactor berikutnya.
  final DateTime? syncedAt;

  bool get isSale {
    return type == TransactionType.sale;
  }

  bool get isExpense {
    return type == TransactionType.expense;
  }

  bool get isPaid {
    return paymentStatus == PaymentStatus.paid;
  }

  bool get isUnpaid {
    return paymentStatus == PaymentStatus.unpaid;
  }

  bool get shouldCreateReceivable {
    return isSale && isUnpaid;
  }

  Transaction copyWith({
    String? id,
    String? businessId,
    TransactionType? type,
    String? title,
    bool clearTitle = false,
    String? categoryId,
    bool clearCategoryId = false,
    int? totalAmount,
    int? costAmount,
    int? profitAmount,
    PaymentStatus? paymentStatus,
    String? contactName,
    bool clearContactName = false,
    String? contactPhone,
    bool clearContactPhone = false,
    DateTime? transactionDate,
    String? note,
    bool clearNote = false,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? syncedAt,
    bool clearSyncedAt = false,
  }) {
    return Transaction(
      id: id ?? this.id,
      businessId: businessId ?? this.businessId,
      type: type ?? this.type,
      title: clearTitle ? null : title ?? this.title,
      categoryId: clearCategoryId ? null : categoryId ?? this.categoryId,
      totalAmount: totalAmount ?? this.totalAmount,
      costAmount: costAmount ?? this.costAmount,
      profitAmount: profitAmount ?? this.profitAmount,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      contactName: clearContactName ? null : contactName ?? this.contactName,
      contactPhone: clearContactPhone
          ? null
          : contactPhone ?? this.contactPhone,
      transactionDate: transactionDate ?? this.transactionDate,
      note: clearNote ? null : note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncedAt: clearSyncedAt ? null : syncedAt ?? this.syncedAt,
    );
  }
}
