import 'package:isar/isar.dart';
import 'measurement_collection.dart';

part 'customer_collection.g.dart';

/// Customer collection model for Isar DB persistence
@collection
class CustomerCollection {
  Id id = Isar.autoIncrement;

  @Index(type: IndexType.value, caseSensitive: false)
  String name = '';

  @Index(type: IndexType.hash)
  String phone = '';

  String? secondaryPhone;
  String? notes;

  DateTime createdAt = DateTime.now();
  DateTime updatedAt = DateTime.now();

  List<MeasurementProfileModel> measurements = [];
}
