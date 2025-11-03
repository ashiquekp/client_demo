import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/network/dio_client.dart';
import '../../core/network/api_response.dart';
import '../../core/constants/api_constants.dart';
import '../models/invoice_model.dart';

class InvoiceRepository {
  final DioClient dioClient;

  InvoiceRepository({required this.dioClient});

  Future<ApiResponse<PaginatedInvoicesResponse>> getInvoices({
    int page = 1,
    int pageSize = 20,
    int? clientId,
    String? status,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'pageSize': pageSize,
      };

      if (clientId != null) {
        queryParams['clientId'] = clientId;
      }

      if (status != null && status.isNotEmpty) {
        queryParams['status'] = status;
      }

      final response = await dioClient.get(
        ApiConstants.invoices,
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        // Handle both array and paginated response
        if (response.data is List) {
          final invoices = (response.data as List)
              .map((e) => InvoiceModel.fromJson(e as Map<String, dynamic>))
              .toList();
          
          return ApiResponse.success(
            data: PaginatedInvoicesResponse(
              invoices: invoices,
              total: invoices.length,
              page: page,
              pageSize: pageSize,
            ),
          );
        } else {
          final paginatedResponse = PaginatedInvoicesResponse.fromJson(
            response.data as Map<String, dynamic>,
          );
          return ApiResponse.success(data: paginatedResponse);
        }
      }

      return ApiResponse.error(
        message: 'Failed to fetch invoices',
        statusCode: response.statusCode,
      );
    } catch (e) {
      return ApiResponse.error(message: _getErrorMessage(e));
    }
  }

  Future<ApiResponse<InvoiceModel>> getInvoiceById(int id) async {
    try {
      final response = await dioClient.get(
        ApiConstants.invoiceDetail(id),
      );

      if (response.statusCode == 200) {
        final invoice = InvoiceModel.fromJson(response.data as Map<String, dynamic>);
        return ApiResponse.success(data: invoice);
      }

      return ApiResponse.error(
        message: 'Failed to fetch invoice details',
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

final invoiceRepositoryProvider = Provider<InvoiceRepository>((ref) {
  return InvoiceRepository(
    dioClient: ref.watch(dioClientProvider),
  );
});