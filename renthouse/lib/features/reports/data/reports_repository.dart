import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:renthouse/core/database/database_provider.dart';
import 'package:renthouse/features/reports/domain/monthly_revenue_report.dart';
import 'package:renthouse/core/database/app_database.dart';
import 'package:drift/drift.dart';

class ReportsRepository {
  final AppDatabase _database;

  ReportsRepository(this._database);

  /// 월별 수익 보고서 생성
  Future<MonthlyRevenueReport> getMonthlyRevenueReport(String yearMonth) async {
    // 현재 월 데이터 조회
    final currentMonthBillings = await (_database
        .select(_database.billings)
        ..where((tbl) => tbl.yearMonth.equals(yearMonth)))
        .get();

    final totalBilledAmount = currentMonthBillings
        .fold<int>(0, (sum, billing) => sum + billing.totalAmount);

    // 수납된 금액 계산 (PaymentAllocation을 통해)
    final paidAllocations = await _database.customSelect('''
      SELECT SUM(pa.amount) as total_received
      FROM payment_allocations pa
      JOIN billings b ON pa.billing_id = b.id
      WHERE b.year_month = ?
    ''', variables: [Variable.withString(yearMonth)]).getSingle();

    final totalReceivedAmount = paidAllocations.data['total_received'] as int? ?? 0;

    // 미납액과 연체액 계산
    final pendingAmount = totalBilledAmount - totalReceivedAmount;
    final overdueAmount = await _getOverdueAmountForMonth(yearMonth);

    // 전년 동월 데이터 조회
    final previousYear = int.parse(yearMonth.split('-')[0]) - 1;
    final previousYearMonth = '$previousYear-${yearMonth.split('-')[1]}';
    
    final previousYearBillings = await (_database
        .select(_database.billings)
        ..where((tbl) => tbl.yearMonth.equals(previousYearMonth)))
        .get();

    final previousYearBilledAmount = previousYearBillings.isNotEmpty 
        ? previousYearBillings.fold<int>(0, (sum, billing) => sum + billing.totalAmount)
        : null;

    final previousYearReceived = await _database.customSelect('''
      SELECT SUM(pa.amount) as total_received
      FROM payment_allocations pa
      JOIN billings b ON pa.billing_id = b.id
      WHERE b.year_month = ?
    ''', variables: [Variable.withString(previousYearMonth)]).getSingleOrNull();

    final previousYearReceivedAmount = previousYearReceived?.data['total_received'] as int?;

    return MonthlyRevenueReport(
      yearMonth: yearMonth,
      totalBilledAmount: totalBilledAmount,
      totalReceivedAmount: totalReceivedAmount,
      collectionRate: totalBilledAmount > 0 ? (totalReceivedAmount / totalBilledAmount) * 100 : 0,
      previousYearBilledAmount: previousYearBilledAmount,
      previousYearReceivedAmount: previousYearReceivedAmount,
      pendingAmount: pendingAmount,
      overdueAmount: overdueAmount,
    );
  }

  /// 연체 보고서 생성
  Future<List<OverdueReport>> getOverdueReports() async {
    final now = DateTime.now();
    
    // 연체된 청구서 조회 (상태가 OVERDUE이거나 due_date가 지난 것들)
    final overdueData = await _database.customSelect('''
      SELECT 
        b.id as billing_id,
        b.year_month,
        b.total_amount,
        b.due_date,
        t.id as tenant_id,
        t.name as tenant_name,
        u.id as unit_id,
        u.unit_number,
        p.name as property_name,
        COALESCE(SUM(pa.amount), 0) as paid_amount
      FROM billings b
      JOIN leases l ON b.lease_id = l.id
      JOIN tenants t ON l.tenant_id = t.id
      JOIN units u ON l.unit_id = u.id
      JOIN properties p ON u.property_id = p.id
      LEFT JOIN payment_allocations pa ON pa.billing_id = b.id
      WHERE b.due_date < ? AND (b.status = 'OVERDUE' OR b.status = 'ISSUED')
      GROUP BY b.id, b.year_month, b.total_amount, b.due_date, t.id, t.name, u.id, u.unit_number, p.name
    ''', variables: [Variable.withDateTime(now)]).get();

    // 임차인별로 그룹화하여 연체 보고서 생성
    final Map<String, List<Map<String, dynamic>>> groupedData = {};
    for (final row in overdueData) {
      final tenantId = row.data['tenant_id'] as String;
      if (!groupedData.containsKey(tenantId)) {
        groupedData[tenantId] = [];
      }
      groupedData[tenantId]!.add(row.data);
    }

    final reports = <OverdueReport>[];
    for (final entry in groupedData.entries) {
      final tenantData = entry.value;
      if (tenantData.isEmpty) continue;

      final firstRow = tenantData.first;
      final overdueList = <OverdueBilling>[];
      int totalOverdueAmount = 0;
      DateTime? oldestOverdueDate;

      for (final row in tenantData) {
        final dueDate = row['due_date'] as DateTime;
        final totalAmount = row['total_amount'] as int;
        final paidAmount = row['paid_amount'] as int;
        final overdueAmount = totalAmount - paidAmount;
        
        if (overdueAmount > 0) {
          final overdueDays = now.difference(dueDate).inDays;
          totalOverdueAmount += overdueAmount;
          
          if (oldestOverdueDate == null || dueDate.isBefore(oldestOverdueDate)) {
            oldestOverdueDate = dueDate;
          }

          overdueList.add(OverdueBilling(
            billingId: row['billing_id'] as String,
            yearMonth: row['year_month'] as String,
            amount: overdueAmount,
            dueDate: dueDate,
            overdueDays: overdueDays,
          ));
        }
      }

      if (overdueList.isNotEmpty && oldestOverdueDate != null) {
        reports.add(OverdueReport(
          tenantId: firstRow['tenant_id'] as String,
          tenantName: firstRow['tenant_name'] as String,
          unitId: firstRow['unit_id'] as String,
          unitNumber: firstRow['unit_number'] as String,
          propertyName: firstRow['property_name'] as String,
          overdueAmount: totalOverdueAmount,
          overdueDays: now.difference(oldestOverdueDate).inDays,
          oldestOverdueDate: oldestOverdueDate,
          overdueList: overdueList,
        ));
      }
    }

    // 연체 금액 순으로 정렬
    reports.sort((a, b) => b.overdueAmount.compareTo(a.overdueAmount));
    return reports;
  }

