import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:renthouse/core/database/database_provider.dart';
import 'package:renthouse/core/database/app_database.dart' as app_db;
import 'package:renthouse/features/payment/domain/payment.dart' as domain;
import 'package:renthouse/features/payment/domain/payment_allocation.dart' as domain;
import 'package:uuid/uuid.dart';
import 'package:drift/drift.dart';

final paymentRepositoryProvider = Provider<PaymentRepository>((ref) {
  final database = ref.watch(appDatabaseProvider);
  return PaymentRepository(database);
});

class PaymentRepository {
  final app_db.AppDatabase _database;
  final _uuid = const Uuid();

  PaymentRepository(this._database);

  // 결제 목록 조회
  Future<List<domain.Payment>> getAllPayments() async {
    final dbPayments = await _database.getAllPayments();
    return dbPayments.map((p) => _mapPayment(p)).toList();
  }

  // 임차인별 결제 목록 조회
  Future<List<domain.Payment>> getPaymentsByTenant(String tenantId) async {
    final dbPayments = await _database.getPaymentsByTenant(tenantId);
    return dbPayments.map((p) => _mapPayment(p)).toList();
  }

  // 결제 생성 (자동 배분 포함)
  Future<domain.Payment> createPayment(domain.CreatePaymentRequest request) async {
    final paymentId = _uuid.v4();
    final now = DateTime.now();

    // 1. Payment 생성
    final payment = domain.Payment(
      id: paymentId,
      tenantId: request.tenantId,
      method: request.method,
      amount: request.amount,
      paidDate: request.paidDate,
      memo: request.memo,
      createdAt: now,
    );

    await _database.insertPayment(app_db.PaymentsCompanion.insert(
      id: payment.id,
      tenantId: payment.tenantId,
      method: _paymentMethodToString(payment.method),
      amount: payment.amount,
      paidDate: payment.paidDate,
      memo: Value(payment.memo),
      createdAt: payment.createdAt,
    ));

    // 2. 자동 배분 또는 수동 배분 처리
    if (request.manualAllocations != null && request.manualAllocations!.isNotEmpty) {
      // 수동 배분
      await _processManualAllocations(paymentId, request.manualAllocations!);
    } else {
      // 자동 배분
      await _processAutoAllocation(paymentId, request.tenantId, request.amount);
    }

    return payment;
  }

  // 자동 배분 미리보기
  Future<domain.AutoAllocationResult> previewAutoAllocation(String tenantId, int amount) async {
    // 해당 임차인의 미납 청구서들을 오래된 순으로 조회
    final unpaidBillings = await _getUnpaidBillingsForTenant(tenantId);
    
    final allocations = <domain.PaymentAllocationPreview>[];
    int remainingAmount = amount;
    int totalAllocated = 0;

    for (final billing in unpaidBillings) {
      if (remainingAmount <= 0) break;

      final billingAmount = billing.totalAmount;
      final alreadyPaid = await _database.getTotalPaidAmountForBilling(billing.id);
      final outstandingAmount = billingAmount - alreadyPaid;

      if (outstandingAmount <= 0) continue;

      final allocationAmount = remainingAmount >= outstandingAmount 
        ? outstandingAmount 
        : remainingAmount;

      allocations.add(domain.PaymentAllocationPreview(
        billingId: billing.id,
        yearMonth: billing.yearMonth,
        billingAmount: billingAmount,
        paidAmount: alreadyPaid,
        allocationAmount: allocationAmount,
        remainingAmount: outstandingAmount - allocationAmount,
      ));

      remainingAmount -= allocationAmount;
      totalAllocated += allocationAmount;
    }

    return domain.AutoAllocationResult(
      totalAmount: amount,
      allocatedAmount: totalAllocated,
      remainingAmount: remainingAmount,
      allocations: allocations,
    );
  }

  // 자동 배분 처리 (private)
  Future<void> _processAutoAllocation(String paymentId, String tenantId, int amount) async {
    final preview = await previewAutoAllocation(tenantId, amount);
    
    for (final allocation in preview.allocations) {
      if (allocation.allocationAmount > 0) {
        await _createPaymentAllocation(
          paymentId,
          allocation.billingId,
          allocation.allocationAmount,
        );
        
        // 청구서 상태 업데이트
        await _updateBillingStatus(allocation.billingId);
      }
    }
  }

  // 수동 배분 처리 (private)
  Future<void> _processManualAllocations(String paymentId, List<domain.PaymentAllocationRequest> allocations) async {
    for (final allocation in allocations) {
      await _createPaymentAllocation(
        paymentId,
        allocation.billingId,
        allocation.amount,
      );
      
      // 청구서 상태 업데이트
      await _updateBillingStatus(allocation.billingId);
    }
  }

  // PaymentAllocation 생성 (private)
  Future<void> _createPaymentAllocation(String paymentId, String billingId, int amount) async {
    final allocationId = _uuid.v4();
    
    await _database.insertPaymentAllocation(app_db.PaymentAllocationsCompanion.insert(
      id: allocationId,
      paymentId: paymentId,
      billingId: billingId,
      amount: amount,
      createdAt: DateTime.now(),
    ));
  }

