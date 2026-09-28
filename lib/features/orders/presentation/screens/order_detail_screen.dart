import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../shared/widgets/confirmation_dialog.dart';
import '../../../../shared/widgets/fabric_photo_picker.dart';
import '../../../../shared/widgets/status_stepper.dart';
import '../providers/order_list_provider.dart';
import '../../domain/entities/order_entity.dart';

/// Comprehensive order detail screen featuring workshop pipeline transitions,
/// customer shortcuts, fabric pattern zoom inspections, and financial settlement.
class OrderDetailScreen extends StatelessWidget {
  final int? orderId;

  const OrderDetailScreen({
    super.key,
    this.orderId,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<OrderListProvider>();
    final matches = provider.allOrders.where((o) => o.id == orderId);

    if (matches.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Order Details')),
        body: const Center(child: Text('Order not found or was deleted.')),
      );
    }

    final order = matches.first;

    return Scaffold(
      appBar: AppBar(
        title: Text('Order ${order.orderToken}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Move to Recycle Bin',
            onPressed: () async {
              final confirm = await ConfirmationDialog.show(
                context,
                title: 'Delete Order ${order.orderToken}?',
                message: 'This will move the order to the Recycle Bin. You can restore it later if needed.',
              );
              if (confirm == true && context.mounted) {
                await provider.deleteOrder(order.id);
                if (context.mounted) Navigator.pop(context);
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.space16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Customer & Token Banner
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppDimensions.space16),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: order.isUrgent ? AppColors.statusError : AppColors.primary,
                        borderRadius: AppDimensions.roundedMedium,
                      ),
                      child: Text(
                        order.orderToken,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ),
                    const SizedBox(width: AppDimensions.space16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            order.customerName,
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${order.garmentType} • ${order.customerPhone}',
                            style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                    IconButton.filledTonal(
                      icon: const Icon(Icons.phone),
                      tooltip: 'Call Customer',
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppDimensions.space16),

            // Workshop Status Stepper
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppDimensions.space16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Workshop Pipeline Stage',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: AppDimensions.space12),
                    StatusStepper(
                      currentStatus: order.status,
                      onStatusChanged: (newStatus) {
                        provider.updateStatus(order.id, newStatus);
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppDimensions.space16),

            // Timeline & Deadlines
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppDimensions.space16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Schedule & Deadlines', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                    const SizedBox(height: AppDimensions.space12),
                    Row(
                      children: [
                        const Icon(Icons.book_online, size: 18, color: AppColors.textMuted),
                        const SizedBox(width: 8),
                        Text('Booked on: ${DateFormatter.formatShortDate(order.bookingDate)}'),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.alarm,
                          size: 18,
                          color: order.isUrgent ? AppColors.statusError : AppColors.secondary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Promised Delivery: ${DateFormatter.formatShortDate(order.targetDeadline)} (${DateFormatter.formatDeadline(order.targetDeadline)})',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: order.isUrgent ? AppColors.statusError : AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppDimensions.space16),

            // Fabric Patterns
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppDimensions.space16),
                child: FabricPhotoPicker(
                  imagePaths: order.fabricImagePaths,
                  onImageAdded: (path) {},
                  onImageRemoved: (idx) {},
                ),
              ),
            ),
            const SizedBox(height: AppDimensions.space16),

            // Financial Settlement Card
            Card(
              color: AppColors.surface,
              child: Padding(
                padding: const EdgeInsets.all(AppDimensions.space16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Financial Summary', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                    const SizedBox(height: AppDimensions.space12),
                    _buildPriceRow('Stitching Charge', CurrencyFormatter.format(order.stitchingRate)),
                    if (order.fabricCharges > 0)
                      _buildPriceRow('Fabric Addon', CurrencyFormatter.format(order.fabricCharges)),
                    if (order.urgentSurcharge > 0)
                      _buildPriceRow('Urgent Surcharge', CurrencyFormatter.format(order.urgentSurcharge)),
                    const Divider(),
                    _buildPriceRow('Total Job Bill', CurrencyFormatter.format(order.totalBill), isBold: true),
                    _buildPriceRow('Advance Deposited', CurrencyFormatter.format(order.advancePaid), color: Colors.green.shade700),
                    const Divider(),
                    _buildPriceRow(
                      order.isFullyPaid ? 'Settlement Status' : 'Remaining Balance Due',
                      order.isFullyPaid ? 'FULLY PAID' : CurrencyFormatter.format(order.balanceDue),
                      isHighlight: true,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppDimensions.space24),

            // Actions
            if (order.status != OrderStatus.delivered)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.check_circle_outline),
                  label: const Text('Advance to Next Workflow Stage'),
                  onPressed: () => provider.advanceStatus(order.id),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceRow(String label, String value, {bool isBold = false, bool isHighlight = false, Color? color}) {
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
              fontSize: isHighlight ? 17 : 14,
              fontWeight: (isBold || isHighlight) ? FontWeight.w800 : FontWeight.w600,
              color: color ?? (isHighlight ? AppColors.secondary : AppColors.textPrimary),
            ),
          ),
        ],
      ),
    );
  }
}
