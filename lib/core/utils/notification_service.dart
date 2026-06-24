import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:video_player/video_player.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:algonaid_mobile_app/core/routes/appRouters.dart';
import 'package:algonaid_mobile_app/core/routes/paths_routes.dart';
import 'package:algonaid_mobile_app/core/constants/app_constants.dart';
import 'package:algonaid_mobile_app/core/utils/cache/shared_pref.dart';

class LocalNotification {
  final String id;
  final String title;
  final String body;
  final DateTime createdAt;
  final bool isRead;
  final String? userId;

  LocalNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.createdAt,
    this.isRead = false,
    this.userId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'createdAt': createdAt.toIso8601String(),
      'isRead': isRead,
      'userId': userId,
    };
  }

  factory LocalNotification.fromMap(Map<String, dynamic> map) {
    return LocalNotification(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      body: map['body'] ?? '',
      createdAt: DateTime.parse(map['createdAt'] ?? DateTime.now().toIso8601String()),
      isRead: map['isRead'] ?? false,
      userId: map['userId'] as String?,
    );
  }
}

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  late Box<String> _notificationsBox;
  late Box<String> _remindersBox;

  Future<void> init() async {
    // Initialize Hive Box for storing notifications history
    _notificationsBox = await Hive.openBox<String>('local_notifications_box');
    _remindersBox = await Hive.openBox<String>('course_reminders_box');

    // Initialize Timezone
    try {
      tz.initializeTimeZones();
      final timeZoneInfo = await FlutterTimezone.getLocalTimezone();
      final String timeZoneName = timeZoneInfo.identifier;
      tz.setLocalLocation(tz.getLocation(timeZoneName));
      debugPrint('NotificationService: Local timezone initialized to $timeZoneName');
    } catch (e) {
      debugPrint('NotificationService: Error initializing timezone: $e');
      try {
        tz.setLocalLocation(tz.getLocation('Asia/Riyadh'));
      } catch (_) {}
    }

    // Initialize Local Notifications
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      defaultPresentAlert: true,
      defaultPresentBadge: true,
      defaultPresentSound: true,
      notificationCategories: [
        DarwinNotificationCategory(
          'course_reminder_category',
          actions: [
            DarwinNotificationAction.plain(
              'start_lesson',
              'ابدأ الدرس الآن 📚',
              options: {DarwinNotificationActionOption.foreground},
            ),
          ],
        ),
      ],
    );

    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    await _localNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        _handleNotificationTap(response);
      },
    );
  }

  // Handle notification tap to redirect to the specific course
  void _handleNotificationTap(NotificationResponse response) {
    debugPrint('NotificationService: Notification tapped: actionId=${response.actionId}, payload=${response.payload}');
    
    final payloadStr = response.payload;
    if (payloadStr != null) {
      try {
        final payloadData = jsonDecode(payloadStr) as Map<String, dynamic>;
        final courseId = payloadData['courseId'] as int?;
        if (courseId != null) {
          // Navigate to the course modules list using GoRouter
          debugPrint('NotificationService: Navigating to course $courseId');
          AppRouters.routers.push('${Routes.modulesList}/$courseId');
        }
      } catch (e) {
        debugPrint('NotificationService: Error handling notification tap: $e');
      }
    }
  }

  // Show a notification, save it, and play sound
  Future<void> showNotification({
    required String title,
    required String body,
  }) async {
    final currentUserId = CacheHelper.getString(key: AppConstants.userId) ?? '0';
    // Generate unique ID
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final newNotification = LocalNotification(
      id: id,
      title: title,
      body: body,
      createdAt: DateTime.now(),
      userId: currentUserId,
    );

    // Save to Hive
    await _notificationsBox.put(id, jsonEncode(newNotification.toMap()));

    // تمت إزالة تشغيل الصوت المزعج success.wav بناءً على طلب المستخدم
    // سيتم الاعتماد على النغمة الهادئة الافتراضية للنظام

    // Show native local notification
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'badge_channel',
      'Badges and Achievements',
      channelDescription: 'Notifications for achievements and badge awards',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
    );

    const DarwinNotificationDetails darwinNotificationDetails =
        DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails,
    );

    await _localNotificationsPlugin.show(
      int.parse(id.substring(id.length - 8)), // 8 digit integer ID
      title,
      body,
      notificationDetails,
    );
  }

  // Retrieve notification history
  List<LocalNotification> getNotifications() {
    try {
      final currentUserId = CacheHelper.getString(key: AppConstants.userId) ?? '0';
      final list = _notificationsBox.values.map((e) {
        return LocalNotification.fromMap(jsonDecode(e) as Map<String, dynamic>);
      }).where((notif) => notif.userId == currentUserId || notif.userId == null).toList();
      // Sort: newest first
      list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return list;
    } catch (e) {
      debugPrint('Error fetching notifications: $e');
      return [];
    }
  }

  // Mark all notifications as read
  Future<void> markAllAsRead() async {
    final currentUserId = CacheHelper.getString(key: AppConstants.userId) ?? '0';
    for (final key in _notificationsBox.keys) {
      final json = _notificationsBox.get(key);
      if (json != null) {
        final map = jsonDecode(json) as Map<String, dynamic>;
        if (map['userId'] == currentUserId || map['userId'] == null) {
          map['isRead'] = true;
          await _notificationsBox.put(key, jsonEncode(map));
        }
      }
    }
  }

  // Clear all notification history
  Future<void> clearAll() async {
    final currentUserId = CacheHelper.getString(key: AppConstants.userId) ?? '0';
    final keysToDelete = <dynamic>[];
    for (final key in _notificationsBox.keys) {
      final json = _notificationsBox.get(key);
      if (json != null) {
        final map = jsonDecode(json) as Map<String, dynamic>;
        if (map['userId'] == currentUserId || map['userId'] == null) {
          keysToDelete.add(key);
        }
      }
    }
    await _notificationsBox.deleteAll(keysToDelete);
  }

  // Delete a single notification
  Future<void> deleteNotification(String id) async {
    await _notificationsBox.delete(id);
    debugPrint('NotificationService: Deleted notification $id');
  }

  // Schedule a recurring weekly reminder for a course on specific days and time
  Future<void> scheduleCourseReminder({
    required int courseId,
    required String courseTitle,
    required List<int> days, // 1 (Mon) to 7 (Sun)
    required int hour,
    required int minute,
  }) async {
    // Cancel any existing notifications for this course to start fresh
    await cancelCourseReminder(courseId);

    if (days.isEmpty) return;

    // Determine the scheduling mode (exact if permission is granted, otherwise inexact)
    AndroidScheduleMode scheduleMode = AndroidScheduleMode.inexactAllowWhileIdle;
    try {
      if (Platform.isAndroid) {
        final bool canScheduleExact = await Permission.scheduleExactAlarm.isGranted;
        if (canScheduleExact) {
          scheduleMode = AndroidScheduleMode.exactAllowWhileIdle;
          debugPrint('NotificationService: Exact alarms permission is granted. Using exact scheduling.');
        } else {
          debugPrint('NotificationService: Exact alarms permission is NOT granted. Using inexact scheduling.');
        }
      }
    } catch (e) {
      debugPrint('NotificationService: Error checking exact alarm permission: $e');
    }

    // Schedule a notification for each selected day
    for (final day in days) {
      final notificationId = courseId * 10 + day;
      final scheduledDate = _nextInstanceOfWeekdayAndTime(day, hour, minute);

      const AndroidNotificationDetails androidNotificationDetails =
          AndroidNotificationDetails(
        'course_reminder_channel',
        'تذكيرات الدراسة',
        channelDescription: 'تنبيهات لتذكيرك بموعد دراسة الكورسات الخاصة بك',
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        color: Color(0xFF4A9F8A), // Logo Teal Accent Color
        actions: [
          AndroidNotificationAction(
            'start_lesson',
            'ابدأ الدرس الآن 📚',
            showsUserInterface: true,
          ),
        ],
      );

      const DarwinNotificationDetails darwinNotificationDetails =
          DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        categoryIdentifier: 'course_reminder_category',
      );

      const NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails,
        iOS: darwinNotificationDetails,
      );

      final payload = jsonEncode({
        'courseId': courseId,
        'courseTitle': courseTitle,
      });

      await _localNotificationsPlugin.zonedSchedule(
        notificationId,
        'حان وقت التعلم! 📚',
        'لديك درس اليوم في كورس: "$courseTitle". دعنا نستمر في إحراز التقدم!',
        scheduledDate,
        notificationDetails,
        androidScheduleMode: scheduleMode,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
        payload: payload,
      );
      
      debugPrint('NotificationService: Scheduled notification for course $courseId, day $day at $hour:$minute using mode $scheduleMode');
    }

    // Save configuration in Hive
    final config = {
      'courseId': courseId,
      'courseTitle': courseTitle,
      'isEnabled': true,
      'days': days,
      'hour': hour,
      'minute': minute,
    };
    await _remindersBox.put(courseId.toString(), jsonEncode(config));
  }

  // Helper to calculate the next occurrence of a specific weekday and time
  tz.TZDateTime _nextInstanceOfWeekdayAndTime(int weekday, int hour, int minute) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    while (scheduledDate.weekday != weekday) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  // Cancel scheduled notifications for a course and remove settings from Hive
  Future<void> cancelCourseReminder(int courseId) async {
    for (int day = 1; day <= 7; day++) {
      final notificationId = courseId * 10 + day;
      await _localNotificationsPlugin.cancel(notificationId);
    }
    await _remindersBox.delete(courseId.toString());
    debugPrint('NotificationService: Cancelled all reminders for course $courseId');
  }

  // Get active reminder configuration for a course
  Map<String, dynamic>? getCourseReminder(int courseId) {
    final data = _remindersBox.get(courseId.toString());
    if (data == null) return null;
    try {
      return jsonDecode(data) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }
}
