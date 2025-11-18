import 'package:client_demo/presentation/viewmodels/invoice_viewmodel.dart';
import 'package:client_demo/presentation/widgets/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
// import '../../../core/constants/app_constants.dart';
// import '../../providers/invoice_provider.dart';
import '../../widgets/common/loading_widget.dart';
import '../../widgets/common/error_widget.dart';
import '../../widgets/common/empty_state_widget.dart';
import 'widgets/invoice_card_widget.dart';
import 'widgets/invoice_filter_widget.dart';

class InvoicesListScreen extends ConsumerStatefulWidget {
  const InvoicesListScreen({super.key});

  @override
  ConsumerState<InvoicesListScreen> createState() => _InvoicesListScreenState();
}

class _InvoicesListScreenState extends ConsumerState<InvoicesListScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      final viewModel = ref.read(invoiceViewModelProvider.notifier);
      viewModel.loadMore();
    }
  }

  Future<void> _handleRefresh() async {
    final viewModel = ref.read(invoiceViewModelProvider.notifier);
    await viewModel.loadInvoices(refresh: true);
  }

  void _showFilterDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => const InvoiceFilterWidget(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(invoiceViewModelProvider);
    final invoices = state.invoices;
    final hasFilters = state.filterClientId != null || state.filterStatus != null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Invoices'),
        elevation: 0,
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.filter_list),
                onPressed: _showFilterDialog,
              ),
              if (hasFilters)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppColors.error,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: _buildBody(state, invoices),
    );
  }

  Widget _buildBody(state, invoices) {
    if (state.isLoading && invoices.isEmpty) {
      return const LoadingWidget(message: 'Loading invoices...');
    }

    if (state.error != null && invoices.isEmpty) {
      return CustomErrorWidget(
        message: state.error!,
        onRetry: _handleRefresh,
      );
    }

    if (invoices.isEmpty) {
      return EmptyStateWidget(
        title: 'No Invoices Found',
        message: state.filterStatus != null || state.filterClientId != null
            ? 'No invoices match your filters'
            : 'No invoices available',
        icon: Icons.receipt_long_outlined,
      );
    }

    return RefreshIndicator(
      onRefresh: _handleRefresh,
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(16),
        itemCount: invoices.length + (state.isLoadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == invoices.length) {
            return const Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          final invoice = invoices[index];
          return InvoiceCardWidget(
            invoice: invoice,
            onTap: () {
              // Todo: Navigate to invoice detail.
            },
          );
        },
      ),
    );
  }
}