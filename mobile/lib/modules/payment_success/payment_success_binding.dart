import 'package:flutter_getx_boilerplate/modules/payment_success/payment_success_controller.dart';
import 'package:flutter_getx_boilerplate/repositories/payment_success_repository.dart';
import 'package:get/get.dart';

class PaymentSuccessBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PaymentSuccessRepository>(
      () => PaymentSuccessRepository(
        apiClient: Get.find(),
      ),
    );

    Get.lazyPut<PaymentSuccessController>(
      () => PaymentSuccessController(Get.find()),
    );
  }
}
