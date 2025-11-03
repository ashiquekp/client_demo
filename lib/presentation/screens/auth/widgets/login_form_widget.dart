import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/utils/validators.dart';
import '../../../widgets/common/custom_button.dart';
import '../../../widgets/common/custom_text_field.dart';

class LoginFormWidget extends StatefulWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final VoidCallback onSubmit;
  final bool isLoading;
  final ValueChanged<bool>? onRememberMeChanged;

  const LoginFormWidget({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.onSubmit,
    this.isLoading = false,
    this.onRememberMeChanged,
  });

  @override
  State<LoginFormWidget> createState() => _LoginFormWidgetState();
}

class _LoginFormWidgetState extends State<LoginFormWidget> {
  final _formKey = GlobalKey<FormState>();
  bool _rememberMe = false;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Email Field
          CustomTextField(
            controller: widget.emailController,
            label: 'Email',
            hint: 'Enter your email',
            prefixIcon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            validator: Validators.email,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 16),

          // Password Field
          CustomTextField(
            controller: widget.passwordController,
            label: 'Password',
            hint: 'Enter your password',
            prefixIcon: Icons.lock_outlined,
            obscureText: true,
            validator: Validators.password,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) {
              if (_formKey.currentState!.validate()) {
                widget.onSubmit();
              }
            },
          ),
          const SizedBox(height: 12),

          // Remember Me Checkbox
          Row(
            children: [
              Checkbox(
                value: _rememberMe,
                onChanged: (value) {
                  setState(() {
                    _rememberMe = value ?? false;
                  });
                  widget.onRememberMeChanged?.call(_rememberMe);
                },
                activeColor: AppColors.primary,
              ),
              Text(
                'Remember me',
                style: AppTextStyles.bodyMedium,
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  // TODO: Implement forgot password
                },
                child: Text(
                  'Forgot Password?',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Login Button
          CustomButton(
            text: 'Login',
            onPressed: widget.isLoading
                ? null
                : () {
                    if (_formKey.currentState!.validate()) {
                      widget.onSubmit();
                    }
                  },
            isLoading: widget.isLoading,
          ),
        ],
      ),
    );
  }
}