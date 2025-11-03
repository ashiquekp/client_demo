import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/storage_keys.dart';

class StorageService {
  final FlutterSecureStorage _secureStorage;
  final SharedPreferences _prefs;

  StorageService(this._secureStorage, this._prefs);

  // Secure Storage Methods (for sensitive data like tokens)
  
  Future<void> saveToken(String token) async {
    await _secureStorage.write(key: StorageKeys.accessToken, value: token);
  }

  Future<String?> getToken() async {
    return await _secureStorage.read(key: StorageKeys.accessToken);
  }

  Future<void> deleteToken() async {
    await _secureStorage.delete(key: StorageKeys.accessToken);
  }

  Future<void> saveUserId(String userId) async {
    await _secureStorage.write(key: StorageKeys.userId, value: userId);
  }

  Future<String?> getUserId() async {
    return await _secureStorage.read(key: StorageKeys.userId);
  }

  Future<void> saveUserEmail(String email) async {
    await _secureStorage.write(key: StorageKeys.userEmail, value: email);
  }

  Future<String?> getUserEmail() async {
    return await _secureStorage.read(key: StorageKeys.userEmail);
  }

  // Clear all secure data
  Future<void> clearSecureData() async {
    await _secureStorage.deleteAll();
  }

  // SharedPreferences Methods (for non-sensitive data)
  
  Future<void> setLoggedIn(bool value) async {
    await _prefs.setBool(StorageKeys.isLoggedIn, value);
  }

  bool isLoggedIn() {
    return _prefs.getBool(StorageKeys.isLoggedIn) ?? false;
  }

  Future<void> setUserName(String name) async {
    await _prefs.setString(StorageKeys.userName, name);
  }

  String? getUserName() {
    return _prefs.getString(StorageKeys.userName);
  }

  Future<void> setRememberMe(bool value) async {
    await _prefs.setBool(StorageKeys.rememberMe, value);
  }

  bool getRememberMe() {
    return _prefs.getBool(StorageKeys.rememberMe) ?? false;
  }

  Future<void> setLastSearchQuery(String query) async {
    await _prefs.setString(StorageKeys.lastSearchQuery, query);
  }

  String? getLastSearchQuery() {
    return _prefs.getString(StorageKeys.lastSearchQuery);
  }

  Future<void> setSortPreference(String sort) async {
    await _prefs.setString(StorageKeys.sortPreference, sort);
  }

  String? getSortPreference() {
    return _prefs.getString(StorageKeys.sortPreference);
  }

  // Clear all data
  Future<void> clearAll() async {
    await clearSecureData();
    await _prefs.clear();
  }

  // Check if token exists
  Future<bool> hasToken() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }
}

// Providers
final secureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
  );
});

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences must be initialized');
});

final storageServiceProvider = Provider<StorageService>((ref) {
  final secureStorage = ref.watch(secureStorageProvider);
  final sharedPrefs = ref.watch(sharedPreferencesProvider);
  return StorageService(secureStorage, sharedPrefs);
});