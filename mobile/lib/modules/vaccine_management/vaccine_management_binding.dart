import 'package:flutter_getx_boilerplate/modules/vaccine_management/vaccine_management_controller.dart';
import 'package:flutter_getx_boilerplate/repositories/appointment_reschedule_repository.dart';
import 'package:flutter_getx_boilerplate/repositories/vaccine_management_repository.dart';
import 'package:get/get.dart';

class VaccineManagementBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AppointmentRescheduleRepository>(
      () => AppointmentRescheduleRepository(apiClient: Get.find()),
    );
    Get.lazyPut<VaccineManagementController>(
      () => VaccineManagementController(Get.find()),
    );
  }
}
