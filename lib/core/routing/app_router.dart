import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../constants/app_colors.dart';
import '../../features/orders/presentation/screens/orders_dashboard_screen.dart';
import '../../features/orders/presentation/screens/order_detail_screen.dart';
import '../../features/orders/presentation/screens/create_order_screen.dart';
import '../../features/customers/presentation/screens/customer_list_screen.dart';
import '../../features/customers/presentation/screens/customer_detail_screen.dart';
import '../../features/customers/presentation/screens/add_edit_customer_screen.dart';
import '../../features/diary/presentation/screens/diary_screen.dart';
import '../../features/backup/presentation/screens/backup_settings_screen.dart';

/// Centralized declarative routing architecture using GoRouter.
///
/// Features custom subtle fade/slide transitions, type-safe route parameters,
/// deep linking, and an error boundary fallback screen.
class AppRouter {
  AppRouter._();

  // Route Paths
  static const String dashboard = '/';
  static const String orderDetail = '/orders/:id';
  static const String createOrder = '/orders/create';
  static const String editOrder = '/orders/edit/:id';

  static const String customerList = '/customers';
  static const String customerDetail = '/customers/:id';
  static const String addCustomer = '/customers/add';
  static const String editCustomer = '/customers/edit/:id';

  static const String diary = '/diary';
  static const String backup = '/backup';

  // Helper generators for parameterized paths
  static String orderDetailPath(int id) => '/orders/$id';
  static String editOrderPath(int id) => '/orders/edit/$id';
  static String customerDetailPath(int id) => '/customers/$id';
  static String editCustomerPath(int id) => '/customers/edit/$id';

  /// Navigation key for root navigator
  static final GlobalKey<NavigatorState> rootNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'rootNav');

  /// GoRouter configuration instance
  static final GoRouter router = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: dashboard,
    debugLogDiagnostics: false,
    routes: [
      // 1. Dashboard (Orders Workshop Pipeline)
      GoRoute(
        path: dashboard,
        name: 'dashboard',
        pageBuilder: (context, state) => _buildTransitionPage(
          state: state,
          child: const OrdersDashboardScreen(),
        ),
      ),

      // 2. Orders Module Routes
      GoRoute(
        path: createOrder,
        name: 'createOrder',
        pageBuilder: (context, state) => _buildTransitionPage(
          state: state,
          child: const CreateOrderScreen(),
        ),
      ),
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

      // 3. Customers Module Routes
      GoRoute(
        path: customerList,
        name: 'customerList',
        pageBuilder: (context, state) => _buildTransitionPage(
          state: state,
          child: const CustomerListScreen(),
        ),
      ),
      GoRoute(
        path: addCustomer,
        name: 'addCustomer',
        pageBuilder: (context, state) => _buildTransitionPage(
          state: state,
          child: const AddEditCustomerScreen(),
        ),
      ),
      GoRoute(
        path: editCustomer,
        name: 'editCustomer',
        pageBuilder: (context, state) {
          final id = int.tryParse(state.pathParameters['id'] ?? '');
          return _buildTransitionPage(
            state: state,
            child: AddEditCustomerScreen(customerId: id),
          );
        },
      ),
      GoRoute(
        path: customerDetail,
        name: 'customerDetail',
        pageBuilder: (context, state) {
          final id = int.tryParse(state.pathParameters['id'] ?? '');
          return _buildTransitionPage(
            state: state,
            child: CustomerDetailScreen(customerId: id),
          );
        },
      ),

      // 4. Roznamcha Daily Diary / Cash Book
      GoRoute(
        path: diary,
        name: 'diary',
        pageBuilder: (context, state) => _buildTransitionPage(
          state: state,
          child: const DiaryScreen(),
        ),
      ),

      // 5. Offline Data Protection & Backup Settings
      GoRoute(
        path: backup,
        name: 'backup',
        pageBuilder: (context, state) => _buildTransitionPage(
          state: state,
          child: const BackupSettingsScreen(),
        ),
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
                label: const Text('Return to Workshop'),
                onPressed: () => context.go(dashboard),
              ),
            ],
          ),
        ),
      ),
    ),
  );

  /// Consistent, subtle fade and slide transition page builder
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
