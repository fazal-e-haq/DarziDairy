import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/routing/app_router.dart';
import '../../../../core/theme/responsive_layout.dart';
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
  final ScrollController _scrollController = ScrollController();
  static const int _pageSize = 25;
  int _visibleCount = _pageSize;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 250) {
      final total = context.read<OrderListProvider>().activeOrders.length;
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
          AppStrings.appName,
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
                    if (_visibleCount != _pageSize) {
                      setState(() {
                        _visibleCount = _pageSize;
                      });
                    }
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
                              if (_visibleCount != _pageSize) {
                                setState(() {
                                  _visibleCount = _pageSize;
                                });
                              }
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
                      if (isSearching) {
                        return Center(
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.all(AppDimensions.space32),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.person_search_outlined,
                                  size: 64,
                                  color: AppColors.primary.withValues(alpha: 0.4),
                                ),
                                const SizedBox(height: AppDimensions.space16),
                                Text(
                                  'No customer found matching "${_searchController.text}"',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontFamily: 'Nunito',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: AppDimensions.space16),
                                OutlinedButton.icon(
                                  onPressed: () {
                                    _searchController.clear();
                                    provider.setSearchQuery('');
                                  },
                                  icon: const Icon(Icons.clear_rounded, size: 18),
                                  label: const Text('تلاش ختم کریں (Clear)'),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      // Empty state when no orders exist: illustrator-like icon & single sentence
                      return Center(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(AppDimensions.space32),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildNoOrdersIllustration(),
                              const SizedBox(height: AppDimensions.space20),
                              const Text(
                                'No orders yet (ابھی کوئی آرڈر نہیں ہے)',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'Nunito',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    return RefreshIndicator(
                      color: AppColors.primary,
                      onRefresh: () async {
                        setState(() {
                          _visibleCount = _pageSize;
                        });
                        await provider.loadOrders();
                      },
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
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'createOrderFab',
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: const StadiumBorder(),
        icon: const Icon(Icons.add_rounded, size: 22),
        label: const Text(
          'New Order',
          style: TextStyle(
            fontFamily: 'Nunito',
            fontWeight: FontWeight.w800,
            fontSize: 14,
          ),
        ),
        onPressed: () => context.push(AppRouter.createOrder),
      ),
    );
  }

  /// Illustrator-like tailoring order badge for empty state
  Widget _buildNoOrdersIllustration() {
    return SizedBox(
      width: 120,
      height: 120,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer soft glow circle
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary.withValues(alpha: 0.07),
            ),
          ),
          // Inner circular backdrop with subtle border
          Container(
            width: 92,
            height: 92,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary.withValues(alpha: 0.12),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.20),
                width: 1.5,
              ),
            ),
            child: const Center(
              child: Icon(
                Icons.assignment_outlined,
                size: 46,
                color: AppColors.primary,
              ),
            ),
          ),
          // Decorative tailor scissors corner badge
          Positioned(
            right: 10,
            bottom: 10,
            child: Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.20),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.18),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.content_cut_rounded,
                size: 16,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Compact mobile single-column list with lazy loading
  Widget _buildMobileList(List orders, OrderListProvider provider) {
    final displayOrders = orders.take(_visibleCount).toList();
    final hasMore = orders.length > displayOrders.length;

    return ListView.builder(
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      addAutomaticKeepAlives: false,
      addRepaintBoundaries: true,
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
      itemCount: displayOrders.length + (hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == displayOrders.length) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 14),
            child: Center(
              child: SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary),
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
  Widget _buildUnfoldedGrid(List orders, OrderListProvider provider) {
    final displayOrders = orders.take(_visibleCount).toList();
    final hasMore = orders.length > displayOrders.length;

    return GridView.builder(
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      addAutomaticKeepAlives: false,
      addRepaintBoundaries: true,
      padding: const EdgeInsets.fromLTRB(24, 4, 24, 24),
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
              child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary),
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
