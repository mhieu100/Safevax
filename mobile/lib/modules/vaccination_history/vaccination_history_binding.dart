import 'package:flutter_getx_boilerplate/modules/vaccination_history/vaccination_history_controller.dart';
import 'package:flutter_getx_boilerplate/repositories/vaccination_history_repository.dart';
import 'package:get/get.dart';

class VaccinationHistoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VaccinationHistoryRepository>(
      () => VaccinationHistoryRepository(
        apiClient: Get.find(),
      ),
    );
    Get.lazyPut<VaccinationHistoryController>(
      () => VaccinationHistoryController(
        Get.find(),
      ),
    );
  }
}
