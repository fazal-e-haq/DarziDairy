import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../../../../shared/widgets/measurement_grid_input.dart';
import '../providers/order_list_provider.dart';
import '../../domain/entities/order_entity.dart';

/// Clean, simple, and responsive New/Edit Order screen.
/// Supports both compact mobile screens and unfolded foldables/tablets.
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

  // 1. Customer Name
  final TextEditingController _customerNameController = TextEditingController();

  // 2. Phone Number
  final TextEditingController _customerPhoneController = TextEditingController();

  // 3. Garment Type
  String _selectedGarment = AppStrings.defaultGarments.first;

  // 4. Delivery Date
  DateTime _targetDeadline = DateTime.now().add(const Duration(days: 4));

  // 5. Urgent or not
  bool _isUrgent = false;

  // 6. Just Payment Price
  final TextEditingController _priceController = TextEditingController(text: '1800');

  // 7. Measurements
  final Map<String, TextEditingController> _measurementControllers = {};

  String? _existingToken;
  DateTime? _existingBookingDate;

  @override
  void initState() {
    super.initState();

    for (final label in AppStrings.standardMeasurementKeys) {
      _measurementControllers[label] = TextEditingController();
    }

    if (widget.orderId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final matches = context.read<OrderListProvider>().allOrders.where(
              (o) => o.id == widget.orderId,
            );
        if (matches.isNotEmpty) {
          final order = matches.first;
          _existingToken = order.orderToken;
          _existingBookingDate = order.bookingDate;
          _customerNameController.text = order.customerName;
          _customerPhoneController.text = order.customerPhone;
          _selectedGarment = order.garmentType;
          _targetDeadline = order.targetDeadline;
          _isUrgent = order.isUrgent;
          _priceController.text = order.stitchingRate.toInt().toString();
          setState(() {});
        }
      });
    }
  }

  @override
  void dispose() {
    _customerNameController.dispose();
    _customerPhoneController.dispose();
    _priceController.dispose();
    for (final controller in _measurementControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

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
              onPrimary: Colors.white,
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
    final price = double.tryParse(_priceController.text.trim()) ?? 0.0;

    final token = _existingToken ?? '#B-${100 + (DateTime.now().millisecondsSinceEpoch % 900)}';

    final newOrder = OrderEntity(
      id: widget.orderId ?? 0,
      orderToken: token,
      customerId: 0,
      customerName: customerName,
      customerPhone: customerPhone,
      garmentType: _selectedGarment,
      bookingDate: _existingBookingDate ?? DateTime.now(),
      targetDeadline: _targetDeadline,
      isUrgent: _isUrgent,
      status: OrderStatus.active,
      stitchingRate: price,
      advancePaid: price,
    );

    final orderProvider = context.read<OrderListProvider>();
    await orderProvider.repository.saveOrder(newOrder);
    await orderProvider.loadOrders();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.orderId != null ? 'Order updated successfully!' : 'Order created successfully!',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          backgroundColor: AppColors.statusReady,
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isUnfolded = MediaQuery.sizeOf(context).width >= 720;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          widget.orderId != null ? 'Edit Order' : 'New Order',
          style: const TextStyle(
            fontFamily: AppFonts.heading,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1050),
            child: Form(
              key: _formKey,
              child: isUnfolded ? _buildUnfoldedLayout() : _buildMobileLayout(),
            ),
          ),
        ),
      ),
    );
  }

  /// Compact single-column layout for standard mobile phones
  Widget _buildMobileLayout() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      children: [
        _buildCustomerCard(),
        const SizedBox(height: 12),
        _buildGarmentAndDeliveryCard(),
        const SizedBox(height: 12),
        _buildPriceCard(),
        const SizedBox(height: 12),
        _buildMeasurementsCard(),
        const SizedBox(height: 24),
        _buildSaveButton(),
        const SizedBox(height: 32),
      ],
    );
  }

  /// Responsive dual-column layout for unfolded foldables and tablets
  Widget _buildUnfoldedLayout() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left Column: Customer details, garment & delivery, price
          Expanded(
            flex: 5,
            child: Column(
              children: [
                _buildCustomerCard(),
                const SizedBox(height: 14),
                _buildGarmentAndDeliveryCard(),
                const SizedBox(height: 14),
                _buildPriceCard(),
              ],
            ),
          ),
          const SizedBox(width: 20),

          // Right Column: Measurements grid + Save Button
          Expanded(
            flex: 6,
            child: Column(
              children: [
                _buildMeasurementsCard(),
                const SizedBox(height: 20),
                _buildSaveButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Card 1: Customer Name and Phone Number
  Widget _buildCustomerCard() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.space16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x05000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.person_outline_rounded, size: 20, color: AppColors.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Customer Details',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: AppFonts.heading,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const Divider(height: 20, color: Color(0xFFF1F5F9)),

          // 1. Customer Name (Required)
          CustomTextField(
            controller: _customerNameController,
            label: 'Customer Name *',
            hint: 'e.g. Muhammad Ali',
            prefixIcon: Icons.badge_outlined,
            validator: (val) {
              if (val == null || val.trim().isEmpty) {
                return 'Customer name is required';
              }
              return null;
            },
          ),
          const SizedBox(height: AppDimensions.space12),

          // 2. Phone Number (Required)
          CustomTextField(
            controller: _customerPhoneController,
            label: 'Phone Number *',
            hint: '0300-1234567',
            prefixIcon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
            validator: (val) {
              if (val == null || val.trim().isEmpty) {
                return 'Phone number is required';
              }
              if (val.trim().length < 7) {
                return 'Please enter a valid phone number';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  /// Card 2: Garment Type, Delivery Date & Urgent Toggle
  Widget _buildGarmentAndDeliveryCard() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.space16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x05000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.content_cut_outlined, size: 20, color: AppColors.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Garment & Delivery',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: AppFonts.heading,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const Divider(height: 20, color: Color(0xFFF1F5F9)),

          // 3. Garment Type
          const Text(
            'Garment Type',
            style: TextStyle(
              fontFamily: AppFonts.body,
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: AppStrings.defaultGarments.map((garment) {
              final isSelected = _selectedGarment == garment;
              return ChoiceChip(
                label: Text(garment),
                selected: isSelected,
                selectedColor: AppColors.primary,
                backgroundColor: const Color(0xFFF8FAFC),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(
                    color: isSelected ? AppColors.primary : const Color(0xFFE2E8F0),
                  ),
                ),
                labelStyle: TextStyle(
                  fontFamily: AppFonts.body,
                  color: isSelected ? Colors.white : const Color(0xFF334155),
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  fontSize: 13,
                ),
                onSelected: (val) {
                  if (val) setState(() => _selectedGarment = garment);
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 16),

          // 4. Delivery Date & 5. Urgent Switch
          Row(
            children: [
              // Delivery Date Tile
              Expanded(
                child: InkWell(
                  onTap: _selectDeadlineDate,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Delivery Date',
                          style: TextStyle(
                            fontFamily: AppFonts.body,
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textMuted,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(
                              Icons.calendar_month_outlined,
                              size: 16,
                              color: AppColors.secondary,
                            ),
                            const SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                DateFormatter.formatDate(_targetDeadline),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontFamily: AppFonts.body,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13.5,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Urgent Check Tile (Check icon with name instead of toggle)
              InkWell(
                onTap: () => setState(() => _isUrgent = !_isUrgent),
                borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: _isUrgent ? const Color(0xFFFEF2F2) : const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                    border: Border.all(
                      color: _isUrgent ? const Color(0xFFFECACA) : const Color(0xFFE2E8F0),
                      width: _isUrgent ? 1.5 : 1.0,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          color: _isUrgent ? const Color(0xFFDC2626) : Colors.transparent,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: _isUrgent ? const Color(0xFFDC2626) : const Color(0xFF94A3B8),
                            width: 1.8,
                          ),
                        ),
                        child: _isUrgent
                            ? const Icon(
                                Icons.check_rounded,
                                size: 16,
                                color: Colors.white,
                              )
                            : null,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Urgent',
                        style: TextStyle(
                          fontFamily: AppFonts.body,
                          fontWeight: FontWeight.w700,
                          fontSize: 13.5,
                          color: _isUrgent ? const Color(0xFFDC2626) : const Color(0xFF475569),
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
    );
  }

  /// Card 3: Just Payment Price (clean single field, no extra complexity)
  Widget _buildPriceCard() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.space16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x05000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.payments_outlined, size: 20, color: AppColors.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Payment',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: AppFonts.heading,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const Divider(height: 20, color: Color(0xFFF1F5F9)),

          // 6. Just Payment Price
          CustomTextField(
            controller: _priceController,
            label: 'Payment Price',
            hint: '1800',
            prefixText: 'Rs',
            keyboardType: TextInputType.number,
            validator: (val) {
              if (val == null || val.trim().isEmpty) {
                return 'Please enter payment price';
              }
              if (double.tryParse(val.trim()) == null) {
                return 'Enter a valid number';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  /// Card 4: Measurements Grid
  Widget _buildMeasurementsCard() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.space16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x05000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.straighten, size: 20, color: AppColors.secondary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Measurements (Inches)',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: AppFonts.heading,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const Divider(height: 20, color: Color(0xFFF1F5F9)),

          // 7. Measurement Grid
          MeasurementGridInput(
            controllers: _measurementControllers,
          ),
        ],
      ),
    );
  }

  /// Action button to save order
  Widget _buildSaveButton() {
    return CustomButton(
      text: widget.orderId != null ? 'Update Order' : 'Save Order',
      icon: Icons.check_circle_outline,
      onPressed: _saveOrder,
    );
  }
}
