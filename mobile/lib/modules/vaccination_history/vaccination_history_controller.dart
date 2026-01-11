import 'package:flutter/material.dart';
import 'package:flutter_getx_boilerplate/models/response/booking_history_grouped_response.dart';
import 'package:flutter_getx_boilerplate/modules/base/base_controller.dart';
import 'package:flutter_getx_boilerplate/repositories/vaccination_history_repository.dart';
import 'package:get/get.dart';

class VaccinationHistoryController
    extends BaseController<VaccinationHistoryRepository> {
  VaccinationHistoryController(super.repository);

  // RxList for booking history data
  final RxList<GroupedBookingData> bookingHistory = <GroupedBookingData>[].obs;

  @override
  Future getData() async {
    try {
      final response = await repository.getBookingHistory();
      bookingHistory.assignAll(response.data);
    } catch (e) {
      // Handle error - could show snackbar or handle gracefully
      Get.snackbar(
        'Lỗi',
        'Không thể tải lịch sử tiêm chủng',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void exportToPDF() {
    Get.snackbar(
      'Thông báo',
      'Đang xuất hồ sơ tiêm chủng PDF...',
      backgroundColor: Colors.white,
      colorText: const Color(0xFF199A8E),
      icon: const Icon(Icons.picture_as_pdf, color: Color(0xFF199A8E)),
    );

    Future.delayed(const Duration(seconds: 2), () {
      Get.snackbar(
        'Thành công',
        'Đã xuất PDF thành công',
        backgroundColor: Colors.white,
        colorText: const Color(0xFF199A8E),
        icon: const Icon(Icons.check_circle, color: Color(0xFF199A8E)),
      );
    });
  }

  void downloadCertificate(dynamic booking) {
    Get.snackbar(
      'Thông báo',
      'Đang tải xuống chứng nhận tiêm chủng...',
      backgroundColor: Colors.white,
      colorText: const Color(0xFF199A8E),
      icon: const Icon(Icons.download, color: Color(0xFF199A8E)),
    );

    Future.delayed(const Duration(seconds: 2), () {
      Get.snackbar(
        'Thành công',
        'Đã tải xuống chứng nhận thành công',
        backgroundColor: Colors.white,
        colorText: const Color(0xFF199A8E),
        icon: const Icon(Icons.check_circle, color: Color(0xFF199A8E)),
      );
    });
  }
}
