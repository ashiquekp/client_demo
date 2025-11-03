import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
// import '../../../core/theme/app_colors.dart';
import '../../../core/utils/validators.dart';
import '../../../core/utils/snackbar_utils.dart';
import '../../../data/repositories/client_repository.dart';
import '../../../data/models/client_model.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_text_field.dart';
import '../../widgets/common/loading_widget.dart';

class ClientFormScreen extends ConsumerStatefulWidget {
  final int? clientId;

  const ClientFormScreen({
    super.key,
    this.clientId,
  });

  @override
  ConsumerState<ClientFormScreen> createState() => _ClientFormScreenState();
}

class _ClientFormScreenState extends ConsumerState<ClientFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  bool _isLoading = false;
  bool _isSaving = false;
  ClientModel? _client;

  @override
  void initState() {
    super.initState();
    if (widget.clientId != null) {
      _loadClient();
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _loadClient() async {
    setState(() => _isLoading = true);

    try {
      final repository = ref.read(clientRepositoryProvider);
      final response = await repository.getClientById(widget.clientId!);

      if (response.success && response.data != null) {
        setState(() {
          _client = response.data;
          _firstNameController.text = _client!.firstName;
          _lastNameController.text = _client!.lastName;
          _emailController.text = _client!.email;
          _phoneController.text = _client!.phone;
          _isLoading = false;
        });
      } else {
        if (mounted) {
          SnackBarUtils.showError(
            context,
            response.message ?? 'Failed to load client',
          );
          context.pop();
        }
      }
    } catch (e) {
      if (mounted) {
        SnackBarUtils.showError(context, 'Error loading client');
        context.pop();
      }
    }
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      final repository = ref.read(clientRepositoryProvider);
      final response = widget.clientId == null
          ? await repository.createClient(
              firstName: _firstNameController.text.trim(),
              lastName: _lastNameController.text.trim(),
              email: _emailController.text.trim(),
              phone: _phoneController.text.trim(),
            )
          : await repository.updateClient(
              id: widget.clientId!,
              firstName: _firstNameController.text.trim(),
              lastName: _lastNameController.text.trim(),
              email: _emailController.text.trim(),
              phone: _phoneController.text.trim(),
            );

      if (mounted) {
        if (response.success) {
          SnackBarUtils.showSuccess(
            context,
            response.message ?? 'Client saved successfully',
          );
          context.pop();
        } else {
          SnackBarUtils.showError(
            context,
            response.message ?? 'Failed to save client',
          );
        }
      }
    } catch (e) {
      if (mounted) {
        SnackBarUtils.showError(context, 'Error saving client');
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.clientId != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Client' : 'Add Client'),
        elevation: 0,
      ),
      body: _isLoading
          ? const LoadingWidget(message: 'Loading client details...')
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // First Name
                    CustomTextField(
                      controller: _firstNameController,
                      label: 'First Name',
                      hint: 'Enter first name',
                      prefixIcon: Icons.person_outline,
                      validator: (value) => Validators.name(
                        value,
                        fieldName: 'First name',
                      ),
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 16),

                    // Last Name
                    CustomTextField(
                      controller: _lastNameController,
                      label: 'Last Name',
                      hint: 'Enter last name',
                      prefixIcon: Icons.person_outline,
                      validator: (value) => Validators.name(
                        value,
                        fieldName: 'Last name',
                      ),
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 16),

                    // Email
                    CustomTextField(
                      controller: _emailController,
                      label: 'Email',
                      hint: 'Enter email address',
                      prefixIcon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      validator: Validators.email,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 16),

                    // Phone
                    CustomTextField(
                      controller: _phoneController,
                      label: 'Phone',
                      hint: 'Enter phone number',
                      prefixIcon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                      validator: Validators.phone,
                      textInputAction: TextInputAction.done,
                      maxLength: 10,
                    ),
                    const SizedBox(height: 24),

                    // Save Button
                    CustomButton(
                      text: isEdit ? 'Update Client' : 'Create Client',
                      onPressed: _isSaving ? null : _handleSave,
                      isLoading: _isSaving,
                      icon: isEdit ? Icons.save : Icons.add,
                    ),
                    const SizedBox(height: 12),

                    // Cancel Button
                    CustomButton(
                      text: 'Cancel',
                      onPressed: () => context.pop(),
                      type: ButtonType.outlined,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}