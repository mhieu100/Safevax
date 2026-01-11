import 'package:flutter_getx_boilerplate/modules/vaccine_missing/vaccine_missing_controller.dart';
import 'package:flutter_getx_boilerplate/repositories/vaccine_missing_repository.dart';
import 'package:get/get.dart';

class VaccineMissingBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VaccineMissingRepository>(
      () => VaccineMissingRepository(
        apiClient: Get.find(),
      ),
    );

    Get.lazyPut<VaccineMissingController>(
      () => VaccineMissingController(Get.find()),
    );
  }
}
