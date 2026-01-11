import 'dart:convert';
import 'package:android_intent_plus/android_intent.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:permission_handler/permission_handler.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;
  static const String _targetTimezone = 'Asia/Ho_Chi_Minh';
  tz.Location? _targetLocation;

  /// Khởi tạo service
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      tz.initializeTimeZones();
      _targetLocation = tz.getLocation(_targetTimezone);
      print(
          '✅ Timezone initialized. Current timezone: ${getCurrentTimezone()}');

      const AndroidInitializationSettings androidSettings =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      const DarwinInitializationSettings iosSettings =
          DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );

      const InitializationSettings initSettings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );

      await flutterLocalNotificationsPlugin.initialize(
        initSettings,
        onDidReceiveNotificationResponse: (NotificationResponse response) {
          _onNotificationTap(response.payload);
        },
      );

      await _createNotificationChannels();
      _isInitialized = true;
      print('✅ Notification service initialized successfully');
    } catch (e) {
      print('❌ Error initializing notification service: $e');
      _isInitialized = false;
    }
  }

  Future<void> _createNotificationChannels() async {
    try {
      const AndroidNotificationChannel scheduledChannel =
          AndroidNotificationChannel(
        'scheduled_channel', // ID must match the one in manifest
        'Scheduled Notifications',
        description: 'Channel for scheduled notifications',
        importance: Importance.high,
        // priority: Priority.high,
        playSound: true,
        enableVibration: true,
        sound: RawResourceAndroidNotificationSound('notification'),
        enableLights: true,
        // ledColor: Colors.blue,
      );

      const AndroidNotificationChannel instantChannel =
          AndroidNotificationChannel(
        'high_importance_channel', // ID must match the one in manifest
        'Instant Notifications',
        description: 'Channel for instant notifications',
        importance: Importance.high,
        // priority: Priority.high,
        playSound: true,
        enableVibration: true,
      );

      final androidPlugin =
          flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();

      await androidPlugin?.createNotificationChannel(scheduledChannel);
      await androidPlugin?.createNotificationChannel(instantChannel);
    } catch (e) {
      print('❌ Error creating notification channels: $e');
    }
  }

  /// Kiểm tra và yêu cầu quyền notification
  Future<bool> requestNotificationPermission() async {
    try {
      if (defaultTargetPlatform == TargetPlatform.android) {
        // For Android 13+
        if (await Permission.notification.isDenied) {
          final result = await Permission.notification.request();
          return result.isGranted;
        }
        return true;
      } else if (defaultTargetPlatform == TargetPlatform.iOS) {
        final status = await Permission.notification.status;
        if (status.isDenied) {
          final result = await Permission.notification.request();
          return result.isGranted;
        }
        return status.isGranted;
      }
      return true;
    } catch (e) {
      print('❌ Error requesting notification permission: $e');
      return false;
    }
  }

  /// Kiểm tra quyền Exact Alarm trên Android (API 31+)
  Future<bool> hasExactAlarmPermission() async {
    if (defaultTargetPlatform != TargetPlatform.android) return true;

    try {
      final androidPlugin =
          flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();

      final bool? hasPermission =
          await androidPlugin?.areNotificationsEnabled();
      return hasPermission ?? false;
    } catch (e) {
      print('❌ Error checking exact alarm permission: $e');
      return false;
    }
  }

  Future<void> openExactAlarmSettings() async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      try {
        const intent = AndroidIntent(
          action: 'android.settings.REQUEST_SCHEDULE_EXACT_ALARM',
        );
        await intent.launch();
      } catch (e) {
        print('❌ Error opening exact alarm settings: $e');
        // Fallback to app settings
        await openAppSettings();
      }
    }
  }

  Future<PermissionStatus> getNotificationPermissionStatus() async {
    try {
      if (defaultTargetPlatform == TargetPlatform.android) {
        // On Android, check if notifications are enabled
        final androidPlugin = flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>();

        final bool? enabled = await androidPlugin?.areNotificationsEnabled();
        return enabled == true
            ? PermissionStatus.granted
            : PermissionStatus.denied;
      } else {
        return await Permission.notification.status;
      }
    } catch (e) {
      print('❌ Error getting notification permission: $e');
      return PermissionStatus.denied;
    }
  }

  /// Hiển thị notification ngay lập tức
  Future<bool> showInstantNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    try {
      if (!_isInitialized) await initialize();

      if (!await requestNotificationPermission()) {
        print('❌ Notification permission denied');
        return false;
      }

      const androidDetails = AndroidNotificationDetails(
        'instant_channel',
        'Instant Notifications',
        channelDescription: 'Channel for instant notifications',
        importance: Importance.high,
        priority: Priority.high,
        playSound: true,
        enableVibration: true,
      );

      const iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      const notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      final id = DateTime.now().millisecondsSinceEpoch.remainder(100000);

      await flutterLocalNotificationsPlugin.show(
        id,
        title,
        body,
        notificationDetails,
        payload: payload,
      );

      print('✅ Instant notification shown successfully');
      return true;
    } catch (e) {
      print('❌ Error showing notification: $e');
      return false;
    }
  }

  Future<bool> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
  }) async {
    try {
      if (!_isInitialized) await initialize();

      if (!await requestNotificationPermission()) {
        print('❌ Notification permission denied');
        return false;
      }

      // Convert to Vietnam timezone properly
      final tzScheduledDate =
          tz.TZDateTime.from(scheduledDate, _targetLocation!);
      final now = tz.TZDateTime.now(_targetLocation!);

      // Check if scheduled date is in the past
      if (tzScheduledDate.isBefore(now)) {
        print('❌ Cannot schedule notification in the past: $tzScheduledDate');
        print('❌ Current time: $now');
        return false;
      }

      print('⏰ Scheduling notification for: $tzScheduledDate');
      print('⏰ Current time: $now');
      print('⏰ Difference: ${tzScheduledDate.difference(now)}');

      const androidDetails = AndroidNotificationDetails(
        'scheduled_channel',
        'Scheduled Notifications',
        channelDescription: 'Channel for scheduled notifications',
        importance: Importance.high,
        priority: Priority.high,
        playSound: true,
        enableVibration: true,
      );

      const iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      const notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        tzScheduledDate,
        notificationDetails,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: payload,
        androidAllowWhileIdle: true,
      );

      print('✅ Notification scheduled successfully for ID: $id');

      // Verify it was scheduled
      final pending = await getPendingNotifications();
      final scheduled = pending.firstWhere((n) => n.id == id,
          orElse: () => const PendingNotificationRequest(0, '', '', ''));
      if (scheduled.id != 0) {
        print('✅ Verified notification is in pending list');
      } else {
        print('❌ Notification not found in pending list');
      }

      return true;
    } catch (e) {
      print('❌ Error scheduling notification: $e');
      return false;
    }
  }

  Future<void> cancelNotification(int id) async {
    try {
      await flutterLocalNotificationsPlugin.cancel(id);
      print('✅ Notification cancelled: $id');
    } catch (e) {
      print('❌ Error cancelling notification: $e');
    }
  }

  Future<void> cancelAllNotifications() async {
    try {
      await flutterLocalNotificationsPlugin.cancelAll();
      print('✅ All notifications cancelled');
    } catch (e) {
      print('❌ Error cancelling all notifications: $e');
    }
  }

  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    try {
      final pending =
          await flutterLocalNotificationsPlugin.pendingNotificationRequests();
      print('📋 Found ${pending.length} pending notifications');
      return pending;
    } catch (e) {
      print('❌ Error getting pending notifications: $e');
      return [];
    }
  }

  void _onNotificationTap(String? payload) {
    if (payload == null) return;
    try {
      final data = jsonDecode(payload);
      if (data['type'] == 'vaccine_reminder') {
        print('💉 Vaccine reminder tapped: ${data['vaccineName']}');
        // Handle navigation to vaccine details screen
      } else if (data['type'] == 'test') {
        print('🔔 Test notification tapped');
      }
    } catch (e) {
      print('❌ Error parsing notification payload: $e');
    }
  }

  Future<bool> testNotification() async {
    return await showInstantNotification(
      title: '🔔 Test Notification',
      body:
          'This is a test notification from SafeVax - ${DateTime.now().toString()}',
      payload: jsonEncode(
          {'type': 'test', 'time': DateTime.now().toIso8601String()}),
    );
  }

  Future<bool> scheduleVaccineReminder({
    required int doseNumber,
    required String vaccineName,
    required DateTime reminderTime,
    required String facilityName,
  }) async {
    const title = '💉 Nhắc lịch tiêm chủng';
    final body = 'Mũi $doseNumber $vaccineName tại $facilityName';

    // Create a stable ID based on vaccine details
    final id = _generateStableId(vaccineName, doseNumber, reminderTime);

    // Check if notification with this ID already exists
    final existingNotifications = await getPendingNotifications();
    final alreadyExists =
        existingNotifications.any((notification) => notification.id == id);

    if (alreadyExists) {
      print(
          '💉 Vaccine reminder already exists (ID: $id), skipping duplicate scheduling');
      return true; // Return true since it's not an error, just already scheduled
    }

    final payload = jsonEncode({
      'type': 'vaccine_reminder',
      'doseNumber': doseNumber,
      'vaccineName': vaccineName,
      'facilityName': facilityName,
      'reminderTime': reminderTime.toIso8601String(),
      'id': id,
    });

    print('💉 Scheduling vaccine reminder:');
    print('   - ID: $id');
    print('   - Vaccine: $vaccineName (Dose $doseNumber)');
    print('   - Time: $reminderTime');
    print('   - Facility: $facilityName');

    return await scheduleNotification(
      id: id,
      title: title,
      body: body,
      scheduledDate: reminderTime,
      payload: payload,
    );
  }

  // Generate a stable ID for vaccine reminders
  int _generateStableId(String vaccineName, int doseNumber, DateTime time) {
    final uniqueString =
        '$vaccineName-$doseNumber-${time.millisecondsSinceEpoch}';
    return uniqueString.hashCode.abs() % 100000;
  }

  String getCurrentTimezone() => (_targetLocation ?? tz.local).name;

  // Debug method to print all pending notifications
  Future<void> debugPrintPendingNotifications() async {
    final pending = await getPendingNotifications();
    print('📋 PENDING NOTIFICATIONS (${pending.length}):');
    for (var notif in pending) {
      print('   - ID: ${notif.id}, Title: ${notif.title}, Body: ${notif.body}');
    }
  }

  // Add this method to your NotificationService class
  Future<bool> areNotificationsEnabled() async {
    try {
      if (defaultTargetPlatform == TargetPlatform.android) {
        final androidPlugin = flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>();
        final bool? enabled = await androidPlugin?.areNotificationsEnabled();
        return enabled ?? false;
      } else if (defaultTargetPlatform == TargetPlatform.iOS) {
        // For iOS, we assume notifications are enabled if permission is granted
        final status = await getNotificationPermissionStatus();
        return status == PermissionStatus.granted;
      }
      return false;
    } catch (e) {
      print('❌ Error checking if notifications are enabled: $e');
      return false;
    }
  }
}
