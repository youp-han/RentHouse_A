import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:renthouse/core/database/app_database.dart';

// 싱글톤 인스턴스를 직접 관리
AppDatabase? _databaseInstance;

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  // 싱글톤 패턴으로 인스턴스 생성 보장
  _databaseInstance ??= AppDatabase();

  // Provider 생명주기 관리
  ref.onDispose(() {
    // 앱 종료 시에만 정리되도록 주의깊게 관리
    // _databaseInstance?.close();
    // _databaseInstance = null;
  });

  return _databaseInstance!;
});
