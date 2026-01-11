import 'package:flutter_getx_boilerplate/modules/vaccine_list/person_selection/person_selection_controller.dart';
import 'package:flutter_getx_boilerplate/repositories/family_management_repository.dart';
import 'package:get/get.dart';

class PersonSelectionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FamilyManangementRepository>(
      () => FamilyManangementRepository(
        apiClient: Get.find(),
      ),
    );
    Get.lazyPut<PersonSelectionController>(
      () => PersonSelectionController(Get.find<FamilyManangementRepository>()),
    );
  }
}
