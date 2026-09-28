import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:darzi_dairy/features/customers/presentation/providers/customer_list_provider.dart';
import 'package:darzi_dairy/features/customers/domain/entities/customer.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/responsive_layout.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../../../../shared/widgets/fabric_photo_picker.dart';
import '../../../../shared/widgets/measurement_grid_input.dart';
import '../providers/order_list_provider.dart';
import '../../domain/entities/order_entity.dart';

/// Production step-by-step unified order builder screen with real-time financial balance preview
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

  CustomerEntity? _selectedCustomer;
  String _selectedGarment = AppStrings.defaultGarments.first;
  final TextEditingController _tokenController = TextEditingController();
  DateTime _targetDeadline = DateTime.now().add(const Duration(days: 4));
  bool _isUrgent = false;

  // Financial inputs
  final TextEditingController _stitchingRateController = TextEditingController(text: '1800');
  final TextEditingController _fabricChargesController = TextEditingController(text: '0');
  final TextEditingController _urgentSurchargeController = TextEditingController(text: '0');
  final TextEditingController _advancePaidController = TextEditingController(text: '500');

  // Attachments & measurements
  final List<String> _fabricImagePaths = [];
  final Map<String, TextEditingController> _measurementControllers = {};

  @override
  void initState() {
    super.initState();
    _tokenController.text = '#B-${100 + (DateTime.now().millisecondsSinceEpoch % 900)}';

    for (final label in AppStrings.standardMeasurementKeys) {
      _measurementControllers[label] = TextEditingController();
    }

    _stitchingRateController.addListener(_onPriceChanged);
    _fabricChargesController.addListener(_onPriceChanged);
    _urgentSurchargeController.addListener(_onPriceChanged);
    _advancePaidController.addListener(_onPriceChanged);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final customers = context.read<CustomerListProvider>().allCustomers;
      if (customers.isNotEmpty) {
        _onCustomerChanged(customers.first);
      }
    });
  }

  void _onPriceChanged() {
    setState(() {});
  }

  void _onCustomerChanged(CustomerEntity customer) {
    setState(() {
      _selectedCustomer = customer;
      // Pre-fill measurements if available
      final matches = customer.measurementProfiles.where((p) => p.garmentType == _selectedGarment);
      if (matches.isNotEmpty) {
        final profile = matches.first;
        for (final v in profile.values) {
          if (_measurementControllers.containsKey(v.label)) {
            _measurementControllers[v.label]!.text = v.value.toString();
          }
        }
      }
    });
  }

  @override
  void dispose() {
    _tokenController.dispose();
    _stitchingRateController.dispose();
    _fabricChargesController.dispose();
    _urgentSurchargeController.dispose();
    _advancePaidController.dispose();
    for (final c in _measurementControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  double get _stitchingRate => double.tryParse(_stitchingRateController.text) ?? 0.0;
  double get _fabricCharges => double.tryParse(_fabricChargesController.text) ?? 0.0;
  double get _urgentSurcharge => double.tryParse(_urgentSurchargeController.text) ?? 0.0;
  double get _advancePaid => double.tryParse(_advancePaidController.text) ?? 0.0;
  double get _totalBill => _stitchingRate + _fabricCharges + _urgentSurcharge;
  double get _balanceDue => _totalBill - _advancePaid;

  Future<void> _pickDeadline() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _targetDeadline,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() => _targetDeadline = picked);
    }
  }

  Future<void> _submitOrder() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCustomer == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a customer for this order')),
      );
      return;
    }

    final newOrder = OrderEntity(
      id: widget.orderId ?? 0,
      orderToken: _tokenController.text.trim(),
      customerId: _selectedCustomer!.id,
      customerName: _selectedCustomer!.name,
      customerPhone: _selectedCustomer!.phone,
      garmentType: _selectedGarment,
      fabricImagePaths: _fabricImagePaths,
      bookingDate: DateTime.now(),
      targetDeadline: _targetDeadline,
      isUrgent: _isUrgent,
      status: OrderStatus.pending,
      stitchingRate: _stitchingRate,
      fabricCharges: _fabricCharges,
      urgentSurcharge: _urgentSurcharge,
      advancePaid: _advancePaid,
    );

    final messenger = ScaffoldMessenger.of(context);
    final nav = Navigator.of(context);
    final orderProvider = context.read<OrderListProvider>();

    await orderProvider.repository.saveOrder(newOrder);
    await orderProvider.loadOrders();

    messenger.showSnackBar(
      SnackBar(content: Text('Order ${newOrder.orderToken} booked successfully!')),
    );
    nav.pop();
  }

  @override
  Widget build(BuildContext context) {
    final customers = context.watch<CustomerListProvider>().allCustomers;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Book New Workshop Order'),
      ),
      body: Form(
        key: _formKey,
        child: ResponsiveLayout.builder(
          builder: (context, constraints, screenType) {
            final isUnfolded = screenType == ScreenType.unfolded;

            return SingleChildScrollView(
              padding: context.responsiveScreenPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Form Grid / Column
                  if (isUnfolded)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: _buildCustomerAndGarmentSection(customers)),
                        const SizedBox(width: AppDimensions.space20),
                        Expanded(child: _buildMeasurementsSection()),
                      ],
                    )
                  else ...[
                    _buildCustomerAndGarmentSection(customers),
                    const SizedBox(height: AppDimensions.space16),
                    _buildMeasurementsSection(),
                  ],

                  const SizedBox(height: AppDimensions.space16),

                  // Job Attributes & Pricing
                  if (isUnfolded)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: _buildJobAttributesSection()),
                        const SizedBox(width: AppDimensions.space20),
                        Expanded(child: _buildFinancialSection()),
                      ],
                    )
                  else ...[
                    _buildJobAttributesSection(),
                    const SizedBox(height: AppDimensions.space16),
                    _buildFinancialSection(),
                  ],

                  const SizedBox(height: AppDimensions.space24),

                  // Submit Action Button
                  CustomButton(
                    label: 'Book Order & Print Token',
                    icon: Icons.check_circle_outline,
                    onPressed: _submitOrder,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCustomerAndGarmentSection(List<CustomerEntity> customers) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.space16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '1. Customer & Garment Specification',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: AppDimensions.space16),

            // Customer Selector Dropdown
            DropdownButtonFormField<CustomerEntity>(
              initialValue: _selectedCustomer,
              isExpanded: true,
              decoration: const InputDecoration(labelText: 'Select Customer *'),
              items: customers.map((c) {
                return DropdownMenuItem<CustomerEntity>(
                  value: c,
                  child: Text('${c.name} (${c.phone})'),
                );
              }).toList(),
              onChanged: (val) {
                if (val != null) _onCustomerChanged(val);
              },
            ),
            const SizedBox(height: AppDimensions.space12),

            // Garment Type Selector
            DropdownButtonFormField<String>(
              initialValue: _selectedGarment,
              decoration: const InputDecoration(labelText: 'Garment Category'),
              items: AppStrings.defaultGarments.map((g) {
                return DropdownMenuItem(value: g, child: Text(g));
              }).toList(),
              onChanged: (val) {
                if (val != null) {
                  setState(() => _selectedGarment = val);
                  if (_selectedCustomer != null) _onCustomerChanged(_selectedCustomer!);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMeasurementsSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.space16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '2. Garment Measurements',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                Text(
                  _selectedGarment,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primary),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.space12),
            MeasurementGridInput(controllers: _measurementControllers),
          ],
        ),
      ),
    );
  }

  Widget _buildJobAttributesSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.space16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '3. Workshop Token & Delivery Deadline',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: AppDimensions.space16),

            // Chalk Token Tag
            CustomTextField(
              label: 'Fabric Chalk Token ID *',
              controller: _tokenController,
              hint: 'e.g. #B-105',
              validator: (v) => v == null || v.trim().isEmpty ? 'Token ID required' : null,
            ),
            const SizedBox(height: AppDimensions.space12),

            // Delivery Deadline Picker
            InkWell(
              onTap: _pickDeadline,
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Promised Delivery Deadline',
                  suffixIcon: Icon(Icons.calendar_month, color: AppColors.primary),
                ),
                child: Text(
                  '${DateFormatter.formatShortDate(_targetDeadline)} (${DateFormatter.formatDeadline(_targetDeadline)})',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),
            const SizedBox(height: AppDimensions.space12),

            // Urgent Toggle
            SwitchListTile.adaptive(
              contentPadding: EdgeInsets.zero,
              title: const Text('Mark as Urgent Order', style: TextStyle(fontWeight: FontWeight.w600)),
              subtitle: const Text('Highlights order in crimson red and places it at top of workshop queue'),
              activeTrackColor: AppColors.statusError,
              value: _isUrgent,
              onChanged: (val) {
                setState(() {
                  _isUrgent = val;
                  if (val && _urgentSurchargeController.text == '0') {
                    _urgentSurchargeController.text = '300';
                  } else if (!val && _urgentSurchargeController.text == '300') {
                    _urgentSurchargeController.text = '0';
                  }
                });
              },
            ),
            const SizedBox(height: AppDimensions.space12),

            // Fabric Photo Attachments
            FabricPhotoPicker(
              imagePaths: _fabricImagePaths,
              onImageAdded: (path) => setState(() => _fabricImagePaths.add(path)),
              onImageRemoved: (index) => setState(() => _fabricImagePaths.removeAt(index)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFinancialSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.space16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '4. Pricing & Deposit Ledger',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: AppDimensions.space16),

            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    label: 'Stitching Labor Rate',
                    controller: _stitchingRateController,
                    isNumericOnly: true,
                    prefixText: 'Rs. ',
                  ),
                ),
                const SizedBox(width: AppDimensions.space12),
                Expanded(
                  child: CustomTextField(
                    label: 'Fabric Add-on',
                    controller: _fabricChargesController,
                    isNumericOnly: true,
                    prefixText: 'Rs. ',
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.space12),

            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    label: 'Urgent Surcharge',
                    controller: _urgentSurchargeController,
                    isNumericOnly: true,
                    prefixText: 'Rs. ',
                  ),
                ),
                const SizedBox(width: AppDimensions.space12),
                Expanded(
                  child: CustomTextField(
                    label: 'Advance Deposit Received',
                    controller: _advancePaidController,
                    isNumericOnly: true,
                    prefixText: 'Rs. ',
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.space16),

            // Live Real-Time Financial Balance Due Calculator Preview
            Container(
              padding: const EdgeInsets.all(AppDimensions.space16),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: AppDimensions.roundedMedium,
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total Stitching Price:', style: TextStyle(color: Colors.white70, fontSize: 13)),
                      Text(CurrencyFormatter.format(_totalBill), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Advance Deposit Paid:', style: TextStyle(color: Colors.white70, fontSize: 13)),
                      Text(CurrencyFormatter.format(_advancePaid), style: const TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold, fontSize: 15)),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Divider(color: Colors.white24),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Due on Delivery:', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                      Text(
                        CurrencyFormatter.format(_balanceDue),
                        style: const TextStyle(color: AppColors.secondary, fontWeight: FontWeight.w900, fontSize: 20),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
