import 'package:flutter_getx_boilerplate/modules/family_management/family_management_controller.dart';
import 'package:flutter_getx_boilerplate/repositories/family_management_repository.dart';
import 'package:get/get.dart';

class FamilyManangementBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FamilyManangementRepository>(
      () => FamilyManangementRepository(
        apiClient: Get.find(),
      ),
    );

    Get.lazyPut<FamilyManangementController>(
      () => FamilyManangementController(Get.find()),
    );
  }
}
