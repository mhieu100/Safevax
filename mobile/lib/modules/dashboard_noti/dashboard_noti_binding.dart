import 'package:flutter_getx_boilerplate/modules/dashboard_noti/dashboard_noti_controller.dart';
import 'package:flutter_getx_boilerplate/repositories/dashboard_noti_repository.dart';
import 'package:get/get.dart';

class DashboardNotiBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashboardNotiRepository>(
      () => DashboardNotiRepository(
        apiClient: Get.find(),
      ),
    );

    Get.lazyPut<DashboardNotiController>(
      () => DashboardNotiController(Get.find()),
    );
  }
}
