import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:renthouse/features/payment/domain/payment.dart';

part 'receipt.freezed.dart';
part 'receipt.g.dart';

@freezed
class Receipt with _$Receipt {
  const factory Receipt({
    required String id,
    required String paymentId,
    required String tenantId,
    required String tenantName,
    required String tenantPhone,
    required PaymentMethod paymentMethod,
    required int totalAmount,
    required DateTime paidDate,
    required DateTime issuedDate,
    String? memo,
    required List<ReceiptItem> items,
  }) = _Receipt;

  factory Receipt.fromJson(Map<String, dynamic> json) => _$ReceiptFromJson(json);
}

@freezed
class ReceiptItem with _$ReceiptItem {
  const factory ReceiptItem({
    required String billingId,
    required String yearMonth,
    required String propertyName,
    required String unitNumber,
    required int amount,
    required String description,
  }) = _ReceiptItem;

  factory ReceiptItem.fromJson(Map<String, dynamic> json) => _$ReceiptItemFromJson(json);
}