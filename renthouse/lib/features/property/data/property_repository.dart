import 'package:dio/dio.dart';
import 'package:renthouse/core/network/dio_client.dart';
import 'package:renthouse/features/property/domain/property.dart';

class PropertyRepository {
  final DioClient _dioClient;
  // TODO: REMOVE AFTER BACKEND INTEGRATION - START SIMULATED DATABASE
  final List<Property> _properties = [];
  // TODO: REMOVE AFTER BACKEND INTEGRATION - END SIMULATED DATABASE

  PropertyRepository(this._dioClient);

  Future<List<Property>> getProperties() async {
    // TODO: REMOVE AFTER BACKEND INTEGRATION - START SIMULATED DATABASE
    await Future.delayed(const Duration(milliseconds: 500)); // Simulate network delay
    return _properties;
    // TODO: REMOVE AFTER BACKEND INTEGRATION - END SIMULATED DATABASE

    /*
    try {
      // TODO: 실제 API 엔드포인트 및 응답 구조에 맞게 수정
      final response = await _dioClient.dio.get('/properties');
      // return (response.data as List).map((json) => Property.fromJson(json)).toList();
      return []; // Return an empty list
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? '자산 목록 불러오기 실패');
    }
    */
  }

  Future<Property> createProperty(Property property) async {
    // TODO: REMOVE AFTER BACKEND INTEGRATION - START SIMULATED DATABASE
    await Future.delayed(const Duration(milliseconds: 500)); // Simulate network delay
    _properties.add(property);
    return property;
    // TODO: REMOVE AFTER BACKEND INTEGRATION - END SIMULATED DATABASE

    /*
    try {
      // TODO: 실제 API 엔드포인트 및 응답 구조에 맞게 수정
      final response = await _dioClient.dio.post(
        '/properties',
        data: property.toJson(),
      );
      return Property.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? '자산 생성 실패');
    }
    */
  }

  Future<Property> updateProperty(Property property) async {
    // TODO: REMOVE AFTER BACKEND INTEGRATION - START SIMULATED DATABASE
    await Future.delayed(const Duration(milliseconds: 500)); // Simulate network delay
    final index = _properties.indexWhere((p) => p.id == property.id);
    if (index != -1) {
      _properties[index] = property;
    }
    return property;
    // TODO: REMOVE AFTER BACKEND INTEGRATION - END SIMULATED DATABASE

    /*
    try {
      // TODO: 실제 API 엔드포인트 및 응답 구조에 맞게 수정
      final response = await _dioClient.dio.put(
        '/properties/${property.id}',
        data: property.toJson(),
      );
      return Property.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? '자산 업데이트 실패');
    }
    */
  }

  Future<void> deleteProperty(String id) async {
    // TODO: REMOVE AFTER BACKEND INTEGRATION - START SIMULATED DATABASE
    await Future.delayed(const Duration(milliseconds: 500)); // Simulate network delay
    _properties.removeWhere((p) => p.id == id);
    // TODO: REMOVE AFTER BACKEND INTEGRATION - END SIMULATED DATABASE

    /*
    try {
      // TODO: 실제 API 엔드포인트 및 응답 구조에 맞게 수정
      await _dioClient.dio.delete('/properties/$id');
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? '자산 삭제 실패');
    }
    */
  }
}
