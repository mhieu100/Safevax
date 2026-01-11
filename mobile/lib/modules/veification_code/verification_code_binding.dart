import 'package:flutter_getx_boilerplate/modules/veification_code/verification_code_controller.dart';
import 'package:flutter_getx_boilerplate/repositories/verification_code_repository.dart';
import 'package:get/get.dart';

class VerificationCodeBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VerificationCodeRepository>(
      () => VerificationCodeRepository(
        apiClient: Get.find(),
      ),
    );

    Get.lazyPut<VerificationCodeController>(
      () => VerificationCodeController(Get.find()),
    );
  }
}
