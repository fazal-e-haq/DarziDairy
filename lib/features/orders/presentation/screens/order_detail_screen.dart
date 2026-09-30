import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/routing/app_router.dart';
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
            icon: const Icon(Icons.edit_outlined),
            tooltip: 'Edit Order',
            onPressed: () => context.push(AppRouter.editOrderPath(order.id)),
          ),
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
                if (context.mounted && context.canPop()) {
                  context.pop();
                }
              }
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 850),
            child: SingleChildScrollView(
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
                                    fontFamily: 'Nunito',
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
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
                                        fontFamily: 'Nunito',
                                        fontSize: 19,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      order.customerPhone,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (order.customerPhone.isNotEmpty)
                                IconButton(
                                  icon: const Icon(Icons.copy_rounded, size: 20, color: AppColors.textMuted),
                                  tooltip: 'Copy Phone',
                                  onPressed: () {
                                    Clipboard.setData(ClipboardData(text: order.customerPhone));
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Phone number copied to clipboard'),
                                        behavior: SnackBarBehavior.floating,
                                        duration: Duration(seconds: 2),
                                      ),
                                    );
                                  },
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

            // 3. Measurements Card (پیمائش)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppDimensions.space16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.straighten, size: 20, color: AppColors.secondary),
                        SizedBox(width: 8),
                        Text(
                          'Measurements (پیمائش)',
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 20),
                    if (order.measurements.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          'No specific measurements recorded.',
                          style: TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 13,
                          ),
                        ),
                      )
                    else
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: order.measurements.entries.map((m) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8FAFC),
                              borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                              border: Border.all(color: const Color(0xFFE2E8F0)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  m.key,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${m.value}"',
                                  style: const TextStyle(
                                    fontFamily: 'Nunito',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppDimensions.space12),

            // 4. Payment Breakdown Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppDimensions.space16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Payment Summary',
                      style: TextStyle(
                        fontFamily: 'Nunito',
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
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                onPressed: () async {
                  final wasCompleted = order.isCompleted;
                  await provider.toggleOrderStatus(order.id);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          wasCompleted
                              ? 'Order ${order.orderToken} marked as active'
                              : 'Order ${order.orderToken} completed and moved to History!',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        backgroundColor: wasCompleted
                            ? AppColors.primary
                            : const Color(0xFF16A34A),
                        behavior: SnackBarBehavior.floating,
                        action: !wasCompleted
                            ? SnackBarAction(
                                label: 'View History',
                                textColor: Colors.white,
                                onPressed: () => context.push(AppRouter.history),
                              )
                            : null,
                      ),
                    );
                  }
                },
              ),
            ),
            const SizedBox(height: AppDimensions.space32),
          ],
        ),
      ),
    ),
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
            color: AppColors.textSecondary,
            fontSize: 14,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
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
            fontSize: isTotal ? 15 : 14,
            fontWeight: isTotal ? FontWeight.w700 : FontWeight.w500,
            color: isTotal ? AppColors.textPrimary : AppColors.textSecondary,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            fontFamily: 'Nunito',
            fontSize: isTotal ? 18 : 15,
            fontWeight: FontWeight.w800,
            color: color ?? AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
