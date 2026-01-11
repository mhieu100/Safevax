import 'package:flutter/material.dart';
import 'package:flutter_getx_boilerplate/modules/base/base_controller.dart';
import 'package:flutter_getx_boilerplate/repositories/vaccine_detail_repository.dart';
import 'package:flutter_getx_boilerplate/routes/navigator_helper.dart';
import 'package:get/get.dart';

class VaccineDetailController extends BaseController<VaccineDetailRepository> {
  VaccineDetailController(super.repository);
  final RxMap<String, dynamic> vaccine = <String, dynamic>{}.obs;

  @override
  void onInit() {
    super.onInit();
    // Get vaccine data from arguments
    final args = Get.arguments ?? {};
    if (args.containsKey('title')) {
      // It's news data, map to vaccine format
      vaccine.value = {
        'name': args['title'] ?? 'Không rõ tên',
        'recommendedAge': 'Tùy theo loại vaccine',
        'requiredDoses': 'Theo khuyến cáo',
        'doseInterval': 'Theo lịch tiêm',
        'disease': args['shortDescription'] ?? 'Thông tin sức khỏe',
        'sideEffects': args['content'] ?? 'Chi tiết trong bài viết',
        'importantNotes': args['tags'] ?? '',
        'status': 'Thông tin',
        'color': const Color(0xFF199A8E),
        'icon': Icons.article,
      };
    } else {
      vaccine.value = args;
    }
  }

  void toVaccineScheduleScreen() {
    NavigatorHelper.toVaccineScheduleScreen();
  }
}
