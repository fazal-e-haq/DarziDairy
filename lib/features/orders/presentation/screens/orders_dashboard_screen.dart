import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/routing/app_router.dart';
import '../../../../core/theme/responsive_layout.dart';
import '../../../notifications/presentation/providers/notification_provider.dart';
import '../../../notifications/presentation/widgets/notifications_sheet.dart';
import '../widgets/order_card.dart';
import '../providers/order_list_provider.dart';

/// Modern, clean, and simple main orders screen with real-time customer name search,
/// responsive card grid for unfolded/foldable screens, and quick action FAB.
class OrdersDashboardScreen extends StatefulWidget {
  const OrdersDashboardScreen({super.key});

  @override
  State<OrdersDashboardScreen> createState() => _OrdersDashboardScreenState();
}

class _OrdersDashboardScreenState extends State<OrdersDashboardScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isUnfolded = context.isUnfolded;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          AppStrings.appName,
          style: TextStyle(
            fontFamily: 'Nunito',
            fontWeight: FontWeight.w800,
            letterSpacing: -0.2,
          ),
        ),
        actions: [
          Consumer<NotificationProvider>(
            builder: (context, notificationProvider, _) {
              final count = notificationProvider.unreadCount;
              return IconButton(
                icon: Badge(
                  isLabelVisible: count > 0,
                  label: Text('$count'),
                  backgroundColor: const Color(0xFFDC2626),
                  child: const Icon(Icons.notifications_outlined, size: 24),
                ),
                tooltip: 'Notifications & Reminders',
                onPressed: () => NotificationsSheet.show(context),
              );
            },
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Column(
            children: [
              // Modern Search Bar (searches by customer name)
              Padding(
                padding: EdgeInsets.fromLTRB(
                  isUnfolded ? 24 : 16,
                  16,
                  isUnfolded ? 24 : 16,
                  12,
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (val) {
                    context.read<OrderListProvider>().setSearchQuery(val);
                  },
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Search by customer name...',
                    hintStyle: const TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                    prefixIcon: const Icon(
                      Icons.search_rounded,
                      color: AppColors.primary,
                      size: 22,
                    ),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, size: 18),
                            onPressed: () {
                              _searchController.clear();
                              context.read<OrderListProvider>().setSearchQuery('');
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: AppColors.surface,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
                      borderSide: const BorderSide(color: AppColors.border),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
                      borderSide: const BorderSide(color: AppColors.border),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
                      borderSide: const BorderSide(color: AppColors.primary, width: 1.6),
                    ),
                  ),
                ),
              ),

              // Orders List / Responsive Grid
              Expanded(
                child: Consumer<OrderListProvider>(
                  builder: (context, provider, _) {
                    if (provider.isLoading) {
                      return const Center(
                        child: CircularProgressIndicator(color: AppColors.primary),
                      );
                    }

                    final orders = provider.activeOrders;

                    if (orders.isEmpty) {
                      final isSearching = _searchController.text.trim().isNotEmpty;
                      return Center(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(AppDimensions.space32),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                isSearching ? Icons.person_search_outlined : Icons.assignment_add,
                                size: 68,
                                color: AppColors.primary.withValues(alpha: 0.4),
                              ),
                              const SizedBox(height: AppDimensions.space16),
                              Text(
                                isSearching
                                    ? 'No customer found matching "${_searchController.text}"'
                                    : 'No orders added yet',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontFamily: 'Nunito',
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: AppDimensions.space8),
                              Text(
                                isSearching
                                    ? 'Try checking for spelling or search by a different name.'
                                    : 'Start recording customer measurements, stitching rates, and delivery dates.',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              const SizedBox(height: AppDimensions.space20),
                              if (isSearching)
                                OutlinedButton.icon(
                                  onPressed: () {
                                    _searchController.clear();
                                    provider.setSearchQuery('');
                                  },
                                  icon: const Icon(Icons.clear_rounded, size: 18),
                                  label: const Text('Clear Search'),
                                )
                              else
                                ElevatedButton.icon(
                                  onPressed: () => context.go(AppRouter.createOrder),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primary,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                                    ),
                                    elevation: 2,
                                  ),
                                  icon: const Icon(Icons.add_rounded, size: 20),
                                  label: const Text(
                                    'Create New Order',
                                    style: TextStyle(
                                      fontFamily: 'Nunito',
                                      fontSize: 15,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    }

                    return RefreshIndicator(
                      color: AppColors.primary,
                      onRefresh: () => provider.loadOrders(),
                      child: isUnfolded
                          ? _buildUnfoldedGrid(orders, provider)
                          : _buildMobileList(orders, provider),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Compact mobile single-column list
  Widget _buildMobileList(List orders, OrderListProvider provider) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return OrderCard(
          order: order,
          onTap: () => context.push(AppRouter.orderDetailPath(order.id)),
        );
      },
    );
  }

  /// Unfolded / Tablet dual-column responsive grid
  Widget _buildUnfoldedGrid(List orders, OrderListProvider provider) {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(24, 4, 24, 24),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 12,
        mainAxisExtent: 210,
      ),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return OrderCard(
          order: order,
          margin: EdgeInsets.zero,
          onTap: () => context.push(AppRouter.orderDetailPath(order.id)),
        );
      },
    );
  }
}
