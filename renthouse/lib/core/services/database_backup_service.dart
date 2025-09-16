import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:file_picker/file_picker.dart';
import 'package:renthouse/core/utils/database_path_checker.dart';
import 'package:renthouse/core/utils/platform_utils.dart';
import 'package:renthouse/core/logging/app_logger.dart';

/// 데이터베이스 백업 및 복원 서비스
class DatabaseBackupService {

  /// 현재 데이터베이스를 지정된 경로에 백업
  static Future<bool> backupDatabase(String backupPath) async {
    try {
      AppLogger.info('데이터베이스 백업 시작', tag: 'DatabaseBackup');

      final currentDbPath = await DatabasePathChecker.getCurrentDatabasePath();
      final currentDbFile = File(currentDbPath);

      if (!await currentDbFile.exists()) {
        AppLogger.warning('백업할 데이터베이스 파일이 존재하지 않음: $currentDbPath', tag: 'DatabaseBackup');
        return false;
      }

      // 백업 파일명 생성 (타임스탬프 포함)
      final timestamp = DateTime.now().toIso8601String().replaceAll(':', '-').substring(0, 19);
      final backupFileName = 'renthouse_backup_$timestamp.sqlite';
      final fullBackupPath = p.join(backupPath, backupFileName);

      // 백업 디렉터리가 존재하지 않으면 생성
      final backupDir = Directory(backupPath);
      if (!await backupDir.exists()) {
        await backupDir.create(recursive: true);
      }

      // 파일 복사
      await currentDbFile.copy(fullBackupPath);

      AppLogger.info('데이터베이스 백업 완료: $fullBackupPath', tag: 'DatabaseBackup');
      return true;

    } catch (e, stackTrace) {
      AppLogger.error('데이터베이스 백업 중 오류 발생',
          tag: 'DatabaseBackup', error: e, stackTrace: stackTrace);
      return false;
    }
  }

  /// 백업 파일을 현재 데이터베이스 위치로 복원
  static Future<bool> restoreDatabase(String backupFilePath) async {
    try {
      AppLogger.info('데이터베이스 복원 시작', tag: 'DatabaseRestore');

      final backupFile = File(backupFilePath);
      if (!await backupFile.exists()) {
        AppLogger.warning('복원할 백업 파일이 존재하지 않음: $backupFilePath', tag: 'DatabaseRestore');
        return false;
      }

      // 백업 파일이 유효한 SQLite 파일인지 확인
      if (!await _isValidSQLiteFile(backupFile)) {
        AppLogger.warning('유효하지 않은 SQLite 파일: $backupFilePath', tag: 'DatabaseRestore');
        return false;
      }

      final currentDbPath = await DatabasePathChecker.getCurrentDatabasePath();

      // 현재 데이터베이스가 있다면 백업 생성
      final currentDbFile = File(currentDbPath);
      if (await currentDbFile.exists()) {
        final preRestoreBackupPath = '$currentDbPath.pre-restore-backup';
        await currentDbFile.copy(preRestoreBackupPath);
        AppLogger.info('복원 전 현재 DB 백업 생성: $preRestoreBackupPath', tag: 'DatabaseRestore');
      }

      // 백업 파일을 현재 위치로 복사
      await backupFile.copy(currentDbPath);

      AppLogger.info('데이터베이스 복원 완료: $currentDbPath', tag: 'DatabaseRestore');
      return true;

    } catch (e, stackTrace) {
      AppLogger.error('데이터베이스 복원 중 오류 발생',
          tag: 'DatabaseRestore', error: e, stackTrace: stackTrace);
      return false;
    }
  }

  /// 백업 폴더 선택 (플랫폼별 구현)
  static Future<String?> selectBackupFolder() async {
    try {
      if (PlatformUtils.isDesktop) {
        // Windows/Desktop: 폴더 선택
        final selectedDirectory = await FilePicker.platform.getDirectoryPath();
        return selectedDirectory;
      } else {
        // Android: 기본 다운로드 폴더 또는 외부 저장소 사용
        return await _getAndroidBackupPath();
      }
    } catch (e) {
      AppLogger.error('백업 폴더 선택 중 오류 발생', tag: 'DatabaseBackup', error: e);
      return null;
    }
  }

