// lib/modules/schedule_selection/schedule_selection_controller.dart
import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_getx_boilerplate/models/vaccine_model/healthcare_facility_model.dart';
import 'package:flutter_getx_boilerplate/models/vaccine_model/vaccine_model.dart';
import 'package:get/get.dart';
import 'package:flutter_getx_boilerplate/modules/base/base_controller.dart';
import 'package:flutter_getx_boilerplate/repositories/schedule_selection_repository.dart';

class ScheduleSelectionController
    extends BaseController<ScheduleSelectionRepository> {
  ScheduleSelectionController(super.repository);

  // Reactive variables
  final selectedFacility = Rx<HealthcareFacility?>(null);
  final vaccine = Rx<VaccineModel?>(null);
  final isLoading = false.obs;
  final availableDates = <DateTime>[].obs;
  final availableTimeSlots = <String>[].obs;

  // Selected values
  final selectedDate = Rx<DateTime?>(null);
  final selectedTimeSlot = Rx<String?>(null);

  // Suggested doses
  final suggestedSecondDoseDate = Rx<DateTime?>(null);
  final suggestedThirdDoseDate = Rx<DateTime?>(null);

  // Calendar
  final focusedDay = DateTime.now().obs;
  final selectedDay = DateTime.now().obs;

  @override
  void onInit() {
    super.onInit();
    _loadInitialData();
  }

  void _loadInitialData() {
    // Get data passed from previous screen
    selectedFacility.value = Get.arguments['facility'];
    vaccine.value = Get.arguments['vaccine'];

    if (selectedFacility.value != null) {
      loadAvailableSchedule();
    }
  }

  Future<void> loadAvailableSchedule() async {
    try {
      setLoading(true);

      // Load available dates and time slots
      final dates = await repository
          .getAvailableDates(selectedFacility.value!.id)
          .timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          throw TimeoutException('Request timed out');
        },
      );
      availableDates.assignAll(dates);

      if (dates.isNotEmpty) {
        final timeSlots = await repository
            .getAvailableTimeSlots(selectedFacility.value!.id, dates.first)
            .timeout(
          const Duration(seconds: 5),
          onTimeout: () {
            throw TimeoutException('Request timed out');
          },
        );
        availableTimeSlots.assignAll(timeSlots);
      }
    } catch (e) {
      Get.snackbar(
        'Lỗi',
        'Không thể tải lịch trống',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      setLoading(false);
    }
  }

  Future<void> selectDate(DateTime date) async {
    try {
      log('ScheduleSelection: Selecting date - $date');
      setLoading(true);

      selectedDate.value = date;
      selectedDay.value = date;

      // Load time slots for selected date
      final timeSlots = await repository
          .getAvailableTimeSlots(selectedFacility.value!.id, date)
          .timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          throw TimeoutException('Request timed out');
        },
      );
      availableTimeSlots.assignAll(timeSlots);

      // Calculate suggested doses
      _calculateSuggestedDoses();
    } catch (e) {
      log('ScheduleSelection: Failed to select date - $e');
      Get.snackbar(
        'Lỗi',
        'Không thể tải khung giờ trống',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      setLoading(false);
    }
  }

  void selectTimeSlot(String timeSlot) {
    selectedTimeSlot.value = timeSlot;
  }

  void _calculateSuggestedDoses() {
    if (selectedDate.value == null || vaccine.value == null) return;

    final firstDoseDate = selectedDate.value!;

    // Calculate suggested dates based on vaccine schedule
    if (vaccine.value!.numberOfDoses >= 2) {
      final secondDoseInterval = _getDoseInterval(2);
      suggestedSecondDoseDate.value = firstDoseDate.add(secondDoseInterval);
    }

    if (vaccine.value!.numberOfDoses >= 3) {
      final thirdDoseInterval = _getDoseInterval(3);
      suggestedThirdDoseDate.value = firstDoseDate.add(thirdDoseInterval);
    }
  }

  Duration _getDoseInterval(int doseNumber) {
    // Use vaccine schedule if available, otherwise use default intervals
    if (vaccine.value != null && vaccine.value!.schedule.isNotEmpty) {
      for (var schedule in vaccine.value!.schedule) {
        if (schedule.doseNumber == doseNumber) {
          // Parse time interval (e.g., "4 weeks", "6 months")
          return _parseTimeInterval(schedule.timeInterval ?? '');
        }
      }
    }

    // Default intervals based on common vaccine schedules
    switch (doseNumber) {
      case 2:
        return const Duration(days: 28); // 4 weeks
      case 3:
        return const Duration(days: 180); // 6 months
      default:
        return Duration.zero;
    }
  }

  Duration _parseTimeInterval(String interval) {
    if (interval.toLowerCase().contains('tuần')) {
      final weeks =
          int.tryParse(interval.replaceAll(RegExp(r'[^0-9]'), '')) ?? 1;
      return Duration(days: weeks * 7);
    } else if (interval.toLowerCase().contains('tháng')) {
      final months =
          int.tryParse(interval.replaceAll(RegExp(r'[^0-9]'), '')) ?? 1;
      return Duration(days: months * 30);
    } else if (interval.toLowerCase().contains('năm')) {
      final years =
          int.tryParse(interval.replaceAll(RegExp(r'[^0-9]'), '')) ?? 1;
      return Duration(days: years * 365);
    }
    return const Duration(days: 28); // Default to 4 weeks
  }

  bool get isSelectionComplete {
    return selectedDate.value != null && selectedTimeSlot.value != null;
  }

  void confirmSelection() {
    if (isSelectionComplete) {
      Get.toNamed('/booking-confirmation', arguments: {
        'facility': selectedFacility.value,
        'vaccine': vaccine.value,
        'firstDoseDate': selectedDate.value,
        'timeSlot': selectedTimeSlot.value,
        'secondDoseDate': suggestedSecondDoseDate.value,
        'thirdDoseDate': suggestedThirdDoseDate.value,
      });
    } else {
      Get.snackbar(
        'Lỗi',
        'Vui lòng chọn đầy đủ ngày và giờ tiêm',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
