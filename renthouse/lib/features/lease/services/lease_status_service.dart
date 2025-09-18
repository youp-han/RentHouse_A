import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:drift/drift.dart';
import 'package:renthouse/core/database/app_database.dart';
import 'package:renthouse/core/database/database_provider.dart';

part 'lease_status_service.g.dart';

/// 계약 상태 자동 관리 서비스
/// - 계약 시작일에 pending → active 변경
/// - 유닛 상태 vacant → rented 변경
/// - 계약 종료일 다음날 active → terminated, rented → vacant 변경
class LeaseStatusService {
  final AppDatabase _database;
  Timer? _timer;

  LeaseStatusService(this._database);

  /// 서비스 시작 - 매일 00:00에 실행
  void start() {
    // 즉시 한 번 실행
    _updateLeaseStatuses();

    // 매일 00:00에 실행되도록 설정
    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    final initialDelay = tomorrow.difference(now);

    _timer = Timer(initialDelay, () {
      // 첫 실행 후 24시간마다 반복
      _timer = Timer.periodic(const Duration(days: 1), (_) {
        _updateLeaseStatuses();
      });
      // 첫 번째 실행
      _updateLeaseStatuses();
    });
  }

  /// 서비스 중지
  void stop() {
    _timer?.cancel();
    _timer = null;
  }

  /// 모든 계약의 상태를 확인하고 업데이트
  Future<void> _updateLeaseStatuses() async {
    try {
      final today = DateTime.now();
      final todayOnly = DateTime(today.year, today.month, today.day);

      // 1. pending → active 변경 (시작일이 오늘이거나 지난 계약)
      await _activatePendingLeases(todayOnly);

      // 2. active → terminated 변경 (종료일이 어제이거나 그 이전인 계약)
      await _terminateExpiredLeases(todayOnly);

      print('[LeaseStatusService] 계약 상태 업데이트 완료: ${todayOnly.toString().substring(0, 10)}');
    } catch (e) {
      print('[LeaseStatusService] 계약 상태 업데이트 오류: $e');
    }
  }

  /// pending 상태 계약을 active로 변경하고 유닛을 rented로 변경
  Future<void> _activatePendingLeases(DateTime today) async {
    print('[LeaseStatusService] pending 계약 검색 중... 기준일: $today');

    final pendingLeases = await _database.customSelect(
      'SELECT * FROM leases WHERE lease_status = ? AND start_date <= ?',
      variables: [
        Variable.withString('pending'),
        Variable.withDateTime(today),
      ],
      readsFrom: {_database.leases},
    ).get();

    print('[LeaseStatusService] 발견된 pending 계약: ${pendingLeases.length}개');

    for (final leaseRow in pendingLeases) {
      final leaseId = leaseRow.read<String>('id');
      final unitId = leaseRow.read<String>('unit_id');
      final startDate = leaseRow.read<DateTime>('start_date');

      print('[LeaseStatusService] 계약 처리 중 - ID: $leaseId, 유닛: $unitId, 시작일: $startDate');

      try {
        // 계약을 active로 변경
        final leaseUpdateResult = await _database.customUpdate(
          'UPDATE leases SET lease_status = ? WHERE id = ?',
          variables: [
            Variable.withString('active'),
            Variable.withString(leaseId),
          ],
          updates: {_database.leases},
        );
        print('[LeaseStatusService] 계약 상태 업데이트 결과: $leaseUpdateResult행 영향');

        // 유닛을 rented로 변경
        final unitUpdateResult = await _database.customUpdate(
          'UPDATE units SET rent_status = ? WHERE id = ?',
          variables: [
            Variable.withString('RENTED'),
            Variable.withString(unitId),
          ],
          updates: {_database.units},
        );
        print('[LeaseStatusService] 유닛 상태 업데이트 결과: $unitUpdateResult행 영향');

        print('[LeaseStatusService] ✅ 계약 활성화 완료: $leaseId, 유닛: $unitId');
      } catch (e) {
        print('[LeaseStatusService] ❌ 계약 활성화 오류 ($leaseId): $e');
      }
    }
  }

  /// 만료된 active 계약을 terminated로 변경하고 유닛을 vacant로 변경
  Future<void> _terminateExpiredLeases(DateTime today) async {
    print('[LeaseStatusService] 만료된 계약 검색 중... 기준일: $today');

    final expiredLeases = await _database.customSelect(
      'SELECT * FROM leases WHERE lease_status = ? AND end_date < ?',
      variables: [
        Variable.withString('active'),
        Variable.withDateTime(today), // 종료일이 오늘 이전인 계약
      ],
      readsFrom: {_database.leases},
    ).get();

    print('[LeaseStatusService] 발견된 만료 계약: ${expiredLeases.length}개');

    for (final leaseRow in expiredLeases) {
      final leaseId = leaseRow.read<String>('id');
      final unitId = leaseRow.read<String>('unit_id');
      final endDate = leaseRow.read<DateTime>('end_date');

      print('[LeaseStatusService] 만료 계약 처리 중 - ID: $leaseId, 유닛: $unitId, 종료일: $endDate');

      try {
        // 계약을 terminated로 변경
        final leaseUpdateResult = await _database.customUpdate(
          'UPDATE leases SET lease_status = ? WHERE id = ?',
          variables: [
            Variable.withString('terminated'),
            Variable.withString(leaseId),
          ],
          updates: {_database.leases},
        );
        print('[LeaseStatusService] 계약 종료 업데이트 결과: $leaseUpdateResult행 영향');

        // 유닛을 vacant로 변경
        final unitUpdateResult = await _database.customUpdate(
          'UPDATE units SET rent_status = ? WHERE id = ?',
          variables: [
            Variable.withString('VACANT'),
            Variable.withString(unitId),
          ],
          updates: {_database.units},
        );
        print('[LeaseStatusService] 유닛 공실 업데이트 결과: $unitUpdateResult행 영향');

        print('[LeaseStatusService] ✅ 계약 종료 완료: $leaseId, 유닛: $unitId');
      } catch (e) {
        print('[LeaseStatusService] ❌ 계약 종료 오류 ($leaseId): $e');
      }
    }
  }

  /// 수동으로 상태 업데이트 실행 (테스트용)
  Future<void> forceUpdate() async {
    await _updateLeaseStatuses();
  }
}

@riverpod
LeaseStatusService leaseStatusService(LeaseStatusServiceRef ref) {
  final database = ref.watch(appDatabaseProvider);
  return LeaseStatusService(database);
}