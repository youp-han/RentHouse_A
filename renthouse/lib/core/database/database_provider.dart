import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:renthouse/core/database/app_database.dart';

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase();
});
