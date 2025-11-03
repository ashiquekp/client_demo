import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/network/dio_client.dart';
import '../../core/constants/api_constants.dart';

/// Centralized API Service for making HTTP requests
/// This service wraps DioClient for easier API calls
class ApiService {
  final DioClient _dioClient;

  ApiService(this._dioClient);

  // Health check
  Future<bool> ping() async {
    try {
      final response = await _dioClient.get(ApiConstants.ping);
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // GET request helper
  Future<dynamic> get(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
  }) async {
    final response = await _dioClient.get(
      endpoint,
      queryParameters: queryParameters,
    );
    return response.data;
  }

  // POST request helper
  Future<dynamic> post(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    final response = await _dioClient.post(
      endpoint,
      data: data,
      queryParameters: queryParameters,
    );
    return response.data;
  }

  // PUT request helper
  Future<dynamic> put(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    final response = await _dioClient.put(
      endpoint,
      data: data,
      queryParameters: queryParameters,
    );
    return response.data;
  }

  // DELETE request helper
  Future<dynamic> delete(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    final response = await _dioClient.delete(
      endpoint,
      data: data,
      queryParameters: queryParameters,
    );
    return response.data;
  }

  // PATCH request helper
  Future<dynamic> patch(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    final response = await _dioClient.patch(
      endpoint,
      data: data,
      queryParameters: queryParameters,
    );
    return response.data;
  }
}

// Provider for ApiService
final apiServiceProvider = Provider<ApiService>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return ApiService(dioClient);
});