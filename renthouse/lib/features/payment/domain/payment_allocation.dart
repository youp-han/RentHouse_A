import 'package:freezed_annotation/freezed_annotation.dart';

part 'payment_allocation.freezed.dart';
part 'payment_allocation.g.dart';

@freezed
class PaymentAllocation with _$PaymentAllocation {
  const factory PaymentAllocation({
    required String id,
    required String paymentId,
    required String billingId,
    required int amount,
    required DateTime createdAt,
  }) = _PaymentAllocation;

  factory PaymentAllocation.fromJson(Map<String, dynamic> json) => 
    _$PaymentAllocationFromJson(json);
}

// 결제 배분 결과 모델 (미리보기용)
@freezed
class PaymentAllocationPreview with _$PaymentAllocationPreview {
  const factory PaymentAllocationPreview({
    required String billingId,
    required String yearMonth,
    required int billingAmount,
    required int paidAmount,
    required int allocationAmount,
    required int remainingAmount,
  }) = _PaymentAllocationPreview;

  factory PaymentAllocationPreview.fromJson(Map<String, dynamic> json) => 
    _$PaymentAllocationPreviewFromJson(json);
}

// 자동 배분 결과 모델
@freezed
class AutoAllocationResult with _$AutoAllocationResult {
  const factory AutoAllocationResult({
    required int totalAmount,
    required int allocatedAmount,
    required int remainingAmount,
    required List<PaymentAllocationPreview> allocations,
  }) = _AutoAllocationResult;

  factory AutoAllocationResult.fromJson(Map<String, dynamic> json) => 
    _$AutoAllocationResultFromJson(json);
}