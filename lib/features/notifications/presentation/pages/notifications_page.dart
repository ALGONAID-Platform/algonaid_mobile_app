import 'package:algonaid_mobile_app/core/common/extensions/theme_helper.dart';
import 'dart:ui' as ui;
import 'package:algonaid_mobile_app/core/widgets/shared/app_empty_state.dart';
import 'package:flutter/material.dart';
import 'package:algonaid_mobile_app/core/widgets/shared/shared_app_bar.dart';
import 'package:algonaid_mobile_app/core/utils/notification_service.dart';
import 'package:intl/intl.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  List<LocalNotification> _notifications = [];

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  void _loadNotifications() {
    setState(() {
      _notifications = NotificationService().getNotifications();
    });
    // Mark all as read when user opens the notifications page
    NotificationService().markAllAsRead();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: ui.TextDirection.rtl,
      child: Scaffold(
        backgroundColor: context.background,
        appBar: SharedAppBar(
          title: 'الإشعارات',
          actions: [
            if (_notifications.isNotEmpty)
              IconButton(
                icon: const Icon(Icons.delete_sweep_outlined, color: Colors.red),
                tooltip: 'حذف جميع الإشعارات',
                onPressed: () async {
                  await NotificationService().clearAll();
                  setState(() {
                    _notifications = [];
                  });
                },
              ),
          ],
        ),
        body: _notifications.isEmpty
            ? const AppEmptyState(
                icon: Icons.notifications_active_outlined,
                title: 'لا توجد إشعارات حالياً',
                subtitle: 'سنقوم بإعلامك فور وصول أي تحديث أو رسالة جديدة',
              )
            : ListView.builder(
                itemCount: _notifications.length,
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemBuilder: (context, index) {
                  final notification = _notifications[index];
                  return Card(
                    elevation: 0,
                    color: notification.isRead
                        ? context.surface
                        : context.primary.withOpacity(0.05),
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(
                        color: notification.isRead
                            ? Colors.grey.withOpacity(0.15)
                            : context.primary.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      leading: CircleAvatar(
                        backgroundColor: notification.isRead
                            ? Colors.grey.withOpacity(0.1)
                            : context.primary.withOpacity(0.15),
                        child: Icon(
                          Icons.notifications_active_rounded,
                          color: notification.isRead ? Colors.grey : context.primary,
                        ),
                      ),
                      title: Text(
                        notification.title,
                        style: context.theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: notification.isRead ? Colors.grey[700] : context.onBackground,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          Text(
                            notification.body,
                            style: context.theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            DateFormat('yyyy/MM/dd hh:mm a').format(notification.createdAt),
                            style: context.theme.textTheme.labelSmall?.copyWith(
                              color: Colors.grey[400],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
