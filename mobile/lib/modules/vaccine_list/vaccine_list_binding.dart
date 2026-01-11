import 'package:flutter_getx_boilerplate/modules/vaccine_list/vaccine_list_controller.dart';
import 'package:flutter_getx_boilerplate/repositories/vaccine_list_repository.dart';
import 'package:get/get.dart';

class VaccineListBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VaccineListRepository>(
      () => VaccineListRepository(
        apiClient: Get.find(),
      ),
    );

    Get.lazyPut<VaccineListController>(
      () => VaccineListController(Get.find()),
    );
  }
}
