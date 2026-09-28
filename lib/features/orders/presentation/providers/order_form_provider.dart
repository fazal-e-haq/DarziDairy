import 'package:flutter/foundation.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/repositories/i_order_repository.dart';

/// Provider for creating and calculating order financials
class OrderFormProvider extends ChangeNotifier {
  final IOrderRepository repository;

  OrderFormProvider({required this.repository});

  double _stitchingRate = 0.0;
  double _fabricCharges = 0.0;
  double _urgentSurcharge = 0.0;
  double _advancePaid = 0.0;

  double get stitchingRate => _stitchingRate;
  double get fabricCharges => _fabricCharges;
  double get urgentSurcharge => _urgentSurcharge;
  double get advancePaid => _advancePaid;

  double get totalBill => _stitchingRate + _fabricCharges + _urgentSurcharge;
  double get balanceDue => totalBill - _advancePaid;

  void updateRates({
    double? stitchingRate,
    double? fabricCharges,
    double? urgentSurcharge,
    double? advancePaid,
  }) {
    if (stitchingRate != null) _stitchingRate = stitchingRate;
    if (fabricCharges != null) _fabricCharges = fabricCharges;
    if (urgentSurcharge != null) _urgentSurcharge = urgentSurcharge;
    if (advancePaid != null) _advancePaid = advancePaid;
    notifyListeners();
  }

  Future<bool> submitOrder(OrderEntity order) async {
    try {
      await repository.saveOrder(order);
      return true;
    } catch (_) {
      return false;
    }
  }
}
