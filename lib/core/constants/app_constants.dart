class AppConstants {
  // App Info
  static const String appName = 'ByteSymphony Client Manager';
  static const String appVersion = '1.0.0';
  
  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;
  
  // Validation
  static const int minPasswordLength = 6;
  static const int maxPasswordLength = 50;
  static const int minNameLength = 2;
static const int maxNameLength = 100;

// Phone validation
static const String phoneRegex = r'^[0-9]{10}$';

// Email validation
static const String emailRegex = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';

// Debounce
  static const Duration searchDebounce = Duration(milliseconds: 500);
  
  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);
  
  // Invoice Status
  static const String statusPaid = 'Paid';
  static const String statusPending = 'Pending';
  static const String statusOverdue = 'Overdue';
  static const String statusCancelled = 'Cancelled';
  
  static const List<String> invoiceStatuses = [
    statusPaid,
    statusPending,
    statusOverdue,
    statusCancelled,
  ];
  
  // Sort Options
  static const String sortByNameAsc = 'name_asc';
  static const String sortByNameDesc = 'name_desc';
  static const String sortByDateAsc = 'date_asc';
  static const String sortByDateDesc = 'date_desc';
  
  // Error Messages
  static const String networkError = 'Network error. Please check your connection.';
  static const String serverError = 'Server error. Please try again later.';
  static const String unauthorizedError = 'Session expired. Please login again.';
  static const String notFoundError = 'Resource not found.';
  static const String validationError = 'Please check your input.';
  static const String unknownError = 'Something went wrong. Please try again.';
}

// Save this as: lib/core/constants/app_constants.dart