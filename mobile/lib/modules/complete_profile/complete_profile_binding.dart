import 'package:flutter_getx_boilerplate/modules/complete_profile/complete_profile_controller.dart';
import 'package:flutter_getx_boilerplate/repositories/register_repository.dart';
import 'package:get/get.dart';

class CompleteProfileBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RegisterRepository>(
      () => RegisterRepository(
        apiClient: Get.find(),
      ),
    );

    Get.lazyPut<CompleteProfileController>(
      () => CompleteProfileController(Get.find()),
    );
  }
}
