import 'package:flutter_getx_boilerplate/modules/vaccine_payment/vaccine_payment_controller.dart';
import 'package:flutter_getx_boilerplate/repositories/vaccine_payment_repository.dart';
import 'package:get/get.dart';

class VaccinePaymentBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VaccinePaymentRepository>(
      () => VaccinePaymentRepository(
        apiClient: Get.find(),
      ),
    );

    Get.lazyPut<VaccinePaymentController>(
      () => VaccinePaymentController(Get.find()),
    );
  }
}
