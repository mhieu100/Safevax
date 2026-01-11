import 'package:flutter/material.dart';
import 'package:flutter_getx_boilerplate/modules/base/base_controller.dart';
import 'package:flutter_getx_boilerplate/modules/vaccine_schedule_detail/vaccine_schedule_binding.dart';
import 'package:flutter_getx_boilerplate/modules/vaccine_schedule_detail/vaccine_schedule_screen.dart';
import 'package:flutter_getx_boilerplate/repositories/vaccine_missing_repository.dart';
import 'package:flutter_getx_boilerplate/routes/routes.dart';
import 'package:get/get.dart';

class VaccineMissingController
    extends BaseController<VaccineMissingRepository> {
  VaccineMissingController(super.repository);

  // Fake data for demo, replace with API call later
  var missingVaccines = <Map<String, dynamic>>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchMissingVaccines();
  }

  void fetchMissingVaccines() async {
    await Future.delayed(const Duration(seconds: 1)); // simulate API call
    missingVaccines.assignAll([
      {
        "name": "COVID-19 Booster",
        "recommendedAge": "18+ tuổi",
        "status": "Chưa tiêm",
        "icon": Icons.coronavirus,
        "color": Colors.redAccent,
        "disease": "COVID-19 (nCoV)",
        "requiredDoses": "1 mũi",
        "doseInterval": "Sau mũi cơ bản 6 tháng",
        "sideEffects": "Đau tại chỗ tiêm, mệt mỏi, đau đầu nhẹ",
      },
      {
        "name": "Cúm mùa",
        "recommendedAge": "Mỗi năm",
        "status": "Quá hạn",
        "icon": Icons.sick,
        "color": Colors.orangeAccent,
        "disease": "Cúm mùa (Influenza)",
        "requiredDoses": "1 mũi/năm",
        "doseInterval": "Tiêm nhắc lại hàng năm",
        "sideEffects": "Sốt nhẹ, đau cơ, khó chịu",
      },
      {
        "name": "Viêm gan B",
        "recommendedAge": "Sơ sinh",
        "status": "Còn thiếu 1 mũi",
        "icon": Icons.health_and_safety,
        "color": Colors.blueAccent,
        "disease": "Viêm gan siêu vi B",
        "requiredDoses": "3 mũi (0-1-6 tháng)",
        "doseInterval": "Mũi 2 sau 1 tháng, mũi 3 sau 6 tháng",
        "sideEffects": "Đau tại chỗ tiêm, sốt nhẹ",
      },
      {
        "name": "Sởi - Quai bị - Rubella",
        "recommendedAge": "12-15 tháng",
        "status": "Sắp đến hạn",
        "icon": Icons.medical_services,
        "color": Colors.purpleAccent,
        "disease": "Sởi, Quai bị, Rubella",
        "requiredDoses": "2 mũi",
        "doseInterval": "Mũi 2 cách mũi 1 ít nhất 1 tháng",
        "sideEffects": "Sốt nhẹ, phát ban, sưng hạch",
      },
    ]);
    isLoading.value = false;
  }

  void toVaccineDetailScreen(vaccine) {
    Get.to(
      () => const VaccineScheduleDetailScreen(),
      arguments: vaccine, // Pass the vaccine data
      binding: VaccineScheduleDetailBinding(),
    );
  }

  void toVaccineScheduleScreen(vaccine) {
    NavigatorHelper.toVaccineScheduleScreen();
  }
}
