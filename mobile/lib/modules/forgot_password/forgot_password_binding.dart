import 'package:flutter_getx_boilerplate/modules/forgot_password/forgot_password_controller.dart';
import 'package:flutter_getx_boilerplate/repositories/forgot_password_repository.dart';
import 'package:get/get.dart';

class ForgotPasswordBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ForgotPasswordRepository>(
      () => ForgotPasswordRepository(
        apiClient: Get.find(),
      ),
    );

    Get.lazyPut<ForgotPasswordController>(
      () => ForgotPasswordController(Get.find()),
    );
  }
}
