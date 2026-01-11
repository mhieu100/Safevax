import 'package:flutter_getx_boilerplate/modules/appointment_list/appointment_list_controller.dart';
import 'package:flutter_getx_boilerplate/repositories/appointment_reschedule_repository.dart';
import 'package:get/get.dart';

class AppointmentListBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AppointmentRescheduleRepository>(
      () => AppointmentRescheduleRepository(apiClient: Get.find()),
    );
    Get.lazyPut<AppointmentListController>(
      () => AppointmentListController(Get.find()),
    );
  }
}
