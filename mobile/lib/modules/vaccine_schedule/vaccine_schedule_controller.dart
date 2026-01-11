import 'package:flutter/material.dart';
import 'package:flutter_getx_boilerplate/modules/base/base_controller.dart';
import 'package:flutter_getx_boilerplate/models/request/reschedule_request.dart';
import 'package:flutter_getx_boilerplate/repositories/appointment_reschedule_repository.dart';

import 'package:get/get.dart';

class VaccineScheduleController extends BaseController {
  VaccineScheduleController() : super(null);

  late final AppointmentRescheduleRepository _rescheduleRepository;

  final Rx<DateTime> selectedDate =
      DateTime.now().add(const Duration(days: 1)).obs;
  final RxString selectedTimeSlot = 'SLOT_07_00'.obs;
  final RxBool isScheduling = false.obs;
  final TextEditingController reasonController = TextEditingController();
  final RxString reasonError = ''.obs;

  bool get isReschedule => Get.arguments?['isReschedule'] ?? false;
  Map<String, dynamic>? get appointment => Get.arguments?['appointment'];

  @override
  void onInit() {
    super.onInit();
    _rescheduleRepository = Get.find<AppointmentRescheduleRepository>();
  }

  final List<String> timeSlots = [
    'SLOT_07_00',
    'SLOT_09_00',
    'SLOT_11_00',
    'SLOT_13_00',
    'SLOT_15_00',
  ];

  final Map<String, String> timeLabels = {
    'SLOT_07_00': '07:00 - 09:00',
    'SLOT_09_00': '09:00 - 11:00',
    'SLOT_11_00': '11:00 - 13:00',
    'SLOT_13_00': '13:00 - 15:00',
    'SLOT_15_00': '15:00 - 17:00',
  };

  void selectDate(DateTime date) {
    selectedDate.value = date;
  }

  String getDisplayTimeRange(String timeSlot) {
    return timeLabels[timeSlot] ?? timeSlot;
  }

  String parseTimeSlot(String timeSlot) {
    if (timeSlot.startsWith('SLOT_')) {
      // Convert "SLOT_07_00" to "07:00"
      final parts = timeSlot.split('_');
      if (parts.length >= 3) {
        final hour = parts[1];
        final minute = parts[2];
        return '$hour:$minute';
      }
    }
    return timeSlot;
  }

  Future<void> scheduleVaccine(Map<String, dynamic>? vaccine) async {
    if (isReschedule) {
      await rescheduleAppointment();
    } else {
      // Original schedule logic
      Get.snackbar(
        'Đặt lịch thành công',
        'Bạn đã đặt lịch tiêm ${vaccine?['name']}',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 1),
      );
    }
  }

  Future<void> rescheduleAppointment() async {
    try {
      isScheduling.value = true;

      final request = RescheduleRequest(
        appointmentId: int.parse(appointment!['id']),
        desiredDate: selectedDate.value.toIso8601String().split('T')[0],
        desiredTimeSlot: selectedTimeSlot.value,
        reason: reasonController.text,
      );

      await _rescheduleRepository.rescheduleAppointment(request);

      Get.back(); // Return to previous screen
      Get.snackbar(
        'Thành công',
        'Yêu cầu đổi lịch đã được gửi',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      Get.snackbar(
        'Lỗi',
        'Có lỗi xảy ra khi đổi lịch. Vui lòng thử lại.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 2),
      );
    } finally {
      isScheduling.value = false;
    }
  }
}
