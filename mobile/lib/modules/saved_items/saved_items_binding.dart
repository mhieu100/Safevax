import 'package:flutter_getx_boilerplate/modules/saved_items/saved_items_controller.dart';
import 'package:get/get.dart';

class SavedItemsBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SavedItemsController>(
      () => SavedItemsController(),
    );
  }
}