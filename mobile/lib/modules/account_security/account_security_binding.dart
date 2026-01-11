import 'package:flutter_getx_boilerplate/modules/account_security/account_security_controller.dart';
import 'package:flutter_getx_boilerplate/repositories/account_security_repository.dart';
import 'package:get/get.dart';

class AccountSecurityBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AccountSecurityRepository>(
      () => AccountSecurityRepository(
        apiClient: Get.find(),
      ),
    );

    Get.lazyPut<AccountSecurityController>(
      () => AccountSecurityController(Get.find()),
    );
  }
}
