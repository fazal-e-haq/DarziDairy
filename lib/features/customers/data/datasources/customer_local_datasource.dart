import 'package:isar/isar.dart';
import 'package:darzi_dairy/core/database/isar_service.dart';
import '../models/customer_collection.dart';
import '../models/measurement_collection.dart';

/// Direct Isar datasource for customer directory and measurement sheets with defensive fallback
class CustomerLocalDataSource {
  Isar? get _isar => IsarService.instance.isOpen ? IsarService.instance.isar : null;

  Future<List<CustomerCollection>> getCustomers() async {
    final db = _isar;
    if (db == null) return [];
    return db.customerCollections.where().sortByName().findAll();
  }

  Future<CustomerCollection?> getCustomerById(int id) async {
    final db = _isar;
    if (db == null) return null;
    return db.customerCollections.get(id);
  }

  Future<List<CustomerCollection>> search(String query) async {
    final db = _isar;
    if (db == null) return [];
    if (query.trim().isEmpty) return getCustomers();
    final lower = query.trim().toLowerCase();
    return db.customerCollections
        .filter()
        .nameContains(lower, caseSensitive: false)
        .or()
        .phoneContains(lower)
        .findAll();
  }

  Future<int> putCustomer(CustomerCollection customer) async {
    final db = _isar;
    if (db == null) return customer.id;
    return db.writeTxn(() => db.customerCollections.put(customer));
  }

  Future<void> deleteCustomer(int id) async {
    final db = _isar;
    if (db == null) return;
    await db.writeTxn(() => db.customerCollections.delete(id));
  }

  Future<void> saveMeasurementProfile(int customerId, MeasurementProfileModel profile) async {
    final db = _isar;
    if (db == null) return;
    final customer = await db.customerCollections.get(customerId);
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
      await db.writeTxn(() => db.customerCollections.put(customer));
    }
  }

  Stream<List<CustomerCollection>> watchCustomers() {
    final db = _isar;
    if (db == null) return Stream.value([]);
    return db.customerCollections.where().sortByName().watch(fireImmediately: true);
  }
}
