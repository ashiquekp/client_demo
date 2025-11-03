import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../viewmodels/client_viewmodel.dart';

// Re-export for convenience
final clientStateProvider = clientViewModelProvider;

final clientsListProvider = Provider((ref) {
  return ref.watch(clientViewModelProvider).clients;
});

final clientsLoadingProvider = Provider<bool>((ref) {
  return ref.watch(clientViewModelProvider).isLoading;
});

final clientsErrorProvider = Provider<String?>((ref) {
  return ref.watch(clientViewModelProvider).error;
});

final clientsTotalProvider = Provider<int>((ref) {
  return ref.watch(clientViewModelProvider).total;
});