  // 청구서 상태 업데이트 (private)
  Future<void> _updateBillingStatus(String billingId) async {
    final billing = await _database.getAllBillings().then(
      (billings) => billings.firstWhere((b) => b.id == billingId)
    );
    
    final totalPaid = await _database.getTotalPaidAmountForBilling(billingId);
    
    String newStatus;
    if (totalPaid >= billing.totalAmount) {
      newStatus = 'PAID';
    } else if (totalPaid > 0) {
      newStatus = 'PARTIALLY_PAID';
    } else if (DateTime.now().isAfter(billing.dueDate)) {
      newStatus = 'OVERDUE';
    } else {
      newStatus = 'ISSUED';
    }

    await _database.updateBillingStatus(billingId, newStatus);
  }

  // 임차인의 미납 청구서 조회 (private)
  Future<List<app_db.Billing>> _getUnpaidBillingsForTenant(String tenantId) async {
    // 모든 청구서에서 해당 임차인의 것만 필터링하고 오래된 순으로 정렬
    final allBillings = await _database.getAllBillings();
    final allLeases = await _database.getAllLeases();
    
    // 해당 임차인의 리스 ID들 찾기
    final tenantLeaseIds = allLeases
      .where((lease) => lease.tenantId == tenantId)
      .map((lease) => lease.id)
      .toList();
    
    // 해당 임차인의 미납/부분납 청구서들 찾기
    final unpaidBillings = allBillings
      .where((billing) => 
        tenantLeaseIds.contains(billing.leaseId) &&
        (billing.status == 'ISSUED' || 
         billing.status == 'PARTIALLY_PAID' || 
         billing.status == 'OVERDUE'))
      .toList();
    
    // 발행일 기준 오름차순 정렬 (오래된 것부터)
    unpaidBillings.sort((a, b) => a.issueDate.compareTo(b.issueDate));
    
    return unpaidBillings;
  }

  // PaymentMethod enum to string 변환
  String _paymentMethodToString(domain.PaymentMethod method) {
    switch (method) {
      case domain.PaymentMethod.cash:
        return 'CASH';
      case domain.PaymentMethod.transfer:
        return 'TRANSFER';
      case domain.PaymentMethod.card:
        return 'CARD';
      case domain.PaymentMethod.check:
        return 'CHECK';
      case domain.PaymentMethod.other:
        return 'OTHER';
    }
  }

  // PaymentMethod string to enum 변환
  domain.PaymentMethod _stringToPaymentMethod(String method) {
    switch (method.toUpperCase()) {
      case 'CASH':
        return domain.PaymentMethod.cash;
      case 'TRANSFER':
        return domain.PaymentMethod.transfer;
      case 'CARD':
        return domain.PaymentMethod.card;
      case 'CHECK':
        return domain.PaymentMethod.check;
      case 'OTHER':
        return domain.PaymentMethod.other;
      default:
        return domain.PaymentMethod.transfer; // 기본값
    }
  }

  // 결제 배분 조회
  Future<List<domain.PaymentAllocation>> getPaymentAllocations(String paymentId) async {
    final dbAllocations = await _database.getPaymentAllocationsByPayment(paymentId);
    return dbAllocations.map((a) => _mapPaymentAllocation(a)).toList();
  }

  // 청구서별 배분 조회
  Future<List<domain.PaymentAllocation>> getBillingAllocations(String billingId) async {
    final dbAllocations = await _database.getPaymentAllocationsByBilling(billingId);
    return dbAllocations.map((a) => _mapPaymentAllocation(a)).toList();
  }

  // 결제 삭제
  Future<void> deletePayment(String paymentId) async {
    // 1. 관련 PaymentAllocation들의 청구서 상태를 되돌림
    final allocations = await _database.getPaymentAllocationsByPayment(paymentId);
    
    // 2. PaymentAllocation 삭제
    await _database.deletePaymentAllocationsForPayment(paymentId);
    
    // 3. 청구서 상태 재계산
    for (final allocation in allocations) {
      await _updateBillingStatus(allocation.billingId);
    }
    
    // 4. Payment 삭제
    await _database.deletePayment(paymentId);
  }

  // 월별 수납 통계
  Future<Map<String, int>> getMonthlyPaymentStats(int year, int month) async {
    final payments = await getAllPayments();
    
    final monthlyPayments = payments.where((payment) =>
      payment.paidDate.year == year && payment.paidDate.month == month
    ).toList();
    
    int totalAmount = 0;
    int totalCount = 0;
    final methodStats = <String, int>{};
    
    for (final payment in monthlyPayments) {
      totalAmount += payment.amount;
      totalCount++;
      
      final methodKey = _paymentMethodToString(payment.method);
      methodStats[methodKey] = (methodStats[methodKey] ?? 0) + payment.amount;
    }
    
    return {
      'totalAmount': totalAmount,
      'totalCount': totalCount,
      ...methodStats,
    };
  }

  // DB Payment -> Domain Payment 매핑
  domain.Payment _mapPayment(app_db.Payment dbPayment) {
    return domain.Payment(
      id: dbPayment.id,
      tenantId: dbPayment.tenantId,
      method: _stringToPaymentMethod(dbPayment.method),
      amount: dbPayment.amount,
      paidDate: dbPayment.paidDate,
      memo: dbPayment.memo,
      createdAt: dbPayment.createdAt,
    );
  }

  // DB PaymentAllocation -> Domain PaymentAllocation 매핑
  domain.PaymentAllocation _mapPaymentAllocation(app_db.PaymentAllocation dbAllocation) {
    return domain.PaymentAllocation(
      id: dbAllocation.id,
      paymentId: dbAllocation.paymentId,
      billingId: dbAllocation.billingId,
      amount: dbAllocation.amount,
      createdAt: dbAllocation.createdAt,
    );
  }
}