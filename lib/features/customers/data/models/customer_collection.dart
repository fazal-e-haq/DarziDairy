import 'measurement_collection.dart';

/// Customer collection model for persistence
class CustomerCollection {
  int id = 0;

  String name = '';
  String phone = '';

  String? secondaryPhone;
  String? notes;

  DateTime createdAt = DateTime.now();
  DateTime updatedAt = DateTime.now();

  List<MeasurementProfileModel> measurements = [];
}
