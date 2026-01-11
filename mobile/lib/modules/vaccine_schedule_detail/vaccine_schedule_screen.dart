// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_getx_boilerplate/shared/shared.dart';
import 'package:get/get.dart';
import 'package:flutter_getx_boilerplate/modules/vaccine_schedule_detail/vaccine_schedule_controller.dart';

class VaccineScheduleDetailScreen
    extends GetView<VaccineScheduleDetailController> {
  const VaccineScheduleDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Obx(
          () => Text(
            controller.vaccine['name'] ?? 'Chi tiết vắc xin',
            style: const TextStyle(color: Colors.white),
          ),
        ),
        backgroundColor: ColorConstants.primaryGreen,
      ),
      body: Obx(() {
        if (controller.vaccine.isEmpty) {
          return const Center(child: Text('Không có thông tin vắc xin'));
        }
        return _buildDetailContent();
      }),
    );
  }

  Widget _buildDetailContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeaderCard(),
          const SizedBox(height: 20),
          _buildSectionTitle("Thông tin chung"),
          _buildInfoCard(Icons.calendar_today, "Độ tuổi khuyến nghị",
              controller.vaccine['recommendedAge']),
          _buildInfoCard(Icons.medical_services, "Số mũi cần tiêm",
              controller.vaccine['requiredDoses']),
          _buildInfoCard(Icons.timelapse, "Khoảng cách giữa các mũi",
              controller.vaccine['doseInterval']),
          const SizedBox(height: 20),
          _buildSectionTitle("Phòng bệnh"),
          _buildDiseaseInfo(),
          const SizedBox(height: 20),
          _buildSectionTitle("Tác dụng phụ"),
          _buildSideEffects(),
          const SizedBox(height: 20),
          _buildSectionTitle("Lưu ý quan trọng"),
          _buildImportantNotes(),
          const SizedBox(height: 30),
          _buildScheduleButton(),
        ],
      ),
    );
  }

  // All the helper widget methods remain the same as previous example
  // Just replace vaccine[...] with controller.vaccine[...]
  Widget _buildHeaderCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor:
                  (controller.vaccine['color'] as Color?)?.withOpacity(0.1) ??
                      Colors.grey.withOpacity(0.1),
              child: Icon(
                controller.vaccine['icon'] ?? Icons.help_outline,
                size: 30,
                color: controller.vaccine['color'] ?? Colors.grey,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    controller.vaccine['name'] ?? 'Không rõ tên',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Chip(
                    backgroundColor: _getStatusColor().withOpacity(0.1),
                    label: Text(
                      controller.vaccine['status'] ?? 'Không rõ trạng thái',
                      style: TextStyle(
                        color: _getStatusColor(),
                        fontWeight: FontWeight.bold,
                      ),
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

  Color _getStatusColor() {
    final status = controller.vaccine['status']?.toString() ?? '';
    if (status.contains("Quá hạn")) return Colors.red;
    if (status.contains("Chưa tiêm")) return Colors.orange;
    if (status.contains("thiếu")) return Colors.blue;
    return Colors.grey;
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: ColorConstants.primaryGreen,
        ),
      ),
    );
  }

  Widget _buildInfoCard(IconData icon, String title, String value) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Icon(icon, color: ColorConstants.primaryGreen),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
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

  Widget _buildDiseaseInfo() {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              controller.vaccine["disease"],
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Vắc xin này giúp phòng ngừa các bệnh nguy hiểm có thể dẫn đến biến chứng nặng hoặc tử vong. Tiêm đủ liều và đúng lịch sẽ tạo miễn dịch bảo vệ tốt nhất.",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSideEffects() {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              controller.vaccine["sideEffects"],
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Các tác dụng phụ thường nhẹ và tự khỏi sau 1-2 ngày. Nếu có biểu hiện sốt cao, co giật hoặc phản ứng nặng, cần đến cơ sở y tế ngay lập tức.",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImportantNotes() {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: const Color(0xFFF8FCFC),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: ColorConstants.primaryGreen, width: 1),
      ),
      child: const Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "• Hoãn tiêm nếu đang sốt cao hoặc mắc bệnh cấp tính\n"
              "• Thông báo cho bác sĩ nếu có tiền sử dị ứng\n"
              "• Theo dõi 30 phút tại điểm tiêm sau khi tiêm\n"
              "• Không dùng thuốc hạ sốt trước khi tiêm",
              style: TextStyle(
                fontSize: 14,
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          controller.toVaccineScheduleScreen();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorConstants.primaryGreen,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: const Text(
          "Đặt lịch tiêm ngay",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
