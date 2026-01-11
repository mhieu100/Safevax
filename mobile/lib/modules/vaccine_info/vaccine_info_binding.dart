import 'package:flutter_getx_boilerplate/modules/vaccine_info/vaccine_info_controller.dart';
import 'package:flutter_getx_boilerplate/repositories/vaccine_info_repository.dart';
import 'package:get/get.dart';

class VaccineInfoBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VaccineInfoRepository>(
      () => VaccineInfoRepository(
        apiClient: Get.find(),
      ),
    );

    Get.lazyPut<VaccineInfoController>(
      () => VaccineInfoController(Get.find()),
    );
  }
}
