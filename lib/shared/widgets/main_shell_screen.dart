import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/theme/responsive_layout.dart';
import '../../features/orders/presentation/screens/orders_dashboard_screen.dart';
import '../../features/orders/presentation/screens/order_history_screen.dart';
import '../../features/expenses/presentation/screens/profile_expense_screen.dart';

/// Navigation item model for bottom bar
class _NavItem {
  final IconData unselectedIcon;
  final IconData selectedIcon;
  final String label;

  const _NavItem({
    required this.unselectedIcon,
    required this.selectedIcon,
    required this.label,
  });
}

const _navItems = [
  _NavItem(
    unselectedIcon: Icons.content_cut_outlined,
    selectedIcon: Icons.content_cut_rounded,
    label: 'Orders',
  ),
  _NavItem(
    unselectedIcon: Icons.history_outlined,
    selectedIcon: Icons.history_rounded,
    label: 'History',
  ),
  _NavItem(
    unselectedIcon: Icons.account_balance_wallet_outlined,
    selectedIcon: Icons.account_balance_wallet_rounded,
    label: 'Expenses',
  ),
];

/// Main application shell hosting 3 primary tabs:
/// 1. Orders (Dashboard of active orders with New Order FAB)
/// 2. History (Completed orders archive)
/// 3. Expenses & Profile (Workshop ledger)
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
    _currentIndex = widget.initialIndex.clamp(0, 2);
  }

  @override
  void didUpdateWidget(covariant MainShellScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialIndex != widget.initialIndex) {
      setState(() {
        _currentIndex = widget.initialIndex.clamp(0, 2);
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

    const tabs = [
      OrdersDashboardScreen(),
      OrderHistoryScreen(),
      ProfileExpenseScreen(),
    ];

    if (isUnfolded) {
      // Responsive layout with NavigationRail for tablets & foldables (≥ 600dp)
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
                indicatorShape: const StadiumBorder(),
                selectedIconTheme: const IconThemeData(color: AppColors.primary, size: 26),
                unselectedIconTheme: const IconThemeData(color: Color(0xFF64748B), size: 24),
                selectedLabelTextStyle: const TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 12.5,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                ),
                unselectedLabelTextStyle: const TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF64748B),
                ),
                destinations: const [
                  NavigationRailDestination(
                    icon: Icon(Icons.content_cut_outlined),
                    selectedIcon: Icon(Icons.content_cut_rounded),
                    label: Text('Orders'),
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

    // Modern inspired Bottom Navigation Bar with pill capsule for active tab
    return Scaffold(
      backgroundColor: AppColors.background,
      body: IndexedStack(
        index: _currentIndex,
        children: tabs,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.28),
              blurRadius: 18,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 64,
            child: Row(
              children: List.generate(_navItems.length, (index) {
                final isSelected = _currentIndex == index;
                final item = _navItems[index];

                return Expanded(
                  child: Center(
                    child: InkWell(
                      onTap: () => _onTabChanged(index),
                      borderRadius: BorderRadius.circular(24),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 220),
                        curve: Curves.easeInOut,
                        padding: isSelected
                            ? const EdgeInsets.symmetric(horizontal: 14, vertical: 8)
                            : const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.white.withValues(alpha: 0.18)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              isSelected ? item.selectedIcon : item.unselectedIcon,
                              color: isSelected
                                  ? Colors.white
                                  : Colors.white.withValues(alpha: 0.70),
                              size: 22,
                            ),
                            if (isSelected) ...[
                              const SizedBox(width: 6),
                              Flexible(
                                child: Text(
                                  item.label,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontFamily: 'Nunito',
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 13,
                                    letterSpacing: 0.1,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
