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

  String _formatTimeOfDay(DateTime dateTime) {
    final timeStr = DateFormat('hh:mm a').format(dateTime);
    return timeStr.replaceAll('AM', 'ص').replaceAll('PM', 'م');
  }

  String _formatRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    final timeStr = _formatTimeOfDay(dateTime);

    if (difference.inSeconds < 60) {
      return 'الآن';
    } else if (difference.inMinutes < 60) {
      final minutes = difference.inMinutes;
      if (minutes == 1) return 'منذ دقيقة';
      if (minutes == 2) return 'منذ دقيقتين';
      if (minutes >= 3 && minutes <= 10) return 'منذ $minutes دقائق';
      return 'منذ $minutes دقيقة';
    } else if (difference.inHours < 24) {
      if (now.day == dateTime.day) {
        return 'اليوم $timeStr';
      }
      final hours = difference.inHours;
      if (hours == 1) return 'منذ ساعة';
      if (hours == 2) return 'منذ ساعتين';
      if (hours >= 3 && hours <= 10) return 'منذ $hours ساعات';
      return 'منذ $hours ساعة';
    } else if (difference.inDays == 1 || (now.day - dateTime.day == 1 && difference.inHours < 48)) {
      return 'أمس $timeStr';
    } else if (difference.inDays < 7) {
      final days = difference.inDays;
      if (days == 2) return 'منذ يومين';
      if (days >= 3 && days <= 10) return 'منذ $days أيام';
      return 'منذ $days يوم';
    } else {
      return '${DateFormat('yyyy/MM/dd').format(dateTime)} $timeStr';
    }
  }

  NotificationCategory _getCategory(String title, String body) {
    final text = '$title $body'.toLowerCase();
    if (text.contains('إنجاز') ||
        text.contains('درع') ||
        text.contains('كأس') ||
        text.contains('وسام') ||
        text.contains('شرف') ||
        text.contains('تهنئة') ||
        text.contains('فوز')) {
      return NotificationCategory(
        icon: Icons.emoji_events_rounded,
        color: const Color(0xFFFFB300), // Gold
        label: 'إنجاز',
      );
    } else if (text.contains('تذكير') ||
        text.contains('منبه') ||
        text.contains('وقت') ||
        text.contains('درس') ||
        text.contains('حان')) {
      return NotificationCategory(
        icon: Icons.alarm_rounded,
        color: const Color(0xFF5C6BC0), // Indigo
        label: 'تذكير',
      );
    } else if (text.contains('اختبار') ||
        text.contains('امتحان') ||
        text.contains('سؤال') ||
        text.contains('نتيجة') ||
        text.contains('درجة') ||
        text.contains('تقييم')) {
      return NotificationCategory(
        icon: Icons.assignment_rounded,
        color: const Color(0xFF4CAF50), // Emerald
        label: 'اختبار',
      );
    } else {
      return NotificationCategory(
        icon: Icons.notifications_active_rounded,
        color: const ui.Color(0xFF2196F3), // Blue
        label: 'عام',
      );
    }
  }

  Widget _buildDismissBackground(bool isRightToLeft) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.red[600],
        borderRadius: BorderRadius.circular(16),
      ),
      alignment: isRightToLeft ? Alignment.centerLeft : Alignment.centerRight,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: const Icon(
        Icons.delete_forever_rounded,
        color: Colors.white,
        size: 28,
      ),
    );
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
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (context) => Directionality(
                      textDirection: ui.TextDirection.rtl,
                      child: AlertDialog(
                        title: const Text('حذف جميع الإشعارات؟'),
                        content: const Text('هل أنت متأكد من رغبتك في حذف كل الإشعارات نهائياً؟'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('إلغاء'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            style: TextButton.styleFrom(foregroundColor: Colors.red),
                            child: const Text('حذف الكل'),
                          ),
                        ],
                      ),
                    ),
                  );

                  if (confirm == true) {
                    await NotificationService().clearAll();
                    setState(() {
                      _notifications = [];
                    });
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('تم حذف جميع الإشعارات بنجاح', textAlign: TextAlign.center),
                          backgroundColor: Colors.black87,
                        ),
                      );
                    }
                  }
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
                  final category = _getCategory(notification.title, notification.body);

                  return TweenAnimationBuilder<double>(
                    key: ValueKey(notification.id),
                    tween: Tween<double>(begin: 0.0, end: 1.0),
                    duration: Duration(milliseconds: 200 + (index * 40).clamp(0, 250)),
                    curve: Curves.easeOutCubic,
                    builder: (context, animValue, child) {
                      return Transform.translate(
                        offset: Offset(0, 30 * (1 - animValue)),
                        child: Opacity(
                          opacity: animValue,
                          child: child,
                        ),
                      );
                    },
                    child: Dismissible(
                      key: ValueKey(notification.id),
                      direction: DismissDirection.horizontal,
                      onDismissed: (direction) async {
                        final id = notification.id;
                        setState(() {
                          _notifications.removeAt(index);
                        });
                        await NotificationService().deleteNotification(id);
                      },
                      background: _buildDismissBackground(true),
                      secondaryBackground: _buildDismissBackground(false),
                      child: Card(
                        elevation: 0,
                        color: notification.isRead
                            ? context.surface
                            : category.color.withOpacity(0.03),
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(
                            color: notification.isRead
                                ? Colors.grey.withOpacity(0.12)
                                : category.color.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Stack(
                            children: [
                              if (!notification.isRead)
                                Positioned(
                                  top: 0,
                                  bottom: 0,
                                  right: 0,
                                  width: 5,
                                  child: Container(
                                    color: category.color,
                                  ),
                                ),
                              Padding(
                                padding: EdgeInsets.only(
                                  right: !notification.isRead ? 19.0 : 16.0,
                                  left: 16.0,
                                  top: 16.0,
                                  bottom: 16.0,
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 46,
                                      height: 46,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: notification.isRead
                                            ? Colors.grey.withOpacity(0.08)
                                            : category.color.withOpacity(0.12),
                                      ),
                                      child: Icon(
                                        category.icon,
                                        color: notification.isRead ? Colors.grey : category.color,
                                        size: 22,
                                      ),
                                    ),
                                    const SizedBox(width: 14),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  notification.title,
                                                  style: context.theme.textTheme.titleSmall?.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    color: notification.isRead
                                                        ? Colors.grey[700]
                                                        : context.onBackground,
                                                    fontSize: 14.5,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                _formatRelativeTime(notification.createdAt),
                                                style: context.theme.textTheme.labelSmall?.copyWith(
                                                  color: Colors.grey[400],
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            notification.body,
                                            style: context.theme.textTheme.bodyMedium?.copyWith(
                                              color: notification.isRead
                                                  ? Colors.grey[500]
                                                  : Colors.grey[700],
                                              height: 1.35,
                                              fontSize: 13.5,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}

class NotificationCategory {
  final IconData icon;
  final ui.Color color;
  final String label;

  NotificationCategory({
    required this.icon,
    required this.color,
    required this.label,
  });
}
