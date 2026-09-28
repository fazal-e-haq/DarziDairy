/// Data model for Order persistence
class OrderCollection {
  int id = 0;

  String orderToken = '';

  int customerId = 0;
  String customerName = '';
  String customerPhone = '';
  String garmentType = '';

  DateTime bookingDate = DateTime.now();

  DateTime targetDeadline = DateTime.now();

  bool isUrgent = false;

  int status = 0;

  double stitchingRate = 0.0;
  double fabricCharges = 0.0;
  double urgentSurcharge = 0.0;
  double advancePaid = 0.0;
  double balanceDue = 0.0;

  bool isDeleted = false;

  DateTime? deletedAt;
}
