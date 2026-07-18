enum DebtType { payable, receivable }

enum DebtStatus { unpaid, paid }

class Debt {
  const Debt({
    required this.id,
    required this.businessId,
    required this.type,
    required this.status,
    required this.contactName,
    required this.amount,
    required this.createdAt,
    required this.updatedAt,
    this.contactPhone,
    this.dueDate,
    this.paidAt,
    this.note,
    this.sourceTransactionId,
  });

  final String id;
  final String businessId;

  /// payable = utang usaha ke orang lain.
  /// receivable = piutang pelanggan ke usaha.
  final DebtType type;

  final DebtStatus status;

  final String contactName;
  final String? contactPhone;

  /// Nominal utang/piutang dalam rupiah.
  final int amount;

  final DateTime? dueDate;
  final DateTime? paidAt;
  final String? note;

  /// Dipakai kalau piutang dibuat otomatis dari transaksi belum lunas.
  final String? sourceTransactionId;

  final DateTime createdAt;
  final DateTime updatedAt;

  /// Nullable untuk future cloud sync.

  bool get isPayable {
    return type == DebtType.payable;
  }

  bool get isReceivable {
    return type == DebtType.receivable;
  }

  bool get isPaid {
    return status == DebtStatus.paid;
  }

  bool get isUnpaid {
    return status == DebtStatus.unpaid;
  }

  bool get hasDueDate {
    return dueDate != null;
  }

  bool isOverdue(DateTime now) {
    return isUnpaid && dueDate != null && dueDate!.isBefore(now);
  }

  Debt copyWith({
    String? id,
    String? businessId,
    DebtType? type,
    DebtStatus? status,
    String? contactName,
    String? contactPhone,
    bool clearContactPhone = false,
    int? amount,
    DateTime? dueDate,
    bool clearDueDate = false,
    DateTime? paidAt,
    bool clearPaidAt = false,
    String? note,
    bool clearNote = false,
    String? sourceTransactionId,
    bool clearSourceTransactionId = false,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Debt(
      id: id ?? this.id,
      businessId: businessId ?? this.businessId,
      type: type ?? this.type,
      status: status ?? this.status,
      contactName: contactName ?? this.contactName,
      contactPhone: clearContactPhone
          ? null
          : contactPhone ?? this.contactPhone,
      amount: amount ?? this.amount,
      dueDate: clearDueDate ? null : dueDate ?? this.dueDate,
      paidAt: clearPaidAt ? null : paidAt ?? this.paidAt,
      note: clearNote ? null : note ?? this.note,
      sourceTransactionId: clearSourceTransactionId
          ? null
          : sourceTransactionId ?? this.sourceTransactionId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
