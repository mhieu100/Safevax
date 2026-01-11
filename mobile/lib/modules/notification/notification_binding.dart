import 'package:flutter_getx_boilerplate/modules/notification/notification_controller.dart';
import 'package:flutter_getx_boilerplate/repositories/notification_repository.dart';
import 'package:get/get.dart';

class NotificationBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NotificationRepository>(
      () => NotificationRepository(
        apiClient: Get.find(),
      ),
    );

    Get.lazyPut<NotificationController>(
      () => NotificationController(Get.find()),
    );
  }
}
