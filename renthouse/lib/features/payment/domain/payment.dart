import 'package:freezed_annotation/freezed_annotation.dart';

part 'payment.freezed.dart';
part 'payment.g.dart';

// 결제 수단 enum
enum PaymentMethod {
  cash,       // 현금
  transfer,   // 계좌이체
  card,       // 카드
  check,      // 수표
  other       // 기타
}

@freezed
class Payment with _$Payment {
  const factory Payment({
    required String id,
    required String tenantId,
    required PaymentMethod method,
    required int amount,
    required DateTime paidDate,
    String? memo,
    required DateTime createdAt,
  }) = _Payment;

  factory Payment.fromJson(Map<String, dynamic> json) => _$PaymentFromJson(json);
}

// 결제 생성 요청 모델
@freezed
class CreatePaymentRequest with _$CreatePaymentRequest {
  const factory CreatePaymentRequest({
    required String tenantId,
    required PaymentMethod method,
    required int amount,
    required DateTime paidDate,
    String? memo,
    // 수동 배분용 (선택사항)
    List<PaymentAllocationRequest>? manualAllocations,
  }) = _CreatePaymentRequest;

  factory CreatePaymentRequest.fromJson(Map<String, dynamic> json) => 
    _$CreatePaymentRequestFromJson(json);
}

// 결제 배분 요청 모델
@freezed
class PaymentAllocationRequest with _$PaymentAllocationRequest {
  const factory PaymentAllocationRequest({
    required String billingId,
    required int amount,
  }) = _PaymentAllocationRequest;

  factory PaymentAllocationRequest.fromJson(Map<String, dynamic> json) => 
    _$PaymentAllocationRequestFromJson(json);
}