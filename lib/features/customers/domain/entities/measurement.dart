/// Single measurement item representing key/value pair (e.g. Chest: 38.5)
class MeasurementValueEntity {
  final String label;
  final double value;

  const MeasurementValueEntity({
    required this.label,
    required this.value,
  });
}

/// Garment measurement profile (e.g. Kurta Pajama profile)
class MeasurementProfileEntity {
  final String garmentType;
  final String title;
  final List<MeasurementValueEntity> values;
  final DateTime updatedAt;

  const MeasurementProfileEntity({
    required this.garmentType,
    this.title = 'Default',
    required this.values,
    required this.updatedAt,
  });
}
