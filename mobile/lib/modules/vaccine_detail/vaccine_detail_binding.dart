import 'package:flutter_getx_boilerplate/modules/vaccine_detail/vaccine_detail_controller.dart';
import 'package:flutter_getx_boilerplate/repositories/vaccine_detail_repository.dart';
import 'package:get/get.dart';

class VaccineDetailBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VaccineDetailRepository>(
      () => VaccineDetailRepository(
        apiClient: Get.find(),
      ),
    );

    Get.lazyPut<VaccineDetailController>(
      () => VaccineDetailController(Get.find()),
    );
  }
}
