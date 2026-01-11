// lib/modules/facility_selection/facility_selection_controller.dart
import 'package:flutter/material.dart';
import 'package:flutter_getx_boilerplate/models/vaccine_model/healthcare_facility_model.dart';
import 'package:flutter_getx_boilerplate/models/vietnam_address/vietnam_address.dart';
import 'package:flutter_getx_boilerplate/models/vaccine_model/vaccine_model.dart';
import 'package:flutter_getx_boilerplate/repositories/facility_selection_repository.dart';
import 'package:flutter_getx_boilerplate/repositories/schedule_selection_repository.dart';
import 'package:get/get.dart';
import 'package:flutter_getx_boilerplate/modules/base/base_controller.dart';

class FacilitySelectionController
    extends BaseController<FacilitySelectionRepository> {
  FacilitySelectionController(super.repository);

  // Reactive variables
  final facilities = <HealthcareFacility>[].obs;
  final vaccine = Rx<VaccineModel?>(null);
  final selectedFacility = Rx<HealthcareFacility?>(null);
  final isLoading = false.obs;
  final searchQuery = ''.obs;
  final filterByDistance = true.obs;
  final filterByRating = false.obs;

  // Vietnam address data
  final provinces = <VietnamProvince>[].obs;
  final districts = <VietnamDistrict>[].obs;
  final wards = <VietnamWard>[].obs;

  // Selected locations
  final selectedProvince = Rx<VietnamProvince?>(null);
  final selectedDistrict = Rx<VietnamDistrict?>(null);
  final selectedWard = Rx<VietnamWard?>(null);

  @override
  void onInit() {
    super.onInit();
    _loadVaccineData();
    loadVietnamProvinces();
    loadFacilities();
  }

  Future<void> loadVietnamProvinces() async {
    try {
      final result = await VietnamAddressService.getProvinces();
      provinces.assignAll(result);
    } catch (e) {
      // print('Error loading provinces: $e');
    }
  }

  Future<void> loadVietnamDistricts(String provinceCode) async {
    try {
      final result = await VietnamAddressService.getDistricts(provinceCode);
      districts.assignAll(result);
    } catch (e) {
      // print('Error loading districts: $e');
    }
  }

  Future<void> loadVietnamWards(String districtCode) async {
    try {
      final result = await VietnamAddressService.getWards(districtCode);
      wards.assignAll(result);
    } catch (e) {
      // print('Error loading wards: $e');
    }
  }

  void selectProvince(VietnamProvince? province) {
    selectedProvince.value = province;
    selectedDistrict.value = null;
    selectedWard.value = null;
    districts.clear();
    wards.clear();

    if (province != null) {
      loadVietnamDistricts(province.code);
    }
    _applyFilters();
  }

  void selectDistrict(VietnamDistrict? district) {
    selectedDistrict.value = district;
    selectedWard.value = null;
    wards.clear();

    if (district != null) {
      loadVietnamWards(district.code);
    }
    _applyFilters();
  }

  void selectWard(VietnamWard? ward) {
    selectedWard.value = ward;
    _applyFilters();
  }

  void _loadVaccineData() {
    try {
      final vaccineId = Get.parameters['vaccineId'];
      if (vaccineId != null) {
        vaccine.value = VaccineModel(
          id: vaccineId,
          name: 'Vaccine',
          manufacturer: '',
          description: '',
          prevention: [],
          numberOfDoses: 2,
          recommendedAge: '',
          price: 0,
        );
      }
    } catch (e) {
      // print('Error loading vaccine data: $e');
    }
  }

  Future<void> loadFacilities() async {
    try {
      isLoading.value = true;
      final result = await repository.getHealthcareFacilities();
      facilities.assignAll(result);

      if (facilities.isNotEmpty && selectedFacility.value == null) {
        selectedFacility.value = facilities.first;
      }

      _applyFilters();
    } catch (e) {
      Get.snackbar(
        'Lỗi',
        'Không thể tải danh sách cơ sở tiêm chủng',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void selectFacility(HealthcareFacility facility) {
    selectedFacility.value = facility;
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
    _applyFilters();
  }

  void toggleDistanceFilter() {
    filterByDistance.value = !filterByDistance.value;
    if (filterByDistance.value) {
      filterByRating.value = false;
    }
    _applyFilters();
  }

  void toggleRatingFilter() {
    filterByRating.value = !filterByRating.value;
    if (filterByRating.value) {
      filterByDistance.value = false;
    }
    _applyFilters();
  }

  void clearLocationFilters() {
    selectedProvince.value = null;
    selectedDistrict.value = null;
    selectedWard.value = null;
    districts.clear();
    wards.clear();
    _applyFilters();
  }

  void _applyFilters() {
    List<HealthcareFacility> filtered = List.from(facilities);

    // Apply search filter
    if (searchQuery.isNotEmpty) {
      filtered = filtered.where((facility) {
        return facility.name
                .toLowerCase()
                .contains(searchQuery.toLowerCase()) ||
            facility.address.toLowerCase().contains(searchQuery.toLowerCase());
      }).toList();
    }

    // Apply Vietnam address filters
    if (selectedProvince.value != null) {
      filtered = filtered.where((facility) {
        return _doesAddressContain(
            facility.address, selectedProvince.value!.name);
      }).toList();
    }

    if (selectedDistrict.value != null) {
      filtered = filtered.where((facility) {
        return _doesAddressContain(
            facility.address, selectedDistrict.value!.name);
      }).toList();
    }

    if (selectedWard.value != null) {
      filtered = filtered.where((facility) {
        return _doesAddressContain(facility.address, selectedWard.value!.name);
      }).toList();
    }

    // Apply sorting
    if (filterByDistance.value) {
      filtered.sort((a, b) => a.distance.compareTo(b.distance));
    } else if (filterByRating.value) {
      filtered.sort((a, b) => b.rating.compareTo(a.rating));
    }

    filteredFacilities.assignAll(filtered);
  }

  bool _doesAddressContain(String address, String searchTerm) {
    return address.toLowerCase().contains(searchTerm.toLowerCase());
  }

  List<HealthcareFacility> get filteredFacilities {
    List<HealthcareFacility> filtered = List.from(facilities);

    // Apply search filter
    if (searchQuery.isNotEmpty) {
      filtered = filtered.where((facility) {
        return facility.name
                .toLowerCase()
                .contains(searchQuery.toLowerCase()) ||
            facility.address.toLowerCase().contains(searchQuery.toLowerCase());
      }).toList();
    }

    // Apply Vietnam address filters với chuẩn hóa
    if (selectedProvince.value != null) {
      filtered = filtered.where((facility) {
        return _doesAddressContainNormalized(
            facility.address, selectedProvince.value!.name);
      }).toList();
    }

    if (selectedDistrict.value != null) {
      filtered = filtered.where((facility) {
        return _doesAddressContainNormalized(
            facility.address, selectedDistrict.value!.name);
      }).toList();
    }

    if (selectedWard.value != null) {
      filtered = filtered.where((facility) {
        return _doesAddressContainNormalized(
            facility.address, selectedWard.value!.name);
      }).toList();
    }

    // Apply sorting
    if (filterByDistance.value) {
      filtered.sort((a, b) => a.distance.compareTo(b.distance));
    } else if (filterByRating.value) {
      filtered.sort((a, b) => b.rating.compareTo(a.rating));
    }

    return filtered;
  }

// Hàm chuẩn hóa địa chỉ để so sánh linh hoạt
  String _normalizeAddressForComparison(String address) {
    return address
        .toLowerCase()
        .replaceAll('thành phố', '')
        .replaceAll('tỉnh', '')
        .replaceAll('tp.', '')
        .replaceAll('tp', '')
        .replaceAll('quận', '')
        .replaceAll('huyện', '')
        .replaceAll('thị xã', '')
        .replaceAll('phường', '')
        .replaceAll('xã', '')
        .replaceAll('thị trấn', '')
        .replaceAll(RegExp(r'[^\w\s]'), '') // Remove special characters
        .trim()
        .replaceAll(RegExp(r'\s+'), ' '); // Remove extra spaces
  }

// Hàm kiểm tra với chuẩn hóa
  bool _doesAddressContainNormalized(String address, String searchTerm) {
    final normalizedAddress = _normalizeAddressForComparison(address);
    final normalizedSearchTerm = _normalizeAddressForComparison(searchTerm);

    return normalizedAddress.contains(normalizedSearchTerm);
  }

// Giữ lại hàm cũ để tương thích (nếu cần)
  // bool _doesAddressContain(String address, String searchTerm) {
  //   return address.toLowerCase().contains(searchTerm.toLowerCase());
  // }

// Helper function for confirmSelection
  void confirmSelection() {
    if (selectedFacility.value != null) {
      // Return the selected facility when navigating back
      Get.back(result: selectedFacility.value);
    } else {
      // Show error or message if no facility is selected
      Get.snackbar('Lỗi', 'Vui lòng chọn cơ sở tiêm chủng');
    }
  }

  void cancelSelection() {
    Get.back(); // Return without a result
  }
}

  // void confirmSelection(context) {
  // if (selectedFacility.value != null && vaccine.value != null) {
  // Get.toNamed('/schedule-selection', arguments: {
  //   'facility': selectedFacility.value,
  //   'vaccine': vaccine.value,
  // });
  // NavigatorHelper.toScheduleSelectionScreen();
  // } else {
  //   Get.snackbar(
  //     'Lỗi',
  //     'Vui lòng chọn một cơ sở tiêm chủng',
  //     snackPosition: SnackPosition.BOTTOM,
  //     backgroundColor: Colors.red,
  //     colorText: Colors.white,
  //   );
  // }
// }
