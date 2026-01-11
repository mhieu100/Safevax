import 'package:flutter/material.dart';
import 'package:flutter_getx_boilerplate/modules/vaccine_missing/vaccine_missing_controller.dart';
import 'package:get/get.dart';

class VaccineMissingScreen extends GetView<VaccineMissingController> {
  const VaccineMissingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FCFC),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text("Vắc xin còn thiếu",
            style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF199A8E),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.info_outline,
              color: Colors.white,
            ),
            onPressed: () {
              Get.dialog(
                AlertDialog(
                  title: const Text("Thông tin vắc xin thiếu"),
                  content: const Text(
                    "Danh sách này hiển thị các loại vắc xin được khuyến nghị nhưng chưa được tiêm hoặc đã quá hạn so với độ tuổi khuyến nghị.",
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Get.back(),
                      child: const Text("Đóng"),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.missingVaccines.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.verified_user, size: 60, color: Colors.green),
                const SizedBox(height: 16),
                const Text(
                  "Không có vắc xin nào thiếu",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  "Bạn đã hoàn thành tất cả các mũi tiêm được khuyến nghị",
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Card(
                color: const Color(0xFFE8F5F4),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      const Icon(Icons.warning_amber_rounded,
                          color: Color(0xFF199A8E)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          "Bạn có ${controller.missingVaccines.length} vắc xin chưa tiêm",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF199A8E),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: controller.missingVaccines.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final vaccine = controller.missingVaccines[index];
                  return _buildVaccineCard(context, vaccine);
                },
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildVaccineCard(BuildContext context, Map<String, dynamic> vaccine) {
    final isOverdue = vaccine["status"] == "Quá hạn";

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          leading: CircleAvatar(
            radius: 24,
            backgroundColor: vaccine["color"].withOpacity(0.1),
            child: Icon(vaccine["icon"], color: vaccine["color"], size: 24),
          ),
          title: Text(
            vaccine["name"],
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
          ),
          subtitle: Text(
            "Độ tuổi khuyến nghị: ${vaccine["recommendedAge"]}",
            style: TextStyle(color: Colors.grey[700], fontSize: 14),
          ),
          trailing: Chip(
            backgroundColor: isOverdue ? Colors.red[50] : Colors.orange[50],
            label: Text(
              vaccine["status"],
              style: TextStyle(
                color: isOverdue ? Colors.red : Colors.orange,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoRow("Phòng bệnh:", vaccine["disease"]),
                  _buildInfoRow("Số mũi cần tiêm:", vaccine["requiredDoses"]),
                  _buildInfoRow(
                      "Khoảng cách giữa các mũi:", vaccine["doseInterval"]),
                  _buildInfoRow(
                      "Tác dụng phụ thường gặp:", vaccine["sideEffects"]),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            controller.toVaccineDetailScreen(vaccine);
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF199A8E),
                            side: const BorderSide(color: Color(0xFF199A8E)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text("Chi tiết"),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            controller.toVaccineScheduleScreen(vaccine);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF199A8E),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text("Đặt lịch"),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
