import 'package:freezed_annotation/freezed_annotation.dart';

part 'monthly_revenue_report.freezed.dart';
part 'monthly_revenue_report.g.dart';

@freezed
class MonthlyRevenueReport with _$MonthlyRevenueReport {
  const factory MonthlyRevenueReport({
    required String yearMonth, // YYYY-MM 형태
    required int totalBilledAmount, // 총 청구액
    required int totalReceivedAmount, // 총 수납액
    required double collectionRate, // 수납률 (%)
    int? previousYearBilledAmount, // 전년 동월 청구액
    int? previousYearReceivedAmount, // 전년 동월 수납액
    double? billedAmountGrowthRate, // 청구액 증감률 (%)
    double? receivedAmountGrowthRate, // 수납액 증감률 (%)
    required int pendingAmount, // 미납액
    required int overdueAmount, // 연체액
  }) = _MonthlyRevenueReport;

  const MonthlyRevenueReport._();

  factory MonthlyRevenueReport.fromJson(Map<String, dynamic> json) => 
      _$MonthlyRevenueReportFromJson(json);

  /// 수납률 계산
  double get calculatedCollectionRate {
    if (totalBilledAmount == 0) return 0.0;
    return (totalReceivedAmount / totalBilledAmount) * 100;
  }

  /// 전년 대비 청구액 증감률 계산
  double get calculatedBilledGrowthRate {
    if (previousYearBilledAmount == null || previousYearBilledAmount == 0) return 0.0;
    return ((totalBilledAmount - previousYearBilledAmount!) / previousYearBilledAmount!) * 100;
  }

  /// 전년 대비 수납액 증감률 계산
  double get calculatedReceivedGrowthRate {
    if (previousYearReceivedAmount == null || previousYearReceivedAmount == 0) return 0.0;
    return ((totalReceivedAmount - previousYearReceivedAmount!) / previousYearReceivedAmount!) * 100;
  }
}

@freezed
class OverdueReport with _$OverdueReport {
  const factory OverdueReport({
    required String tenantId,
    required String tenantName,
    required String unitId,
    required String unitNumber,
    required String propertyName,
    required int overdueAmount, // 연체 금액
    required int overdueDays, // 연체 일수
    required DateTime oldestOverdueDate, // 가장 오래된 연체 날짜
    required List<OverdueBilling> overdueList, // 연체된 청구서 목록
  }) = _OverdueReport;

  factory OverdueReport.fromJson(Map<String, dynamic> json) => 
      _$OverdueReportFromJson(json);
}

@freezed
class OverdueBilling with _$OverdueBilling {
  const factory OverdueBilling({
    required String billingId,
    required String yearMonth,
    required int amount,
    required DateTime dueDate,
    required int overdueDays,
  }) = _OverdueBilling;

  factory OverdueBilling.fromJson(Map<String, dynamic> json) => 
      _$OverdueBillingFromJson(json);
}

@freezed
class OccupancyReport with _$OccupancyReport {
  const factory OccupancyReport({
    required String propertyId,
    required String propertyName,
    required int totalUnits, // 총 유닛 수
    required int occupiedUnits, // 임대 중인 유닛 수
    required int vacantUnits, // 공실 유닛 수
    required double occupancyRate, // 점유율 (%)
    required int potentialMonthlyRevenue, // 잠재 월 수익 (모든 유닛 임대 시)
    required int actualMonthlyRevenue, // 실제 월 수익
    required int revenueloss, // 공실로 인한 수익 손실
  }) = _OccupancyReport;

  const OccupancyReport._();

  factory OccupancyReport.fromJson(Map<String, dynamic> json) => 
      _$OccupancyReportFromJson(json);

  /// 점유율 계산
  double get calculatedOccupancyRate {
    if (totalUnits == 0) return 0.0;
    return (occupiedUnits / totalUnits) * 100;
  }

  /// 수익 손실률 계산
  double get revenueLossRate {
    if (potentialMonthlyRevenue == 0) return 0.0;
    return (revenueloss / potentialMonthlyRevenue) * 100;
  }
}