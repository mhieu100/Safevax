import 'package:flutter_getx_boilerplate/modules/payment_methods/payment_methods_controller.dart';
import 'package:get/get.dart';

class PaymentMethodsBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PaymentMethodsController>(
      () => PaymentMethodsController(),
    );
  }
}