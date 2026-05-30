import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:video_player/video_player.dart';

class LocalNotification {
  final String id;
  final String title;
  final String body;
  final DateTime createdAt;
  final bool isRead;

  LocalNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.createdAt,
    this.isRead = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'createdAt': createdAt.toIso8601String(),
      'isRead': isRead,
    };
  }

  factory LocalNotification.fromMap(Map<String, dynamic> map) {
    return LocalNotification(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      body: map['body'] ?? '',
      createdAt: DateTime.parse(map['createdAt'] ?? DateTime.now().toIso8601String()),
      isRead: map['isRead'] ?? false,
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

  Future<void> init() async {
    // Initialize Hive Box for storing notifications history
    _notificationsBox = await Hive.openBox<String>('local_notifications_box');

    // Initialize Local Notifications
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    await _localNotificationsPlugin.initialize(
      initializationSettings,
    );
  }

  // Show a notification, save it, and play sound
  Future<void> showNotification({
    required String title,
    required String body,
  }) async {
    // Generate unique ID
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final newNotification = LocalNotification(
      id: id,
      title: title,
      body: body,
      createdAt: DateTime.now(),
    );

    // Save to Hive
    await _notificationsBox.put(id, jsonEncode(newNotification.toMap()));

    // Play Victory Sound (in-app audio using video_player)
    try {
      final controller = VideoPlayerController.asset('assets/audio/success.wav');
      await controller.initialize();
      await controller.play();
      Future.delayed(const Duration(seconds: 4), () {
        controller.dispose();
      });
    } catch (e) {
      debugPrint('Error playing success audio via video_player: $e');
    }

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
      final list = _notificationsBox.values.map((e) {
        return LocalNotification.fromMap(jsonDecode(e) as Map<String, dynamic>);
      }).toList();
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
    for (final key in _notificationsBox.keys) {
      final json = _notificationsBox.get(key);
      if (json != null) {
        final map = jsonDecode(json) as Map<String, dynamic>;
        map['isRead'] = true;
        await _notificationsBox.put(key, jsonEncode(map));
      }
    }
  }

  // Clear all notification history
  Future<void> clearAll() async {
    await _notificationsBox.clear();
  }
}
