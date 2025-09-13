import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:renthouse/core/database/database_provider.dart';
import 'package:renthouse/features/dashboard/domain/dashboard_stats.dart';

part 'dashboard_controller.g.dart';

@riverpod
class DashboardController extends _$DashboardController {
  @override
  Future<DashboardStats> build() async {
    final database = ref.read(appDatabaseProvider);
    final now = DateTime.now();
    
    // 이번 달 시작일과 종료일
    final currentMonthStart = DateTime(now.year, now.month, 1);
    final currentMonthEnd = DateTime(now.year, now.month + 1, 1).subtract(const Duration(days: 1));
    
    // 1. 이번 달 청구 합계
    final allBillings = await database.getAllBillings();
    final currentMonthBillings = allBillings.where((billing) {
      final billingDate = DateTime.parse('${billing.yearMonth}-01');
      return billingDate.year == now.year && billingDate.month == now.month;
    }).toList();
    
    final totalBillingAmount = currentMonthBillings.fold<int>(
      0, (sum, billing) => sum + billing.totalAmount
    );
    
    // 2. 이번 달 수납 합계
    final allPayments = await database.getAllPayments();
    final currentMonthPayments = allPayments.where((payment) =>
      payment.paidDate.isAfter(currentMonthStart.subtract(const Duration(days: 1))) &&
      payment.paidDate.isBefore(currentMonthEnd.add(const Duration(days: 1)))
    ).toList();
    
    final totalPaymentAmount = currentMonthPayments.fold<int>(
      0, (sum, payment) => sum + payment.amount
    );
    
    // 3. 미납 건수와 미납액
    final unpaidBillings = allBillings.where((billing) =>
      billing.status == 'ISSUED' || 
      billing.status == 'PARTIALLY_PAID' ||
      billing.status == 'OVERDUE'
    ).toList();
    
    int totalUnpaidAmount = 0;
    for (final billing in unpaidBillings) {
      final paidAmount = await database.getTotalPaidAmountForBilling(billing.id);
      totalUnpaidAmount += (billing.totalAmount - paidAmount);
    }
    
    // 4. 연체 건수와 연체 비중
    final overdueBillings = allBillings.where((billing) =>
      billing.status == 'OVERDUE' || 
      (billing.dueDate.isBefore(now) && billing.status != 'PAID')
    ).toList();
    
    int totalOverdueAmount = 0;
    for (final billing in overdueBillings) {
      final paidAmount = await database.getTotalPaidAmountForBilling(billing.id);
      totalOverdueAmount += (billing.totalAmount - paidAmount);
    }
    
    final overduePercentage = totalUnpaidAmount > 0 
      ? (totalOverdueAmount / totalUnpaidAmount * 100).round()
      : 0;
    
    // 5. 활성 계약 수
    final allLeases = await database.getAllLeases();
    final activeLeases = allLeases.where((lease) => lease.leaseStatus == 'active').length;
    
    // 6. 이번 달 연체율 (이번 달 청구 대비 연체액)
    final currentMonthOverdueAmount = currentMonthBillings.where((billing) =>
      billing.dueDate.isBefore(now) && billing.status != 'PAID'
    ).fold<int>(0, (sum, billing) => sum + billing.totalAmount);
    
    final currentMonthOverdueRate = totalBillingAmount > 0 
      ? (currentMonthOverdueAmount / totalBillingAmount * 100).round()
      : 0;
    
    return DashboardStats(
      currentMonthBillingAmount: totalBillingAmount,
      currentMonthPaymentAmount: totalPaymentAmount,
      unpaidCount: unpaidBillings.length,
      unpaidAmount: totalUnpaidAmount,
      activeLeaseCount: activeLeases,
      overdueCount: overdueBillings.length,
      overdueAmount: totalOverdueAmount,
      overduePercentage: overduePercentage,
      currentMonthOverdueRate: currentMonthOverdueRate,
      lastUpdated: DateTime.now(),
    );
  }
  
  Future<void> refresh() async {
    ref.invalidateSelf();
  }
}