import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../constants/app_colors.dart';
import '../../features/orders/presentation/screens/order_detail_screen.dart';
import '../../features/orders/presentation/screens/create_order_screen.dart';
import '../../shared/widgets/main_shell_screen.dart';

/// Centralized declarative routing architecture using GoRouter.
class AppRouter {
  AppRouter._();

  // Route Paths
  static const String dashboard = '/';
  static const String orderDetail = '/orders/:id';
  static const String createOrder = '/orders/create';
  static const String editOrder = '/orders/edit/:id';
  static const String history = '/history';
  static const String expenses = '/expenses';
  static const String settings = '/settings';

  // Helper generators for parameterized paths
  static String orderDetailPath(int id) => '/orders/$id';
  static String editOrderPath(int id) => '/orders/edit/$id';

  /// Navigation key for root navigator
  static final GlobalKey<NavigatorState> rootNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'rootNav');

  /// GoRouter configuration instance
  static final GoRouter router = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: dashboard,
    debugLogDiagnostics: false,
    routes: [
      // 1. Dashboard Tab (Orders Main Screen)
      GoRoute(
        path: dashboard,
        name: 'dashboard',
        pageBuilder: (context, state) => _buildTransitionPage(
          state: state,
          child: const MainShellScreen(initialIndex: 0),
        ),
      ),

      // 2. New Order Tab
      GoRoute(
        path: createOrder,
        name: 'createOrder',
        pageBuilder: (context, state) => _buildTransitionPage(
          state: state,
          child: const MainShellScreen(initialIndex: 1),
        ),
      ),

      // 3. History Tab
      GoRoute(
        path: history,
        name: 'history',
        pageBuilder: (context, state) => _buildTransitionPage(
          state: state,
          child: const MainShellScreen(initialIndex: 2),
        ),
      ),

      // 4. Expenses & Profile Tab
      GoRoute(
        path: expenses,
        name: 'expenses',
        pageBuilder: (context, state) => _buildTransitionPage(
          state: state,
          child: const MainShellScreen(initialIndex: 3),
        ),
      ),
      GoRoute(
        path: settings,
        name: 'settings',
        pageBuilder: (context, state) => _buildTransitionPage(
          state: state,
          child: const MainShellScreen(initialIndex: 3),
        ),
      ),

      // Edit Order (Pushed on top with back arrow)
      GoRoute(
        path: editOrder,
        name: 'editOrder',
        pageBuilder: (context, state) {
          final id = int.tryParse(state.pathParameters['id'] ?? '');
          return _buildTransitionPage(
            state: state,
            child: CreateOrderScreen(orderId: id),
          );
        },
      ),

      // Order Detail (Pushed on top with back arrow)
      GoRoute(
        path: orderDetail,
        name: 'orderDetail',
        pageBuilder: (context, state) {
          final id = int.tryParse(state.pathParameters['id'] ?? '');
          return _buildTransitionPage(
            state: state,
            child: OrderDetailScreen(orderId: id),
          );
        },
      ),
    ],

    // Fallback Error Boundary
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('Page Not Found')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 64,
                color: AppColors.statusError,
              ),
              const SizedBox(height: 16),
              Text(
                'Route Error: ${state.error?.message ?? "The requested page was not found"}',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                icon: const Icon(Icons.home),
                label: const Text('مین اسکرین پر واپس جائیں (Go Home)'),
                onPressed: () => context.go(dashboard),
              ),
            ],
          ),
        ),
      ),
    ),
  );

  /// Consistent subtle fade and slide transition page builder
  static Page<dynamic> _buildTransitionPage({
    required GoRouterState state,
    required Widget child,
  }) {
    return CustomTransitionPage<void>(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
          reverseCurve: Curves.easeInCubic,
        );

        return FadeTransition(
          opacity: CurvedAnimation(
            parent: animation,
            curve: const Interval(0.0, 0.75, curve: Curves.easeOut),
          ),
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.04, 0.0),
              end: Offset.zero,
            ).animate(curvedAnimation),
            child: child,
          ),
        );
      },
    );
  }
}
