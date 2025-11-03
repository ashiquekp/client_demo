import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/network/dio_client.dart';
import '../../core/network/api_response.dart';
import '../../core/constants/api_constants.dart';
import '../models/auth_response_model.dart';
import '../models/user_model.dart';
import '../services/storage_service.dart';

class AuthRepository {
  final DioClient dioClient;
  final StorageService storageService;

  AuthRepository({
    required this.dioClient,
    required this.storageService,
  });

  Future<ApiResponse<AuthResponseModel>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await dioClient.post(
        ApiConstants.login,
        data: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        final authResponse = AuthResponseModel.fromJson(response.data);
        
        // Save token
        await storageService.saveToken(authResponse.token);
        await storageService.setLoggedIn(true);
        
        if (authResponse.user != null) {
          await storageService.saveUserId(authResponse.user!.id.toString());
          await storageService.saveUserEmail(authResponse.user!.email);
          await storageService.setUserName(authResponse.user!.fullName);
        }

        return ApiResponse.success(
          data: authResponse,
          message: 'Login successful',
        );
      }

      return ApiResponse.error(
        message: 'Login failed',
        statusCode: response.statusCode,
      );
    } catch (e) {
      return ApiResponse.error(
        message: _getErrorMessage(e),
      );
    }
  }

  Future<ApiResponse<UserModel>> getCurrentUser() async {
    try {
      final response = await dioClient.get(ApiConstants.me);

      if (response.statusCode == 200) {
        final user = UserModel.fromJson(response.data);
        return ApiResponse.success(data: user);
      }

      return ApiResponse.error(
        message: 'Failed to fetch user details',
        statusCode: response.statusCode,
      );
    } catch (e) {
      return ApiResponse.error(message: _getErrorMessage(e));
    }
  }

  Future<void> logout() async {
    await storageService.clearAll();
  }

  Future<bool> isLoggedIn() async {
    return await storageService.hasToken();
  }

  String _getErrorMessage(dynamic error) {
    if (error is ApiException) {
      return error.message;
    } else if (error is NetworkException) {
      return error.message;
    } else if (error is UnauthorizedException) {
      return error.message;
    }
    return 'An unexpected error occurred';
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(
    dioClient: ref.watch(dioClientProvider),
    storageService: ref.watch(storageServiceProvider),
  );
});