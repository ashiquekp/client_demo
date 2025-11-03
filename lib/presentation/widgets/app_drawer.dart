import 'package:client_demo/presentation/viewmodels/auth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/text_styles.dart';
import '../../core/constants/app_constants.dart';
import '../providers/auth_provider.dart';
import '../../routes/route_names.dart';

class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);

    return Drawer(
      child: Column(
        children: [
          // User Profile Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),
            decoration: const BoxDecoration(
              gradient: AppColors.primaryGradient,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundColor: AppColors.white,
                  child: Text(
                    user?.fullName.substring(0, 1).toUpperCase() ?? 'U',
                    style: AppTextStyles.headlineMedium.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  user?.fullName ?? 'User',
                  style: AppTextStyles.titleLarge.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  user?.email ?? '',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),

          // Menu Items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                _DrawerItem(
                  icon: Icons.dashboard_outlined,
                  title: 'Dashboard',
                  onTap: () {
                    Navigator.pop(context);
                    context.go(RouteNames.home);
                  },
                ),
                _DrawerItem(
                  icon: Icons.people_outline,
                  title: 'Clients',
                  onTap: () {
                    Navigator.pop(context);
                    context.go(RouteNames.clients);
                  },
                ),
                _DrawerItem(
                  icon: Icons.receipt_long_outlined,
                  title: 'Invoices',
                  onTap: () {
                    Navigator.pop(context);
                    context.go(RouteNames.invoices);
                  },
                ),
                const Divider(),
                _DrawerItem(
                  icon: Icons.settings_outlined,
                  title: 'Settings',
                  onTap: () {
                    Navigator.pop(context);
                    // TODO: Navigate to settings
                  },
                ),
                _DrawerItem(
                  icon: Icons.help_outline,
                  title: 'Help & Support',
                  onTap: () {
                    Navigator.pop(context);
                    // TODO: Navigate to help
                  },
                ),
              ],
            ),
          ),

          // App Info & Logout
          Column(
            children: [
              const Divider(),
              _DrawerItem(
                icon: Icons.logout,
                title: 'Logout',
                onTap: () async {
                  Navigator.pop(context);
                  await ref.read(authViewModelProvider.notifier).logout();
                  if (context.mounted) {
                    context.go(RouteNames.login);
                  }
                },
                isDestructive: true,
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  '${AppConstants.appName}\nVersion ${AppConstants.appVersion}',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textTertiary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool isDestructive;

  const _DrawerItem({
    required this.icon,
    required this.title,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: isDestructive ? AppColors.error : AppColors.textSecondary,
      ),
      title: Text(
        title,
        style: AppTextStyles.bodyMedium.copyWith(
          color: isDestructive ? AppColors.error : AppColors.textPrimary,
        ),
      ),
      onTap: onTap,
      hoverColor: isDestructive
          ? AppColors.error.withOpacity(0.1)
          : AppColors.surfaceLight,
    );
  }
}