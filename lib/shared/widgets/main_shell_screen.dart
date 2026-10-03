import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/theme/responsive_layout.dart';
import '../../features/orders/presentation/screens/orders_dashboard_screen.dart';
import '../../features/orders/presentation/screens/create_order_screen.dart';
import '../../features/orders/presentation/screens/order_history_screen.dart';
import '../../features/expenses/presentation/screens/profile_expense_screen.dart';

/// Main responsive application shell hosting the 4 primary tabs:
/// 1. Orders (Dashboard of active orders)
/// 2. New Order (Direct order creation form)
/// 3. History (Completed orders archive)
/// 4. Profile + Expense Tracker (Workshop ledger)
class MainShellScreen extends StatefulWidget {
  final int initialIndex;

  const MainShellScreen({
    super.key,
    this.initialIndex = 0,
  });

  @override
  State<MainShellScreen> createState() => _MainShellScreenState();
}

class _MainShellScreenState extends State<MainShellScreen> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex.clamp(0, 3);
  }

  @override
  void didUpdateWidget(covariant MainShellScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialIndex != widget.initialIndex) {
      setState(() {
        _currentIndex = widget.initialIndex.clamp(0, 3);
      });
    }
  }

  void _onTabChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isUnfolded = context.isUnfolded;

    final tabs = [
      const OrdersDashboardScreen(),
      CreateOrderScreen(
        isTab: true,
        onOrderSaved: () => _onTabChanged(0),
      ),
      const OrderHistoryScreen(),
      const ProfileExpenseScreen(),
    ];

    if (isUnfolded) {
      // Responsive layout with NavigationRail for tablets & foldables (≥ 600dp)
      // Wrapped in SafeArea so left navigation tiles and hinge are protected
      return Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          left: true,
          top: true,
          right: true,
          bottom: true,
          child: Row(
            children: [
              NavigationRail(
                selectedIndex: _currentIndex,
                onDestinationSelected: _onTabChanged,
                labelType: NavigationRailLabelType.all,
                backgroundColor: AppColors.surface,
                indicatorColor: AppColors.primary.withValues(alpha: 0.12),
                indicatorShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                selectedIconTheme: const IconThemeData(color: AppColors.primary, size: 26),
                unselectedIconTheme: const IconThemeData(color: Color(0xFF64748B), size: 24),
                selectedLabelTextStyle: const TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 12.5,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                ),
                unselectedLabelTextStyle: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 11.5,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF64748B),
                ),
                destinations: const [
                  NavigationRailDestination(
                    icon: Icon(Icons.content_cut_outlined),
                    selectedIcon: Icon(Icons.content_cut_rounded),
                    label: Text('Orders'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.add_box_outlined),
                    selectedIcon: Icon(Icons.add_box_rounded),
                    label: Text('New Order'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.history_outlined),
                    selectedIcon: Icon(Icons.history_rounded),
                    label: Text('History'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.account_balance_wallet_outlined),
                    selectedIcon: Icon(Icons.account_balance_wallet_rounded),
                    label: Text('Expenses'),
                  ),
                ],
              ),
              const VerticalDivider(width: 1, thickness: 1, color: Color(0xFFE2E8F0)),
              Expanded(
                child: IndexedStack(
                  index: _currentIndex,
                  children: tabs,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Standard mobile layout with polished Material 3 NavigationBar (< 600dp)
    return Scaffold(
      backgroundColor: AppColors.background,
      body: IndexedStack(
        index: _currentIndex,
        children: tabs,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 12,
              offset: const Offset(0, -3),
            ),
          ],
          border: const Border(
            top: BorderSide(color: Color(0xFFE2E8F0), width: 1.0),
          ),
        ),
        child: SafeArea(
          top: false,
          child: NavigationBarTheme(
            data: NavigationBarThemeData(
              indicatorColor: AppColors.primary.withValues(alpha: 0.12),
              indicatorShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              labelTextStyle: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return const TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                  );
                }
                return const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF64748B),
                );
              }),
            ),
            child: NavigationBar(
              selectedIndex: _currentIndex,
              onDestinationSelected: _onTabChanged,
              backgroundColor: AppColors.surface,
              elevation: 0,
              height: 72,
              labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.content_cut_outlined, size: 22, color: Color(0xFF64748B)),
                  selectedIcon: Icon(Icons.content_cut_rounded, color: AppColors.primary, size: 24),
                  label: 'Orders',
                ),
                NavigationDestination(
                  icon: Icon(Icons.add_box_outlined, size: 22, color: Color(0xFF64748B)),
                  selectedIcon: Icon(Icons.add_box_rounded, color: AppColors.primary, size: 24),
                  label: 'New Order',
                ),
                NavigationDestination(
                  icon: Icon(Icons.history_outlined, size: 22, color: Color(0xFF64748B)),
                  selectedIcon: Icon(Icons.history_rounded, color: AppColors.primary, size: 24),
                  label: 'History',
                ),
                NavigationDestination(
                  icon: Icon(Icons.account_balance_wallet_outlined, size: 22, color: Color(0xFF64748B)),
                  selectedIcon: Icon(Icons.account_balance_wallet_rounded, color: AppColors.primary, size: 24),
                  label: 'Expenses',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
