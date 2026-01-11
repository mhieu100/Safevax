import 'package:flutter_getx_boilerplate/modules/reminder/reminder_controller.dart';
import 'package:flutter_getx_boilerplate/repositories/reminder_repository.dart';
import 'package:get/get.dart';

class ReminderBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReminderRepository>(
      () => ReminderRepository(
        apiClient: Get.find(),
      ),
    );

    Get.lazyPut<ReminderController>(
      () => ReminderController(Get.find()),
    );
  }
}
