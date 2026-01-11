import 'package:flutter_getx_boilerplate/modules/facility_map/facility_map_controller.dart';
import 'package:flutter_getx_boilerplate/repositories/facility_map_repository.dart';
import 'package:get/get.dart';

class FacilityMapBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FacilityMapRepository>(
      () => FacilityMapRepository(
        apiClient: Get.find(),
      ),
    );

    Get.lazyPut<FacilityMapController>(
      () => FacilityMapController(Get.find()),
    );
  }
}
