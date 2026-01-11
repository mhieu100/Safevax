// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_getx_boilerplate/modules/medical_alerts_detail/medical_alerts_detail_controller.dart';
import 'package:flutter_getx_boilerplate/shared/constants/colors.dart';

class MedicalAlertsDetailScreen extends GetView<MedicalAlertsDetailController> {
  const MedicalAlertsDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FCFC),
      appBar: AppBar(
        title: const Text(
          'Chi tiết cảnh báo',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: ColorConstants.secondaryGreen,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.alert.value.isEmpty) {
          // Access .value here
          return const Center(child: Text('Không tìm thấy thông tin cảnh báo'));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAlertHeader(),
              const SizedBox(height: 24),
              _buildAlertContent(),
              const SizedBox(height: 24),
              if (controller.alert.value['type'] ==
                      'vaccine' || // Access .value here
                  controller.alert.value['type'] ==
                      'recall') // Access .value here
                _buildActionButtons(),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildAlertHeader() {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: controller
                    .getIconColor(
                        controller.alert.value['type']) // Access .value here
                    .withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                controller.getIcon(
                    controller.alert.value['type']), // Access .value here
                color: controller.getIconColor(
                    controller.alert.value['type']), // Access .value here
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    controller.alert.value['title'] ??
                        'Không có tiêu đề', // Access .value here
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    controller.alert.value['date'] ?? '', // Access .value here
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
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

  Widget _buildAlertContent() {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Nội dung chi tiết',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: ColorConstants.secondaryGreen,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              controller.alert.value['description'] ??
                  'Không có nội dung', // Access .value here
              style: const TextStyle(
                fontSize: 15,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 16),
            if (controller.alert.value['additional_info'] !=
                null) // Access .value here
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Thông tin bổ sung:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(controller
                      .alert.value['additional_info']), // Access .value here
                ],
              ),
            const SizedBox(height: 16),
            if (controller.alert.value['locations'] !=
                null) // Access .value here
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Địa điểm liên quan:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...List<Widget>.from(
                    controller.alert.value['locations']
                        .map((location) => Padding(
                              // Access .value here
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(Icons.location_on,
                                      size: 16, color: Colors.grey),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      location,
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ),
                                ],
                              ),
                            )),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        if (controller.alert.value['type'] == 'vaccine') // Access .value here
          Expanded(
            child: ElevatedButton.icon(
              onPressed: controller.scheduleVaccine,
              icon: const Icon(Icons.calendar_today, size: 20),
              label: const Text('Đặt lịch tiêm',
                  style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                iconColor: Colors.white,
                backgroundColor: ColorConstants.primaryGreen,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        if (controller.alert.value['type'] == 'vaccine') // Access .value here
          const SizedBox(width: 12),
        if (controller.alert.value['type'] == 'recall' || // Access .value here
            controller.alert.value['type'] == 'vaccine') // Access .value here
          Expanded(
            child: OutlinedButton.icon(
              onPressed: controller.viewMoreInfo,
              icon: const Icon(Icons.cancel_outlined, color: Color(0xFF199A8E)),
              label: const Text(
                "Xoá",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF199A8E),
                  fontSize: 16,
                ),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: ColorConstants.secondaryGreen,
                side: const BorderSide(color: ColorConstants.secondaryGreen),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
