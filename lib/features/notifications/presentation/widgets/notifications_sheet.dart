import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/routing/app_router.dart';
import '../../domain/entities/app_notification_entity.dart';
import '../providers/notification_provider.dart';

/// Modal bottom sheet displaying real-time tailoring notifications & deadline reminders
class NotificationsSheet extends StatefulWidget {
  const NotificationsSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const NotificationsSheet(),
    );
  }

  @override
  State<NotificationsSheet> createState() => _NotificationsSheetState();
}

class _NotificationsSheetState extends State<NotificationsSheet> {
  AppNotificationType? _selectedFilter;

  @override
  Widget build(BuildContext context) {
    final notificationProvider = context.watch<NotificationProvider>();
    final allNotifications = notificationProvider.notifications;

    final filteredList = _selectedFilter == null
        ? allNotifications
        : allNotifications.where((n) => n.type == _selectedFilter).toList();

    final maxHeight = MediaQuery.of(context).size.height * 0.85;

    return Container(
      constraints: BoxConstraints(maxHeight: maxHeight),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag Handle
          const SizedBox(height: 12),
          Container(
            width: 44,
            height: 4.5,
            decoration: BoxDecoration(
              color: const Color(0xFFCBD5E1),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 14),

          // Header Row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.notifications_active_outlined,
                    color: AppColors.primary,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Notifications & Reminders',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        'اطلاعات اور ڈیلیوری یاد دہانی',
                        style: TextStyle(
                          fontSize: 11.5,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                if (allNotifications.isNotEmpty)
                  TextButton(
                    onPressed: () {
                      notificationProvider.markAllAsRead();
                    },
                    child: const Text(
                      'Mark all read',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Filter Chips
          if (allNotifications.isNotEmpty) ...[
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  _buildFilterChip('All (${allNotifications.length})', null),
                  const SizedBox(width: 8),
                  if (notificationProvider.overdueCount > 0) ...[
                    _buildFilterChip(
                      'Overdue (${notificationProvider.overdueCount})',
                      AppNotificationType.overdue,
                      badgeColor: const Color(0xFFDC2626),
                    ),
                    const SizedBox(width: 8),
                  ],
                  if (notificationProvider.dueTodayCount > 0) ...[
                    _buildFilterChip(
                      'Due Today (${notificationProvider.dueTodayCount})',
                      AppNotificationType.dueToday,
                      badgeColor: const Color(0xFFEA580C),
                    ),
                    const SizedBox(width: 8),
                  ],
                  if (notificationProvider.urgentCount > 0)
                    _buildFilterChip(
                      'Urgent (${notificationProvider.urgentCount})',
                      AppNotificationType.urgent,
                      badgeColor: const Color(0xFFD97706),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],

          const Divider(height: 1, color: Color(0xFFE2E8F0)),

          // Notifications List or Empty State
          Expanded(
            child: filteredList.isEmpty
                ? _buildEmptyState()
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
                    itemCount: filteredList.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final item = filteredList[index];
                      return _buildNotificationCard(context, item, notificationProvider);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, AppNotificationType? type, {Color? badgeColor}) {
    final isSelected = _selectedFilter == type;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      selectedColor: AppColors.primary,
      backgroundColor: const Color(0xFFF1F5F9),
      labelStyle: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: isSelected ? Colors.white : (badgeColor ?? const Color(0xFF334155)),
      ),
      onSelected: (_) {
        setState(() {
          _selectedFilter = type;
        });
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: const BoxDecoration(
                color: Color(0xFFF0FDF4),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle_outline_rounded,
                size: 36,
                color: Color(0xFF16A34A),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'All Caught Up!',
              style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'No pending delivery alerts. All orders are on track!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationCard(
    BuildContext context,
    AppNotificationEntity item,
    NotificationProvider provider,
  ) {
    Color bg;
    Color border;
    Color iconColor;
    IconData icon;

    switch (item.type) {
      case AppNotificationType.overdue:
        bg = const Color(0xFFFEF2F2);
        border = const Color(0xFFFECACA);
        iconColor = const Color(0xFFDC2626);
        icon = Icons.warning_amber_rounded;
        break;
      case AppNotificationType.dueToday:
        bg = const Color(0xFFFFF7ED);
        border = const Color(0xFFFED7AA);
        iconColor = const Color(0xFFEA580C);
        icon = Icons.today_rounded;
        break;
      case AppNotificationType.urgent:
        bg = const Color(0xFFFEFCE8);
        border = const Color(0xFFFEF08A);
        iconColor = const Color(0xFFCA8A04);
        icon = Icons.bolt_rounded;
        break;
      case AppNotificationType.dueTomorrow:
        bg = const Color(0xFFEFF6FF);
        border = const Color(0xFFBFDBFE);
        iconColor = AppColors.primary;
        icon = Icons.schedule_rounded;
        break;
    }

    return InkWell(
      onTap: () {
        provider.markAsRead(item.id);
        Navigator.pop(context);
        context.push(AppRouter.orderDetailPath(item.orderId));
      },
      borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          border: Border.all(color: border),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 20, color: iconColor),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: 14.5,
                            fontWeight: FontWeight.w800,
                            color: iconColor,
                          ),
                        ),
                      ),
                      if (!item.isRead)
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: iconColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    item.message,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12.5,
                      color: Color(0xFF334155),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        item.type.displayName,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: iconColor,
                        ),
                      ),
                      const Row(
                        children: [
                          Text(
                            'View Order',
                            style: TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                          Icon(
                            Icons.chevron_right,
                            size: 15,
                            color: AppColors.primary,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
