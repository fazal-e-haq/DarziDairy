import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../../../../shared/widgets/measurement_grid_input.dart';
import '../providers/order_list_provider.dart';
import '../../domain/entities/order_entity.dart';

/// Clean, focused order builder screen with real-time financial balance preview
class CreateOrderScreen extends StatefulWidget {
  final int? orderId;

  const CreateOrderScreen({
    super.key,
    this.orderId,
  });

  @override
  State<CreateOrderScreen> createState() => _CreateOrderScreenState();
}

class _CreateOrderScreenState extends State<CreateOrderScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _customerNameController = TextEditingController();
  final TextEditingController _customerPhoneController = TextEditingController();
  String _selectedGarment = AppStrings.defaultGarments.first;
  final TextEditingController _tokenController = TextEditingController();
  DateTime _targetDeadline = DateTime.now().add(const Duration(days: 4));
  bool _isUrgent = false;

  // Financial inputs
  final TextEditingController _stitchingRateController = TextEditingController(text: '1800');
  final TextEditingController _advancePaidController = TextEditingController(text: '500');

  // Measurements
  final Map<String, TextEditingController> _measurementControllers = {};

  @override
  void initState() {
    super.initState();
    _tokenController.text = '#B-${100 + (DateTime.now().millisecondsSinceEpoch % 900)}';

    for (final label in AppStrings.standardMeasurementKeys) {
      _measurementControllers[label] = TextEditingController();
    }

    _stitchingRateController.addListener(_onPriceChanged);
    _advancePaidController.addListener(_onPriceChanged);

    if (widget.orderId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final order = context.read<OrderListProvider>().allOrders.firstWhere(
              (o) => o.id == widget.orderId,
              orElse: () => context.read<OrderListProvider>().allOrders.first,
            );
        _customerNameController.text = order.customerName;
        _customerPhoneController.text = order.customerPhone;
        _tokenController.text = order.orderToken;
        _selectedGarment = order.garmentType;
        _stitchingRateController.text = order.stitchingRate.toInt().toString();
        _advancePaidController.text = order.advancePaid.toInt().toString();
        _targetDeadline = order.targetDeadline;
        _isUrgent = order.isUrgent;
        setState(() {});
      });
    }
  }

  void _onPriceChanged() {
    setState(() {});
  }

  @override
  void dispose() {
    _tokenController.dispose();
    _customerNameController.dispose();
    _customerPhoneController.dispose();
    _stitchingRateController.dispose();
    _advancePaidController.dispose();
    for (final controller in _measurementControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  double get _stitchingRate => double.tryParse(_stitchingRateController.text.trim()) ?? 0.0;
  double get _advancePaid => double.tryParse(_advancePaidController.text.trim()) ?? 0.0;
  double get _balanceDue => _stitchingRate - _advancePaid;

  Future<void> _selectDeadlineDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _targetDeadline,
      firstDate: DateTime.now().subtract(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 180)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: AppColors.surface,
              surface: AppColors.surface,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() => _targetDeadline = picked);
    }
  }

  Future<void> _saveOrder() async {
    if (!_formKey.currentState!.validate()) return;

    final customerName = _customerNameController.text.trim();
    final customerPhone = _customerPhoneController.text.trim();

    if (customerName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter customer name.')),
      );
      return;
    }

    final newOrder = OrderEntity(
      id: widget.orderId ?? 0,
      orderToken: _tokenController.text.trim(),
      customerId: 0,
      customerName: customerName,
      customerPhone: customerPhone,
      garmentType: _selectedGarment,
      bookingDate: DateTime.now(),
      targetDeadline: _targetDeadline,
      isUrgent: _isUrgent,
      status: OrderStatus.active,
      stitchingRate: _stitchingRate,
      advancePaid: _advancePaid,
    );

    final orderProvider = context.read<OrderListProvider>();
    await orderProvider.repository.saveOrder(newOrder);
    await orderProvider.loadOrders();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Order ${newOrder.orderToken} saved successfully!'),
          backgroundColor: AppColors.statusReady,
        ),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(widget.orderId != null ? 'Edit Order' : 'New Order'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppDimensions.space16),
          children: [
            // 1. Token & Customer Details Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppDimensions.space16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.confirmation_number_outlined, size: 20, color: AppColors.primary),
                        const SizedBox(width: AppDimensions.space8),
                        const Text(
                          'Order Token',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
                          ),
                          child: Text(
                            _tokenController.text,
                            style: const TextStyle(
                              fontFamily: 'monospace',
                              fontWeight: FontWeight.w800,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 24),

                    // Customer Inputs
                    CustomTextField(
                      controller: _customerNameController,
                      label: 'Customer Name',
                      hint: 'Enter customer name',
                      prefixIcon: Icons.person_outline,
                      validator: (val) => val == null || val.trim().isEmpty ? 'Required' : null,
                    ),
                    const SizedBox(height: AppDimensions.space12),
                    CustomTextField(
                      controller: _customerPhoneController,
                      label: 'Phone Number',
                      hint: '0300-1234567',
                      prefixIcon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppDimensions.space12),

            // 2. Garment & Delivery Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppDimensions.space16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Garment / Job Type',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: AppDimensions.space12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: AppStrings.defaultGarments.map((garment) {
                        final isSelected = _selectedGarment == garment;
                        return ChoiceChip(
                          label: Text(garment),
                          selected: isSelected,
                          selectedColor: AppColors.primary,
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : AppColors.textPrimary,
                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                          ),
                          onSelected: (val) {
                            if (val) setState(() => _selectedGarment = garment);
                          },
                        );
                      }).toList(),
                    ),
                    const Divider(height: 24),

                    // Delivery Date & Urgent Toggle
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: _selectDeadlineDate,
                            borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppColors.surfaceVariant,
                                borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                                border: Border.all(color: AppColors.border),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Delivery Date', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      const Icon(Icons.calendar_today, size: 16, color: AppColors.primary),
                                      const SizedBox(width: 6),
                                      Text(
                                        DateFormatter.formatDate(_targetDeadline),
                                        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        InkWell(
                          onTap: () => setState(() => _isUrgent = !_isUrgent),
                          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                            decoration: BoxDecoration(
                              color: _isUrgent
                                  ? AppColors.statusError.withValues(alpha: 0.12)
                                  : AppColors.surfaceVariant,
                              borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                              border: Border.all(
                                color: _isUrgent ? AppColors.statusError : AppColors.border,
                                width: _isUrgent ? 1.5 : 1.0,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.bolt,
                                  color: _isUrgent ? AppColors.statusError : AppColors.textMuted,
                                  size: 20,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Urgent',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: _isUrgent ? AppColors.statusError : AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppDimensions.space12),

            // 3. Pricing Card (with Live Balance Due Preview)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppDimensions.space16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Payment & Rates',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: AppDimensions.space12),
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            controller: _stitchingRateController,
                            label: 'Total Rate (Rs)',
                            keyboardType: TextInputType.number,
                            prefixIcon: Icons.payments_outlined,
                          ),
                        ),
                        const SizedBox(width: AppDimensions.space12),
                        Expanded(
                          child: CustomTextField(
                            controller: _advancePaidController,
                            label: 'Advance (Rs)',
                            keyboardType: TextInputType.number,
                            prefixIcon: Icons.price_check,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppDimensions.space12),

                    // Balance preview banner
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: _balanceDue <= 0
                            ? AppColors.statusReady.withValues(alpha: 0.1)
                            : AppColors.secondary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
                        border: Border.all(
                          color: _balanceDue <= 0
                              ? AppColors.statusReady.withValues(alpha: 0.4)
                              : AppColors.secondary.withValues(alpha: 0.4),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            _balanceDue <= 0 ? Icons.check_circle_outline : Icons.pending_outlined,
                            size: 18,
                            color: _balanceDue <= 0 ? AppColors.statusReady : AppColors.secondary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _balanceDue <= 0 ? 'Fully Paid' : 'Remaining Balance:',
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                          ),
                          const Spacer(),
                          Text(
                            CurrencyFormatter.format(_balanceDue > 0 ? _balanceDue : 0),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: _balanceDue <= 0 ? AppColors.statusReady : AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppDimensions.space12),

            // 4. Measurements Grid Card
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
                          'Measurements (Inches)',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppDimensions.space12),
                    MeasurementGridInput(
                      controllers: _measurementControllers,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppDimensions.space20),

            // Save Order Button
            CustomButton(
              text: widget.orderId != null ? 'Update Order' : 'Save Order',
              icon: Icons.check,
              onPressed: _saveOrder,
            ),
            const SizedBox(height: AppDimensions.space32),
          ],
        ),
      ),
    );
  }
}
