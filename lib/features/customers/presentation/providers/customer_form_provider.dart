import 'package:flutter/foundation.dart';
import '../../domain/entities/customer.dart';
import '../../domain/repositories/i_customer_repository.dart';

/// Provider for adding/editing customer and measurements
class CustomerFormProvider extends ChangeNotifier {
  final ICustomerRepository repository;

  CustomerFormProvider({required this.repository});

  bool _isSaving = false;
  bool get isSaving => _isSaving;

  Future<bool> saveCustomer(CustomerEntity customer) async {
    _isSaving = true;
    notifyListeners();
    try {
      await repository.saveCustomer(customer);
      _isSaving = false;
      notifyListeners();
      return true;
    } catch (_) {
      _isSaving = false;
      notifyListeners();
      return false;
    }
  }
}
