import 'package:flutter_getx_boilerplate/modules/profile/profile_controller.dart';
import 'package:flutter_getx_boilerplate/repositories/profile_repository.dart';
import 'package:get/get.dart';

class ProfileBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileRepository>(
      () => ProfileRepository(
        apiClient: Get.find(),
      ),
    );

    Get.lazyPut<ProfileController>(
      () => ProfileController(Get.find()),
    );
  }
}
