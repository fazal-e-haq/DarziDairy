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
import '../../domain/entities/order_entity.dart';
import '../providers/order_list_provider.dart';

/// Clean, card-less order detail screen.
/// AppBar displays '#token' with copy action and popup menu (edit/delete).
/// English on left side and Urdu on right side without brackets.
class OrderDetailScreen extends StatelessWidget {
  final int? orderId;

  const OrderDetailScreen({
    super.key,
    this.orderId,
  });

  String _formatOrderTitle(String token, int id) {
    final clean = token.replaceAll('#', '').trim();
    if (clean.toLowerCase().startsWith('order')) return clean;
    if (clean.isEmpty) return 'Order $id';
    return 'Order $clean';
  }

  void _copyOrderSummary(BuildContext context, OrderEntity order) {
    final buffer = StringBuffer();
    buffer.writeln('📋 Darzi Dairy - ${_formatOrderTitle(order.orderToken, order.id)}');
    buffer.writeln('Customer: ${order.customerName}');
    if (order.customerPhone.isNotEmpty) {
      buffer.writeln('Phone: ${order.customerPhone}');
    }
    buffer.writeln('Garment: ${order.garmentType}');
    buffer.writeln('Booking Date: ${DateFormatter.formatDate(order.bookingDate)}');
    buffer.writeln('Delivery Date: ${DateFormatter.formatDate(order.targetDeadline)}');
    buffer.writeln('Total Bill: Rs ${order.totalBill.toInt()}');
    buffer.writeln('Advance Paid: Rs ${order.advancePaid.toInt()}');
    buffer.writeln('Remaining Balance: Rs ${order.balanceDue.toInt()}');
    if (order.measurements.isNotEmpty) {
      buffer.writeln('\nMeasurements (Inches):');
      for (final entry in order.measurements.entries) {
        buffer.writeln('${entry.key}: ${entry.value}"');
      }
    }

    Clipboard.setData(ClipboardData(text: buffer.toString()));
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('آرڈر کی تفصیلات کاپی ہو گئیں (Copied for WhatsApp)'),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ),
    );
  }

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
        centerTitle: true,
        // Order 1 title in app bar (not only 1 or #1)
        title: Text(
          _formatOrderTitle(order.orderToken, order.id),
          style: const TextStyle(
            fontFamily: 'Nunito',
            fontSize: 21,
            fontWeight: FontWeight.w800,
          ),
        ),
        actions: [
          // Copy all order details for WhatsApp or sharing
          IconButton(
            icon: const Icon(Icons.copy_rounded, size: 25),
            tooltip: 'Copy Order Details',
            onPressed: () => _copyOrderSummary(context, order),
          ),
          // Menu icon with copy, edit and delete features
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert_rounded, size: 26),
            tooltip: 'Menu',
            onSelected: (val) async {
              if (val == 'copy') {
                _copyOrderSummary(context, order);
              } else if (val == 'edit') {
                context.push(AppRouter.editOrderPath(order.id));
              } else if (val == 'delete') {
                final confirm = await ConfirmationDialog.show(
                  context,
                  title: 'Delete ${_formatOrderTitle(order.orderToken, order.id)}?',
                  message: 'Are you sure you want to delete this order from records?',
                  confirmLabel: 'Delete',
                  cancelLabel: 'Cancel',
                  isDestructive: true,
                );
                if (confirm == true && context.mounted) {
                  final token = _formatOrderTitle(order.orderToken, order.id);
                  await provider.deleteOrder(order.id);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).clearSnackBars();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('$token deleted successfully'),
                        behavior: SnackBarBehavior.floating,
                        duration: const Duration(seconds: 2),
                      ),
                    );
                    if (context.canPop()) {
                      context.pop();
                    }
                  }
                }
              }
            },
            itemBuilder: (ctx) => [
              const PopupMenuItem(
                value: 'copy',
                child: Row(
                  children: [
                    Icon(Icons.copy_rounded, size: 20, color: AppColors.primary),
                    SizedBox(width: 10),
                    Expanded(child: Text('Copy Details (کاپی کریں)')),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: [
                    Icon(Icons.edit_outlined, size: 20, color: AppColors.primary),
                    SizedBox(width: 10),
                    Expanded(child: Text('Edit Order (تبدیل کریں)')),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete_outline, size: 20, color: AppColors.statusError),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text('Delete Order (حذف کریں)', style: TextStyle(color: AppColors.statusError)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 850),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Customer Name and Phone (No cards, no person icon, no phone copy icon)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              order.customerName,
                              style: const TextStyle(
                                fontFamily: 'Nunito',
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            if (order.customerPhone.isNotEmpty) ...[
                              const SizedBox(height: 2),
                              Text(
                                order.customerPhone,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: order.isCompleted
                              ? const Color(0xFFF0FDF4)
                              : const Color(0xFFEFF6FF),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: order.isCompleted
                                ? const Color(0xFFBBF7D0)
                                : const Color(0xFFBFDBFE),
                          ),
                        ),
                        child: Text(
                          order.isCompleted ? 'COMPLETED' : 'ACTIVE',
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: order.isCompleted
                                ? const Color(0xFF15803D)
                                : AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(color: Color(0xFFE2E8F0)),
                  const SizedBox(height: 12),

                  // 2. Garment & Dates Section (Urdu only in heading)
                  _buildSectionHeader('Order Details', 'آرڈر کی تفصیل'),
                  const SizedBox(height: 8),
                  _buildDetailRow(
                    label: 'Garment Type',
                    value: order.garmentType,
                  ),
                  const Divider(height: 1, color: Color(0xFFF1F5F9)),
                  _buildDetailRow(
                    label: 'Booking Date',
                    value: DateFormatter.formatDate(order.bookingDate),
                  ),
                  const Divider(height: 1, color: Color(0xFFF1F5F9)),
                  _buildDetailRow(
                    label: 'Delivery Date',
                    value: DateFormatter.formatDate(order.targetDeadline),
                    valueColor: DateFormatter.formatDeadline(order.targetDeadline).contains('Overdue') && !order.isCompleted
                        ? AppColors.statusError
                        : AppColors.primary,
                  ),
                  const SizedBox(height: 16),
                  const Divider(color: Color(0xFFE2E8F0)),
                  const SizedBox(height: 12),

                  // 3. Measurements Section (Inches)
                  _buildSectionHeader('Measurements (Inches)', 'پیمائش'),
                  const SizedBox(height: 10),
                  if (order.measurements.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 6),
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
                      spacing: 8,
                      runSpacing: 8,
                      children: order.measurements.entries.map((m) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
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
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  const SizedBox(height: 16),
                  const Divider(color: Color(0xFFE2E8F0)),
                  const SizedBox(height: 12),

                  // 4. Payment Breakdown Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildSectionHeader('Payment Summary', 'حساب کتاب'),
                      TextButton.icon(
                        onPressed: () => _showUpdateAdvanceDialog(context, order, provider),
                        icon: const Icon(Icons.edit_note_rounded, size: 18),
                        label: const Text(
                          'Update Advance',
                          style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700),
                        ),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _buildDetailRow(
                    label: 'Total Rate',
                    value: CurrencyFormatter.format(order.totalBill),
                  ),
                  const Divider(height: 1, color: Color(0xFFF1F5F9)),
                  _buildDetailRow(
                    label: 'Advance Paid',
                    value: CurrencyFormatter.format(order.advancePaid),
                  ),
                  const Divider(height: 1, color: Color(0xFFF1F5F9)),
                  _buildDetailRow(
                    label: 'Balance Due',
                    value: order.isFullyPaid ? 'Rs 0 (PAID)' : CurrencyFormatter.format(order.balanceDue),
                    valueColor: order.isFullyPaid ? const Color(0xFF16A34A) : AppColors.primary,
                    isBold: true,
                  ),
                  const SizedBox(height: 28),

                  // 5. Action Button: "Order Ready (سوٹ تیار ہے)" or "Completed (مکمل)"
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: order.isCompleted
                            ? const Color(0xFF475569)
                            : const Color(0xFF16A34A),
                        foregroundColor: Colors.white,
                        elevation: 1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                        ),
                      ),
                      icon: Icon(
                        order.isCompleted ? Icons.check_circle_outline : Icons.check_circle,
                        size: 22,
                      ),
                      label: Text(
                        order.isCompleted
                            ? 'Completed (مکمل)'
                            : 'Order Ready (سوٹ تیار ہے)',
                        style: const TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      onPressed: () async {
                        final wasCompleted = order.isCompleted;
                        await provider.toggleOrderStatus(order.id);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).clearSnackBars();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                wasCompleted
                                    ? 'آرڈر ${order.orderToken} دوبارہ جاری کر دیا گیا'
                                    : 'آرڈر ${order.orderToken} تیار ہو گیا! ہسٹری میں محفوظ',
                                style: const TextStyle(fontWeight: FontWeight.w600),
                              ),
                              backgroundColor: wasCompleted
                                  ? AppColors.primary
                                  : const Color(0xFF16A34A),
                              behavior: SnackBarBehavior.floating,
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String english, String urdu) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          english,
          style: const TextStyle(
            fontFamily: 'Nunito',
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '($urdu)',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow({
    required String label,
    required String value,
    Color? valueColor,
    bool isBold = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 9),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Nunito',
              fontSize: 14,
              fontWeight: isBold ? FontWeight.w800 : FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Nunito',
              fontSize: 14.5,
              fontWeight: isBold ? FontWeight.w800 : FontWeight.w700,
              color: valueColor ?? AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  void _showUpdateAdvanceDialog(
    BuildContext context,
    OrderEntity order,
    OrderListProvider provider,
  ) {
    final controller = TextEditingController(
      text: order.advancePaid.toInt().toString(),
    );

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final entered = double.tryParse(controller.text.trim()) ?? 0.0;
            final rem = (order.totalBill - entered).clamp(0.0, double.infinity);

            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: const Row(
                children: [
                  Icon(Icons.payments_outlined, size: 24, color: AppColors.primary),
                  SizedBox(width: 8),
                  Text(
                    'Update Advance Payment',
                    style: TextStyle(fontFamily: 'Nunito', fontSize: 17, fontWeight: FontWeight.w800),
                  ),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Bill: Rs ${order.totalBill.toInt()}',
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: controller,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Advance Paid',
                      prefixText: 'Rs ',
                    ),
                    onChanged: (val) => setModalState(() {}),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    rem == 0
                        ? 'Balance: Rs 0 (Fully Paid)'
                        : 'Remaining Balance: Rs ${rem.toInt()}',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      color: rem == 0 ? const Color(0xFF16A34A) : AppColors.primary,
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await provider.updateAdvancePayment(order.id, entered);
                    if (ctx.mounted) {
                      Navigator.pop(ctx);
                    }
                  },
                  child: const Text('Save Payment'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
