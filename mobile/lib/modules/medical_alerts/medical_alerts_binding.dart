import 'package:flutter_getx_boilerplate/modules/medical_alerts/medical_alerts_controller.dart';
import 'package:flutter_getx_boilerplate/repositories/medical_alert_repository.dart';
import 'package:get/get.dart';

class MedicalAlertsBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MedicalAlertsRepository>(
      () => MedicalAlertsRepository(
        apiClient: Get.find(),
      ),
    );

    Get.lazyPut<MedicalAlertsController>(
      () => MedicalAlertsController(Get.find()),
    );
  }
}
