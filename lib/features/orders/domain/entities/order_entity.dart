/// Workflow Status Enum for Workshop Pipeline
enum OrderStatus {
  pending,
  cutting,
  stitching,
  trialReady,
  completed,
  delivered;

  String get displayName {
    switch (this) {
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.cutting:
        return 'Cutting';
      case OrderStatus.stitching:
        return 'Stitching';
      case OrderStatus.trialReady:
        return 'Trial Ready';
      case OrderStatus.completed:
        return 'Completed';
      case OrderStatus.delivered:
        return 'Delivered';
    }
  }
}

/// Pure Order domain entity
class OrderEntity {
  final int id;
  final String orderToken;
  final int customerId;
  final String customerName;
  final String customerPhone;
  final String garmentType;
  final List<String> fabricImagePaths;
  final DateTime bookingDate;
  final DateTime targetDeadline;
  final bool isUrgent;
  final OrderStatus status;
  final double stitchingRate;
  final double fabricCharges;
  final double urgentSurcharge;
  final double advancePaid;
  final bool isDeleted;
  final DateTime? deletedAt;

  const OrderEntity({
    required this.id,
    required this.orderToken,
    required this.customerId,
    required this.customerName,
    required this.customerPhone,
    required this.garmentType,
    this.fabricImagePaths = const [],
    required this.bookingDate,
    required this.targetDeadline,
    this.isUrgent = false,
    this.status = OrderStatus.pending,
    this.stitchingRate = 0.0,
    this.fabricCharges = 0.0,
    this.urgentSurcharge = 0.0,
    this.advancePaid = 0.0,
    this.isDeleted = false,
    this.deletedAt,
  });

  double get totalBill => stitchingRate + fabricCharges + urgentSurcharge;
  double get balanceDue => totalBill - advancePaid;
  bool get isFullyPaid => balanceDue <= 0;
}