  /// 백업 파일 선택 (복원용)
  static Future<String?> selectBackupFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['sqlite', 'db'],
        dialogTitle: '복원할 데이터베이스 백업 파일을 선택하세요',
      );

      if (result != null && result.files.single.path != null) {
        return result.files.single.path!;
      }

      return null;
    } catch (e) {
      AppLogger.error('백업 파일 선택 중 오류 발생', tag: 'DatabaseRestore', error: e);
      return null;
    }
  }

  /// 안드로이드용 백업 경로 가져오기
  static Future<String?> _getAndroidBackupPath() async {
    try {
      if (Platform.isAndroid) {
        // Android 11+에서는 Downloads 폴더 사용
        final Directory downloadsDir = Directory('/storage/emulated/0/Download');

        if (await downloadsDir.exists()) {
          final backupDir = Directory('${downloadsDir.path}/RentHouse_Backups');
          if (!await backupDir.exists()) {
            await backupDir.create(recursive: true);
          }
          return backupDir.path;
        }

        // 대안: 앱의 외부 저장소 디렉터리 사용
        try {
          // 이 방법은 path_provider를 통해 앱 전용 외부 디렉터리를 사용
          final appDir = Directory('/Android/data/com.example.renthouse/files/Backups');
          if (!await appDir.exists()) {
            await appDir.create(recursive: true);
          }
          return appDir.path;
        } catch (e) {
          AppLogger.warning('앱 전용 디렉터리 생성 실패', tag: 'DatabaseBackup', details: e);
        }
      }
      return null;
    } catch (e) {
      AppLogger.error('Android 백업 경로 가져오기 실패', tag: 'DatabaseBackup', error: e);
      return null;
    }
  }

  /// SQLite 파일 유효성 검사
  static Future<bool> _isValidSQLiteFile(File file) async {
    try {
      final bytes = await file.openRead(0, 16).single;
      // SQLite 파일은 "SQLite format 3" 으로 시작
      const sqliteHeader = [0x53, 0x51, 0x4C, 0x69, 0x74, 0x65, 0x20, 0x66, 0x6F, 0x72, 0x6D, 0x61, 0x74, 0x20, 0x33, 0x00];

      if (bytes.length < 16) return false;

      for (int i = 0; i < 16; i++) {
        if (bytes[i] != sqliteHeader[i]) {
          return false;
        }
      }

      return true;
    } catch (e) {
      AppLogger.error('SQLite 파일 유효성 검사 실패', tag: 'DatabaseBackup', error: e);
      return false;
    }
  }

  /// 백업 파일 목록 가져오기
  static Future<List<FileSystemEntity>> getBackupFiles(String backupFolderPath) async {
    try {
      final backupDir = Directory(backupFolderPath);
      if (!await backupDir.exists()) {
        return [];
      }

      final files = await backupDir
          .list()
          .where((file) => file is File &&
              (file.path.endsWith('.sqlite') || file.path.endsWith('.db')))
          .toList();

      // 수정 시간순으로 정렬 (최신 순)
      files.sort((a, b) {
        final statA = (a as File).statSync();
        final statB = (b as File).statSync();
        return statB.modified.compareTo(statA.modified);
      });

      return files;
    } catch (e) {
      AppLogger.error('백업 파일 목록 가져오기 실패', tag: 'DatabaseBackup', error: e);
      return [];
    }
  }

  /// 백업 파일 정보 가져오기
  static Future<Map<String, dynamic>> getBackupFileInfo(String filePath) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) {
        return {};
      }

      final stat = await file.stat();
      final fileName = p.basename(filePath);

      return {
        'fileName': fileName,
        'filePath': filePath,
        'size': stat.size,
        'modified': stat.modified,
        'sizeFormatted': _formatFileSize(stat.size),
        'modifiedFormatted': _formatDateTime(stat.modified),
      };
    } catch (e) {
      AppLogger.error('백업 파일 정보 가져오기 실패', tag: 'DatabaseBackup', error: e);
      return {};
    }
  }

  /// 파일 크기 포맷팅
  static String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  /// 날짜 시간 포맷팅
  static String _formatDateTime(DateTime dateTime) {
    return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} '
           '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}