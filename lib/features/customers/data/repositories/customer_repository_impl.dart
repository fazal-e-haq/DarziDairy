import '../../domain/entities/customer.dart';
import '../../domain/entities/measurement.dart';
import '../../domain/repositories/i_customer_repository.dart';
import '../datasources/customer_local_datasource.dart';
import '../models/customer_collection.dart';
import '../models/measurement_collection.dart';

/// Concrete customer repository implementation
class CustomerRepositoryImpl implements ICustomerRepository {
  final CustomerLocalDataSource localDataSource;

  CustomerRepositoryImpl({required this.localDataSource});

  @override
  Future<List<CustomerEntity>> getAllCustomers() async {
    final list = await localDataSource.getCustomers();
    return list.map(_toEntity).toList();
  }

  @override
  Future<CustomerEntity?> getCustomerById(int id) async {
    final model = await localDataSource.getCustomerById(id);
    return model != null ? _toEntity(model) : null;
  }

  @override
  Future<List<CustomerEntity>> searchCustomers(String query) async {
    final list = await localDataSource.search(query);
    return list.map(_toEntity).toList();
  }

  @override
  Future<int> saveCustomer(CustomerEntity customer) async {
    final model = _toModel(customer);
    return localDataSource.putCustomer(model);
  }

  @override
  Future<void> deleteCustomer(int id) async {
    await localDataSource.deleteCustomer(id);
  }

  @override
  Future<void> saveMeasurementProfile(int customerId, MeasurementProfileEntity profile) async {
    final model = _toProfileModel(profile);
    await localDataSource.saveMeasurementProfile(customerId, model);
  }

  @override
  Stream<List<CustomerEntity>> watchCustomers() {
    return localDataSource.watchCustomers().map(
          (models) => models.map(_toEntity).toList(),
        );
  }

  static CustomerEntity _toEntity(CustomerCollection m) {
    return CustomerEntity(
      id: m.id,
      customerId: 'CUST-${m.id}',
      name: m.name,
      phone: m.phone,
      secondaryPhone: m.secondaryPhone,
      notes: m.notes,
      createdAt: m.createdAt,
      updatedAt: m.updatedAt,
      measurementProfiles: m.measurements.map((p) {
        return MeasurementProfileEntity(
          garmentType: p.garmentType,
          title: p.title,
          updatedAt: p.updatedAt,
          values: p.values.map((v) => MeasurementValueEntity(label: v.label, value: v.value)).toList(),
        );
      }).toList(),
    );
  }

  static CustomerCollection _toModel(CustomerEntity e) {
    final m = CustomerCollection()
      ..name = e.name
      ..phone = e.phone
      ..secondaryPhone = e.secondaryPhone
      ..notes = e.notes
      ..createdAt = e.createdAt
      ..updatedAt = e.updatedAt
      ..measurements = e.measurementProfiles.map(_toProfileModel).toList();
    if (e.id > 0) {
      m.id = e.id;
    }
    return m;
  }

  static MeasurementProfileModel _toProfileModel(MeasurementProfileEntity p) {
    return MeasurementProfileModel()
      ..garmentType = p.garmentType
      ..title = p.title
      ..updatedAt = p.updatedAt
      ..values = p.values.map((v) {
        return MeasurementValueModel()
          ..label = v.label
          ..value = v.value;
      }).toList();
  }
}
