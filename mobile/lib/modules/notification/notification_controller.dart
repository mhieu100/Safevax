import 'package:flutter_getx_boilerplate/shared/services/notification_service.dart';
import 'package:flutter_getx_boilerplate/modules/base/base_controller.dart';
import 'package:flutter_getx_boilerplate/repositories/notification_repository.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationController extends BaseController<NotificationRepository> {
  NotificationController(super.repository);

  final NotificationService _notificationService = NotificationService();

  final RxBool _notificationsEnabled = false.obs;
  final RxList<PendingNotificationRequest> _scheduledNotifications =
      <PendingNotificationRequest>[].obs;
  final Rx<PermissionStatus> _permissionStatus = PermissionStatus.denied.obs;

  bool get notificationsEnabled => _notificationsEnabled.value;
  List<PendingNotificationRequest> get scheduledNotifications =>
      _scheduledNotifications;
  PermissionStatus get permissionStatus => _permissionStatus.value;

  @override
  void onInit() {
    super.onInit();
    _initializeNotifications();
  }

  Future<void> _initializeNotifications() async {
    await _notificationService.initialize();
    await _updatePermissionStatus();
    await _loadScheduledNotifications();
  }

  Future<void> _updatePermissionStatus() async {
    final status = await _notificationService.getNotificationPermissionStatus();
    _permissionStatus.value = status;
    _notificationsEnabled.value = status == PermissionStatus.granted;
  }

  Future<void> _loadScheduledNotifications() async {
    final pending = await _notificationService.getPendingNotifications();
    _scheduledNotifications.assignAll(pending);
  }

  Future<bool> requestPermissions() async {
    final granted = await _notificationService.requestNotificationPermission();
    await _updatePermissionStatus();

    if (!granted) {
      Get.snackbar('Thông báo', 'Quyền thông báo bị từ chối');
      return false;
    }

    // Android: Kiểm tra Exact Alarm permission
    if (GetPlatform.isAndroid) {
      final hasExactAlarm =
          await _notificationService.hasExactAlarmPermission();
      if (!hasExactAlarm) {
        Get.snackbar('Thông báo', 'Cần bật Exact Alarm để thông báo đúng giờ');
        await _notificationService.openExactAlarmSettings();
        return false;
      }
    }

    Get.snackbar('Thành công', 'Đã cấp quyền thông báo');
    return true;
  }

  Future<void> sendTestNotification() async {
    final success = await _notificationService.testNotification();
    if (success) {
      Get.snackbar('Thành công', 'Đã gửi thông báo thử nghiệm');
    } else {
      Get.snackbar('Lỗi', 'Không thể gửi thông báo. Vui lòng kiểm tra quyền.');
    }
  }

  Future<bool> scheduleVaccineReminder({
    required int doseNumber,
    required String vaccineName,
    required DateTime reminderTime,
    required String facilityName,
  }) async {
    if (!_notificationsEnabled.value) {
      final granted = await requestPermissions();
      if (!granted) return false;
    }

    // Debug: Print current time and scheduled time
    print('⏰ Current time: ${DateTime.now()}');
    print('⏰ Attempting to schedule for: $reminderTime');

    final success = await _notificationService.scheduleVaccineReminder(
      doseNumber: doseNumber,
      vaccineName: vaccineName,
      reminderTime: reminderTime,
      facilityName: facilityName,
    );

    if (success) {
      await _loadScheduledNotifications();
      Get.snackbar('Thành công', 'Đã lên lịch nhắc nhở thành công');

      // Debug: Print all pending notifications
      await _notificationService.debugPrintPendingNotifications();
    } else {
      Get.snackbar(
          'Lỗi', 'Không thể lên lịch nhắc nhở. Thời gian có thể đã qua.');
    }

    return success;
  }

  Future<void> cancelAllNotifications() async {
    await _notificationService.cancelAllNotifications();
    _scheduledNotifications.clear();
    Get.snackbar('Thành công', 'Đã hủy tất cả thông báo');
  }

  Future<void> cancelNotification(int id) async {
    await _notificationService.cancelNotification(id);
    await _loadScheduledNotifications();
    Get.snackbar('Thành công', 'Đã hủy thông báo');
  }

  Future<void> checkAndRequestPermission() async {
    await _updatePermissionStatus();
    if (!_notificationsEnabled.value) {
      await requestPermissions();
    }
  }

  PendingNotificationRequest? getNotificationById(int id) {
    try {
      return _scheduledNotifications.firstWhere((n) => n.id == id);
    } catch (e) {
      return null;
    }
  }

  // Debug method to refresh notifications list
  Future<void> refreshNotifications() async {
    await _loadScheduledNotifications();
  }

  Future<void> debugNotificationSystem() async {
    print('=== NOTIFICATION SYSTEM DEBUG ===');

    // Check if notification service is initialized

    // Check permission status
    final status = await _notificationService.getNotificationPermissionStatus();
    print('Permission status: $status');

    // Check if notifications are enabled in system settings
    final notificationsEnabled =
        await _notificationService.areNotificationsEnabled();
    print('System notifications enabled: $notificationsEnabled');

    // List all pending notifications
    final pending = await _notificationService.getPendingNotifications();
    print('Pending notifications: ${pending.length}');
    for (var notif in pending) {
      print('  - ID: ${notif.id}, Title: ${notif.title}, Body: ${notif.body}');
    }

    // Test immediate notification
    print('Testing immediate notification...');
    final testSuccess = await _notificationService.testNotification();
    print('Immediate notification test: ${testSuccess ? 'SUCCESS' : 'FAILED'}');

    print('=== DEBUG COMPLETE ===');
  }
}
