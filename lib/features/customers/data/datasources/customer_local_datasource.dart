import 'dart:async';
import '../models/customer_collection.dart';
import '../models/measurement_collection.dart';

/// In-memory datasource for customer directory and measurement sheets
class CustomerLocalDataSource {
  static final List<CustomerCollection> _store = [];
  static int _nextId = 1;

  Future<List<CustomerCollection>> getCustomers() async {
    return List<CustomerCollection>.from(_store)
      ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
  }

  Future<CustomerCollection?> getCustomerById(int id) async {
    try {
      return _store.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<List<CustomerCollection>> search(String query) async {
    if (query.trim().isEmpty) return getCustomers();
    final lower = query.trim().toLowerCase();
    return _store.where((c) {
      return c.name.toLowerCase().contains(lower) || c.phone.contains(lower);
    }).toList();
  }

  Future<int> putCustomer(CustomerCollection customer) async {
    if (customer.id == 0) {
      customer.id = _nextId++;
      _store.add(customer);
    } else {
      final index = _store.indexWhere((c) => c.id == customer.id);
      if (index >= 0) {
        _store[index] = customer;
      } else {
        _store.add(customer);
      }
    }
    return customer.id;
  }

  Future<void> deleteCustomer(int id) async {
    _store.removeWhere((c) => c.id == id);
  }

  Future<void> saveMeasurementProfile(int customerId, MeasurementProfileModel profile) async {
    final customer = await getCustomerById(customerId);
    if (customer != null) {
      final list = List<MeasurementProfileModel>.from(customer.measurements);
      final existingIndex = list.indexWhere((p) => p.garmentType == profile.garmentType);
      if (existingIndex >= 0) {
        list[existingIndex] = profile;
      } else {
        list.add(profile);
      }
      customer.measurements = list;
      customer.updatedAt = DateTime.now();
    }
  }

  Stream<List<CustomerCollection>> watchCustomers() {
    return Stream.value(List<CustomerCollection>.from(_store));
  }
}
