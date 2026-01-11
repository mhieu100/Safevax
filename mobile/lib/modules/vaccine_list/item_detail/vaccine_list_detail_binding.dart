import 'package:flutter_getx_boilerplate/modules/vaccine_list/item_detail/vaccine_list_detail_controller.dart';
import 'package:flutter_getx_boilerplate/repositories/vaccine_list_repository.dart';
import 'package:get/get.dart';

class VaccineListDetailBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VaccineListRepository>(
      () => VaccineListRepository(
        apiClient: Get.find(),
      ),
    );

    Get.lazyPut<VaccineListDetailController>(
      () => VaccineListDetailController(Get.find()),
    );
  }
}
