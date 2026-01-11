import 'package:flutter_getx_boilerplate/modules/register/register_controller.dart';
import 'package:flutter_getx_boilerplate/repositories/register_repository.dart';
import 'package:get/get.dart';

class RegisterBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RegisterRepository>(
      () => RegisterRepository(
        apiClient: Get.find(),
      ),
    );

    Get.lazyPut<RegisterController>(
      () => RegisterController(Get.find()),
    );
  }
}
