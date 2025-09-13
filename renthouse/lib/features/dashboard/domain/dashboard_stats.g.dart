// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_stats.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DashboardStatsImpl _$$DashboardStatsImplFromJson(
  Map<String, dynamic> json,
) => _$DashboardStatsImpl(
  currentMonthBillingAmount: (json['currentMonthBillingAmount'] as num).toInt(),
  currentMonthPaymentAmount: (json['currentMonthPaymentAmount'] as num).toInt(),
  unpaidCount: (json['unpaidCount'] as num).toInt(),
  unpaidAmount: (json['unpaidAmount'] as num).toInt(),
  activeLeaseCount: (json['activeLeaseCount'] as num).toInt(),
  overdueCount: (json['overdueCount'] as num).toInt(),
  overdueAmount: (json['overdueAmount'] as num).toInt(),
  overduePercentage: (json['overduePercentage'] as num).toInt(),
  currentMonthOverdueRate: (json['currentMonthOverdueRate'] as num).toInt(),
  lastUpdated: DateTime.parse(json['lastUpdated'] as String),
);

Map<String, dynamic> _$$DashboardStatsImplToJson(
  _$DashboardStatsImpl instance,
) => <String, dynamic>{
  'currentMonthBillingAmount': instance.currentMonthBillingAmount,
  'currentMonthPaymentAmount': instance.currentMonthPaymentAmount,
  'unpaidCount': instance.unpaidCount,
  'unpaidAmount': instance.unpaidAmount,
  'activeLeaseCount': instance.activeLeaseCount,
  'overdueCount': instance.overdueCount,
  'overdueAmount': instance.overdueAmount,
  'overduePercentage': instance.overduePercentage,
  'currentMonthOverdueRate': instance.currentMonthOverdueRate,
  'lastUpdated': instance.lastUpdated.toIso8601String(),
};
