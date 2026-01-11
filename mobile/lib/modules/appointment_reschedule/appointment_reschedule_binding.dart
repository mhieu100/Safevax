import 'package:flutter_getx_boilerplate/modules/appointment_reschedule/appointment_reschedule_controller.dart';
import 'package:flutter_getx_boilerplate/repositories/appointment_reschedule_repository.dart';
import 'package:get/get.dart';

class AppointmentRescheduleBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AppointmentRescheduleRepository>(
      () => AppointmentRescheduleRepository(
        apiClient: Get.find(),
      ),
    );

    Get.lazyPut<AppointmentRescheduleController>(
      () => AppointmentRescheduleController(Get.find()),
    );
  }
}
