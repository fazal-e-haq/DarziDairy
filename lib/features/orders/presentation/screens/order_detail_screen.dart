import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../shared/widgets/confirmation_dialog.dart';
import '../providers/order_list_provider.dart';

/// Clean order detail screen featuring status toggling and financial summary
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
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Order ${order.orderToken}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Delete Order',
            onPressed: () async {
              final confirm = await ConfirmationDialog.show(
                context,
                title: 'Delete Order ${order.orderToken}?',
                message: 'Are you sure you want to remove this order from your workshop?',
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
            // 1. Order Header Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppDimensions.space16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: order.isUrgent ? AppColors.statusError : AppColors.primary,
                            borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                          ),
                          child: Text(
                            order.orderToken,
                            style: const TextStyle(
                              fontFamily: AppFonts.heading,
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        if (order.isUrgent) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.statusError.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.bolt, color: AppColors.statusError, size: 14),
                                SizedBox(width: 2),
                                Text(
                                  'URGENT',
                                  style: TextStyle(
                                    fontFamily: AppFonts.body,
                                    color: AppColors.statusError,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: order.isCompleted
                                ? AppColors.statusReady.withValues(alpha: 0.12)
                                : AppColors.secondary.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
                          ),
                          child: Text(
                            order.status.displayName,
                            style: TextStyle(
                              fontFamily: AppFonts.body,
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: order.isCompleted ? AppColors.statusReady : AppColors.secondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 24),

                    // Customer info
                    Row(
                      children: [
                        const CircleAvatar(
                          backgroundColor: AppColors.surfaceVariant,
                          child: Icon(Icons.person, color: AppColors.primary),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                order.customerName,
                                style: const TextStyle(
                                  fontFamily: AppFonts.heading,
                                  fontSize: 19,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                order.customerPhone,
                                style: const TextStyle(
                                  fontFamily: AppFonts.body,
                                  fontSize: 14,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppDimensions.space12),

            // 2. Garment & Dates Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppDimensions.space16),
                child: Column(
                  children: [
                    _DetailRow(
                      icon: Icons.checkroom,
                      label: 'Garment Type',
                      value: order.garmentType,
                    ),
                    const Divider(height: 20),
                    _DetailRow(
                      icon: Icons.calendar_today,
                      label: 'Booking Date',
                      value: DateFormatter.formatDate(order.bookingDate),
                    ),
                    const Divider(height: 20),
                    _DetailRow(
                      icon: Icons.event,
                      label: 'Delivery Date',
                      value: DateFormatter.formatDate(order.targetDeadline),
                      valueColor: DateFormatter.formatDeadline(order.targetDeadline).contains('Overdue') && !order.isCompleted
                          ? AppColors.statusError
                          : AppColors.textPrimary,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppDimensions.space12),

            // 3. Payment Breakdown Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppDimensions.space16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Payment Summary',
                      style: TextStyle(
                        fontFamily: AppFonts.heading,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 14),
                    _PriceRow(label: 'Total Rate', value: CurrencyFormatter.format(order.stitchingRate)),
                    const SizedBox(height: 8),
                    _PriceRow(label: 'Advance Paid', value: CurrencyFormatter.format(order.advancePaid)),
                    const Divider(height: 24),
                    _PriceRow(
                      label: order.isFullyPaid ? 'Status' : 'Balance Due',
                      value: order.isFullyPaid ? 'FULLY PAID' : CurrencyFormatter.format(order.balanceDue),
                      isTotal: true,
                      color: order.isFullyPaid ? AppColors.statusReady : AppColors.primary,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppDimensions.space20),

            // Status Toggle Button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: order.isCompleted ? AppColors.textMuted : AppColors.statusReady,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                  ),
                ),
                icon: Icon(order.isCompleted ? Icons.undo : Icons.check_circle, size: 22),
                label: Text(
                  order.isCompleted ? 'Mark as Active' : 'Mark as Completed',
                  style: const TextStyle(
                    fontFamily: AppFonts.body,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                onPressed: () => provider.toggleOrderStatus(order.id),
              ),
            ),
            const SizedBox(height: AppDimensions.space32),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.textSecondary),
        const SizedBox(width: 10),
        Text(
          label,
          style: const TextStyle(
            fontFamily: AppFonts.body,
            color: AppColors.textSecondary,
            fontSize: 14,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            fontFamily: AppFonts.body,
            fontWeight: FontWeight.w700,
            fontSize: 14,
            color: valueColor ?? AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

class _PriceRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isTotal;
  final Color? color;

  const _PriceRow({
    required this.label,
    required this.value,
    this.isTotal = false,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: AppFonts.body,
            fontSize: isTotal ? 15 : 14,
            fontWeight: isTotal ? FontWeight.w700 : FontWeight.w500,
            color: isTotal ? AppColors.textPrimary : AppColors.textSecondary,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            fontFamily: AppFonts.heading,
            fontSize: isTotal ? 18 : 15,
            fontWeight: FontWeight.w800,
            color: color ?? AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
