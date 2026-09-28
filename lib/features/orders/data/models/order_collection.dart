import 'package:isar/isar.dart';

part 'order_collection.g.dart';

/// Isar model for Order persistence
@collection
class OrderCollection {
  Id id = Isar.autoIncrement;

  @Index(type: IndexType.hash)
  String orderToken = '';

  int customerId = 0;
  String customerName = '';
  String customerPhone = '';
  String garmentType = '';
  List<String> fabricImagePaths = [];

  DateTime bookingDate = DateTime.now();

  @Index()
  DateTime targetDeadline = DateTime.now();

  bool isUrgent = false;

  @Index()
  int status = 0;

  double stitchingRate = 0.0;
  double fabricCharges = 0.0;
  double urgentSurcharge = 0.0;
  double advancePaid = 0.0;
  double balanceDue = 0.0;

  @Index()
  bool isDeleted = false;

  DateTime? deletedAt;
}
