import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/client_repository.dart';
import '../../data/models/client_model.dart';
import '../../core/constants/app_constants.dart';

class ClientState {
  final List<ClientModel> clients;
  final bool isLoading;
  final bool isLoadingMore;
  final String? error;
  final String searchQuery;
  final String? sortBy;
  final int currentPage;
  final bool hasMore;
  final int total;

  ClientState({
    this.clients = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.error,
    this.searchQuery = '',
    this.sortBy,
    this.currentPage = 1,
    this.hasMore = true,
    this.total = 0,
  });

  ClientState copyWith({
    List<ClientModel>? clients,
    bool? isLoading,
    bool? isLoadingMore,
    String? error,
    String? searchQuery,
    String? sortBy,
    int? currentPage,
    bool? hasMore,
    int? total,
  }) {
    return ClientState(
      clients: clients ?? this.clients,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      error: error,
      searchQuery: searchQuery ?? this.searchQuery,
      sortBy: sortBy ?? this.sortBy,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
      total: total ?? this.total,
    );
  }
}

class ClientViewModel extends StateNotifier<ClientState> {
  final ClientRepository _repository;
  Timer? _debounce;

  ClientViewModel(this._repository) : super(ClientState()) {
    loadClients();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  Future<void> loadClients({bool refresh = false}) async {
    if (refresh) {
      state = state.copyWith(
        isLoading: true,
        error: null,
        currentPage: 1,
      );
    } else {
      state = state.copyWith(isLoading: true, error: null);
    }

    try {
      final response = await _repository.getClients(
        page: 1,
        pageSize: AppConstants.defaultPageSize,
        search: state.searchQuery.isEmpty ? null : state.searchQuery,
        sortBy: state.sortBy,
      );

      if (response.success && response.data != null) {
        state = state.copyWith(
          clients: response.data!.clients,
          isLoading: false,
          currentPage: 1,
          hasMore: response.data!.hasMore,
          total: response.data!.total,
          error: null,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error: response.message ?? 'Failed to load clients',
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> loadMore() async {
    if (state.isLoadingMore || !state.hasMore) return;

    state = state.copyWith(isLoadingMore: true);

    try {
      final response = await _repository.getClients(
        page: state.currentPage + 1,
        pageSize: AppConstants.defaultPageSize,
        search: state.searchQuery.isEmpty ? null : state.searchQuery,
        sortBy: state.sortBy,
      );

      if (response.success && response.data != null) {
        state = state.copyWith(
          clients: [...state.clients, ...response.data!.clients],
          isLoadingMore: false,
          currentPage: state.currentPage + 1,
          hasMore: response.data!.hasMore,
          total: response.data!.total,
        );
      } else {
        state = state.copyWith(isLoadingMore: false);
      }
    } catch (e) {
      state = state.copyWith(isLoadingMore: false);
    }
  }

  void search(String query) {
    _debounce?.cancel();
    _debounce = Timer(AppConstants.searchDebounce, () {
      state = state.copyWith(searchQuery: query);
      loadClients(refresh: true);
    });
  }

  void setSortBy(String sortBy) {
    state = state.copyWith(sortBy: sortBy);
    loadClients(refresh: true);
  }

  void clearSearch() {
    state = state.copyWith(searchQuery: '');
    loadClients(refresh: true);
  }

  Future<bool> deleteClient(int id) async {
    try {
      final response = await _repository.deleteClient(id);
      
      if (response.success) {
        // Remove client from list
        state = state.copyWith(
          clients: state.clients.where((c) => c.id != id).toList(),
          total: state.total - 1,
        );
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error deleting client: $e');
      return false;
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

final clientViewModelProvider =
    StateNotifierProvider<ClientViewModel, ClientState>((ref) {
  return ClientViewModel(ref.watch(clientRepositoryProvider));
});