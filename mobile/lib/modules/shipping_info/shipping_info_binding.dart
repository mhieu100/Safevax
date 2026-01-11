import 'package:flutter_getx_boilerplate/modules/shipping_info/shipping_info_controller.dart';
import 'package:flutter_getx_boilerplate/repositories/shipping_info_repository.dart';
import 'package:get/get.dart';

class ShippingInfoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ShippingInfoRepository>(() => ShippingInfoRepository());
    Get.lazyPut<ShippingInfoController>(
      () => ShippingInfoController(Get.find<ShippingInfoRepository>()),
    );
  }
}
