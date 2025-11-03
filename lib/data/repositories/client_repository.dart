import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/network/dio_client.dart';
import '../../core/network/api_response.dart';
import '../../core/constants/api_constants.dart';
import '../models/client_model.dart';

class ClientRepository {
  final DioClient dioClient;

  ClientRepository({required this.dioClient});

  Future<ApiResponse<PaginatedClientsResponse>> getClients({
    int page = 1,
    int pageSize = 20,
    String? search,
    String? sortBy,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'pageSize': pageSize,
      };

      if (search != null && search.isNotEmpty) {
        queryParams['search'] = search;
      }

      if (sortBy != null && sortBy.isNotEmpty) {
        queryParams['sortBy'] = sortBy;
      }

      final response = await dioClient.get(
        ApiConstants.clients,
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        // Handle both array and paginated response
        if (response.data is List) {
          final clients = (response.data as List)
              .map((e) => ClientModel.fromJson(e as Map<String, dynamic>))
              .toList();
          
          return ApiResponse.success(
            data: PaginatedClientsResponse(
              clients: clients,
              total: clients.length,
              page: page,
              pageSize: pageSize,
            ),
          );
        } else {
          final paginatedResponse = PaginatedClientsResponse.fromJson(
            response.data as Map<String, dynamic>,
          );
          return ApiResponse.success(data: paginatedResponse);
        }
      }

      return ApiResponse.error(
        message: 'Failed to fetch clients',
        statusCode: response.statusCode,
      );
    } catch (e) {
      return ApiResponse.error(message: _getErrorMessage(e));
    }
  }

  Future<ApiResponse<ClientModel>> getClientById(int id) async {
    try {
      final response = await dioClient.get(
        ApiConstants.clientDetail(id),
      );

      if (response.statusCode == 200) {
        final client = ClientModel.fromJson(response.data as Map<String, dynamic>);
        return ApiResponse.success(data: client);
      }

      return ApiResponse.error(
        message: 'Failed to fetch client details',
        statusCode: response.statusCode,
      );
    } catch (e) {
      return ApiResponse.error(message: _getErrorMessage(e));
    }
  }

  Future<ApiResponse<ClientModel>> createClient({
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
  }) async {
    try {
      final response = await dioClient.post(
        ApiConstants.clients,
        data: {
          'firstName': firstName,
          'lastName': lastName,
          'email': email,
          'phone': phone,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final client = ClientModel.fromJson(response.data as Map<String, dynamic>);
        return ApiResponse.success(
          data: client,
          message: 'Client created successfully',
        );
      }

      return ApiResponse.error(
        message: 'Failed to create client',
        statusCode: response.statusCode,
      );
    } catch (e) {
      return ApiResponse.error(message: _getErrorMessage(e));
    }
  }

  Future<ApiResponse<ClientModel>> updateClient({
    required int id,
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
  }) async {
    try {
      final response = await dioClient.put(
        ApiConstants.clientUpdate(id),
        data: {
          'firstName': firstName,
          'lastName': lastName,
          'email': email,
          'phone': phone,
        },
      );

      if (response.statusCode == 200) {
        final client = ClientModel.fromJson(response.data as Map<String, dynamic>);
        return ApiResponse.success(
          data: client,
          message: 'Client updated successfully',
        );
      }

      return ApiResponse.error(
        message: 'Failed to update client',
        statusCode: response.statusCode,
      );
    } catch (e) {
      return ApiResponse.error(message: _getErrorMessage(e));
    }
  }

  Future<ApiResponse<bool>> deleteClient(int id) async {
    try {
      final response = await dioClient.delete(
        ApiConstants.clientDelete(id),
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        return ApiResponse.success(
          data: true,
          message: 'Client deleted successfully',
        );
      }

      return ApiResponse.error(
        message: 'Failed to delete client',
        statusCode: response.statusCode,
      );
    } catch (e) {
      return ApiResponse.error(message: _getErrorMessage(e));
    }
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

final clientRepositoryProvider = Provider<ClientRepository>((ref) {
  return ClientRepository(
    dioClient: ref.watch(dioClientProvider),
  );
});