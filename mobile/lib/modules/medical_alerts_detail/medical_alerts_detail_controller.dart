import 'package:flutter/material.dart';
import 'package:flutter_getx_boilerplate/modules/base/base_controller.dart';
import 'package:flutter_getx_boilerplate/repositories/medical_alert_detail_repository.dart';
import 'package:get/get.dart';

class MedicalAlertsDetailController
    extends BaseController<MedicalAlertsDetailRepository> {
  MedicalAlertsDetailController(super.repository);

  final Rx<Map<String, dynamic>> alert = Rx<Map<String, dynamic>>({});
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAlertDetails();
  }

  // void fetchAlertDetails() async {
  //   try {
  //     isLoading.value = true;
  //     // Get alert data from arguments
  //     final args = Get.arguments;
  //     if (args != null && args is Map<String, dynamic>) {
  //       alert.value = args;

  //       // Uncomment to fetch from API if needed
  //       // final response = await repository.getAlertDetails(args['id']);
  //       // alert.value = response;
  //     }
  //   } catch (e) {
  //     Get.snackbar('Lỗi', 'Không thể tải chi tiết cảnh báo');
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }

  void fetchAlertDetails() async {
    try {
      isLoading.value = true;
      final args = Get.arguments;

      if (args != null && args is Map<String, dynamic>) {
        alert.value = args;
      } else {
        // Fake data for testing UI
        alert.value = {
          'id': 1,
          'type': 'vaccine',
          'title': 'Nhắc lịch tiêm vaccine cúm',
          'description':
              'Bạn nên tiêm vaccine cúm mùa trong tuần này để phòng ngừa lây nhiễm.',
          'date': '17/08/2025',
          'additional_info':
              'Vaccine cúm mùa cần được tiêm hàng năm để đảm bảo hiệu quả bảo vệ.',
          'locations': [
            'Bệnh viện Nhi Trung ương, Hà Nội',
            'Trung tâm y tế Quận 1, TP.HCM',
          ],
          'related_vaccine': {
            'id': 101,
            'name': 'Vaccine cúm mùa',
            'manufacturer': 'Sanofi Pasteur',
          },
        };
      }
    } catch (e) {
      Get.snackbar('Lỗi', 'Không thể tải chi tiết cảnh báo');
    } finally {
      isLoading.value = false;
    }
  }

  Color getIconColor(String type) {
    switch (type) {
      case 'vaccine':
        return const Color(0xFF199A8E);
      case 'recall':
        return Colors.redAccent;
      case 'outbreak':
        return Colors.orange;
      case 'location':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  IconData getIcon(String type) {
    switch (type) {
      case 'vaccine':
        return Icons.vaccines;
      case 'recall':
        return Icons.warning_amber_rounded;
      case 'outbreak':
        return Icons.coronavirus;
      case 'location':
        return Icons.location_on;
      default:
        return Icons.notifications;
    }
  }

  void scheduleVaccine() {
    // if (alert.value['type'] == 'vaccine') {
    //   // Access .value first
    //   Get.toNamed('/schedule-vaccine', arguments: {
    //     'vaccine': alert.value['related_vaccine'], // Access .value first
    //   });F
    // }
  }

  void viewMoreInfo() {
    // Implement view more info logic
    // Get.toNamed('/alert-info', arguments: alert.value);
  }
}
