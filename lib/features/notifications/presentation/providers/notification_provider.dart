import 'package:flutter/foundation.dart';

import '../../../../core/utils/date_formatter.dart';
import '../../../orders/domain/entities/order_entity.dart';
import '../../domain/entities/app_notification_entity.dart';

/// Provider managing real-time offline workshop notifications & delivery reminders
class NotificationProvider extends ChangeNotifier {
  List<AppNotificationEntity> _notifications = [];
  final Set<String> _readIds = {};
  final Set<String> _dismissedIds = {};

  List<AppNotificationEntity> get notifications => List.unmodifiable(_notifications);

  int get unreadCount => _notifications.where((n) => !n.isRead).length;
  int get overdueCount => _notifications.where((n) => n.type == AppNotificationType.overdue).length;
  int get dueTodayCount => _notifications.where((n) => n.type == AppNotificationType.dueToday).length;
  int get urgentCount => _notifications.where((n) => n.type == AppNotificationType.urgent).length;

  /// Update notifications when orders change
  void updateFromOrders(List<OrderEntity> orders) {
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final tomorrowStart = todayStart.add(const Duration(days: 1));

    final List<AppNotificationEntity> items = [];

    final activeOrders = orders.where((o) => o.status == OrderStatus.active && !o.isDeleted);

    for (final order in activeOrders) {
      final deadlineStart = DateTime(
        order.targetDeadline.year,
        order.targetDeadline.month,
        order.targetDeadline.day,
      );

      final dateStr = DateFormatter.formatDate(order.targetDeadline);

      if (deadlineStart.isBefore(todayStart)) {
        // Overdue Alert
        final id = 'overdue_${order.id}';
        if (!_dismissedIds.contains(id)) {
          items.add(
            AppNotificationEntity(
              id: id,
              orderId: order.id,
              orderToken: order.orderToken,
              customerName: order.customerName,
              customerPhone: order.customerPhone,
              garmentType: order.garmentType,
              title: 'Order ${order.orderToken} is Overdue!',
              message: '${order.customerName} - Delivery was missed on $dateStr.',
              deadline: order.targetDeadline,
              type: AppNotificationType.overdue,
              isRead: _readIds.contains(id),
            ),
          );
        }
      } else if (deadlineStart == todayStart) {
        // Due Today Alert
        final id = 'today_${order.id}';
        if (!_dismissedIds.contains(id)) {
          items.add(
            AppNotificationEntity(
              id: id,
              orderId: order.id,
              orderToken: order.orderToken,
              customerName: order.customerName,
              customerPhone: order.customerPhone,
              garmentType: order.garmentType,
              title: 'Order ${order.orderToken} is Due Today!',
              message: '${order.customerName} (${order.garmentType}) - Scheduled for delivery today.',
              deadline: order.targetDeadline,
              type: AppNotificationType.dueToday,
              isRead: _readIds.contains(id),
            ),
          );
        }
      } else if (deadlineStart == tomorrowStart) {
        // Due Tomorrow Alert
        final id = 'tomorrow_${order.id}';
        if (!_dismissedIds.contains(id)) {
          items.add(
            AppNotificationEntity(
              id: id,
              orderId: order.id,
              orderToken: order.orderToken,
              customerName: order.customerName,
              customerPhone: order.customerPhone,
              garmentType: order.garmentType,
              title: 'Order ${order.orderToken} Due Tomorrow',
              message: '${order.customerName} - Ready tomorrow ($dateStr).',
              deadline: order.targetDeadline,
              type: AppNotificationType.dueTomorrow,
              isRead: _readIds.contains(id),
            ),
          );
        }
      } else if (order.isUrgent) {
        // Urgent Rush Alert
        final id = 'urgent_${order.id}';
        if (!_dismissedIds.contains(id)) {
          items.add(
            AppNotificationEntity(
              id: id,
              orderId: order.id,
              orderToken: order.orderToken,
              customerName: order.customerName,
              customerPhone: order.customerPhone,
              garmentType: order.garmentType,
              title: 'Urgent Order ${order.orderToken}',
              message: '${order.customerName} - Priority rush stitching needed by $dateStr.',
              deadline: order.targetDeadline,
              type: AppNotificationType.urgent,
              isRead: _readIds.contains(id),
            ),
          );
        }
      }
    }

    // Sort: Overdue first, then Due Today, then Urgent, then Due Tomorrow
    items.sort((a, b) {
      final aPriority = _typePriority(a.type);
      final bPriority = _typePriority(b.type);
      if (aPriority != bPriority) {
        return aPriority.compareTo(bPriority);
      }
      return a.deadline.compareTo(b.deadline);
    });

    _notifications = items;
    notifyListeners();
  }

  int _typePriority(AppNotificationType type) {
    switch (type) {
      case AppNotificationType.overdue:
        return 0;
      case AppNotificationType.dueToday:
        return 1;
      case AppNotificationType.urgent:
        return 2;
      case AppNotificationType.dueTomorrow:
        return 3;
    }
  }

  void markAsRead(String id) {
    _readIds.add(id);
    _notifications = _notifications.map((n) {
      if (n.id == id) {
        return n.copyWith(isRead: true);
      }
      return n;
    }).toList();
    notifyListeners();
  }

  void markAllAsRead() {
    for (final n in _notifications) {
      _readIds.add(n.id);
    }
    _notifications = _notifications.map((n) => n.copyWith(isRead: true)).toList();
    notifyListeners();
  }

  void dismissNotification(String id) {
    _dismissedIds.add(id);
    _notifications.removeWhere((n) => n.id == id);
    notifyListeners();
  }
}
