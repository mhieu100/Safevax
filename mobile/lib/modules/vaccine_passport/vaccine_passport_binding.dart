import 'package:flutter_getx_boilerplate/modules/vaccine_passport/vaccine_passport_controller.dart';
import 'package:flutter_getx_boilerplate/repositories/vaccine_passport_repository.dart';
import 'package:get/get.dart';

class VaccinePassportBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VaccinePassportRepository>(
      () => VaccinePassportRepository(
        apiClient: Get.find(),
      ),
    );

    Get.lazyPut<VaccinePassportController>(
      () => VaccinePassportController(Get.find()),
    );
  }
}
