import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/routing/app_router.dart';
import '../../../../core/theme/responsive_layout.dart';
import '../../../../shared/widgets/order_card.dart';
import '../../domain/entities/order_entity.dart';
import '../providers/order_list_provider.dart';

/// Screen displaying completed orders history with customer search,
/// responsive grid/list layout, and green-tinted completed cards.
class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

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
        title: const Text(
          'Order History',
          style: TextStyle(
            fontFamily: 'Nunito',
            fontWeight: FontWeight.w800,
            letterSpacing: -0.2,
          ),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Column(
            children: [
              // Search Bar for Completed Orders
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
                    setState(() {
                      _searchQuery = val.trim();
                    });
                  },
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Search completed orders by customer...',
                    hintStyle: const TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                    prefixIcon: const Icon(
                      Icons.search_rounded,
                      color: Color(0xFF16A34A),
                      size: 22,
                    ),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, size: 18),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {
                                _searchQuery = '';
                              });
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
                      borderSide: const BorderSide(color: Color(0xFF16A34A), width: 1.6),
                    ),
                  ),
                ),
              ),

              // Completed Orders List / Responsive Grid
              Expanded(
                child: Consumer<OrderListProvider>(
                  builder: (context, provider, _) {
                    if (provider.isLoading) {
                      return const Center(
                        child: CircularProgressIndicator(color: AppColors.primary),
                      );
                    }

                    final completedOrders = provider.getCompletedOrders(_searchQuery);

                    if (completedOrders.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(AppDimensions.space32),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.assignment_turned_in_outlined,
                                size: 64,
                                color: AppColors.textMuted.withValues(alpha: 0.4),
                              ),
                              const SizedBox(height: AppDimensions.space16),
                              Text(
                                _searchQuery.isNotEmpty
                                    ? 'No completed orders matching "$_searchQuery"'
                                    : 'No completed orders yet',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontFamily: 'Nunito',
                                  fontSize: 17,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              const SizedBox(height: AppDimensions.space8),
                              Text(
                                _searchQuery.isNotEmpty
                                    ? 'Try searching with a different customer name.'
                                    : 'When you mark orders as completed, they will appear here.',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: AppColors.textMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    return RefreshIndicator(
                      color: const Color(0xFF16A34A),
                      onRefresh: () => provider.loadOrders(),
                      child: isUnfolded
                          ? _buildUnfoldedGrid(completedOrders)
                          : _buildMobileList(completedOrders),
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
  Widget _buildMobileList(List<OrderEntity> orders) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 32),
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
  Widget _buildUnfoldedGrid(List<OrderEntity> orders) {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(24, 4, 24, 32),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 12,
        mainAxisExtent: 180,
      ),
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
}
