import 'package:flutter_getx_boilerplate/modules/medical_alerts_detail/medical_alerts_detail_controller.dart';
import 'package:flutter_getx_boilerplate/repositories/medical_alert_detail_repository.dart';
import 'package:get/get.dart';

class MedicalAlertsDetailBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MedicalAlertsDetailRepository>(
      () => MedicalAlertsDetailRepository(
        apiClient: Get.find(),
      ),
    );

    Get.lazyPut<MedicalAlertsDetailController>(
      () => MedicalAlertsDetailController(Get.find()),
    );
  }
}
