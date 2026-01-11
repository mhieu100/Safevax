import 'package:flutter_getx_boilerplate/modules/my_app/bottom_nav_controller.dart';
import 'package:flutter_getx_boilerplate/repositories/bottom_nav_repository.dart';
import 'package:get/get.dart';

class BottomNavBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BottomNavRepository>(
      () => BottomNavRepository(
        apiClient: Get.find(),
      ),
    );

    Get.lazyPut<BottomNavController>(
      () => BottomNavController(Get.find()),
    );
  }
}
