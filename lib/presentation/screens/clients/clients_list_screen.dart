// ignore_for_file: use_build_context_synchronously

import 'package:client_demo/presentation/widgets/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
// import '../../../core/theme/text_styles.dart';
import '../../../core/utils/snackbar_utils.dart';
// import '../../providers/client_provider.dart';
import '../../viewmodels/client_viewmodel.dart';
import '../../widgets/common/loading_widget.dart';
import '../../widgets/common/error_widget.dart';
import '../../widgets/common/empty_state_widget.dart';
import 'widgets/client_card_widget.dart';
import 'widgets/client_search_widget.dart';
import '../../../routes/route_names.dart';

class ClientsListScreen extends ConsumerStatefulWidget {
  const ClientsListScreen({super.key});

  @override
  ConsumerState<ClientsListScreen> createState() => _ClientsListScreenState();
}

class _ClientsListScreenState extends ConsumerState<ClientsListScreen> {
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
      final viewModel = ref.read(clientViewModelProvider.notifier);
      viewModel.loadMore();
    }
  }

  Future<void> _handleRefresh() async {
    final viewModel = ref.read(clientViewModelProvider.notifier);
    await viewModel.loadClients(refresh: true);
  }

  void _handleDelete(int clientId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Client'),
        content: const Text('Are you sure you want to delete this client?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final viewModel = ref.read(clientViewModelProvider.notifier);
              final success = await viewModel.deleteClient(clientId);
              
              if (mounted) {
                if (success) {
                  SnackBarUtils.showSuccess(context, 'Client deleted successfully');
                } else {
                  SnackBarUtils.showError(context, 'Failed to delete client');
                }
              }
            },
            style: TextButton.styleFrom(
              foregroundColor: AppColors.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(clientViewModelProvider);
    final clients = state.clients;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Clients'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // TODO: Show filter options
            },
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: Column(
        children: [
          // Search Bar
          const ClientSearchWidget(),
          
          // Client List
          Expanded(
            child: _buildBody(state, clients),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await context.push(RouteNames.clientAdd);
          _handleRefresh();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody(state, clients) {
    if (state.isLoading && clients.isEmpty) {
      return const LoadingWidget(message: 'Loading clients...');
    }

    if (state.error != null && clients.isEmpty) {
      return CustomErrorWidget(
        message: state.error!,
        onRetry: _handleRefresh,
      );
    }

    if (clients.isEmpty) {
      return EmptyStateWidget(
        title: 'No Clients Found',
        message: state.searchQuery.isNotEmpty
            ? 'No clients match your search'
            : 'Add your first client to get started',
        icon: Icons.people_outline,
        actionText: 'Add Client',
        onAction: () => context.push(RouteNames.clientAdd),
      );
    }

    return RefreshIndicator(
      onRefresh: _handleRefresh,
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(16),
        itemCount: clients.length + (state.isLoadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == clients.length) {
            return const Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          final client = clients[index];
          return ClientCardWidget(
            client: client,
            onTap: () {
              // TODO: Navigate to client detail
            },
            onEdit: () async {
              await context.push('/clients/${client.id}/edit');
              _handleRefresh();
            },
            onDelete: () => _handleDelete(client.id),
          );
        },
      ),
    );
  }
}