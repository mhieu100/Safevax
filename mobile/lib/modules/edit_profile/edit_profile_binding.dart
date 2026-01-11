import 'package:flutter_getx_boilerplate/modules/edit_profile/edit_profile_controller.dart';
import 'package:flutter_getx_boilerplate/repositories/auth_repository.dart';
import 'package:get/get.dart';

class EditProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthRepository>(
      () => AuthRepository(apiClient: Get.find()),
    );
    Get.lazyPut<EditProfileController>(
      () => EditProfileController(),
    );
  }
}
