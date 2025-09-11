import 'package:flutter_test/flutter_test.dart';
import 'package:renthouse/features/lease/domain/lease.dart';

void main() {
  group('Lease 도메인 모델 테스트', () {
    late Lease testLease;
    late DateTime startDate;
    late DateTime endDate;

    setUp(() {
      startDate = DateTime(2023, 3, 1);
      endDate = DateTime(2025, 2, 28);
      testLease = Lease(
        id: 'lease1',
        tenantId: 'tenant1',
        unitId: 'unit1',
        startDate: startDate,
        endDate: endDate,
        deposit: 50000000,
        monthlyRent: 1000000,
        leaseType: LeaseType.residential,
        leaseStatus: LeaseStatus.active,
        contractNotes: '2년 계약, 매월 5일까지 입금',
      );
    });

    test('Lease 객체 생성이 정상적으로 동작해야 한다', () {
      expect(testLease.id, 'lease1');
      expect(testLease.tenantId, 'tenant1');
      expect(testLease.unitId, 'unit1');
      expect(testLease.startDate, startDate);
      expect(testLease.endDate, endDate);
      expect(testLease.deposit, 50000000);
      expect(testLease.monthlyRent, 1000000);
      expect(testLease.leaseType, LeaseType.residential);
      expect(testLease.leaseStatus, LeaseStatus.active);
      expect(testLease.contractNotes, '2년 계약, 매월 5일까지 입금');
    });

    test('Lease contractNotes는 nullable이어야 한다', () {
      final leaseWithoutNotes = Lease(
        id: 'lease2',
        tenantId: 'tenant2',
        unitId: 'unit2',
        startDate: startDate,
        endDate: endDate,
        deposit: 30000000,
        monthlyRent: 800000,
        leaseType: LeaseType.commercial,
        leaseStatus: LeaseStatus.pending,
      );

      expect(leaseWithoutNotes.contractNotes, isNull);
    });

    test('LeaseType enum이 올바르게 동작해야 한다', () {
      expect(LeaseType.residential, LeaseType.residential);
      expect(LeaseType.commercial, LeaseType.commercial);
      expect(LeaseType.values.length, 2);
    });

    test('LeaseStatus enum이 올바르게 동작해야 한다', () {
      expect(LeaseStatus.active, LeaseStatus.active);
      expect(LeaseStatus.terminated, LeaseStatus.terminated);
      expect(LeaseStatus.expired, LeaseStatus.expired);
      expect(LeaseStatus.pending, LeaseStatus.pending);
      expect(LeaseStatus.values.length, 4);
    });

    test('Lease JSON 직렬화/역직렬화가 올바르게 동작해야 한다', () {
      final json = testLease.toJson();
      final fromJson = Lease.fromJson(json);

      expect(fromJson, testLease);
      expect(fromJson.id, testLease.id);
      expect(fromJson.tenantId, testLease.tenantId);
      expect(fromJson.startDate, testLease.startDate);
      expect(fromJson.leaseType, testLease.leaseType);
      expect(fromJson.leaseStatus, testLease.leaseStatus);
    });

    test('Lease copyWith가 올바르게 동작해야 한다', () {
      final updatedLease = testLease.copyWith(
        monthlyRent: 1200000,
        leaseStatus: LeaseStatus.terminated,
        contractNotes: '계약 종료됨',
      );

      expect(updatedLease.monthlyRent, 1200000);
      expect(updatedLease.leaseStatus, LeaseStatus.terminated);
      expect(updatedLease.contractNotes, '계약 종료됨');
      expect(updatedLease.id, testLease.id);
      expect(updatedLease.tenantId, testLease.tenantId);
      expect(updatedLease.deposit, testLease.deposit);
    });

    test('다양한 임대 타입을 처리할 수 있어야 한다', () {
      final residentialLease = Lease(
        id: 'lease_res',
        tenantId: 'tenant1',
        unitId: 'unit1',
        startDate: startDate,
        endDate: endDate,
        deposit: 50000000,
        monthlyRent: 1000000,
        leaseType: LeaseType.residential,
        leaseStatus: LeaseStatus.active,
      );

      final commercialLease = Lease(
        id: 'lease_com',
        tenantId: 'tenant2',
        unitId: 'unit2',
        startDate: startDate,
        endDate: endDate,
        deposit: 100000000,
        monthlyRent: 3000000,
        leaseType: LeaseType.commercial,
        leaseStatus: LeaseStatus.active,
      );

      expect(residentialLease.leaseType, LeaseType.residential);
      expect(commercialLease.leaseType, LeaseType.commercial);
    });

    test('다양한 임대 상태를 처리할 수 있어야 한다', () {
      final activeLease = testLease.copyWith(leaseStatus: LeaseStatus.active);
      final pendingLease = testLease.copyWith(leaseStatus: LeaseStatus.pending);
      final terminatedLease = testLease.copyWith(leaseStatus: LeaseStatus.terminated);
      final expiredLease = testLease.copyWith(leaseStatus: LeaseStatus.expired);

      expect(activeLease.leaseStatus, LeaseStatus.active);
      expect(pendingLease.leaseStatus, LeaseStatus.pending);
      expect(terminatedLease.leaseStatus, LeaseStatus.terminated);
      expect(expiredLease.leaseStatus, LeaseStatus.expired);
    });

    test('계약 기간 관련 로직 테스트', () {
      final lease = Lease(
        id: 'lease_period',
        tenantId: 'tenant1',
        unitId: 'unit1',
        startDate: DateTime(2023, 1, 1),
        endDate: DateTime(2024, 12, 31),
        deposit: 30000000,
        monthlyRent: 800000,
        leaseType: LeaseType.residential,
        leaseStatus: LeaseStatus.active,
      );

      // 계약 기간 계산 (2년)
      final duration = lease.endDate.difference(lease.startDate);
      expect(duration.inDays, 730); // 2년 = 730일 (윤년 고려)
    });

    test('금액 관련 테스트', () {
      final lease = Lease(
        id: 'lease_money',
        tenantId: 'tenant1',
        unitId: 'unit1',
        startDate: startDate,
        endDate: endDate,
        deposit: 100000000, // 1억
        monthlyRent: 2000000, // 200만원
        leaseType: LeaseType.residential,
        leaseStatus: LeaseStatus.active,
      );

      expect(lease.deposit, 100000000);
      expect(lease.monthlyRent, 2000000);
      expect(lease.deposit > lease.monthlyRent, isTrue);
    });

    test('Lease equality가 올바르게 동작해야 한다', () {
      final lease1 = Lease(
        id: 'same_id',
        tenantId: 'tenant1',
        unitId: 'unit1',
        startDate: startDate,
        endDate: endDate,
        deposit: 50000000,
        monthlyRent: 1000000,
        leaseType: LeaseType.residential,
        leaseStatus: LeaseStatus.active,
      );

      final lease2 = Lease(
        id: 'same_id',
        tenantId: 'tenant1',
        unitId: 'unit1',
        startDate: startDate,
        endDate: endDate,
        deposit: 50000000,
        monthlyRent: 1000000,
        leaseType: LeaseType.residential,
        leaseStatus: LeaseStatus.active,
      );

      expect(lease1, lease2);
      expect(lease1.hashCode, lease2.hashCode);
    });
  });
}