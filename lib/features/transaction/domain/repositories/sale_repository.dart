import 'package:kasentra/features/transaction/domain/entities/sale.dart';

abstract class SaleRepository {
  /// Mencatat seluruh penjualan sebagai satu operasi atomik.
  ///
  /// Implementasi data layer wajib memastikan bahwa operasi berikut
  /// berhasil seluruhnya atau dibatalkan seluruhnya:
  ///
  /// 1. menyimpan transaksi;
  /// 2. menyimpan semua item;
  /// 3. mengurangi stok produk yang dikelola;
  /// 4. membuat piutang jika pembayaran belum lunas.
  ///
  /// Transaction ID digunakan sebagai idempotency key agar pengulangan
  /// request tidak membuat penjualan ganda.
  Future<void> recordSale(Sale sale);
}
