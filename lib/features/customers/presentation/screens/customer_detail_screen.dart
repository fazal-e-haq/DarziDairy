import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:darzi_dairy/features/orders/presentation/providers/order_list_provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/routing/app_router.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../shared/widgets/order_card.dart';
import '../providers/customer_list_provider.dart';
import '../../domain/entities/measurement.dart';

/// Full customer profile view featuring collapsible measurement sheets per garment
/// and complete workshop order history.
class CustomerDetailScreen extends StatelessWidget {
  final int? customerId;

  const CustomerDetailScreen({
    super.key,
    this.customerId,
  });

  @override
  Widget build(BuildContext context) {
    final customerProvider = context.watch<CustomerListProvider>();
    final customer = customerProvider.allCustomers.firstWhere(
      (c) => c.id == customerId,
      orElse: () => customerProvider.selectedCustomer ?? customerProvider.allCustomers.first,
    );

    final orderProvider = context.watch<OrderListProvider>();
    final customerOrders = orderProvider.allOrders.where((o) => o.customerId == customer.id).toList();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(customer.name),
          actions: [
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              tooltip: 'Edit Profile & Measurements',
              onPressed: () => context.push(AppRouter.editCustomerPath(customer.id)),
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.straighten, size: 18), text: 'Measurements'),
              Tab(icon: Icon(Icons.receipt_long, size: 18), text: 'Order History'),
            ],
          ),
        ),
        body: Column(
          children: [
            // Top Customer Profile Overview Card
            Container(
              padding: const EdgeInsets.all(AppDimensions.space16),
              color: AppColors.surface,
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                    foregroundColor: AppColors.primary,
                    child: Text(
                      customer.name.isNotEmpty ? customer.name[0].toUpperCase() : '?',
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: AppDimensions.space16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          customer.name,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            const Icon(Icons.phone, size: 14, color: AppColors.textSecondary),
                            const SizedBox(width: 4),
                            Text(customer.phone, style: const TextStyle(fontWeight: FontWeight.w500)),
                            if (customer.secondaryPhone != null && customer.secondaryPhone!.isNotEmpty) ...[
                              const SizedBox(width: 8),
                              Text('• ${customer.secondaryPhone!}', style: const TextStyle(color: AppColors.textMuted)),
                            ],
                          ],
                        ),
                        if (customer.notes != null && customer.notes!.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            customer.notes!,
                            style: const TextStyle(fontSize: 12, color: AppColors.textMuted, fontStyle: FontStyle.italic),
                          ),
                        ],
                      ],
                    ),
                  ),
                  IconButton.filledTonal(
                    icon: const Icon(Icons.phone),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            const Divider(),

            // Tabs Content
            Expanded(
              child: TabBarView(
                children: [
                  // Tab 1: Collapsible Garment Measurement Sheets
                  _MeasurementProfilesTab(profiles: customer.measurementProfiles),

                  // Tab 2: Customer Job History
                  _CustomerOrdersTab(orders: customerOrders),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppDimensions.space16),
            child: ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('Book Order for this Customer'),
              onPressed: () => context.push(AppRouter.createOrder),
            ),
          ),
        ),
      ),
    );
  }
}

class _MeasurementProfilesTab extends StatelessWidget {
  final List<MeasurementProfileEntity> profiles;

  const _MeasurementProfilesTab({required this.profiles});

  @override
  Widget build(BuildContext context) {
    if (profiles.isEmpty) {
      return const Center(
        child: Text(
          'No measurement profiles recorded yet.\nTap Edit to enter custom measurements.',
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColors.textMuted),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppDimensions.space16),
      itemCount: profiles.length,
      itemBuilder: (context, index) {
        final profile = profiles[index];
        return Card(
          margin: const EdgeInsets.only(bottom: AppDimensions.space12),
          child: ExpansionTile(
            initiallyExpanded: index == 0,
            leading: const Icon(Icons.content_cut, color: AppColors.secondary),
            title: Text(
              profile.garmentType,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
            ),
            subtitle: Text(
              '${profile.title} • Updated: ${DateFormatter.formatShortDate(profile.updatedAt)}',
              style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(AppDimensions.space16),
                child: Wrap(
                  spacing: AppDimensions.space12,
                  runSpacing: AppDimensions.space12,
                  children: profile.values.map((v) {
                    return Container(
                      width: 140,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceVariant,
                        borderRadius: AppDimensions.roundedMedium,
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            v.label,
                            style: const TextStyle(fontSize: 11, color: AppColors.textSecondary, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${v.value.toStringAsFixed(1)}" in',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _CustomerOrdersTab extends StatelessWidget {
  final List<dynamic> orders;

  const _CustomerOrdersTab({required this.orders});

  @override
  Widget build(BuildContext context) {
    if (orders.isEmpty) {
      return const Center(
        child: Text(
          'No previous orders found for this customer.',
          style: TextStyle(color: AppColors.textMuted),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppDimensions.space16),
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
