import 'package:kasentra/features/transaction/domain/entities/transaction.dart';

class TransactionCursor {
  const TransactionCursor({
    required this.transactionDate,
    required this.transactionId,
  });

  /// Posisi transaksi terakhir pada halaman sebelumnya.
  final DateTime transactionDate;

  /// Tie-breaker ketika beberapa transaksi memiliki tanggal yang sama.
  final String transactionId;
}

class TransactionPage {
  TransactionPage({
    required List<Transaction> items,
    required this.hasMore,
    this.nextCursor,
  }) : items = List<Transaction>.unmodifiable(items) {
    if (hasMore && nextCursor == null) {
      throw ArgumentError(
        'Next cursor wajib tersedia ketika masih ada halaman berikutnya.',
      );
    }

    if (!hasMore && nextCursor != null) {
      throw ArgumentError(
        'Next cursor harus null ketika tidak ada halaman berikutnya.',
      );
    }
  }

  final List<Transaction> items;
  final bool hasMore;
  final TransactionCursor? nextCursor;

  bool get isEmpty {
    return items.isEmpty;
  }

  bool get isNotEmpty {
    return items.isNotEmpty;
  }
}
