import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

/// 데이터베이스 경로 확인 및 마이그레이션 유틸리티
class DatabasePathChecker {
  /// 이전 데이터베이스 파일이 존재하는 위치들을 확인
  static Future<List<String>> findExistingDatabases() async {
    final existingPaths = <String>[];

    try {
      // 1. 기존 경로: Documents 폴더
      final documentsDir = await getApplicationDocumentsDirectory();
      final oldDbPath1 = p.join(documentsDir.path, 'db.sqlite');
      final oldDbPath2 = p.join(documentsDir.path, 'renthouse.sqlite');

      if (await File(oldDbPath1).exists()) {
        existingPaths.add(oldDbPath1);
      }
      if (await File(oldDbPath2).exists()) {
        existingPaths.add(oldDbPath2);
      }

      // 2. Windows: Application Support 폴더
      if (Platform.isWindows) {
        final appSupportDir = await getApplicationSupportDirectory();
        final newDbPath = p.join(appSupportDir.path, 'renthouse.sqlite');

        if (await File(newDbPath).exists()) {
          existingPaths.add(newDbPath);
        }
      }

      // 3. Android: Application Support 폴더 (fallback으로 사용)
      if (Platform.isAndroid) {
        final appSupportDir = await getApplicationSupportDirectory();
        final androidDbPath = p.join(appSupportDir.path, 'renthouse.sqlite');

        if (await File(androidDbPath).exists()) {
          existingPaths.add(androidDbPath);
        }
      }

    } catch (e) {
      print('데이터베이스 경로 확인 중 오류: $e');
    }

    return existingPaths;
  }

  /// 현재 설정된 데이터베이스 경로 반환
  static Future<String> getCurrentDatabasePath() async {
    Directory dbFolder;

    if (Platform.isWindows) {
      // Windows: 앱 데이터 폴더 사용
      dbFolder = await getApplicationSupportDirectory();
    } else if (Platform.isAndroid) {
      // Android: 앱 전용 데이터베이스 디렉터리 사용
      try {
        dbFolder = Directory((await getApplicationSupportDirectory()).path);
      } catch (e) {
        dbFolder = await getApplicationDocumentsDirectory();
      }
    } else {
      dbFolder = await getApplicationDocumentsDirectory();
    }

    return p.join(dbFolder.path, 'renthouse.sqlite');
  }

  /// 기존 데이터베이스를 새 위치로 마이그레이션
  static Future<bool> migrateDatabaseIfNeeded() async {
    try {
      final currentPath = await getCurrentDatabasePath();
      final currentFile = File(currentPath);

      // 현재 위치에 이미 데이터베이스가 있으면 마이그레이션 불필요
      if (await currentFile.exists()) {
        print('데이터베이스가 현재 위치에 이미 존재: $currentPath');
        return true;
      }

      // 기존 데이터베이스 파일들 찾기
      final existingPaths = await findExistingDatabases();

      if (existingPaths.isEmpty) {
        print('기존 데이터베이스 파일을 찾을 수 없습니다. 새로 생성됩니다.');
        return true;
      }

      // 가장 최근에 수정된 파일을 찾기
      File? mostRecentFile;
      DateTime? mostRecentTime;

      for (final path in existingPaths) {
        final file = File(path);
        final stat = await file.stat();

        if (mostRecentTime == null || stat.modified.isAfter(mostRecentTime)) {
          mostRecentTime = stat.modified;
          mostRecentFile = file;
        }
      }

      if (mostRecentFile != null) {
        print('기존 데이터베이스를 마이그레이션: ${mostRecentFile.path} -> $currentPath');

        // 대상 디렉터리 생성
        final targetDir = Directory(p.dirname(currentPath));
        if (!await targetDir.exists()) {
          await targetDir.create(recursive: true);
        }

        // 파일 복사
        await mostRecentFile.copy(currentPath);

        print('데이터베이스 마이그레이션 완료: $currentPath');
        return true;
      }

    } catch (e) {
      print('데이터베이스 마이그레이션 중 오류: $e');
      return false;
    }

    return false;
  }

  /// 모든 데이터베이스 경로 정보를 출력 (디버깅용)
  static Future<void> printDatabaseInfo() async {
    print('=== 데이터베이스 경로 정보 ===');
    print('플랫폼: ${Platform.operatingSystem}');

    try {
      // Documents 디렉터리
      final documentsDir = await getApplicationDocumentsDirectory();
      print('Documents 디렉터리: ${documentsDir.path}');

      // Application Support 디렉터리
      final appSupportDir = await getApplicationSupportDirectory();
      print('Application Support 디렉터리: ${appSupportDir.path}');

      // 현재 설정된 DB 경로
      final currentPath = await getCurrentDatabasePath();
      print('현재 DB 경로: $currentPath');
      print('현재 DB 파일 존재 여부: ${await File(currentPath).exists()}');

      // 기존 DB 파일들 찾기
      final existing = await findExistingDatabases();
      print('발견된 기존 DB 파일들:');
      for (final path in existing) {
        final file = File(path);
        final stat = await file.stat();
        print('  - $path (수정시간: ${stat.modified}, 크기: ${stat.size} bytes)');
      }

    } catch (e) {
      print('경로 정보 조회 중 오류: $e');
    }

    print('=== 정보 조회 완료 ===');
  }
}