import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:renthouse/features/billing/data/billing_repository.dart';
import 'package:renthouse/features/billing/domain/billing.dart';
import 'package:renthouse/features/activity/application/activity_log_service.dart';

part 'billing_controller.g.dart';

@riverpod
class BillingController extends _$BillingController {
  @override
  Future<List<Billing>> build({String? searchQuery}) async {
    return ref.watch(billingRepositoryProvider).getBillings(searchQuery: searchQuery);
  }

  Future<void> addBilling(Billing billing) async {
    await ref.read(billingRepositoryProvider).createBilling(billing);

    // 활동 로그 기록
    final activityLogService = ref.read(activityLogServiceProvider);
    await activityLogService.logBillingCreated(billing.id, billing.yearMonth);

    ref.invalidateSelf();
  }

  Future<void> updateBilling(Billing billing) async {
    await ref.read(billingRepositoryProvider).updateBilling(billing);
    ref.invalidateSelf();
  }

  Future<void> deleteBilling(String id) async {
    await ref.read(billingRepositoryProvider).deleteBilling(id);
    ref.invalidateSelf();
  }

  Future<List<String>> createBulkBillings(String yearMonth, DateTime issueDate, DateTime dueDate) async {
    try {
      final repository = ref.read(billingRepositoryProvider);
      final createdIds = await repository.createBulkBillings(yearMonth, issueDate, dueDate);

      // 청구서 목록 새로고침
      ref.invalidateSelf();

      return createdIds;
    } catch (e) {
      rethrow;
    }
  }

  // task168: 자동 청구서 발행 (월말 발행일)
  Future<List<String>> autoGenerateInvoices() async {
    try {
      print('[BillingController] 자동 청구서 발행 시작');
      final repository = ref.read(billingRepositoryProvider);
      final now = DateTime.now();

      // 현재 연월 문자열 생성 (YYYY-MM 형식)
      final currentYearMonth = '${now.year}-${now.month.toString().padLeft(2, '0')}';
      print('[BillingController] 대상 연월: $currentYearMonth');

      // 월말 날짜 계산
      final lastDayOfMonth = DateTime(now.year, now.month + 1, 0);
      final endOfMonth = DateTime(lastDayOfMonth.year, lastDayOfMonth.month, lastDayOfMonth.day);
      print('[BillingController] 발행일: $endOfMonth');

      // 납기일은 월말 + 10일
      final dueDate = endOfMonth.add(const Duration(days: 10));
      print('[BillingController] 납기일: $dueDate');

      print('[BillingController] createBulkBillings 호출 시작');
      final createdIds = await repository.createBulkBillings(
        currentYearMonth,
        endOfMonth,  // 발행일: 월말
        dueDate,     // 납기일: 월말 + 10일
      );
      print('[BillingController] createBulkBillings 완료: ${createdIds.length}개');

      // 일괄 청구서 생성 활동 로그 기록
      if (createdIds.isNotEmpty) {
        final activityLogService = ref.read(activityLogServiceProvider);
        await activityLogService.logBulkBillingCreated(createdIds.length, currentYearMonth);
      }

      // 청구서 목록 새로고침
      ref.invalidateSelf();

      return createdIds;
    } catch (e, stackTrace) {
      print('[BillingController] 오류 발생: $e');
      print('[BillingController] 스택트레이스: $stackTrace');
      rethrow;
    }
  }
}