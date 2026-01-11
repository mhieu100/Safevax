import 'package:flutter_getx_boilerplate/modules/medical_details/medical_details_controller.dart';
import 'package:flutter_getx_boilerplate/repositories/medical_details_repository.dart';
import 'package:get/get.dart';

class MedicalNewsDetailBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MedicalNewsDetailRepository>(
      () => MedicalNewsDetailRepository(
        apiClient: Get.find(),
      ),
    );

    Get.lazyPut<MedicalNewsDetailController>(
      () => MedicalNewsDetailController(Get.find()),
    );
  }
}
