/// Embedded measurement value model
class MeasurementValueModel {
  String label = '';
  double value = 0.0;
}

/// Embedded measurement profile model
class MeasurementProfileModel {
  String garmentType = '';
  String title = 'Default';
  List<MeasurementValueModel> values = [];
  DateTime updatedAt = DateTime.now();
}
