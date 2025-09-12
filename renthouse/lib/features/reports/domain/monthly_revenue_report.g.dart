// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'monthly_revenue_report.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MonthlyRevenueReportImpl _$$MonthlyRevenueReportImplFromJson(
  Map<String, dynamic> json,
) => _$MonthlyRevenueReportImpl(
  yearMonth: json['yearMonth'] as String,
  totalBilledAmount: (json['totalBilledAmount'] as num).toInt(),
  totalReceivedAmount: (json['totalReceivedAmount'] as num).toInt(),
  collectionRate: (json['collectionRate'] as num).toDouble(),
  previousYearBilledAmount: (json['previousYearBilledAmount'] as num?)?.toInt(),
  previousYearReceivedAmount: (json['previousYearReceivedAmount'] as num?)
      ?.toInt(),
  billedAmountGrowthRate: (json['billedAmountGrowthRate'] as num?)?.toDouble(),
  receivedAmountGrowthRate: (json['receivedAmountGrowthRate'] as num?)
      ?.toDouble(),
  pendingAmount: (json['pendingAmount'] as num).toInt(),
  overdueAmount: (json['overdueAmount'] as num).toInt(),
);

Map<String, dynamic> _$$MonthlyRevenueReportImplToJson(
  _$MonthlyRevenueReportImpl instance,
) => <String, dynamic>{
  'yearMonth': instance.yearMonth,
  'totalBilledAmount': instance.totalBilledAmount,
  'totalReceivedAmount': instance.totalReceivedAmount,
  'collectionRate': instance.collectionRate,
  'previousYearBilledAmount': instance.previousYearBilledAmount,
  'previousYearReceivedAmount': instance.previousYearReceivedAmount,
  'billedAmountGrowthRate': instance.billedAmountGrowthRate,
  'receivedAmountGrowthRate': instance.receivedAmountGrowthRate,
  'pendingAmount': instance.pendingAmount,
  'overdueAmount': instance.overdueAmount,
};

_$OverdueReportImpl _$$OverdueReportImplFromJson(Map<String, dynamic> json) =>
    _$OverdueReportImpl(
      tenantId: json['tenantId'] as String,
      tenantName: json['tenantName'] as String,
      unitId: json['unitId'] as String,
      unitNumber: json['unitNumber'] as String,
      propertyName: json['propertyName'] as String,
      overdueAmount: (json['overdueAmount'] as num).toInt(),
      overdueDays: (json['overdueDays'] as num).toInt(),
      oldestOverdueDate: DateTime.parse(json['oldestOverdueDate'] as String),
      overdueList: (json['overdueList'] as List<dynamic>)
          .map((e) => OverdueBilling.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$OverdueReportImplToJson(_$OverdueReportImpl instance) =>
    <String, dynamic>{
      'tenantId': instance.tenantId,
      'tenantName': instance.tenantName,
      'unitId': instance.unitId,
      'unitNumber': instance.unitNumber,
      'propertyName': instance.propertyName,
      'overdueAmount': instance.overdueAmount,
      'overdueDays': instance.overdueDays,
      'oldestOverdueDate': instance.oldestOverdueDate.toIso8601String(),
      'overdueList': instance.overdueList,
    };

_$OverdueBillingImpl _$$OverdueBillingImplFromJson(Map<String, dynamic> json) =>
    _$OverdueBillingImpl(
      billingId: json['billingId'] as String,
      yearMonth: json['yearMonth'] as String,
      amount: (json['amount'] as num).toInt(),
      dueDate: DateTime.parse(json['dueDate'] as String),
      overdueDays: (json['overdueDays'] as num).toInt(),
    );

Map<String, dynamic> _$$OverdueBillingImplToJson(
  _$OverdueBillingImpl instance,
) => <String, dynamic>{
  'billingId': instance.billingId,
  'yearMonth': instance.yearMonth,
  'amount': instance.amount,
  'dueDate': instance.dueDate.toIso8601String(),
  'overdueDays': instance.overdueDays,
};

_$OccupancyReportImpl _$$OccupancyReportImplFromJson(
  Map<String, dynamic> json,
) => _$OccupancyReportImpl(
  propertyId: json['propertyId'] as String,
  propertyName: json['propertyName'] as String,
  totalUnits: (json['totalUnits'] as num).toInt(),
  occupiedUnits: (json['occupiedUnits'] as num).toInt(),
  vacantUnits: (json['vacantUnits'] as num).toInt(),
  occupancyRate: (json['occupancyRate'] as num).toDouble(),
  potentialMonthlyRevenue: (json['potentialMonthlyRevenue'] as num).toInt(),
  actualMonthlyRevenue: (json['actualMonthlyRevenue'] as num).toInt(),
  revenueloss: (json['revenueloss'] as num).toInt(),
);

Map<String, dynamic> _$$OccupancyReportImplToJson(
  _$OccupancyReportImpl instance,
) => <String, dynamic>{
  'propertyId': instance.propertyId,
  'propertyName': instance.propertyName,
  'totalUnits': instance.totalUnits,
  'occupiedUnits': instance.occupiedUnits,
  'vacantUnits': instance.vacantUnits,
  'occupancyRate': instance.occupancyRate,
  'potentialMonthlyRevenue': instance.potentialMonthlyRevenue,
  'actualMonthlyRevenue': instance.actualMonthlyRevenue,
  'revenueloss': instance.revenueloss,
};