  /// 점유율 보고서 생성
  Future<List<OccupancyReport>> getOccupancyReports() async {
    final propertiesData = await _database.customSelect('''
      SELECT 
        p.id as property_id,
        p.name as property_name,
        COUNT(u.id) as total_units,
        SUM(CASE WHEN u.rent_status = 'OCCUPIED' THEN 1 ELSE 0 END) as occupied_units,
        SUM(CASE WHEN u.rent_status = 'VACANT' THEN 1 ELSE 0 END) as vacant_units,
        SUM(p.rent) as potential_monthly_revenue,
        COALESCE(SUM(CASE WHEN u.rent_status = 'OCCUPIED' THEN p.rent ELSE 0 END), 0) as actual_monthly_revenue
      FROM properties p
      LEFT JOIN units u ON p.id = u.property_id
      GROUP BY p.id, p.name, p.rent
    ''').get();

    final reports = <OccupancyReport>[];
    for (final row in propertiesData) {
      final totalUnits = row.data['total_units'] as int;
      final occupiedUnits = row.data['occupied_units'] as int;
      final vacantUnits = row.data['vacant_units'] as int;
      final potentialRevenue = row.data['potential_monthly_revenue'] as int;
      final actualRevenue = row.data['actual_monthly_revenue'] as int;
      final revenueLoss = potentialRevenue - actualRevenue;

      reports.add(OccupancyReport(
        propertyId: row.data['property_id'] as String,
        propertyName: row.data['property_name'] as String,
        totalUnits: totalUnits,
        occupiedUnits: occupiedUnits,
        vacantUnits: vacantUnits,
        occupancyRate: totalUnits > 0 ? (occupiedUnits / totalUnits) * 100 : 0,
        potentialMonthlyRevenue: potentialRevenue,
        actualMonthlyRevenue: actualRevenue,
        revenueloss: revenueLoss,
      ));
    }

    // 점유율 낮은 순으로 정렬 (문제가 있는 자산 우선)
    reports.sort((a, b) => a.occupancyRate.compareTo(b.occupancyRate));
    return reports;
  }

  /// 특정 월의 연체액 계산
  Future<int> _getOverdueAmountForMonth(String yearMonth) async {
    final now = DateTime.now();
    final overdueData = await _database.customSelect('''
      SELECT SUM(b.total_amount - COALESCE(pa.paid_amount, 0)) as overdue_amount
      FROM billings b
      LEFT JOIN (
        SELECT billing_id, SUM(amount) as paid_amount
        FROM payment_allocations
        GROUP BY billing_id
      ) pa ON b.id = pa.billing_id
      WHERE b.year_month = ? AND b.due_date < ?
    ''', variables: [
      Variable.withString(yearMonth),
      Variable.withDateTime(now)
    ]).getSingleOrNull();

    return overdueData?.data['overdue_amount'] as int? ?? 0;
  }
}

final reportsRepositoryProvider = Provider<ReportsRepository>((ref) {
  final database = ref.watch(appDatabaseProvider);
  return ReportsRepository(database);
});