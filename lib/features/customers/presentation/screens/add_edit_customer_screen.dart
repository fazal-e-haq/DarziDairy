import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../../../../shared/widgets/measurement_grid_input.dart';
import '../providers/customer_list_provider.dart';
import '../../domain/entities/customer.dart';
import '../../domain/entities/measurement.dart';

/// Form screen to register new customer or edit existing measurements
class AddEditCustomerScreen extends StatefulWidget {
  final int? customerId;

  const AddEditCustomerScreen({
    super.key,
    this.customerId,
  });

  @override
  State<AddEditCustomerScreen> createState() => _AddEditCustomerScreenState();
}

class _AddEditCustomerScreenState extends State<AddEditCustomerScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _secondaryPhoneController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  String _selectedGarment = AppStrings.defaultGarments.first;
  final Map<String, TextEditingController> _measurementControllers = {};

  @override
  void initState() {
    super.initState();
    for (final label in AppStrings.standardMeasurementKeys) {
      _measurementControllers[label] = TextEditingController();
    }

    if (widget.customerId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _loadCustomerData());
    }
  }

  void _loadCustomerData() {
    final provider = context.read<CustomerListProvider>();
    final matches = provider.allCustomers.where((c) => c.id == widget.customerId);
    if (matches.isNotEmpty) {
      final customer = matches.first;
      _nameController.text = customer.name;
      _phoneController.text = customer.phone;
      _secondaryPhoneController.text = customer.secondaryPhone ?? '';
      _notesController.text = customer.notes ?? '';

      if (customer.measurementProfiles.isNotEmpty) {
        final profile = customer.measurementProfiles.first;
        _selectedGarment = profile.garmentType;
        for (final val in profile.values) {
          if (_measurementControllers.containsKey(val.label)) {
            _measurementControllers[val.label]!.text = val.value.toString();
          }
        }
      }
      setState(() {});
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _secondaryPhoneController.dispose();
    _notesController.dispose();
    for (final c in _measurementControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _saveCustomer() async {
    if (!_formKey.currentState!.validate()) return;

    final measurementValues = <MeasurementValueEntity>[];
    for (final entry in _measurementControllers.entries) {
      final text = entry.value.text.trim();
      if (text.isNotEmpty) {
        final val = double.tryParse(text) ?? 0.0;
        if (val > 0) {
          measurementValues.add(MeasurementValueEntity(label: entry.key, value: val));
        }
      }
    }

    final now = DateTime.now();
    final profile = MeasurementProfileEntity(
      garmentType: _selectedGarment,
      title: 'Primary Fit',
      updatedAt: now,
      values: measurementValues,
    );

    final customer = CustomerEntity(
      id: widget.customerId ?? 0,
      customerId: 'CUST-${widget.customerId ?? now.millisecondsSinceEpoch % 10000}',
      name: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      secondaryPhone: _secondaryPhoneController.text.trim().isEmpty ? null : _secondaryPhoneController.text.trim(),
      notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
      createdAt: now,
      updatedAt: now,
      measurementProfiles: [profile],
    );

    await context.read<CustomerListProvider>().saveCustomer(customer);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.customerId != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Customer & Khata' : 'Add New Customer'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.space16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Contact Information Card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppDimensions.space16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Customer Contact Information',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: AppDimensions.space16),
                      CustomTextField(
                        label: 'Full Name *',
                        controller: _nameController,
                        hint: 'e.g. Haji Muhammad Aslam',
                        validator: (val) => val == null || val.trim().isEmpty ? 'Customer name is required' : null,
                      ),
                      const SizedBox(height: AppDimensions.space12),
                      CustomTextField(
                        label: 'Mobile Phone *',
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        hint: 'e.g. 0300-1234567',
                        validator: (val) => val == null || val.trim().isEmpty ? 'Phone number is required' : null,
                      ),
                      const SizedBox(height: AppDimensions.space12),
                      CustomTextField(
                        label: 'Secondary Contact / WhatsApp',
                        controller: _secondaryPhoneController,
                        keyboardType: TextInputType.phone,
                        hint: 'Optional alternate number',
                      ),
                      const SizedBox(height: AppDimensions.space12),
                      CustomTextField(
                        label: 'Preferences / Fitting Notes',
                        controller: _notesController,
                        hint: 'e.g. Prefers loose sleeves, double stitch collar',
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppDimensions.space16),

              // Measurement Book Card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppDimensions.space16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Measurement Profile',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                          ),
                          DropdownButton<String>(
                            value: _selectedGarment,
                            underline: const SizedBox.shrink(),
                            items: AppStrings.defaultGarments.map((g) {
                              return DropdownMenuItem(value: g, child: Text(g));
                            }).toList(),
                            onChanged: (val) {
                              if (val != null) setState(() => _selectedGarment = val);
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: AppDimensions.space12),
                      MeasurementGridInput(controllers: _measurementControllers),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppDimensions.space24),

              CustomButton(
                label: isEditing ? 'Update Customer Khata' : 'Save Customer & Measurements',
                icon: Icons.check,
                onPressed: _saveCustomer,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
