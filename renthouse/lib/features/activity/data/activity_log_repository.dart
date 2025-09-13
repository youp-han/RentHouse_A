import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:renthouse/core/database/app_database.dart';
import 'package:renthouse/core/database/database_provider.dart';
import 'package:renthouse/features/activity/domain/activity_log.dart' as domain;

part 'activity_log_repository.g.dart';

@riverpod
ActivityLogRepository activityLogRepository(Ref ref) {
  final database = ref.watch(appDatabaseProvider);
  return ActivityLogRepository(database);
}

class ActivityLogRepository {
  final AppDatabase _database;
  final _uuid = const Uuid();

  ActivityLogRepository(this._database);

  /// 모든 활동 로그 조회
  Future<List<domain.ActivityLog>> getAllActivityLogs() async {
    final logs = await _database.getAllActivityLogs();
    return logs.map(_mapToActivityLog).toList();
  }

  /// 최근 활동 로그 조회 (기본 50개)
  Future<List<domain.ActivityLog>> getRecentActivityLogs({int limit = 50}) async {
    final logs = await _database.getRecentActivityLogs(limit: limit);
    return logs.map(_mapToActivityLog).toList();
  }

  /// 특정 사용자의 활동 로그 조회
  Future<List<domain.ActivityLog>> getActivityLogsByUser(String userId) async {
    final logs = await _database.getActivityLogsByUser(userId);
    return logs.map(_mapToActivityLog).toList();
  }

  /// 특정 엔티티의 활동 로그 조회
  Future<List<domain.ActivityLog>> getActivityLogsByEntity(String entityType, String entityId) async {
    final logs = await _database.getActivityLogsByEntity(entityType, entityId);
    return logs.map(_mapToActivityLog).toList();
  }

  /// 활동 로그 추가
  Future<void> addActivityLog(domain.ActivityLog activityLog) async {
    final companion = ActivityLogsCompanion(
      id: Value(_uuid.v4()),
      userId: Value(activityLog.userId),
      activityType: Value(activityLog.activityType.value),
      description: Value(activityLog.description),
      entityType: Value(activityLog.entityType),
      entityId: Value(activityLog.entityId),
      entityDisplayName: Value(activityLog.entityName),
      metadata: Value(activityLog.metadata != null ? jsonEncode(activityLog.metadata) : null),
      timestamp: Value(activityLog.timestamp),
    );

    await _database.insertActivityLog(companion);
  }

  /// 활동 로그 삭제
  Future<void> deleteActivityLog(String id) async {
    await _database.deleteActivityLog(id);
  }

  /// 오래된 활동 로그 정리 (지정된 날짜 이전 로그 삭제)
  Future<void> deleteOldActivityLogs(DateTime cutoffDate) async {
    await _database.deleteOldActivityLogs(cutoffDate);
  }

  /// 30일 이전 로그 정리
  Future<void> cleanupOldLogs() async {
    final cutoffDate = DateTime.now().subtract(const Duration(days: 30));
    await deleteOldActivityLogs(cutoffDate);
  }

  /// 데이터베이스 ActivityLog를 도메인 ActivityLog로 변환
  domain.ActivityLog _mapToActivityLog(ActivityLog dbLog) {
    Map<String, dynamic>? metadata;
    if (dbLog.metadata != null) {
      try {
        metadata = jsonDecode(dbLog.metadata!) as Map<String, dynamic>;
      } catch (e) {
        metadata = null;
      }
    }

    return domain.ActivityLog(
      id: dbLog.id,
      userId: dbLog.userId,
      activityType: domain.ActivityType.values.firstWhere(
        (type) => type.value == dbLog.activityType,
        orElse: () => domain.ActivityType.other,
      ),
      description: dbLog.description,
      entityType: dbLog.entityType,
      entityId: dbLog.entityId,
      entityName: dbLog.entityDisplayName,
      metadata: metadata,
      timestamp: dbLog.timestamp,
    );
  }

  /// 사용자별 활동 통계 조회 (최근 7일)
  Future<Map<String, int>> getUserActivityStats(String userId) async {
    final logs = await getActivityLogsByUser(userId);
    final recentLogs = logs.where(
      (log) => log.timestamp.isAfter(DateTime.now().subtract(const Duration(days: 7))),
    );

    final stats = <String, int>{};
    for (final log in recentLogs) {
      final key = log.activityType.displayName;
      stats[key] = (stats[key] ?? 0) + 1;
    }

    return stats;
  }

  /// 일별 활동 통계 조회 (최근 30일)
  Future<Map<String, int>> getDailyActivityStats() async {
    final logs = await getRecentActivityLogs(limit: 1000);
    final recentLogs = logs.where(
      (log) => log.timestamp.isAfter(DateTime.now().subtract(const Duration(days: 30))),
    );

    final stats = <String, int>{};
    for (final log in recentLogs) {
      final dateKey = '${log.timestamp.year}-${log.timestamp.month.toString().padLeft(2, '0')}-${log.timestamp.day.toString().padLeft(2, '0')}';
      stats[dateKey] = (stats[dateKey] ?? 0) + 1;
    }

    return stats;
  }

  /// 활동 유형별 통계 조회
  Future<Map<String, int>> getActivityTypeStats() async {
    final logs = await getRecentActivityLogs(limit: 1000);
    final recentLogs = logs.where(
      (log) => log.timestamp.isAfter(DateTime.now().subtract(const Duration(days: 30))),
    );

    final stats = <String, int>{};
    for (final log in recentLogs) {
      final key = log.activityType.displayName;
      stats[key] = (stats[key] ?? 0) + 1;
    }

    return stats;
  }
}