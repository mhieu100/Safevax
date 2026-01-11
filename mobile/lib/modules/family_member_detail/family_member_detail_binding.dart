import 'package:flutter_getx_boilerplate/modules/family_member_detail/family_member_detail_controller.dart';
import 'package:flutter_getx_boilerplate/repositories/family_management_repository.dart';
import 'package:flutter_getx_boilerplate/repositories/vaccine_management_repository.dart';
import 'package:get/get.dart';

class FamilyMemberDetailBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FamilyManangementRepository>(
      () => FamilyManangementRepository(
        apiClient: Get.find(),
      ),
    );

    Get.lazyPut<VaccineManagementRepository>(
      () => VaccineManagementRepository(
        apiClient: Get.find(),
      ),
    );

    Get.lazyPut<FamilyMemberDetailController>(
      () => FamilyMemberDetailController(Get.find(), Get.find()),
    );
  }
}
