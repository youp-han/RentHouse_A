import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DioClient {
  final Dio _dio;

  DioClient(this._dio) {
    _dio
      ..options.baseUrl = 'http://localhost:8080/api' // TODO: 실제 백엔드 API URL로 변경
      ..options.connectTimeout = const Duration(seconds: 5) // 5초
      ..options.receiveTimeout = const Duration(seconds: 3) // 3초
      ..options.headers = {'Content-Type': 'application/json'};
  }

  Dio get dio => _dio;
}

final dioClientProvider = Provider((ref) => DioClient(Dio()));
