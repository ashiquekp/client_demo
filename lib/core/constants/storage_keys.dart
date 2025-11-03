class StorageKeys {
  // Secure Storage Keys (for sensitive data)
  static const String accessToken = 'access_token';
  static const String refreshToken = 'refresh_token';
  static const String userId = 'user_id';
  static const String userEmail = 'user_email';
  
  // Shared Preferences Keys (for non-sensitive data)
  static const String isLoggedIn = 'is_logged_in';
  static const String rememberMe = 'remember_me';
  static const String themeMode = 'theme_mode';
  static const String userName = 'user_name';
  
  // Filter & Search Preferences
  static const String lastSearchQuery = 'last_search_query';
  static const String sortPreference = 'sort_preference';
  static const String filterPreference = 'filter_preference';
}