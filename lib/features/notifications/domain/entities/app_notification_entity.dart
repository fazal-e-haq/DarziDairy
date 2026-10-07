/// Types of workshop notifications
enum AppNotificationType {
  overdue,
  dueToday,
  dueTomorrow,
  urgent;

  String get displayName {
    switch (this) {
      case AppNotificationType.overdue:
        return 'Overdue (تاخیر شدہ)';
      case AppNotificationType.dueToday:
        return 'Due Today (آج ڈیلیوری)';
      case AppNotificationType.dueTomorrow:
        return 'Due Tomorrow (کل ڈیلیوری)';
      case AppNotificationType.urgent:
        return 'Urgent Rush (ارجنٹ)';
    }
  }
}

/// Notification Entity representing an order deadline or status alert
class AppNotificationEntity {
  final String id;
  final int orderId;
  final String orderToken;
  final String customerName;
  final String customerPhone;
  final String garmentType;
  final String title;
  final String message;
  final DateTime deadline;
  final AppNotificationType type;
  final bool isRead;

  const AppNotificationEntity({
    required this.id,
    required this.orderId,
    required this.orderToken,
    required this.customerName,
    required this.customerPhone,
    required this.garmentType,
    required this.title,
    required this.message,
    required this.deadline,
    required this.type,
    this.isRead = false,
  });

  AppNotificationEntity copyWith({
    bool? isRead,
  }) {
    return AppNotificationEntity(
      id: id,
      orderId: orderId,
      orderToken: orderToken,
      customerName: customerName,
      customerPhone: customerPhone,
      garmentType: garmentType,
      title: title,
      message: message,
      deadline: deadline,
      type: type,
      isRead: isRead ?? this.isRead,
    );
  }
}
