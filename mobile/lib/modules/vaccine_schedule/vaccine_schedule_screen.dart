// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_getx_boilerplate/modules/vaccine_schedule/vaccine_schedule_controller.dart';
import 'package:flutter_getx_boilerplate/shared/constants/colors.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class VaccineScheduleScreen extends GetView<VaccineScheduleController> {
  const VaccineScheduleScreen({super.key, this.vaccine});
  final Map<String, dynamic>? vaccine;

  bool get isReschedule => Get.arguments?['isReschedule'] ?? false;
  Map<String, dynamic>? get appointment => Get.arguments?['appointment'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Chi tiết lịch hẹn',
            style: TextStyle(color: Colors.white)),
        backgroundColor: ColorConstants.primaryGreen,
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (vaccine != null) _buildVaccineInfoCard(),
            const SizedBox(height: 24),
            _buildSectionTitle('Thông tin đặt lịch'),
            const SizedBox(height: 16),
            _buildDateSelector(),
            const SizedBox(height: 20),
            _buildTimeSelector(),
            const SizedBox(height: 20),
            _buildAppointmentInfo(),
            const SizedBox(height: 20),
            if (isReschedule) _buildReasonSelector(),
            const SizedBox(height: 30),
            _buildScheduleButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: ColorConstants.primaryGreen,
      ),
    );
  }

  Widget _buildVaccineInfoCard() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: (vaccine?['color'] as Color?)?.withOpacity(0.1) ??
                    Colors.grey.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                vaccine?['icon'] ?? Icons.medical_services,
                color: vaccine?['color'] ?? Colors.grey,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    vaccine?['name'] ?? 'Không rõ tên vắc xin',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Độ tuổi: ${vaccine?['recommendedAge'] ?? 'Không rõ độ tuổi'}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Ngày tiêm',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        Obx(() => InkWell(
              onTap: () => _showDatePicker(),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      DateFormat('EEEE, dd/MM/yyyy', 'vi_VN')
                          .format(controller.selectedDate.value),
                      style: const TextStyle(fontSize: 15),
                    ),
                    const Icon(Icons.calendar_month,
                        color: ColorConstants.primaryGreen),
                  ],
                ),
              ),
            )),
      ],
    );
  }

  void _showDatePicker() async {
    final DateTime? picked = await showDatePicker(
      context: Get.context!,
      initialDate: controller.selectedDate.value,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 60)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: ColorConstants.primaryGreen,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      controller.selectDate(picked);
    }
  }

  Widget _buildTimeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Chọn khung giờ',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Obx(() => DropdownButton<String>(
                value: controller.selectedTimeSlot.value,
                isExpanded: true,
                underline: const SizedBox(),
                items: controller.timeSlots.map((timeSlot) {
                  final displayText =
                      controller.timeLabels[timeSlot] ?? timeSlot;
                  return DropdownMenuItem<String>(
                    value: timeSlot,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        displayText,
                        style: const TextStyle(fontSize: 15),
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    controller.selectedTimeSlot.value = value;
                  }
                },
              )),
        ),
      ],
    );
  }

  Widget _buildAppointmentInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline,
                  color: ColorConstants.primaryGreen, size: 20),
              const SizedBox(width: 8),
              Text(
                'Thông tin lịch tiêm',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: ColorConstants.primaryGreen,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildInfoRow(Icons.location_on, 'Địa điểm',
              'VNVC Hoàng Văn Thụ\n198 Hoàng Văn Thụ, P. 9, Q. Phú Nhuận, TP.HCM'),
          const SizedBox(height: 12),
          _buildInfoRow(Icons.person, 'Bác sĩ', 'Dr. Nguyễn Văn A'),
          const SizedBox(height: 12),
          _buildInfoRow(Icons.medical_services, 'Phòng tiêm', 'Phòng 101'),
          const SizedBox(height: 12),
          _buildInfoRow(Icons.phone, 'Liên hệ', '028 7102 6595'),
        ],
      ),
    );
  }

  Widget _buildReasonSelector() {
    return Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Lý do thay đổi lịch tiêm',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                    color: controller.reasonError.value.isEmpty
                        ? Colors.grey.shade300
                        : Colors.red),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: controller.reasonController,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'Nhập lý do thay đổi lịch tiêm...',
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  focusedErrorBorder: InputBorder.none,
                ),
                onChanged: (value) {
                  if (controller.reasonError.value.isNotEmpty) {
                    controller.reasonError.value = '';
                  }
                },
              ),
            ),
            if (controller.reasonError.value.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4, left: 12),
                child: Text(
                  controller.reasonError.value,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),
          ],
        ));
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: ColorConstants.primaryGreen.withOpacity(0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(icon, size: 16, color: ColorConstants.primaryGreen),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF1E293B),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildScheduleButton() {
    return Obx(() => SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: controller.isScheduling.value
                ? null
                : () {
                    if (controller.isReschedule &&
                        controller.reasonController.text.trim().isEmpty) {
                      controller.reasonError.value =
                          'Vui lòng nhập lý do thay đổi lịch tiêm';
                    } else {
                      controller.reasonError.value = '';
                      controller.scheduleVaccine(vaccine);
                    }
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorConstants.primaryGreen,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 0,
            ),
            child: controller.isScheduling.value
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Text(
                    'Đổi lịch tiêm',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ));
  }
}
