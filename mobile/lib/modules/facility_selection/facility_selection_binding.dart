import 'package:flutter_getx_boilerplate/modules/facility_selection/facility_selection_controller.dart';
import 'package:flutter_getx_boilerplate/repositories/facility_selection_repository.dart';
import 'package:get/get.dart';

class FacilitySelectionBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FacilitySelectionRepository>(
      () => FacilitySelectionRepository(
        apiClient: Get.find(),
      ),
    );

    Get.lazyPut<FacilitySelectionController>(
      () => FacilitySelectionController(Get.find()),
    );
  }
}
