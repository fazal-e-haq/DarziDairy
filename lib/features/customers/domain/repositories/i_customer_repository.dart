import '../entities/customer.dart';
import '../entities/measurement.dart';

/// Abstract repository contract for customer operations
abstract class ICustomerRepository {
  Future<List<CustomerEntity>> getAllCustomers();
  Future<CustomerEntity?> getCustomerById(int id);
  Future<List<CustomerEntity>> searchCustomers(String query);
  Future<int> saveCustomer(CustomerEntity customer);
  Future<void> deleteCustomer(int id);
  Future<void> saveMeasurementProfile(int customerId, MeasurementProfileEntity profile);
  Stream<List<CustomerEntity>> watchCustomers();
}
