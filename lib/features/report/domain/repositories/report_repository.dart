import 'package:kasentra/features/report/domain/entities/report_summary.dart';

abstract class ReportRepository {
  Future<ReportSummary> getReportSummary({
    required String businessId,
    required DateTime startDate,
    required DateTime endDate,
  });
}
