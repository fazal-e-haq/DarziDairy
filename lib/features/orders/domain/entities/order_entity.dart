/// Workflow Status Enum - simplified to Active and Completed
enum OrderStatus {
  active,
  completed;

  String get displayName => this == OrderStatus.active ? 'Active' : 'Completed';
}

/// Pure Order domain entity
class OrderEntity {
  final int id;
  final String orderToken;
  final int customerId;
  final String customerName;
  final String customerPhone;
  final String garmentType;
  final DateTime bookingDate;
  final DateTime targetDeadline;
  final bool isUrgent;
  final OrderStatus status;
  final double stitchingRate;
  final double fabricCharges;
  final double urgentSurcharge;
  final double advancePaid;
  final Map<String, String> measurements;
  final bool isDeleted;
  final DateTime? deletedAt;

  const OrderEntity({
    required this.id,
    required this.orderToken,
    required this.customerId,
    required this.customerName,
    required this.customerPhone,
    required this.garmentType,
    required this.bookingDate,
    required this.targetDeadline,
    this.isUrgent = false,
    this.status = OrderStatus.active,
    this.stitchingRate = 0.0,
    this.fabricCharges = 0.0,
    this.urgentSurcharge = 0.0,
    this.advancePaid = 0.0,
    this.measurements = const {},
    this.isDeleted = false,
    this.deletedAt,
  });

  double get totalBill => stitchingRate + fabricCharges + urgentSurcharge;
  double get balanceDue => totalBill - advancePaid;
  bool get isFullyPaid => balanceDue <= 0;
  bool get isCompleted => status == OrderStatus.completed;

  OrderEntity copyWith({
    int? id,
    String? orderToken,
    int? customerId,
    String? customerName,
    String? customerPhone,
    String? garmentType,
    DateTime? bookingDate,
    DateTime? targetDeadline,
    bool? isUrgent,
    OrderStatus? status,
    double? stitchingRate,
    double? fabricCharges,
    double? urgentSurcharge,
    double? advancePaid,
    Map<String, String>? measurements,
    bool? isDeleted,
    DateTime? deletedAt,
  }) {
    return OrderEntity(
      id: id ?? this.id,
      orderToken: orderToken ?? this.orderToken,
      customerId: customerId ?? this.customerId,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      garmentType: garmentType ?? this.garmentType,
      bookingDate: bookingDate ?? this.bookingDate,
      targetDeadline: targetDeadline ?? this.targetDeadline,
      isUrgent: isUrgent ?? this.isUrgent,
      status: status ?? this.status,
      stitchingRate: stitchingRate ?? this.stitchingRate,
      fabricCharges: fabricCharges ?? this.fabricCharges,
      urgentSurcharge: urgentSurcharge ?? this.urgentSurcharge,
      advancePaid: advancePaid ?? this.advancePaid,
      measurements: measurements ?? this.measurements,
      isDeleted: isDeleted ?? this.isDeleted,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }
}
