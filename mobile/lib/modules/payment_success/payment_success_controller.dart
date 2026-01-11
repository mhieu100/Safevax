// lib/modules/payment_success/payment_success_controller.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_getx_boilerplate/shared/extension/num_ext.dart';
import 'package:flutter_getx_boilerplate/shared/services/notification_service.dart';
import 'package:flutter_getx_boilerplate/models/vaccine_model/booking_model.dart';
import 'package:flutter_getx_boilerplate/modules/base/base_controller.dart';
import 'package:flutter_getx_boilerplate/modules/dashboarh_main/dashboard_controller.dart';
import 'package:flutter_getx_boilerplate/modules/dashboard_noti/dashboard_noti_controller.dart';
import 'package:flutter_getx_boilerplate/repositories/payment_success_repository.dart';
import 'package:flutter_getx_boilerplate/routes/routes.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class PaymentSuccessController
    extends BaseController<PaymentSuccessRepository> {
  PaymentSuccessController(super.repository);

  final NotificationService _notificationService = NotificationService();

  final RxBool _notificationsEnabled = false.obs;
  final RxList<PendingNotificationRequest> _scheduledNotifications =
      <PendingNotificationRequest>[].obs;
  final Rx<PermissionStatus> _permissionStatus = PermissionStatus.denied.obs;

  bool get notificationsEnabled => _notificationsEnabled.value;
  List<PendingNotificationRequest> get scheduledNotifications =>
      _scheduledNotifications;
  PermissionStatus get permissionStatus => _permissionStatus.value;

  final Rx<VaccineBooking> _booking = Rx<VaccineBooking>(VaccineBooking(
    id: '',
    userId: '',
    vaccines: [],
    vaccineQuantities: {},
    bookingDate: DateTime.now(),
    doseBookings: {},
    totalPrice: 0,
    status: 'confirmed',
    paymentMethod: 'CASH',
    confirmationCode: '',
    createdAt: DateTime.now(),
  ));

  final RxBool _isLoading = false.obs;
  final RxBool _notificationsSent = false.obs;
  final RxBool _remindersScheduled = false.obs;

  VaccineBooking get booking => _booking.value;
  bool get isLoading => _isLoading.value;
  bool get notificationsSent => _notificationsSent.value;
  bool get remindersScheduled => _remindersScheduled.value;

  @override
  void onInit() {
    super.onInit();
    // Lấy dữ liệu booking từ arguments
    if (Get.arguments != null && Get.arguments is VaccineBooking) {
      _booking.value = Get.arguments as VaccineBooking;
      // Gửi thông báo tự động khi màn hình được khởi tạo
      _sendBookingConfirmationNotifications();
      // Schedule vaccine reminders
      _scheduleVaccineReminders();
    }
    _initializeNotifications();
    // sendTestNotification();
    _isLoading.value = false;
  }

  Future<void> _initializeNotifications() async {
    await _notificationService.initialize();
    await _updatePermissionStatus();
    await _loadScheduledNotifications();
  }

  // Hàm gửi thông báo xác nhận
  Future<void> _sendBookingConfirmationNotifications() async {
    if (_notificationsSent.value) return;

    _isLoading.value = true;

    try {
      // Gửi thông báo qua nhiều kênh
      await Future.wait([
        _sendPushNotification(),
        _sendEmailConfirmation(),
        _sendSMSConfirmation(),
      ]);

      _notificationsSent.value = true;

      // Don't print success messages to avoid console noise
    } catch (e) {
      // Don't print error messages to avoid console noise
    } finally {
      _isLoading.value = false;
    }
  }

  // Show immediate notification that schedules have been set for vaccine doses
  Future<void> _showScheduleConfirmationNotification() async {
    final doseCount = booking.doseBookings.length;
    final title = '✅ Lịch nhắc nhở đã được lên lịch';
    final body =
        'Đã lên lịch nhắc nhở cho $doseCount mũi tiêm trong đơn hàng của bạn.';

    await _notificationService.showInstantNotification(
      title: title,
      body: body,
      payload: jsonEncode({
        'type': 'schedule_confirmation',
        'doseCount': doseCount,
        'bookingId': booking.id,
      }),
    );
  }

  // Schedule vaccine reminders for all doses
  Future<void> _scheduleVaccineReminders() async {
    // Prevent duplicate scheduling if already done for this booking
    if (_remindersScheduled.value) {
      print(
          '💉 Vaccine reminders already scheduled for this booking, skipping');
      return;
    }

    try {
      // Schedule reminders for each dose booking
      for (final entry in booking.doseBookings.entries) {
        final doseNumber = entry.key;
        final doseBooking = entry.value;

        // Schedule reminder 24 hours before the appointment
        final reminderTime =
            doseBooking.dateTime.subtract(const Duration(hours: 24));

        // Only schedule if the reminder time is in the future
        if (reminderTime.isAfter(DateTime.now())) {
          final vaccineName =
              doseBooking.vaccineId.isNotEmpty && booking.vaccines.isNotEmpty
                  ? booking.vaccines
                      .firstWhere(
                        (v) => v.id == doseBooking.vaccineId,
                        orElse: () => booking.vaccines.first,
                      )
                      .name
                  : booking.vaccines.isNotEmpty
                      ? booking.vaccines.first.name
                      : 'Vaccine';

          await scheduleVaccineReminder(
            doseNumber: doseNumber,
            vaccineName: vaccineName,
            reminderTime: reminderTime,
            facilityName: doseBooking.facility.name,
          );
        }

        // Schedule reminder 2 hours before the appointment
        final reminderTime2Hours =
            doseBooking.dateTime.subtract(const Duration(hours: 2));

        if (reminderTime2Hours.isAfter(DateTime.now())) {
          final vaccineName =
              doseBooking.vaccineId.isNotEmpty && booking.vaccines.isNotEmpty
                  ? booking.vaccines
                      .firstWhere(
                        (v) => v.id == doseBooking.vaccineId,
                        orElse: () => booking.vaccines.first,
                      )
                      .name
                  : booking.vaccines.isNotEmpty
                      ? booking.vaccines.first.name
                      : 'Vaccine';

          await scheduleVaccineReminder(
            doseNumber: doseNumber,
            vaccineName: vaccineName,
            reminderTime: reminderTime2Hours,
            facilityName: doseBooking.facility.name,
          );
        }
      }

      // Show immediate notification that schedules have been set
      await _showScheduleConfirmationNotification();

      // Mark reminders as scheduled to prevent duplicates
      _remindersScheduled.value = true;
    } catch (e) {
      // Don't print error messages to avoid console noise
    }
  }

  // Gửi thông báo push notification
  Future<void> _sendPushNotification() async {
    // Giả lập gửi push notification
    await Future.delayed(const Duration(seconds: 1));

    // Trong thực tế, bạn sẽ tích hợp với Firebase Cloud Messaging hoặc OneSignal
    // Don't print to avoid console noise
  }

  // Gửi email xác nhận
  Future<void> _sendEmailConfirmation() async {
    final emailContent = '''
Xin chào,

Cảm ơn bạn đã đặt lịch tiêm chủng tại hệ thống của chúng tôi.

THÔNG TIN ĐẶT LỊCH:
- Mã xác nhận: ${booking.confirmationCode}
- Ngày đặt lịch: ${DateFormat('dd/MM/yyyy HH:mm').format(booking.bookingDate)}
- Tổng thanh toán: ${booking.totalPrice.formatNumber()} VND

DANH SÁCH VACCINE:
${booking.vaccines.map((v) => '• ${v.name} (${v.manufacturer}) - ${v.numberOfDoses} mũi').join('\n')}

LỊCH HẸN ĐẦU TIÊN:
${booking.doseBookings.isNotEmpty && booking.doseBookings[1] != null ? '• Ngày: ${DateFormat('dd/MM/yyyy').format(booking.doseBookings[1]!.dateTime)}\n• Giờ: ${DateFormat('HH:mm').format(booking.doseBookings[1]!.dateTime)}\n• Địa điểm: ${booking.doseBookings[1]!.facility.name}\n• Địa chỉ: ${booking.doseBookings[1]!.facility.address}' : 'Chưa có thông tin'}

Vui lòng mang theo mã QR hoặc mã xác nhận này khi đến tiêm.

Trân trọng,
Đội ngũ chăm sóc sức khỏe
''';

    // Giả lập gửi email
    await Future.delayed(const Duration(seconds: 2));
    // Don't print email content to avoid console noise

    // Trong thực tế, bạn sẽ tích hợp với EmailJS, SendGrid, hoặc API email của bạn
  }

  // Gửi SMS xác nhận
  Future<void> _sendSMSConfirmation() async {
    final smsContent =
        'Xac nhan dat lich tiem chung thanh cong. Ma: ${booking.confirmationCode}. '
        'Lich hen dau tien: ${booking.doseBookings.isNotEmpty && booking.doseBookings[1] != null ? DateFormat('dd/MM HH:mm').format(booking.doseBookings[1]!.dateTime) : 'sẽ thông báo sau'}. '
        'Vui long mang ma QR khi den tiem. Hotro: 1900 9090';

    // Don't print SMS content to avoid console noise

    // Trong thực tế, bạn có thể tích hợp với Twilio, AWS SNS, hoặc API SMS của Việt Nam
  }

  // Gửi lại thông báo (manual trigger)
  Future<void> resendNotifications() async {
    await _sendBookingConfirmationNotifications();
  }

  String get qrData {
    return '''
VACCINE BOOKING CONFIRMATION
Code: ${booking.confirmationCode}
Date: ${booking.bookingDate.toString()}
Total: ${booking.totalPrice} VND
Vaccines: ${booking.vaccines.map((v) => v.name).join(', ')}
Status: ${booking.status}
''';
  }

  void shareConfirmation() {
    final shareContent = 'Đã đặt lịch tiêm chủng thành công!\n'
        'Mã xác nhận: ${booking.confirmationCode}\n'
        'Tổng cộng: ${booking.totalPrice.formatNumber()}₫\n'
        'Lịch hẹn đầu tiên: ${booking.doseBookings.isNotEmpty && booking.doseBookings[1] != null ? DateFormat('dd/MM/yyyy HH:mm').format(booking.doseBookings[1]!.dateTime) : 'Sẽ thông báo'}';

    // Don't print share content to avoid console noise

    // Trong thực tế, tích hợp với package share_plus
    // await Share.share(shareContent);
  }

  void goToHome() {
    // Navigate back to the first route (bottom nav) by popping all routes above it
    Get.until((route) => route.isFirst);

    // Refresh dashboard data after payment success
    try {
      final dashboardController = Get.find<DashboardController>();
      dashboardController.getData();
      final dashboardNotiController = Get.find<DashboardNotiController>();
      dashboardNotiController.getData();
    } catch (e) {
      // Dashboard controllers might not be initialized yet, ignore
    }
  }

  void viewBookingDetails() {
    // Navigate to appointment list to view booking details
    Get.offAllNamed(Routes.appointmentList);
  }

  void downloadQRCode() {
    // Don't print QR download action to avoid console noise
  }

  Future<void> sendTestNotification() async {
    final success = await _notificationService.testNotification();
    if (success) {
      // Don't show snackbar
      _isLoading.value = true;
      // Don't print to avoid console noise
    } else {
      // Don't show error snackbar
      // Don't print to avoid console noise
    }
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
      // Don't print to avoid console noise
      return false;
    }

    // Android: Kiểm tra Exact Alarm permission
    if (GetPlatform.isAndroid) {
      final hasExactAlarm =
          await _notificationService.hasExactAlarmPermission();
      if (!hasExactAlarm) {
        // Don't print to avoid console noise
        await _notificationService.openExactAlarmSettings();
        return false;
      }
    }

    // Don't print to avoid console noise
    return true;
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

    // Don't print debug info to avoid console noise

    final success = await _notificationService.scheduleVaccineReminder(
      doseNumber: doseNumber,
      vaccineName: vaccineName,
      reminderTime: reminderTime,
      facilityName: facilityName,
    );

    if (success) {
      await _loadScheduledNotifications();
      // Don't print success/failure messages to avoid console noise
    } else {
      // Don't print failure messages to avoid console noise
    }

    return success;
  }

  Future<void> cancelAllNotifications() async {
    await _notificationService.cancelAllNotifications();
    _scheduledNotifications.clear();
    // Don't print to avoid console noise
  }

  Future<void> cancelNotification(int id) async {
    await _notificationService.cancelNotification(id);
    await _loadScheduledNotifications();
    // Don't print to avoid console noise
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
    // Debug method - only print essential info to avoid console noise
    print('=== NOTIFICATION SYSTEM DEBUG ===');

    // Check if notification service is initialized
    print('Notification service available: ${_notificationService != null}');

    // Check permission status
    final status = await _notificationService.getNotificationPermissionStatus();
    print('Permission status: $status');

    // Check if notifications are enabled in system settings
    final notificationsEnabled =
        await _notificationService.areNotificationsEnabled();
    print('System notifications enabled: $notificationsEnabled');

    // List count only, not details to avoid noise
    final pending = await _notificationService.getPendingNotifications();
    print('Pending notifications count: ${pending.length}');

    // Test immediate notification
    final testSuccess = await _notificationService.testNotification();
    print('Immediate notification test: ${testSuccess ? 'SUCCESS' : 'FAILED'}');

    print('=== DEBUG COMPLETE ===');
  }
}
