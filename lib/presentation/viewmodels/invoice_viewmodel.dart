import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/invoice_repository.dart';
import '../../data/models/invoice_model.dart';
import '../../core/constants/app_constants.dart';

class InvoiceState {
  final List<InvoiceModel> invoices;
  final bool isLoading;
  final bool isLoadingMore;
  final String? error;
  final int? filterClientId;
  final String? filterStatus;
  final int currentPage;
  final bool hasMore;
  final int total;

  InvoiceState({
    this.invoices = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.error,
    this.filterClientId,
    this.filterStatus,
    this.currentPage = 1,
    this.hasMore = true,
    this.total = 0,
  });

  InvoiceState copyWith({
    List<InvoiceModel>? invoices,
    bool? isLoading,
    bool? isLoadingMore,
    String? error,
    int? filterClientId,
    String? filterStatus,
    int? currentPage,
    bool? hasMore,
    int? total,
  }) {
    return InvoiceState(
      invoices: invoices ?? this.invoices,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      error: error,
      filterClientId: filterClientId ?? this.filterClientId,
      filterStatus: filterStatus ?? this.filterStatus,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
      total: total ?? this.total,
    );
  }
}

class InvoiceViewModel extends StateNotifier<InvoiceState> {
  final InvoiceRepository _repository;

  InvoiceViewModel(this._repository) : super(InvoiceState()) {
    loadInvoices();
  }

  Future<void> loadInvoices({bool refresh = false}) async {
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
      final response = await _repository.getInvoices(
        page: 1,
        pageSize: AppConstants.defaultPageSize,
        clientId: state.filterClientId,
        status: state.filterStatus,
      );

      if (response.success && response.data != null) {
        state = state.copyWith(
          invoices: response.data!.invoices,
          isLoading: false,
          currentPage: 1,
          hasMore: response.data!.hasMore,
          total: response.data!.total,
          error: null,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error: response.message ?? 'Failed to load invoices',
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
      final response = await _repository.getInvoices(
        page: state.currentPage + 1,
        pageSize: AppConstants.defaultPageSize,
        clientId: state.filterClientId,
        status: state.filterStatus,
      );

      if (response.success && response.data != null) {
        state = state.copyWith(
          invoices: [...state.invoices, ...response.data!.invoices],
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

  void setClientFilter(int? clientId) {
    state = state.copyWith(filterClientId: clientId);
    loadInvoices(refresh: true);
  }

  void setStatusFilter(String? status) {
    state = state.copyWith(filterStatus: status);
    loadInvoices(refresh: true);
  }

  void clearFilters() {
    state = state.copyWith(
      filterClientId: null,
      filterStatus: null,
    );
    loadInvoices(refresh: true);
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

final invoiceViewModelProvider =
    StateNotifierProvider<InvoiceViewModel, InvoiceState>((ref) {
  return InvoiceViewModel(ref.watch(invoiceRepositoryProvider));
});