import 'package:flutter_getx_boilerplate/modules/schedule_selection/schedule_selection_controller.dart';
import 'package:flutter_getx_boilerplate/repositories/schedule_selection_repository.dart';
import 'package:get/get.dart';

class ScheduleSelectionBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ScheduleSelectionRepository>(
      () => ScheduleSelectionRepository(
        apiClient: Get.find(),
      ),
    );

    Get.lazyPut<ScheduleSelectionController>(
      () => ScheduleSelectionController(Get.find()),
    );
  }
}
