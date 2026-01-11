// lib/modules/vaccine_list/vaccine_list_controller.dart
import 'package:flutter_getx_boilerplate/models/vaccine_model/healthcare_facility_model.dart';
import 'package:flutter_getx_boilerplate/models/vaccine_model/vaccine_model.dart';
import 'package:flutter_getx_boilerplate/modules/vaccine_list/vaccine_list_controller.dart';
import 'package:flutter_getx_boilerplate/repositories/vaccine_list_repository.dart';
import 'package:flutter_getx_boilerplate/routes/navigator_helper.dart';
import 'package:flutter_getx_boilerplate/routes/routes.dart';
import 'package:get/get.dart';
import 'package:flutter_getx_boilerplate/modules/base/base_controller.dart';

class VaccineListDetailController
    extends BaseController<VaccineListRepository> {
  VaccineListDetailController(super.repository);
  // Get VaccineListController instance
  VaccineListController get vaccineListController =>
      Get.find<VaccineListController>();

// Get selected vaccines from either selectedVaccine or cart items
  VaccineModel? get selectedVaccines {
    // If there's a selected vaccine (single vaccine scenario)
    return vaccineListController.selectedVaccine.value;
  }

  // list detail
  final isLoading = false.obs;

  final vaccine = Rx<VaccineModel?>(null);
  final isFavorite = false.obs;
  final selectedTabIndex = 0.obs;
  final isExpanded = false.obs;
  final error = ''.obs;
  final healthcareFacilities = <HealthcareFacility>[].obs;
  final selectedFacility = Rx<HealthcareFacility?>(null);

  void toggleFavorite() {
    isFavorite.value = !isFavorite.value;
  }

  @override
  void onInit() {
    super.onInit();

    // list detail
    loadVaccineDetail();
  }

// List Detail

  Future<void> loadVaccineDetail() async {
    try {
      isLoading.value = true;
      error.value = '';
      // final vaccineId = Get.parameters['vaccineId'] ?? '1';
      // final result = await repository.getVaccineDetail(vaccineId);
      vaccine.value = selectedVaccines;
    } catch (e) {
      error.value = 'Không thể tải thông tin vaccine. Vui lòng thử lại.';
    } finally {
      isLoading.value = false;
    }
  }

  void toggleExpand() {
    isExpanded.value = !isExpanded.value;
  }

  void changeTab(int index) {
    selectedTabIndex.value = index;
  }

  void selectFacility(HealthcareFacility facility) {
    selectedFacility.value = facility;
  }

  void bookVaccine() {
    if (vaccine.value == null) return;
    // Navigate to booking vaccines screen
    Get.toNamed(Routes.bookingVaccines);
  }

  void bookAtFacility(String facilityId) {
    final facility = healthcareFacilities.firstWhere(
      (f) => f.id == facilityId,
      orElse: () => healthcareFacilities.first,
    );

    selectFacility(facility);
    bookVaccine();
  }

  void shareVaccine() {
    if (vaccine.value == null) return;

    // Implement share functionality
    Get.snackbar(
      'Chia sẻ',
      'Tính năng chia sẻ sẽ được triển khai sau',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
