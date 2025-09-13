import 'package:freezed_annotation/freezed_annotation.dart';

part 'dashboard_stats.freezed.dart';
part 'dashboard_stats.g.dart';

@freezed
class DashboardStats with _$DashboardStats {
  const factory DashboardStats({
    required int currentMonthBillingAmount,  // 이번 달 청구 합계
    required int currentMonthPaymentAmount,  // 이번 달 수납 합계
    required int unpaidCount,                // 미납 건수
    required int unpaidAmount,               // 총 미납액
    required int activeLeaseCount,           // 활성 계약 수
    required int overdueCount,               // 연체 건수
    required int overdueAmount,              // 연체 금액
    required int overduePercentage,          // 연체 비중 (%)
    required int currentMonthOverdueRate,    // 이번 달 연체율 (%)
    required DateTime lastUpdated,           // 마지막 업데이트 시간
  }) = _DashboardStats;

  factory DashboardStats.fromJson(Map<String, dynamic> json) => 
    _$DashboardStatsFromJson(json);
}