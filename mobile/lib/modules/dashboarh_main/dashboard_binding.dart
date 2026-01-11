import 'package:flutter_getx_boilerplate/modules/dashboarh_main/dashboard_controller.dart';
import 'package:flutter_getx_boilerplate/repositories/dashboard_repository.dart';
import 'package:flutter_getx_boilerplate/repositories/medical_news_repository.dart';
import 'package:get/get.dart';

class DashboardBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashboardRepository>(
      () => DashboardRepository(
        apiClient: Get.find(),
      ),
    );

    Get.lazyPut<MedicalNewsRepository>(
      () => MedicalNewsRepository(
        apiClient: Get.find(),
      ),
    );

    Get.lazyPut<DashboardController>(
      () => DashboardController(Get.find(), Get.find()),
    );
  }
}
