import 'package:flutter_getx_boilerplate/modules/vaccine_schedule/vaccine_schedule_controller.dart';
import 'package:flutter_getx_boilerplate/repositories/appointment_reschedule_repository.dart';
import 'package:get/get.dart';

class VaccineScheduleBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AppointmentRescheduleRepository>(
      () => AppointmentRescheduleRepository(apiClient: Get.find()),
    );
    Get.lazyPut<VaccineScheduleController>(
      () => VaccineScheduleController(),
    );
  }
}
