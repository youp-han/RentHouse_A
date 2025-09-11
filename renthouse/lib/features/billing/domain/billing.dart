import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:renthouse/features/billing/domain/billing_item.dart';

part 'billing.freezed.dart';
part 'billing.g.dart';

// Phase 2: 청구서 상태 enum
enum BillingStatus { 
  draft,         // 초안
  issued,        // 발행됨
  partiallyPaid, // 부분 결제
  paid,          // 완전 결제
  overdue,       // 연체
  voided         // 무효
}

@freezed
class Billing with _$Billing {
  const factory Billing({
    required String id,
    required String leaseId,
    required String yearMonth,
    required DateTime issueDate,
    required DateTime dueDate,
    @Default(false) bool paid,
    DateTime? paidDate,
    required int totalAmount,
    @Default([]) List<BillingItem> items,
    // Phase 2: 새로운 필드들
    @Default(BillingStatus.draft) BillingStatus status,
  }) = _Billing;

  factory Billing.fromJson(Map<String, dynamic> json) => _$BillingFromJson(json);
}
