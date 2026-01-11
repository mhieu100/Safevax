// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_getx_boilerplate/shared/constants/colors.dart';
import 'package:get/get.dart';
import 'vaccine_info_controller.dart';

class VaccineInfoScreen extends GetView<VaccineInfoController> {
  const VaccineInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FCFC),
      appBar: AppBar(
        title: const Text('Thông tin Vaccine',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
        centerTitle: true,
        backgroundColor: ColorConstants.secondaryGreen,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.vaccines.isEmpty) {
          return Center(
            child: Text('Thông tin vaccine không tìm thấy',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500)),
          );
        }

        final vaccine = controller.vaccines.first;

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Vaccine Header Card
              _vaccineHeader(context, vaccine),

              const SizedBox(height: 32),

              // Section: Vaccine Details
              _sectionTitle('🧬 Thông tin vaccine', Icons.medical_services),
              const SizedBox(height: 12),

              _infoDetailCard(
                title: 'Thành phần',
                icon: Icons.science_outlined,
                content: vaccine['ingredients'] ?? 'Không có thông tin',
              ),
              _infoDetailCard(
                title: 'Nhà sản xuất',
                icon: Icons.business_outlined,
                content: vaccine['manufacturer'] ?? 'Không có thông tin',
              ),
              _infoDetailCard(
                title: 'Số lô',
                icon: Icons.confirmation_number_outlined,
                content: vaccine['lotNumber'] ?? 'Không có thông tin',
              ),
              _infoDetailCard(
                title: 'Chống chỉ định',
                icon: Icons.warning_amber_outlined,
                content: vaccine['contraindications'] ?? 'Không có thông tin',
                isWarning: true,
              ),

              const SizedBox(height: 40),

              // Section: Blockchain Trace
              _sectionTitle('🔗 Nguồn gốc vaccine (Blockchain)', Icons.link),
              const SizedBox(height: 12),

              _blockchainTimeline(
                steps: [
                  {
                    'title': 'Nơi sản xuất',
                    'desc': vaccine['origin'] ?? 'Thông tin chưa có',
                    'icon': Icons.factory_outlined,
                  },
                  {
                    'title': 'Vận chuyển',
                    'desc': vaccine['transport'] ?? 'Thông tin chưa có',
                    'icon': Icons.local_shipping_outlined,
                  },
                  {
                    'title': 'Trung tâm tiêm chủng',
                    'desc': vaccine['vaccinationCenter'] ?? 'Thông tin chưa có',
                    'icon': Icons.local_hospital_outlined,
                  },
                ],
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _vaccineHeader(BuildContext context, Map vaccine) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [ColorConstants.secondaryGreen, Color(0xFF16B2A2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.07),
              blurRadius: 12,
              offset: const Offset(0, 6)),
        ],
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 32,
            backgroundColor: Colors.white24,
            child: Icon(Icons.medical_services, color: Colors.white, size: 36),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Text(
              vaccine['name'] ?? 'Vaccine',
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium
                  ?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String text, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: ColorConstants.secondaryGreen, size: 22),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: ColorConstants.secondaryGreen,
          ),
        ),
      ],
    );
  }

  Widget _infoDetailCard({
    required String title,
    required IconData icon,
    required String content,
    bool isWarning = false,
  }) {
    final bgColor =
        isWarning ? const Color(0xFFFFF3E0) : const Color(0xFFE8F5F4);
    final iconColor = isWarning ? Colors.orange : ColorConstants.secondaryGreen;

    return Card(
      color: bgColor,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 28),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade700)),
                  const SizedBox(height: 6),
                  Text(
                    content,
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                        height: 1.4),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _blockchainTimeline({required List<Map<String, dynamic>> steps}) {
    return Column(
      children: List.generate(steps.length, (index) {
        final step = steps[index];
        final isLast = index == steps.length - 1;

        return Padding(
          padding: EdgeInsets.only(bottom: isLast ? 0 : 24),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Step indicator & line
              Column(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: ColorConstants.primaryGreen,
                    child: Icon(step['icon'], color: Colors.white, size: 20),
                  ),
                  if (!isLast)
                    Container(
                      width: 3,
                      height: 60,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 20),

              // Step info card
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F5F4), // background
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 5))
                    ],
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(step['title'],
                            style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: ColorConstants.secondaryGreen)),
                        const SizedBox(height: 6),
                        Text(step['desc'],
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey.shade800,
                                height: 1.4)),
                      ]),
                ),
              )
            ],
          ),
        );
      }),
    );
  }
}
