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
    this.contactName,
    this.contactPhone,
    this.note,
    this.syncedAt,
  });

  final String id;
  final String businessId;
  final TransactionType type;

  /// Total transaksi dalam rupiah.
  final int totalAmount;

  /// Total modal dalam rupiah.
  /// Untuk pengeluaran, bisa 0.
  final int costAmount;

  /// Estimasi laba dalam rupiah.
  /// Untuk pengeluaran, bisa bernilai 0 atau negatif sesuai kebutuhan laporan.
  final int profitAmount;

  final PaymentStatus paymentStatus;

  /// Dipakai saat penjualan belum lunas.
  final String? contactName;
  final String? contactPhone;

  final DateTime transactionDate;
  final String? note;

  final DateTime createdAt;
  final DateTime updatedAt;

  /// Nullable untuk future cloud sync.
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
