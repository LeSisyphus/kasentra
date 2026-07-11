import 'package:flutter_test/flutter_test.dart';
import 'package:kasentra/features/report/domain/entities/report_summary.dart';
import 'package:kasentra/features/report/domain/repositories/report_repository.dart';
import 'package:kasentra/features/report/domain/usecases/get_report_summary_usecase.dart';

void main() {
  group('GetReportSummaryUseCase', () {
    late _FakeReportRepository repository;
    late GetReportSummaryUseCase useCase;

    setUp(() {
      repository = _FakeReportRepository();
      useCase = GetReportSummaryUseCase(repository);
    });

    test('requests report summary using normalized date range', () async {
      final result = await useCase(
        businessId: ' business-1 ',
        startDate: DateTime(2026, 7, 1, 15, 30),
        endDate: DateTime(2026, 7, 31, 9, 45),
      );

      expect(result.businessId, 'business-1');
      expect(repository.receivedBusinessId, 'business-1');
      expect(repository.receivedStartDate, DateTime(2026, 7, 1));
      expect(repository.receivedEndDate, DateTime(2026, 7, 31));
    });

    test('throws when business id is empty', () {
      expect(
        () => useCase(
          businessId: '   ',
          startDate: DateTime(2026, 7, 1),
          endDate: DateTime(2026, 7, 31),
        ),
        throwsArgumentError,
      );
    });

    test('throws when start date is after end date', () {
      expect(
        () => useCase(
          businessId: 'business-1',
          startDate: DateTime(2026, 8, 1),
          endDate: DateTime(2026, 7, 31),
        ),
        throwsArgumentError,
      );
    });
  });
}

class _FakeReportRepository implements ReportRepository {
  String? receivedBusinessId;
  DateTime? receivedStartDate;
  DateTime? receivedEndDate;

  @override
  Future<ReportSummary> getReportSummary({
    required String businessId,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    receivedBusinessId = businessId;
    receivedStartDate = startDate;
    receivedEndDate = endDate;

    return ReportSummary(
      businessId: businessId,
      startDate: startDate,
      endDate: endDate,
      totalSales: 1000000,
      totalExpenses: 300000,
      netProfit: 700000,
      totalTransactionCount: 12,
      totalPayable: 200000,
      totalReceivable: 150000,
    );
  }
}
