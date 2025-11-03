import 'package:client_demo/presentation/viewmodels/invoice_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/constants/app_constants.dart';
// import '../../../providers/invoice_provider.dart';
import '../../../widgets/common/custom_button.dart';

class InvoiceFilterWidget extends ConsumerStatefulWidget {
  const InvoiceFilterWidget({super.key});

  @override
  ConsumerState<InvoiceFilterWidget> createState() => _InvoiceFilterWidgetState();
}

class _InvoiceFilterWidgetState extends ConsumerState<InvoiceFilterWidget> {
  String? _selectedStatus;

  @override
  void initState() {
    super.initState();
    _selectedStatus = ref.read(invoiceViewModelProvider).filterStatus;
  }

  void _applyFilters() {
    final viewModel = ref.read(invoiceViewModelProvider.notifier);
    viewModel.setStatusFilter(_selectedStatus);
    Navigator.pop(context);
  }

  void _clearFilters() {
    setState(() {
      _selectedStatus = null;
    });
    final viewModel = ref.read(invoiceViewModelProvider.notifier);
    viewModel.clearFilters();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Filter Invoices',
                    style: AppTextStyles.headlineMedium,
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Status Filter
              Text(
                'Status',
                style: AppTextStyles.titleMedium,
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _StatusChip(
                    label: 'All',
                    isSelected: _selectedStatus == null,
                    onTap: () {
                      setState(() {
                        _selectedStatus = null;
                      });
                    },
                  ),
                  ...AppConstants.invoiceStatuses.map(
                    (status) => _StatusChip(
                      label: status,
                      isSelected: _selectedStatus == status,
                      onTap: () {
                        setState(() {
                          _selectedStatus = status;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      text: 'Clear',
                      onPressed: _clearFilters,
                      type: ButtonType.outlined,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CustomButton(
                      text: 'Apply',
                      onPressed: _applyFilters,
                      type: ButtonType.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _StatusChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary
              : AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : AppColors.border,
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.labelMedium.copyWith(
            color: isSelected
                ? AppColors.white
                : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}