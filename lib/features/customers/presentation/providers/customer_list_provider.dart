import 'package:flutter/foundation.dart';
import '../../domain/entities/customer.dart';
import '../../domain/entities/measurement.dart';
import '../../domain/repositories/i_customer_repository.dart';

/// Provider for reactive customer listing, search filter, and selection
class CustomerListProvider extends ChangeNotifier {
  final ICustomerRepository repository;

  CustomerListProvider({required this.repository}) {
    loadCustomers();
  }

  List<CustomerEntity> _allCustomers = [];
  CustomerEntity? _selectedCustomer;
  String _searchQuery = '';
  bool _isLoading = false;

  List<CustomerEntity> get allCustomers => _allCustomers;
  CustomerEntity? get selectedCustomer => _selectedCustomer;
  String get searchQuery => _searchQuery;
  bool get isLoading => _isLoading;

  List<CustomerEntity> get filteredCustomers {
    if (_searchQuery.trim().isEmpty) return _allCustomers;
    final query = _searchQuery.trim().toLowerCase();
    return _allCustomers.where((c) {
      return c.name.toLowerCase().contains(query) || c.phone.contains(query);
    }).toList();
  }

  Future<void> loadCustomers() async {
    _isLoading = true;
    notifyListeners();

    _allCustomers = await repository.getAllCustomers();

    if (_allCustomers.isEmpty) {
      await _seedSampleCustomers();
      _allCustomers = await repository.getAllCustomers();
    }

    if (_selectedCustomer == null && _allCustomers.isNotEmpty) {
      _selectedCustomer = _allCustomers.first;
    }

    _isLoading = false;
    notifyListeners();
  }

  void search(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void selectCustomer(CustomerEntity customer) {
    _selectedCustomer = customer;
    notifyListeners();
  }

  Future<void> saveCustomer(CustomerEntity customer) async {
    await repository.saveCustomer(customer);
    await loadCustomers();
  }

  Future<void> deleteCustomer(int customerId) async {
    await repository.deleteCustomer(customerId);
    await loadCustomers();
  }

  Future<void> _seedSampleCustomers() async {
    final now = DateTime.now();
    final sampleCustomers = [
      CustomerEntity(
        id: 0,
        customerId: 'CUST-101',
        name: 'Chaudhry Nadeem',
        phone: '0300-8452199',
        secondaryPhone: '0301-7654321',
        notes: 'VIP Client. Prefers soft cotton fabrics and spread collars.',
        createdAt: now.subtract(const Duration(days: 30)),
        updatedAt: now,
        measurementProfiles: [
          MeasurementProfileEntity(
            garmentType: 'Kurta Pajama',
            title: 'Standard Eid Fit',
            updatedAt: now,
            values: const [
              MeasurementValueEntity(label: 'Length', value: 40.5),
              MeasurementValueEntity(label: 'Chest', value: 42.0),
              MeasurementValueEntity(label: 'Waist', value: 38.0),
              MeasurementValueEntity(label: 'Shoulder', value: 18.5),
              MeasurementValueEntity(label: 'Sleeve', value: 24.5),
              MeasurementValueEntity(label: 'Neck', value: 16.0),
              MeasurementValueEntity(label: 'Inseam', value: 38.0),
              MeasurementValueEntity(label: 'Pancha', value: 8.5),
            ],
          ),
          MeasurementProfileEntity(
            garmentType: 'Waistcoat',
            title: 'Festive Fit',
            updatedAt: now,
            values: const [
              MeasurementValueEntity(label: 'Length', value: 27.5),
              MeasurementValueEntity(label: 'Chest', value: 42.5),
              MeasurementValueEntity(label: 'Waist', value: 39.0),
              MeasurementValueEntity(label: 'Shoulder', value: 17.5),
            ],
          ),
        ],
      ),
      CustomerEntity(
        id: 0,
        customerId: 'CUST-102',
        name: 'Sheikh Tariq',
        phone: '0321-4567890',
        secondaryPhone: null,
        notes: 'Double cuff suit fittings only.',
        createdAt: now.subtract(const Duration(days: 60)),
        updatedAt: now,
        measurementProfiles: [
          MeasurementProfileEntity(
            garmentType: 'Two-Piece Suit',
            title: 'Executive Fit',
            updatedAt: now,
            values: const [
              MeasurementValueEntity(label: 'Coat Length', value: 30.0),
              MeasurementValueEntity(label: 'Chest', value: 44.0),
              MeasurementValueEntity(label: 'Waist', value: 40.0),
              MeasurementValueEntity(label: 'Shoulder', value: 19.0),
              MeasurementValueEntity(label: 'Sleeve', value: 25.0),
              MeasurementValueEntity(label: 'Trouser Length', value: 41.0),
              MeasurementValueEntity(label: 'Trouser Waist', value: 38.0),
              MeasurementValueEntity(label: 'Pancha', value: 7.5),
            ],
          ),
        ],
      ),
      CustomerEntity(
        id: 0,
        customerId: 'CUST-103',
        name: 'Bilal Farooq',
        phone: '0333-9876543',
        notes: 'Regular customer from Model Town.',
        createdAt: now.subtract(const Duration(days: 15)),
        updatedAt: now,
        measurementProfiles: [
          MeasurementProfileEntity(
            garmentType: 'Shalwar Kameez',
            title: 'Relaxed Fit',
            updatedAt: now,
            values: const [
              MeasurementValueEntity(label: 'Length', value: 39.0),
              MeasurementValueEntity(label: 'Chest', value: 40.0),
              MeasurementValueEntity(label: 'Waist', value: 36.0),
              MeasurementValueEntity(label: 'Shoulder', value: 17.5),
              MeasurementValueEntity(label: 'Sleeve', value: 23.5),
              MeasurementValueEntity(label: 'Neck', value: 15.5),
              MeasurementValueEntity(label: 'Shalwar Length', value: 39.0),
              MeasurementValueEntity(label: 'Pancha', value: 9.0),
            ],
          ),
        ],
      ),
    ];

    for (final c in sampleCustomers) {
      await repository.saveCustomer(c);
    }
  }
}
