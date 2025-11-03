import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../viewmodels/auth_viewmodel.dart';

// Re-export for convenience
final authStateProvider = authViewModelProvider;

final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(authViewModelProvider).isAuthenticated;
});

final currentUserProvider = Provider((ref) {
  return ref.watch(authViewModelProvider).user;
});

final authLoadingProvider = Provider<bool>((ref) {
  return ref.watch(authViewModelProvider).isLoading;
});

final authErrorProvider = Provider<String?>((ref) {
  return ref.watch(authViewModelProvider).error;
});