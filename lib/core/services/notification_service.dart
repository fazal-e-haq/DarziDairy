import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../../features/orders/domain/entities/order_entity.dart';

/// Lightweight service scheduling device notifications exactly 3 days before order deadline.
class NotificationService {
  NotificationService._();
  static final instance = NotificationService._();

  final _plugin = FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;
    try {
      tz.initializeTimeZones();
      const android = AndroidInitializationSettings('@mipmap/ic_launcher');
      const ios = DarwinInitializationSettings();
      await _plugin.initialize(settings: const InitializationSettings(android: android, iOS: ios));
      await _plugin
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();
      _initialized = true;
    } catch (e) {
      debugPrint('NotificationService.init error: $e');
    }
  }

  /// Schedules a native OS alert 3 days before the order's due date at 9:00 AM.
  Future<void> schedule3DaysBefore(OrderEntity order) async {
    if (order.isCompleted || order.isDeleted) {
      await cancel(order.id);
      return;
    }

    try {
      final deadline = order.targetDeadline;
      // 3 days prior at 9:00 AM
      final notifyTime = DateTime(deadline.year, deadline.month, deadline.day, 9)
          .subtract(const Duration(days: 3));

      if (notifyTime.isBefore(DateTime.now())) return;

      await _plugin.zonedSchedule(
        id: order.id,
        title: 'Order ${order.orderToken} Due in 3 Days',
        body: '${order.customerName} - Ready date is approaching.',
        scheduledDate: tz.TZDateTime.from(notifyTime, tz.local),
        notificationDetails: const NotificationDetails(
          android: AndroidNotificationDetails(
            'order_reminders',
            'Order Reminders',
            channelDescription: 'Alerts 3 days before order delivery',
            importance: Importance.high,
            priority: Priority.high,
          ),
          iOS: DarwinNotificationDetails(),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );
    } catch (e) {
      debugPrint('NotificationService.schedule error: $e');
    }
  }

  Future<void> cancel(int orderId) async {
    try {
      await _plugin.cancel(id: orderId);
    } catch (_) {}
  }
}
