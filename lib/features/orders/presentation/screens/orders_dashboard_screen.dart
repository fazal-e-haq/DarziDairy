import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/routing/app_router.dart';
import '../../../../core/theme/responsive_layout.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../shared/widgets/order_card.dart';
import '../../../../shared/widgets/status_stepper.dart';
import '../providers/order_list_provider.dart';

/// Main workshop dashboard featuring filter pills, reactive orders list,
/// quick status advancement, and responsive unfolded master-detail dual pane.
class OrdersDashboardScreen extends StatelessWidget {
  const OrdersDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.content_cut, size: 20, color: AppColors.secondary),
            SizedBox(width: AppDimensions.space8),
            Text(AppStrings.appName),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu_book),
            tooltip: AppStrings.navDiary,
            onPressed: () => context.push(AppRouter.diary),
          ),
          IconButton(
            icon: const Icon(Icons.people_alt_outlined),
            tooltip: AppStrings.navCustomers,
            onPressed: () => context.push(AppRouter.customerList),
          ),
          IconButton(
            icon: const Icon(Icons.backup_outlined),
            tooltip: AppStrings.navBackup,
            onPressed: () => context.push(AppRouter.backup),
          ),
        ],
      ),
      body: ResponsiveDualPane(
        masterWidth: 420.0,
        masterPane: const _OrdersListPane(),
        detailPane: const _OrderDetailPreviewPane(),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.secondary,
        foregroundColor: AppColors.surface,
        elevation: 4,
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

/// Master list pane containing filter pills and reactive order cards
class _OrdersListPane extends StatelessWidget {
  const _OrdersListPane();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Filter Pills Header
        const _FilterPillsBar(),

        // Reactive Orders List
        Expanded(
          child: Consumer<OrderListProvider>(
            builder: (context, provider, child) {
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
                          size: 64,
                          color: AppColors.textDisabled.withValues(alpha: 0.6),
                        ),
                        const SizedBox(height: AppDimensions.space16),
                        const Text(
                          'No orders match this filter',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
                        ),
                        const SizedBox(height: AppDimensions.space8),
                        const Text(
                          'Tap "+ New Order" below to book a customer job.',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 13, color: AppColors.textMuted),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return ListView.builder(
                padding: context.responsiveScreenPadding,
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  final order = orders[index];
                  final isSelected = context.isUnfolded && provider.selectedOrder?.id == order.id;

                  return Dismissible(
                    key: Key('order_${order.id}'),
                    direction: DismissDirection.startToEnd,
                    background: Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(left: 20),
                      color: AppColors.statusReady,
                      child: const Row(
                        children: [
                          Icon(Icons.fast_forward, color: Colors.white),
                          SizedBox(width: 8),
                          Text('Advance Status', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    confirmDismiss: (direction) async {
                      await provider.advanceStatus(order.id);
                      return false; // Don't remove from list, just update state
                    },
                    child: Container(
                      decoration: isSelected
                          ? BoxDecoration(
                              borderRadius: AppDimensions.roundedMedium,
                              border: Border.all(color: AppColors.primary, width: 2.0),
                            )
                          : null,
                      child: OrderCard(
                        order: order,
                        onTap: () {
                          if (context.isUnfolded) {
                            provider.selectOrder(order);
                          } else {
                            context.push(AppRouter.orderDetailPath(order.id));
                          }
                        },
                        onAdvanceStatus: () => provider.advanceStatus(order.id),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

/// Horizontal scrollable bar with status and urgency filter pills
class _FilterPillsBar extends StatelessWidget {
  const _FilterPillsBar();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<OrderListProvider>();
    final active = provider.activeFilter;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.space16,
        vertical: AppDimensions.space12,
      ),
      child: Row(
        children: [
          _buildPill(
            context,
            label: 'All Orders',
            count: provider.countAll,
            isSelected: active == OrderFilter.all,
            onTap: () => provider.setFilter(OrderFilter.all),
          ),
          const SizedBox(width: AppDimensions.space8),
          _buildPill(
            context,
            label: 'Urgent',
            count: provider.countUrgent,
            color: AppColors.statusError,
            isSelected: active == OrderFilter.urgent,
            onTap: () => provider.setFilter(OrderFilter.urgent),
          ),
          const SizedBox(width: AppDimensions.space8),
          _buildPill(
            context,
            label: "Due Today",
            count: provider.countToday,
            color: AppColors.secondary,
            isSelected: active == OrderFilter.today,
            onTap: () => provider.setFilter(OrderFilter.today),
          ),
          const SizedBox(width: AppDimensions.space8),
          _buildPill(
            context,
            label: 'Cutting',
            count: provider.countCutting,
            color: AppColors.statusCutting,
            isSelected: active == OrderFilter.cutting,
            onTap: () => provider.setFilter(OrderFilter.cutting),
          ),
          const SizedBox(width: AppDimensions.space8),
          _buildPill(
            context,
            label: 'Ready for Trial',
            count: provider.countTrialReady,
            color: AppColors.statusReady,
            isSelected: active == OrderFilter.trialReady,
            onTap: () => provider.setFilter(OrderFilter.trialReady),
          ),
        ],
      ),
    );
  }

  Widget _buildPill(
    BuildContext context, {
    required String label,
    required int count,
    required bool isSelected,
    required VoidCallback onTap,
    Color color = AppColors.primary,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDimensions.radiusCircular),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? color : AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusCircular),
          border: Border.all(
            color: isSelected ? color : AppColors.border,
            width: 1.2,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                color: isSelected ? Colors.white : AppColors.textPrimary,
              ),
            ),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.white.withValues(alpha: 0.25)
                    : color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
              ),
              child: Text(
                '$count',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.white : color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Unfolded / Tablet detail preview pane displayed side-by-side with the list
class _OrderDetailPreviewPane extends StatelessWidget {
  const _OrderDetailPreviewPane();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<OrderListProvider>();
    final order = provider.selectedOrder;

    if (order == null) {
      return const Center(
        child: Text(
          'Select an order from the list to view workshop details',
          style: TextStyle(color: AppColors.textMuted),
        ),
      );
    }

    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.all(AppDimensions.space24),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Token & Status
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
                  ),
                  child: Text(
                    order.orderToken,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      fontFamily: 'monospace',
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order.customerName,
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(order.customerPhone, style: const TextStyle(color: AppColors.textSecondary)),
                    ],
                  ),
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.open_in_new, size: 16),
                  label: const Text('Full View'),
                  onPressed: () => context.push(AppRouter.orderDetailPath(order.id)),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.space24),

            // Visual Status Stepper
            const Text(
              'Workflow Pipeline Status',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: AppDimensions.space12),
            StatusStepper(
              currentStatus: order.status,
              onStatusChanged: (newStatus) => provider.updateStatus(order.id, newStatus),
            ),
            const SizedBox(height: AppDimensions.space24),

            // Financial Summary Card
            Container(
              padding: const EdgeInsets.all(AppDimensions.space16),
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: AppDimensions.roundedMedium,
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  _buildFinancialRow('Stitching Rate', CurrencyFormatter.format(order.stitchingRate)),
                  if (order.fabricCharges > 0)
                    _buildFinancialRow('Fabric Addon', CurrencyFormatter.format(order.fabricCharges)),
                  if (order.urgentSurcharge > 0)
                    _buildFinancialRow('Urgent Surcharge', CurrencyFormatter.format(order.urgentSurcharge)),
                  const Divider(),
                  _buildFinancialRow('Total Job Price', CurrencyFormatter.format(order.totalBill), isBold: true),
                  _buildFinancialRow('Advance Paid', CurrencyFormatter.format(order.advancePaid), color: Colors.green.shade700),
                  const Divider(),
                  _buildFinancialRow('Balance Due on Delivery', CurrencyFormatter.format(order.balanceDue), isHighlight: true),
                ],
              ),
            ),
            const SizedBox(height: AppDimensions.space24),

            // Target Delivery Details
            Row(
              children: [
                const Icon(Icons.event_available, color: AppColors.secondary),
                const SizedBox(width: 8),
                Text(
                  'Promised Delivery: ${DateFormatter.formatShortDate(order.targetDeadline)} (${DateFormatter.formatDeadline(order.targetDeadline)})',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFinancialRow(String label, String value, {bool isBold = false, bool isHighlight = false, Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isHighlight ? 15 : 13,
              fontWeight: (isBold || isHighlight) ? FontWeight.w700 : FontWeight.w500,
              color: isHighlight ? AppColors.primary : AppColors.textSecondary,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isHighlight ? 16 : 14,
              fontWeight: (isBold || isHighlight) ? FontWeight.w800 : FontWeight.w600,
              color: color ?? (isHighlight ? AppColors.primary : AppColors.textPrimary),
            ),
          ),
        ],
      ),
    );
  }
}
