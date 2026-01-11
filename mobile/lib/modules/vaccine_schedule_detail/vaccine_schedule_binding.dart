import 'package:flutter_getx_boilerplate/modules/vaccine_schedule_detail/vaccine_schedule_controller.dart';
import 'package:flutter_getx_boilerplate/repositories/vaccine_schedule_detail_repository.dart';
import 'package:get/get.dart';

class VaccineScheduleDetailBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VaccineScheduleDetailRepository>(
      () => VaccineScheduleDetailRepository(
        apiClient: Get.find(),
      ),
    );

    Get.lazyPut<VaccineScheduleDetailController>(
      () => VaccineScheduleDetailController(Get.find()),
    );
  }
}
