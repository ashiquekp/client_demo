import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../presentation/screens/splash/splash_screen.dart';
import '../presentation/screens/auth/login_screen.dart';
import '../presentation/screens/home/home_screen.dart';
import '../presentation/screens/clients/clients_list_screen.dart';
import '../presentation/screens/clients/client_form_screen.dart';
import '../presentation/screens/invoices/invoices_list_screen.dart';
import '../presentation/providers/auth_provider.dart';
import 'route_names.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  final isAuthenticated = ref.watch(isAuthenticatedProvider);

  return GoRouter(
    initialLocation: RouteNames.splash,
    debugLogDiagnostics: true,
    redirect: (BuildContext context, GoRouterState state) {
      final isLoggingIn = state.matchedLocation == RouteNames.login;
      final isSplash = state.matchedLocation == RouteNames.splash;

      // Allow splash screen always
      if (isSplash) {
        return null;
      }

      // If not authenticated and not going to login, redirect to login
      if (!isAuthenticated && !isLoggingIn) {
        return RouteNames.login;
      }

      // If authenticated and going to login, redirect to home
      if (isAuthenticated && isLoggingIn) {
        return RouteNames.home;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: RouteNames.splash,
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: RouteNames.login,
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: RouteNames.home,
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: RouteNames.clients,
        name: 'clients',
        builder: (context, state) => const ClientsListScreen(),
        routes: [
          GoRoute(
            path: 'add',
            name: 'clientAdd',
            builder: (context, state) => const ClientFormScreen(),
          ),
          GoRoute(
            path: ':id/edit',
            name: 'clientEdit',
            builder: (context, state) {
              final id = int.parse(state.pathParameters['id']!);
              return ClientFormScreen(clientId: id);
            },
          ),
        ],
      ),
      GoRoute(
        path: RouteNames.invoices,
        name: 'invoices',
        builder: (context, state) => const InvoicesListScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Page not found: ${state.matchedLocation}'),
      ),
    ),
  );
});