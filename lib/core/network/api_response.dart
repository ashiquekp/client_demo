import 'package:equatable/equatable.dart';

// Generic API Response wrapper
class ApiResponse<T> extends Equatable {
  final T? data;
  final String? message;
  final bool success;
  final int? statusCode;

  const ApiResponse({
    this.data,
    this.message,
    required this.success,
    this.statusCode,
  });

  factory ApiResponse.success({
    T? data,
    String? message,
    int? statusCode,
  }) {
    return ApiResponse<T>(
      data: data,
      message: message,
      success: true,
      statusCode: statusCode,
    );
  }

  factory ApiResponse.error({
    String? message,
    int? statusCode,
  }) {
    return ApiResponse<T>(
      message: message ?? 'An error occurred',
      success: false,
      statusCode: statusCode,
    );
  }

  @override
  List<Object?> get props => [data, message, success, statusCode];
}

// API Exception
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic error;

  ApiException({
    required this.message,
    this.statusCode,
    this.error,
  });

  @override
  String toString() {
    return 'ApiException: $message (Status: $statusCode)';
  }
}

// Network Exception
class NetworkException implements Exception {
  final String message;

  NetworkException({
    this.message = 'Network error occurred',
  });

  @override
  String toString() {
    return 'NetworkException: $message';
  }
}

// Timeout Exception
class TimeoutException implements Exception {
  final String message;

  TimeoutException({
    this.message = 'Request timeout',
  });

  @override
  String toString() {
    return 'TimeoutException: $message';
  }
}

// Unauthorized Exception
class UnauthorizedException implements Exception {
  final String message;

  UnauthorizedException({
    this.message = 'Unauthorized access',
  });

  @override
  String toString() {
    return 'UnauthorizedException: $message';
  }
}