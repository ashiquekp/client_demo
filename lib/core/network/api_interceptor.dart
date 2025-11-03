import 'package:dio/dio.dart';
import '../../data/services/storage_service.dart';
import '../constants/app_constants.dart';
import 'api_response.dart';

class ApiInterceptor extends Interceptor {
  final StorageService storageService;
  final Function()? onUnauthorized;

  ApiInterceptor({
    required this.storageService,
    this.onUnauthorized,
  });

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Add authorization token to all requests except login
    if (!options.path.contains('/auth/login')) {
      final token = await storageService.getToken();
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }

    print('🚀 REQUEST[${options.method}] => PATH: ${options.path}');
    print('🔑 Headers: ${options.headers}');
    if (options.data != null) {
      print('📦 Body: ${options.data}');
    }
    if (options.queryParameters.isNotEmpty) {
      print('🔍 Params: ${options.queryParameters}');
    }

    super.onRequest(options, handler);
  }

  @override
  void onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) {
    print('✅ RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
    print('📥 Data: ${response.data}');

    super.onResponse(response, handler);
  }

  @override
  void onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    print('❌ ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}');
    print('💥 Message: ${err.message}');
    print('📛 Error Type: ${err.type}');

    if (err.response != null) {
      print('📥 Error Response: ${err.response?.data}');
    }

    // Handle different error scenarios
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return handler.reject(
          DioException(
            requestOptions: err.requestOptions,
            error: TimeoutException(
              message: 'Request timeout. Please try again.',
            ),
            type: err.type,
          ),
        );

      case DioExceptionType.connectionError:
        return handler.reject(
          DioException(
            requestOptions: err.requestOptions,
            error: NetworkException(
              message: AppConstants.networkError,
            ),
            type: err.type,
          ),
        );

      case DioExceptionType.badResponse:
        return _handleBadResponse(err, handler);

      default:
        return handler.reject(err);
    }
  }

  Future<void> _handleBadResponse(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final statusCode = err.response?.statusCode;
    String errorMessage = AppConstants.unknownError;

    // Try to extract error message from response
    try {
      final responseData = err.response?.data;
      if (responseData is Map<String, dynamic>) {
        errorMessage = responseData['message'] as String? ??
            responseData['error'] as String? ??
            errorMessage;
      } else if (responseData is String) {
        errorMessage = responseData;
      }
    } catch (e) {
      print('Error parsing error response: $e');
    }

    switch (statusCode) {
      case 400:
        return handler.reject(
          DioException(
            requestOptions: err.requestOptions,
            response: err.response,
            error: ApiException(
              message: errorMessage.isEmpty
                  ? AppConstants.validationError
                  : errorMessage,
              statusCode: statusCode,
            ),
            type: err.type,
          ),
        );

      case 401:
        // Token expired or invalid - trigger logout
        print('🔐 Unauthorized - Clearing token and redirecting to login');
        await storageService.clearAll();
        
        // Call the unauthorized callback
        onUnauthorized?.call();

        return handler.reject(
          DioException(
            requestOptions: err.requestOptions,
            response: err.response,
            error: UnauthorizedException(
              message: AppConstants.unauthorizedError,
            ),
            type: err.type,
          ),
        );

      case 404:
        return handler.reject(
          DioException(
            requestOptions: err.requestOptions,
            response: err.response,
            error: ApiException(
              message: errorMessage.isEmpty
                  ? AppConstants.notFoundError
                  : errorMessage,
              statusCode: statusCode,
            ),
            type: err.type,
          ),
        );

      case 500:
      case 502:
      case 503:
        return handler.reject(
          DioException(
            requestOptions: err.requestOptions,
            response: err.response,
            error: ApiException(
              message: AppConstants.serverError,
              statusCode: statusCode,
            ),
            type: err.type,
          ),
        );

      default:
        return handler.reject(
          DioException(
            requestOptions: err.requestOptions,
            response: err.response,
            error: ApiException(
              message: errorMessage,
              statusCode: statusCode,
            ),
            type: err.type,
          ),
        );
    }
  }
}