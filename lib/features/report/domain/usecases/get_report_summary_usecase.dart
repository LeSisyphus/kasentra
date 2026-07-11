import 'package:kasentra/features/report/domain/entities/report_summary.dart';
import 'package:kasentra/features/report/domain/repositories/report_repository.dart';

class GetReportSummaryUseCase {
  const GetReportSummaryUseCase(this._repository);

  final ReportRepository _repository;

  Future<ReportSummary> call({
    required String businessId,
    required DateTime startDate,
    required DateTime endDate,
  }) {
    final trimmedBusinessId = businessId.trim();

    if (trimmedBusinessId.isEmpty) {
      throw ArgumentError('Business id tidak boleh kosong.');
    }

    final normalizedStartDate = _dateOnly(startDate);
    final normalizedEndDate = _dateOnly(endDate);

    if (normalizedStartDate.isAfter(normalizedEndDate)) {
      throw ArgumentError('Tanggal mulai tidak boleh setelah tanggal selesai.');
    }

    return _repository.getReportSummary(
      businessId: trimmedBusinessId,
      startDate: normalizedStartDate,
      endDate: normalizedEndDate,
    );
  }

  DateTime _dateOnly(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }
}
