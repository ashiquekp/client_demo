class ApiConstants {
  // Base URL
  static const String baseUrl = 'https://www.bytesymphony.dev/TestAPI';
  
  // API Endpoints
  static const String login = '/api/auth/login';
  static const String me = '/api/me';
  static const String ping = '/api/ping';
  
  // Client Endpoints
  static const String clients = '/api/clients';
  static String clientDetail(int id) => '/api/clients/$id';
  static String clientUpdate(int id) => '/api/clients/$id';
  static String clientDelete(int id) => '/api/clients/$id';
  
  // Invoice Endpoints
  static const String invoices = '/api/invoices';
  static String invoiceDetail(int id) => '/api/invoices/$id';
  static String invoiceUpdate(int id) => '/api/invoices/$id';
  
  // Headers
  static const String contentType = 'application/json';
  static const String accept = 'application/json';
  
  // Timeout
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);
}