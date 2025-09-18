import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
// Windows SQLite 지원
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';
// 데이터베이스 경로 체크
import 'package:renthouse/core/utils/database_path_checker.dart';

LazyDatabase connect() {
  return LazyDatabase(() async {
    // Windows에서 SQLite FFI 초기화
    if (Platform.isWindows || Platform.isLinux) {
      // SQLite 라이브러리 초기화
      await applyWorkaroundToOpenSqlite3OnOldAndroidVersions();
      sqfliteFfiInit();
    }

    // 디버깅 정보 출력 (개발 모드에서만)
    if (Platform.isWindows) {
      await DatabasePathChecker.printDatabaseInfo();
    }

    // 기존 데이터베이스 마이그레이션 시도
    await DatabasePathChecker.migrateDatabaseIfNeeded();

    // 현재 데이터베이스 경로 가져오기
    final dbPath = await DatabasePathChecker.getCurrentDatabasePath();
    final file = File(dbPath);

    // 디렉터리가 존재하지 않으면 생성
    final dbFolder = Directory(p.dirname(dbPath));
    if (!await dbFolder.exists()) {
      await dbFolder.create(recursive: true);
    }

    print('데이터베이스 연결: $dbPath');

    // 플랫폼별 데이터베이스 생성
    if (Platform.isWindows || Platform.isLinux) {
      // Windows/Linux용 FFI 데이터베이스
      return NativeDatabase.createInBackground(file, setup: (database) {
        // 필요한 경우 추가 설정
        database.execute('PRAGMA foreign_keys = ON;');
      });
    } else {
      // Android/iOS용 일반 데이터베이스
      return NativeDatabase.createInBackground(file);
    }
  });
}