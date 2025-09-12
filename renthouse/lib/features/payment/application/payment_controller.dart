import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:renthouse/features/payment/data/payment_repository.dart';
import 'package:renthouse/features/payment/domain/payment.dart';
import 'package:renthouse/features/payment/domain/payment_allocation.dart';

part 'payment_controller.g.dart';

@riverpod
class PaymentController extends _$PaymentController {
  @override
  Future<List<Payment>> build() async {
    final repository = ref.read(paymentRepositoryProvider);
    return await repository.getAllPayments();
  }

  // 결제 생성
  Future<void> createPayment(CreatePaymentRequest request) async {
    state = const AsyncValue.loading();
    
    try {
      final repository = ref.read(paymentRepositoryProvider);
      await repository.createPayment(request);
      
      // 상태 새로고침
      final payments = await repository.getAllPayments();
      state = AsyncValue.data(payments);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }

  // 결제 삭제
  Future<void> deletePayment(String paymentId) async {
    state = const AsyncValue.loading();
    
    try {
      final repository = ref.read(paymentRepositoryProvider);
      await repository.deletePayment(paymentId);
      
      // 상태 새로고침
      final payments = await repository.getAllPayments();
      state = AsyncValue.data(payments);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }

  // 상태 새로고침
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    
    try {
      final repository = ref.read(paymentRepositoryProvider);
      final payments = await repository.getAllPayments();
      state = AsyncValue.data(payments);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

// 임차인별 결제 목록 프로바이더
@riverpod
Future<List<Payment>> paymentsByTenant(Ref ref, String tenantId) async {
  final repository = ref.read(paymentRepositoryProvider);
  return await repository.getPaymentsByTenant(tenantId);
}

// 자동 배분 미리보기 프로바이더
@riverpod
Future<AutoAllocationResult> autoAllocationPreview(
  Ref ref,
  String tenantId,
  int amount,
) async {
  final repository = ref.read(paymentRepositoryProvider);
  return await repository.previewAutoAllocation(tenantId, amount);
}

// 결제 배분 조회 프로바이더
@riverpod
Future<List<PaymentAllocation>> paymentAllocations(Ref ref, String paymentId) async {
  final repository = ref.read(paymentRepositoryProvider);
  return await repository.getPaymentAllocations(paymentId);
}

// 청구서별 배분 조회 프로바이더
@riverpod
Future<List<PaymentAllocation>> billingAllocations(Ref ref, String billingId) async {
  final repository = ref.read(paymentRepositoryProvider);
  return await repository.getBillingAllocations(billingId);
}

// 월별 결제 통계 프로바이더
@riverpod
Future<Map<String, int>> monthlyPaymentStats(Ref ref, int year, int month) async {
  final repository = ref.read(paymentRepositoryProvider);
  return await repository.getMonthlyPaymentStats(year, month);
}