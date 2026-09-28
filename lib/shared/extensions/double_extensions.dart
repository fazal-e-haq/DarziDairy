/// Measurement and currency helper extensions for double
extension DoubleExtensions on double {
  /// Formats measurement value removing redundant trailing .0 (e.g. 38.0 -> "38", 38.5 -> "38.5")
  String toCleanMeasurementString() {
    if (this == toInt().toDouble()) {
      return toInt().toString();
    }
    return toStringAsFixed(1);
  }

  /// Formats to 2 decimal currency string
  String toPriceString() {
    return toStringAsFixed(0);
  }
}
