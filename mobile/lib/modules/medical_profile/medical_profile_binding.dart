import 'package:flutter_getx_boilerplate/modules/medical_profile/medical_profile_controller.dart';
import 'package:flutter_getx_boilerplate/repositories/medical_profile_repository.dart';
import 'package:get/get.dart';

class MedicalProfileBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MedicalProfileRepository>(
      () => MedicalProfileRepository(
        apiClient: Get.find(),
      ),
    );

    Get.lazyPut<MedicalProfileController>(
      () => MedicalProfileController(Get.find()),
    );
  }
}
