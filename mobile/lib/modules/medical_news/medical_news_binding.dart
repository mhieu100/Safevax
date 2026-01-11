import 'package:flutter_getx_boilerplate/modules/medical_news/medical_news_controller.dart';
import 'package:flutter_getx_boilerplate/repositories/medical_news_repository.dart';
import 'package:get/get.dart';

class MedicalNewsBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MedicalNewsRepository>(
      () => MedicalNewsRepository(
        apiClient: Get.find(),
      ),
    );

    Get.lazyPut<MedicalNewsController>(
      () => MedicalNewsController(Get.find()),
    );
  }
}
