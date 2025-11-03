class RouteNames {
  // Auth Routes
  static const String splash = '/';
  static const String login = '/login';
  
  // Main Routes
  static const String home = '/home';
  
  // Client Routes
  static const String clients = '/clients';
  static const String clientDetail = '/clients/:id';
  static const String clientAdd = '/clients/add';
  static const String clientEdit = '/clients/:id/edit';
  
  // Invoice Routes
  static const String invoices = '/invoices';
  static const String invoiceDetail = '/invoices/:id';
  static const String invoiceAdd = '/invoices/add';
  static const String invoiceEdit = '/invoices/:id/edit';
  
  // Helper methods
  static String clientDetailPath(int id) => '/clients/$id';
  static String clientEditPath(int id) => '/clients/$id/edit';
  static String invoiceDetailPath(int id) => '/invoices/$id';
  static String invoiceEditPath(int id) => '/invoices/$id/edit';
}