// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_getx_boilerplate/modules/appointment_reschedule/appointment_reschedule_controller.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AppointmentRescheduleScreen
    extends GetView<AppointmentRescheduleController> {
  const AppointmentRescheduleScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FCFC),
      appBar: AppBar(
        title: const Text(
          "Đặt lại lịch hẹn",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF199A8E),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Chọn ngày
            const Text(
              "Ngày tiêm:",
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 12),
            Obx(() => Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.calendar_today, size: 20),
                    title: Text(DateFormat('EEEE, dd/MM/yyyy', 'vi_VN')
                        .format(controller.selectedDate.value)),
                    trailing: const Icon(Icons.arrow_drop_down),
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: controller.selectedDate.value,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (pickedDate != null) {
                        controller.setDate(pickedDate);
                      }
                    },
                  ),
                )),
            const SizedBox(height: 24),

            // Chọn khung giờ
            const Text(
              "Giờ tiêm:",
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            Text(
              "Chọn khung giờ trống:",
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            Obx(() => Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButton<String>(
                    value: controller.selectedTime.value.isEmpty
                        ? null
                        : controller.selectedTime.value,
                    isExpanded: true,
                    underline: const SizedBox(),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    hint: const Text("Chọn khung giờ trống"),
                    items: controller.timeSlots.map((time) {
                      return DropdownMenuItem<String>(
                        value: time,
                        child: Text(
                          time,
                          style: const TextStyle(fontSize: 14),
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newTime) {
                      if (newTime != null) {
                        controller.setTime(newTime);
                      }
                    },
                  ),
                )),
            const Spacer(),

            // Nút xác nhận
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon:
                    const Icon(Icons.check_circle_outline, color: Colors.white),
                label: const Text(
                  "Xác nhận đặt lại",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF199A8E),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                  shadowColor: const Color(0xFF199A8E).withOpacity(0.3),
                ),
                onPressed: () {
                  if (controller.selectedTime.value.isNotEmpty) {
                    Get.snackbar(
                      "Đặt lại lịch hẹn thành công",
                      "Lịch hẹn của bạn đã được cập nhật.",
                      backgroundColor: Colors.white,
                      colorText: const Color(0xFF199A8E),
                      icon: const Icon(Icons.check_circle,
                          color: Color(0xFF199A8E)),
                    );
                  } else {
                    Get.snackbar(
                      "Chọn giờ",
                      "Vui lòng chọn khung giờ trước khi xác nhận.",
                      backgroundColor: Colors.white,
                      colorText: Colors.red,
                      icon: const Icon(Icons.warning_amber, color: Colors.red),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
