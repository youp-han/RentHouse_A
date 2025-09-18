import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:renthouse/features/reports/data/reports_repository.dart';
import 'package:renthouse/features/reports/domain/monthly_revenue_report.dart';

part 'reports_controller.g.dart';

@riverpod
class ReportsController extends _$ReportsController {
  @override
  FutureOr<void> build() {
    // 초기 상태
  }

  /// 월별 수익 보고서 가져오기
  Future<MonthlyRevenueReport> getMonthlyRevenueReport(String yearMonth) async {
    final repository = ref.read(reportsRepositoryProvider);
    return await repository.getMonthlyRevenueReport(yearMonth);
  }

  /// 연체 보고서 가져오기
  Future<List<OverdueReport>> getOverdueReports() async {
    final repository = ref.read(reportsRepositoryProvider);
    return await repository.getOverdueReports();
  }

  /// 점유율 보고서 가져오기
  Future<List<OccupancyReport>> getOccupancyReports() async {
    final repository = ref.read(reportsRepositoryProvider);
    return await repository.getOccupancyReports();
  }
}

/// 월별 수익 보고서 프로바이더
@riverpod
Future<MonthlyRevenueReport> monthlyRevenueReport(MonthlyRevenueReportRef ref, String yearMonth) async {
  final repository = ref.watch(reportsRepositoryProvider);
  return await repository.getMonthlyRevenueReport(yearMonth);
}

/// 연체 보고서 프로바이더
@riverpod
Future<List<OverdueReport>> overdueReports(OverdueReportsRef ref) async {
  final repository = ref.watch(reportsRepositoryProvider);
  return await repository.getOverdueReports();
}

/// 점유율 보고서 프로바이더
@riverpod
Future<List<OccupancyReport>> occupancyReports(OccupancyReportsRef ref) async {
  final repository = ref.watch(reportsRepositoryProvider);
  return await repository.getOccupancyReports();
}