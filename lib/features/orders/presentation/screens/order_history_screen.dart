import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/routing/app_router.dart';
import '../../../../core/theme/responsive_layout.dart';
import '../widgets/order_card.dart';
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
  final ScrollController _scrollController = ScrollController();
  static const int _pageSize = 25;
  int _visibleCount = _pageSize;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 250) {
      final total = context.read<OrderListProvider>().getCompletedOrders(_searchQuery).length;
      if (_visibleCount < total) {
        setState(() {
          _visibleCount = (_visibleCount + _pageSize).clamp(0, total);
        });
      }
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
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
          'Order History',
          style: TextStyle(
            fontFamily: 'Nunito',
            fontSize: 21,
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
                      _visibleCount = _pageSize;
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
                                _visibleCount = _pageSize;
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
                      onRefresh: () async {
                        setState(() {
                          _visibleCount = _pageSize;
                        });
                        await provider.loadOrders();
                      },
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

  /// Compact mobile single-column list with lazy loading
  Widget _buildMobileList(List<OrderEntity> orders) {
    final displayOrders = orders.take(_visibleCount).toList();
    final hasMore = orders.length > displayOrders.length;

    return ListView.builder(
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      addAutomaticKeepAlives: false,
      addRepaintBoundaries: true,
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 32),
      itemCount: displayOrders.length + (hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == displayOrders.length) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 14),
            child: Center(
              child: SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF16A34A)),
              ),
            ),
          );
        }
        final order = displayOrders[index];
        return OrderCard(
          order: order,
          onTap: () => context.push(AppRouter.orderDetailPath(order.id)),
        );
      },
    );
  }

  /// Unfolded / Tablet dual-column responsive grid with lazy loading
  Widget _buildUnfoldedGrid(List<OrderEntity> orders) {
    final displayOrders = orders.take(_visibleCount).toList();
    final hasMore = orders.length > displayOrders.length;

    return GridView.builder(
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      addAutomaticKeepAlives: false,
      addRepaintBoundaries: true,
      padding: const EdgeInsets.fromLTRB(24, 4, 24, 32),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 12,
        mainAxisExtent: 210,
      ),
      itemCount: displayOrders.length + (hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == displayOrders.length) {
          return const Center(
            child: SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF16A34A)),
            ),
          );
        }
        final order = displayOrders[index];
        return OrderCard(
          order: order,
          margin: EdgeInsets.zero,
          onTap: () => context.push(AppRouter.orderDetailPath(order.id)),
        );
      },
    );
  }
}
