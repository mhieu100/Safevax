import 'package:flutter_getx_boilerplate/modules/change_password/change_password_controller.dart';
import 'package:flutter_getx_boilerplate/repositories/auth_repository.dart';
import 'package:get/get.dart';

class ChangePasswordBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthRepository>(
      () => AuthRepository(apiClient: Get.find()),
    );
    Get.lazyPut<ChangePasswordController>(
      () => ChangePasswordController(Get.find<AuthRepository>()),
    );
  }
}
