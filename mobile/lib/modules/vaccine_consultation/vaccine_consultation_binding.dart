import 'package:flutter_getx_boilerplate/modules/vaccine_consultation/vaccine_consultation_controller.dart';
import 'package:flutter_getx_boilerplate/repositories/vaccine_consultation_repository.dart';
import 'package:get/get.dart';

class VaccineConsultationBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VaccineConsultationRepository>(
      () => VaccineConsultationRepository(
        apiClient: Get.find(),
      ),
    );

    Get.lazyPut<VaccineConsultationController>(
      () => VaccineConsultationController(Get.find()),
    );
  }
}
