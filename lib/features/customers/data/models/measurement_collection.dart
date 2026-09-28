import 'package:isar/isar.dart';

part 'measurement_collection.g.dart';

/// Embedded measurement value model
@embedded
class MeasurementValueModel {
  String label = '';
  double value = 0.0;
}

/// Embedded measurement profile model
@embedded
class MeasurementProfileModel {
  String garmentType = '';
  String title = 'Default';
  List<MeasurementValueModel> values = [];
  DateTime updatedAt = DateTime.now();
}
