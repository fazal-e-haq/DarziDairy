import 'measurement.dart';

/// Pure Customer domain entity
class CustomerEntity {
  final int id;
  final String customerId;
  final String name;
  final String phone;
  final String? secondaryPhone;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<MeasurementProfileEntity> measurementProfiles;

  const CustomerEntity({
    required this.id,
    required this.customerId,
    required this.name,
    required this.phone,
    this.secondaryPhone,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
    this.measurementProfiles = const [],
  });
}
