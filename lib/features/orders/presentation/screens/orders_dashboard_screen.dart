import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/routing/app_router.dart';
import '../../../../shared/widgets/order_card.dart';
import '../providers/order_list_provider.dart';

/// Single-screen workshop dashboard with quick search, active/completed filters,
/// and fast status toggling.
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
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.content_cut, size: 22, color: AppColors.secondary),
            SizedBox(width: AppDimensions.space8),
            Text(AppStrings.appName),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.people_alt_outlined),
            tooltip: 'Customer Khata',
            onPressed: () => context.push(AppRouter.customerList),
          ),
        ],
      ),
      body: Column(
        children: [
          // Quick Search Bar
          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            color: AppColors.surface,
            child: TextField(
              controller: _searchController,
              onChanged: (val) {
                context.read<OrderListProvider>().setSearchQuery(val);
              },
              decoration: InputDecoration(
                hintText: 'Search customer, phone, or token...',
                hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 14),
                prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary, size: 20),
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
                fillColor: AppColors.surfaceVariant,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                  borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
                ),
              ),
            ),
          ),

          // Filter Pills Bar (Active, Completed, All)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: AppColors.surface,
            child: Consumer<OrderListProvider>(
              builder: (context, provider, _) {
                return Row(
                  children: [
                    _FilterChip(
                      label: 'Active (${provider.countActive})',
                      isSelected: provider.activeFilter == OrderFilter.active,
                      selectedColor: AppColors.primary,
                      onTap: () => provider.setFilter(OrderFilter.active),
                    ),
                    const SizedBox(width: 8),
                    _FilterChip(
                      label: 'Completed (${provider.countCompleted})',
                      isSelected: provider.activeFilter == OrderFilter.completed,
                      selectedColor: AppColors.statusReady,
                      onTap: () => provider.setFilter(OrderFilter.completed),
                    ),
                    const SizedBox(width: 8),
                    _FilterChip(
                      label: 'All (${provider.countAll})',
                      isSelected: provider.activeFilter == OrderFilter.all,
                      selectedColor: AppColors.secondary,
                      onTap: () => provider.setFilter(OrderFilter.all),
                    ),
                  ],
                );
              },
            ),
          ),

          const Divider(height: 1, thickness: 1, color: AppColors.border),

          // Orders List
          Expanded(
            child: Consumer<OrderListProvider>(
              builder: (context, provider, _) {
                if (provider.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  );
                }

                final orders = provider.filteredOrders;
                if (orders.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(AppDimensions.space32),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.inventory_2_outlined,
                            size: 56,
                            color: AppColors.textMuted.withValues(alpha: 0.5),
                          ),
                          const SizedBox(height: AppDimensions.space16),
                          Text(
                            _searchController.text.isNotEmpty
                                ? 'No orders match "${_searchController.text}"'
                                : provider.activeFilter == OrderFilter.completed
                                    ? 'No completed orders yet'
                                    : 'No active orders in workshop',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: AppDimensions.space8),
                          const Text(
                            'Tap "+ New Order" below to create one.',
                            style: TextStyle(fontSize: 13, color: AppColors.textMuted),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return RefreshIndicator(
                  color: AppColors.primary,
                  onRefresh: () => provider.loadOrders(),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(AppDimensions.space16),
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      final order = orders[index];
                      return OrderCard(
                        order: order,
                        onTap: () => context.push(AppRouter.orderDetailPath(order.id)),
                        onToggleStatus: () => provider.toggleOrderStatus(order.id),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.secondary,
        foregroundColor: AppColors.surface,
        elevation: 3,
        onPressed: () => context.push(AppRouter.createOrder),
        icon: const Icon(Icons.add, size: 22),
        label: const Text(
          'New Order',
          style: TextStyle(fontWeight: FontWeight.w700, letterSpacing: 0.3),
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Color selectedColor;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.selectedColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected ? selectedColor : AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
          border: Border.all(
            color: isSelected ? selectedColor : AppColors.border,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected ? Colors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
