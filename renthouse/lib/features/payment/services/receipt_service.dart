import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:renthouse/core/database/app_database.dart';
import 'package:renthouse/core/database/database_provider.dart';
import 'package:renthouse/features/payment/domain/receipt.dart';
import 'package:renthouse/features/payment/data/payment_repository.dart';
import 'package:uuid/uuid.dart';

final receiptServiceProvider = Provider<ReceiptService>((ref) {
  final database = ref.watch(appDatabaseProvider);
  final paymentRepository = ref.watch(paymentRepositoryProvider);
  return ReceiptService(database, paymentRepository);
});

class ReceiptService {
  final AppDatabase _database;
  final PaymentRepository _paymentRepository;
  final _uuid = const Uuid();

  ReceiptService(this._database, this._paymentRepository);

  /// Payment ID를 기반으로 Receipt 생성
  Future<Receipt> createReceiptFromPayment(String paymentId) async {
    // 1. Payment 정보 조회
    final payments = await _paymentRepository.getAllPayments();
    final payment = payments.firstWhere((p) => p.id == paymentId);

    // 2. PaymentAllocation들 조회
    final allocations = await _paymentRepository.getPaymentAllocations(paymentId);

    // 3. 임차인 정보 조회
    final tenant = await _database.getTenantById(payment.tenantId);

    // 4. Receipt Items 생성
    final receiptItems = <ReceiptItem>[];
    
    for (final allocation in allocations) {
      // 청구서 정보 조회
      final billing = await _database.getBillingById(allocation.billingId);
      if (billing == null) continue;

      // 계약 및 유닛, 자산 정보 조회
      final lease = await _database.getLeaseById(billing.leaseId);

      final unit = await _database.getUnitById(lease.unitId);

      final property = await _database.getPropertyById(unit.propertyId);

      // 청구 항목들 조회
      final billingItems = await _database.getBillingItemsForBilling(billing.id);
      
      String description;
      if (billingItems.length == 1) {
        // 단일 항목인 경우 해당 항목명 사용 (예: 월세, 관리비 등)
        final billTemplate = await _database.getBillTemplateById(billingItems.first.billTemplateId);
        description = billTemplate?.name ?? '수납금';
      } else if (billingItems.length > 1) {
        // 여러 항목인 경우 "월세+관리비 등" 형태로 표시
        final itemNames = <String>[];
        for (final item in billingItems.take(2)) {
          final template = await _database.getBillTemplateById(item.billTemplateId);
          if (template != null) {
            itemNames.add(template.name);
          }
        }
        description = itemNames.join('+');
        if (billingItems.length > 2) {
          description += ' 등 ${billingItems.length}항목';
        }
      } else {
        description = '수납금';
      }

      receiptItems.add(ReceiptItem(
        billingId: allocation.billingId,
        yearMonth: billing.yearMonth,
        propertyName: property.name,
        unitNumber: unit.unitNumber,
        amount: allocation.amount,
        description: description,
      ));
    }

    // 5. Receipt 생성
    return Receipt(
      id: _uuid.v4(),
      paymentId: payment.id,
      tenantId: payment.tenantId,
      tenantName: tenant.name,
      tenantPhone: tenant.phone ?? '연락처 없음',
      paymentMethod: payment.method,
      totalAmount: payment.amount,
      paidDate: payment.paidDate,
      issuedDate: DateTime.now(),
      memo: payment.memo,
      items: receiptItems,
    );
  }

  /// 여러 Payment들을 하나의 Receipt로 통합 (월별 통합 영수증 등)
  Future<Receipt> createCombinedReceipt(List<String> paymentIds, {String? customMemo}) async {
    if (paymentIds.isEmpty) {
      throw ArgumentError('결제 ID 목록이 비어있습니다.');
    }

    final receipts = <Receipt>[];
    for (final paymentId in paymentIds) {
      receipts.add(await createReceiptFromPayment(paymentId));
    }

    // 첫 번째 영수증을 기준으로 기본 정보 설정
    final firstReceipt = receipts.first;

    // 모든 항목들을 통합
    final allItems = <ReceiptItem>[];
    int totalAmount = 0;

    for (final receipt in receipts) {
      allItems.addAll(receipt.items);
      totalAmount += receipt.totalAmount;
    }

    // 같은 청구서에 대한 중복 제거 및 통합
    final consolidatedItems = <String, ReceiptItem>{};
    for (final item in allItems) {
      final key = '${item.billingId}_${item.yearMonth}';
      if (consolidatedItems.containsKey(key)) {
        final existing = consolidatedItems[key]!;
        consolidatedItems[key] = existing.copyWith(
          amount: existing.amount + item.amount,
        );
      } else {
        consolidatedItems[key] = item;
      }
    }

    return Receipt(
      id: _uuid.v4(),
      paymentId: 'combined_${paymentIds.join('_')}',
      tenantId: firstReceipt.tenantId,
      tenantName: firstReceipt.tenantName,
      tenantPhone: firstReceipt.tenantPhone,
      paymentMethod: firstReceipt.paymentMethod,
      totalAmount: totalAmount,
      paidDate: receipts.map((r) => r.paidDate).reduce((a, b) => a.isAfter(b) ? a : b), // 가장 최근 결제일
      issuedDate: DateTime.now(),
      memo: customMemo ?? '통합 영수증',
      items: consolidatedItems.values.toList(),
    );
  }

  /// 특정 기간의 임차인 결제내역으로 영수증 생성
  Future<Receipt?> createMonthlyReceipt(String tenantId, int year, int month) async {
    // 해당 월의 모든 결제 조회
    final allPayments = await _paymentRepository.getPaymentsByTenant(tenantId);
    final monthlyPayments = allPayments.where((payment) =>
        payment.paidDate.year == year && payment.paidDate.month == month).toList();

    if (monthlyPayments.isEmpty) {
      return null;
    }

    return createCombinedReceipt(
      monthlyPayments.map((p) => p.id).toList(),
      customMemo: '$year년 $month월 통합 영수증',
    );
  }
}