import 'package:flutter/material.dart';
import 'package:flutter_getx_boilerplate/modules/base/base_controller.dart';
import 'package:flutter_getx_boilerplate/repositories/booking_vaccines_repository.dart';
import 'package:flutter_getx_boilerplate/routes/navigator_helper.dart';
import 'package:get/get.dart';
import 'package:flutter_getx_boilerplate/models/vaccine_model/booking_model.dart';
import 'package:flutter_getx_boilerplate/models/vaccine_model/healthcare_facility_model.dart';
import 'package:flutter_getx_boilerplate/models/vaccine_model/vaccine_model.dart';
import 'package:flutter_getx_boilerplate/modules/vaccine_list/vaccine_list_controller.dart';
import 'package:flutter_getx_boilerplate/modules/vaccine_list/person_selection/person_selection_controller.dart';

class BookingVaccinesController
    extends BaseController<BookingVaccinesRepository> {
  BookingVaccinesController(super.repository);

  bool? useCartOverride;
  bool get useCart {
    if (useCartOverride != null) return useCartOverride!;
    return vaccineListController.selectedVaccine.value == null;
  }

  // Get VaccineListController instance
  VaccineListController get vaccineListController =>
      Get.find<VaccineListController>();

  List<VaccineModel> get selectedVaccines {
    if (!useCart) {
      final vaccine = vaccineListController.selectedVaccine.value;
      if (vaccine != null) {
        return [vaccine];
      }
      return [];
    } else {
      return vaccineListController.cartItems
          .map((cartItem) => cartItem.vaccine)
          .toList();
    }
  }

  // Get quantities for each vaccine
  Map<String, int> get vaccineQuantities {
    final Map<String, int> quantities = {};
    for (final cartItem in vaccineListController.cartItems) {
      quantities[cartItem.vaccine.id] = cartItem.quantity;
    }
    return quantities;
  }

  final RxMap<int, DoseScheduling> _doseSchedules = <int, DoseScheduling>{}.obs;
  final RxMap<int, DateTime?> _selectedDates = <int, DateTime?>{}.obs;
  final RxMap<int, TimeOfDay?> _selectedTimes = <int, TimeOfDay?>{}.obs;
  final confirmedFacility = Rx<HealthcareFacility?>(null);
  final selectedPerson = Rx<Person?>(null);
  final RxBool isSchedulingComplete = RxBool(false);

  Map<int, DoseScheduling> get doseSchedules => _doseSchedules;
  Map<int, DateTime?> get selectedDates => _selectedDates;
  Map<int, TimeOfDay?> get selectedTimes => _selectedTimes;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is Map && args['useCartOverride'] is bool) {
      useCartOverride = args['useCartOverride'] as bool;
    }
    _initializeSchedules();

    // Re-initialize schedules when vaccines change
    ever(vaccineListController.selectedVaccine, (_) => _initializeSchedules());
    ever(vaccineListController.cartItems, (_) => _initializeSchedules());
  }

  @override
  void onReady() {
    super.onReady();
    // Ensure schedules are initialized when screen is ready
    if (_doseSchedules.isEmpty && selectedVaccines.isNotEmpty) {
      _initializeSchedules();
    }
  }

  void _initializeSchedules() {
    _doseSchedules.clear();
    _selectedDates.clear();
    _selectedTimes.clear();

    int globalDoseCounter = 1;

    // Check if we have a selected vaccine (single vaccine scenario)
    if (!useCart) {
      final vaccine = vaccineListController.selectedVaccine.value;

      if (vaccine != null) {
        // For the single selected vaccine, create dose schedules
        for (int doseNumber = 1;
            doseNumber <= vaccine.numberOfDoses;
            doseNumber++) {
          _doseSchedules[globalDoseCounter] = DoseScheduling(
            doseNumber: globalDoseCounter,
            vaccine: vaccine,
            vaccineDoseNumber: doseNumber,
            dateTime: DateTime.now(),
            facility: HealthcareFacility(
              id: 'default',
              name: 'Chưa chọn cơ sở',
              address: '',
              phone: '',
              hours: '',
              image: '',
              capacity: 0,
            ),
          );

          _selectedDates[globalDoseCounter] = null;
          _selectedTimes[globalDoseCounter] = null;

          globalDoseCounter++;
        }
      }
    }
    // Otherwise, use cart items
    else {
      for (final cartItem in vaccineListController.cartItems) {
        final vaccine = cartItem.vaccine;

        // For each quantity of this vaccine, create dose schedules
        for (int quantityIndex = 0;
            quantityIndex < cartItem.quantity;
            quantityIndex++) {
          for (int doseNumber = 1;
              doseNumber <= vaccine.numberOfDoses;
              doseNumber++) {
            _doseSchedules[globalDoseCounter] = DoseScheduling(
              doseNumber: globalDoseCounter,
              vaccine: vaccine,
              vaccineDoseNumber: doseNumber,
              dateTime: DateTime.now(),
              facility: HealthcareFacility(
                id: 'default',
                name: 'Chưa chọn cơ sở',
                address: '',
                phone: '',
                hours: '',
                image: '',
                capacity: 0,
              ),
            );

            _selectedDates[globalDoseCounter] = null;
            _selectedTimes[globalDoseCounter] = null;

            globalDoseCounter++;
          }
        }
      }
    }

    // Notify listeners that schedules have changed
    update();
  }

  void updateFacility(int doseKey, HealthcareFacility facility) {
    _doseSchedules[doseKey] =
        _doseSchedules[doseKey]!.copyWith(facility: facility);
    update();
  }

  void updateDate(int doseKey, DateTime date) {
    _selectedDates[doseKey] = date;

    final time = _selectedTimes[doseKey];
    if (time != null) {
      _updateDateTime(doseKey);
    } else {
      _doseSchedules[doseKey] =
          _doseSchedules[doseKey]!.copyWith(dateTime: null);
    }

    update();
  }

  void updateTime(int doseKey, TimeOfDay time) {
    _selectedTimes[doseKey] = time;

    final date = _selectedDates[doseKey];
    if (date != null) {
      _updateDateTime(doseKey);
    } else {
      _doseSchedules[doseKey] =
          _doseSchedules[doseKey]!.copyWith(dateTime: null);
    }

    updateSchedulingStatus();
    update();
  }

  // kiểm tra trùng lịch
  void _updateDateTime(int doseKey) {
    final date = _selectedDates[doseKey];
    final time = _selectedTimes[doseKey];

    if (date != null && time != null) {
      final newDateTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );

      // Kiểm tra xem DateTime mới có trùng với các mũi khác không
      if (!_isDateTimeOccupied(doseKey, newDateTime)) {
        _doseSchedules[doseKey] =
            _doseSchedules[doseKey]!.copyWith(dateTime: newDateTime);
      } else {
        // Nếu trùng, xóa thời gian đã chọn và thông báo lỗi
        _selectedTimes[doseKey] = null;
        Get.snackbar(
          'Lỗi',
          'Thời gian này đã được chọn cho mũi tiêm khác. Vui lòng chọn giờ khác.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 1),
        );
      }
    } else {
      // Nếu thiếu ngày hoặc giờ, đặt lại dateTime về null
      _doseSchedules[doseKey] =
          _doseSchedules[doseKey]!.copyWith(dateTime: null);
    }
  }

  bool _isDateTimeOccupied(int currentDoseKey, DateTime newDateTime) {
    for (final entry in _doseSchedules.entries) {
      if (entry.key != currentDoseKey) {
        final existingDateTime = entry.value.dateTime;

        // Kiểm tra trùng cả ngày và giờ
        if (existingDateTime.isAtSameMomentAs(newDateTime)) {
          return true;
        }
      }
    }
    return false;
  }

  bool validateScheduling() {
    // Kiểm tra chỉ các mũi dose 1 của mỗi vaccine đã có dateTime (vì UI chỉ cho phép chọn dose 1)
    for (final scheduling in _doseSchedules.values) {
      if (scheduling.vaccineDoseNumber == 1 && scheduling.dateTime == null) {
        return false;
      }
    }

    // Kiểm tra đã chọn cơ sở tiêm chủng
    if (confirmedFacility.value == null) {
      return false;
    }

    // Kiểm tra đã chọn người đặt lịch
    if (selectedPerson.value == null) {
      return false;
    }

    return true;
  }

  double calculateTotalPrice() {
    double total = 0;
    if (!useCart) {
      // Single vaccine scenario
      final vaccine = vaccineListController.selectedVaccine.value;
      if (vaccine != null) {
        total += vaccine.price; // Only price, not multiplied by numberOfDoses
      }
    } else {
      // Cart scenario
      for (final cartItem in vaccineListController.cartItems) {
        total += cartItem.vaccine.price *
            cartItem.quantity; // Only multiply by quantity
      }
    }
    return total;
  }

  Future<void> pickFacility() async {
    final HealthcareFacility? selected =
        await NavigatorHelper.toFacilitySelectionScreen();

    if (selected != null) {
      // Update the selected facility for all doses
      for (final doseKey in _doseSchedules.keys) {
        updateFacility(doseKey, selected);
      }

      // Store the selected facility
      confirmedFacility.value = selected;
      updateSchedulingStatus();
      update();
    }
  }

  VaccineBooking createBooking() {
    final doseBookings = <int, DoseBooking>{};

    for (final entry in _doseSchedules.entries) {
      final scheduling = entry.value;
      doseBookings[entry.key] = DoseBooking(
        doseNumber: entry.key,
        dateTime: scheduling.dateTime,
        facility: scheduling.facility,
        isCompleted: false,
        vaccineId: scheduling.vaccine.id,
        vaccineDoseNumber: scheduling.vaccineDoseNumber,
      );
    }

    return VaccineBooking(
      id: 'booking_${DateTime.now().millisecondsSinceEpoch}',
      userId: selectedPerson.value?.name ??
          "1", // Use selected person name or default
      familyMemberId: selectedPerson.value?.id == 'current_user'
          ? null
          : selectedPerson.value?.id,
      vaccines: selectedVaccines,
      vaccineQuantities: vaccineQuantities,
      bookingDate: DateTime.now(),
      doseBookings: doseBookings,
      totalPrice:
          calculateTotalPrice(), // Ensure correct total price calculation
      status: 'pending',
      createdAt: DateTime.now(),
    );
  }

  String getVaccineNameForDose(int doseKey) {
    final scheduling = _doseSchedules[doseKey];
    return scheduling?.vaccine.name ?? 'Unknown Vaccine';
  }

  int getVaccineDoseNumber(int doseKey) {
    final scheduling = _doseSchedules[doseKey];
    return scheduling?.vaccineDoseNumber ?? 1;
  }

  void updateSchedulingStatus() {
    isSchedulingComplete.value = _isSchedulingComplete();
  }

  bool _isSchedulingComplete() {
    // Chỉ kiểm tra dose 1 của mỗi vaccine (vì UI chỉ cho phép chọn dose 1)
    for (final scheduling in _doseSchedules.values) {
      if (scheduling.vaccineDoseNumber == 1) {
        final doseKey = scheduling.doseNumber;
        if (_selectedDates[doseKey] == null ||
            _selectedTimes[doseKey] == null) {
          return false;
        }
      }
    }
    return true;
  }
}
