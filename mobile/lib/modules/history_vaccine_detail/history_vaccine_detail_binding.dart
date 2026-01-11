// lib/modules/history_vaccine_detail/history_vaccine_detail_binding.dart
import 'package:flutter_getx_boilerplate/api/api.dart';
import 'package:flutter_getx_boilerplate/modules/history_vaccine_detail/history_vaccine_detail_controller.dart';
import 'package:flutter_getx_boilerplate/repositories/history_vaccine_detail_repository.dart';
import 'package:get/get.dart';

class HistoryVaccineDetailBinding extends Bindings {
  @override
  void dependencies() {
    // Repository
    Get.lazyPut<HistoryVaccineDetailRepository>(
      () => HistoryVaccineDetailRepository(
        apiClient: Get.find<ApiServices>(),
      ),
    );

    // Controller
    Get.lazyPut<HistoryVaccineDetailController>(
      () => HistoryVaccineDetailController(
        Get.find<HistoryVaccineDetailRepository>(),
      ),
    );
  }
}