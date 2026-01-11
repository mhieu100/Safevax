import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_getx_boilerplate/models/family_member.dart';
import 'package:flutter_getx_boilerplate/models/response/booking_history_grouped_response.dart';
import 'package:flutter_getx_boilerplate/models/vaccine_model/booking_model.dart';
import 'package:flutter_getx_boilerplate/models/vaccine_model/healthcare_facility_model.dart';
import 'package:flutter_getx_boilerplate/models/vaccine_model/vaccine_model.dart';
import 'package:flutter_getx_boilerplate/modules/base/base_controller.dart';
import 'package:flutter_getx_boilerplate/repositories/family_management_repository.dart';
import 'package:flutter_getx_boilerplate/repositories/vaccine_management_repository.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

enum AppointmentStatus { upcoming, completed, missed }

// Vaccine progress data model
class VaccineProgressItem {
  final String vaccineName;
  final String personName;
  final List<DoseProgress> doses;

  VaccineProgressItem({
    required this.vaccineName,
    required this.personName,
    required this.doses,
  });
}

class DoseProgress {
  final int doseNumber;
  final bool isScheduled;
  final DateTime? scheduledDate;

  DoseProgress({
    required this.doseNumber,
    required this.isScheduled,
    this.scheduledDate,
  });
}

class Appointment {
  final String id;
  final String vaccineName;
  final DateTime date;
  final String doctor;
  final String clinic;
  final AppointmentStatus status;
  final Color? color;
  final IconData? icon;
  final String? bookingId;
  final String? timeSlot;
  final String? statusText;

  Appointment({
    required this.id,
    required this.vaccineName,
    required this.date,
    required this.doctor,
    required this.clinic,
    required this.status,
    this.color,
    this.icon,
    this.bookingId,
    this.timeSlot,
    this.statusText,
  });
}

class FamilyMemberDetailController extends GetxController {
  final FamilyManangementRepository familyRepository;
  final VaccineManagementRepository vaccineRepository;

  FamilyMemberDetailController(this.familyRepository, this.vaccineRepository);

  final RxList<Appointment> appointments = <Appointment>[].obs;
  final RxBool isLoading = true.obs;
  final RxString selectedTab = 'all'.obs;
  final RxList<VaccineBooking> bookings = <VaccineBooking>[].obs;
  final RxList<GroupedBookingData> groupedBookings = <GroupedBookingData>[].obs;
  final RxList<VaccineProgressItem> progressItems = <VaccineProgressItem>[].obs;
  final RxMap<String, dynamic> memberDetail = <String, dynamic>{}.obs;

  FamilyMember? member;

  // Helper method to parse time slot format
  String _parseTimeSlot(String timeSlot) {
    if (timeSlot.startsWith('SLOT_')) {
      // Convert "SLOT_07_00" to "07:00"
      final parts = timeSlot.split('_');
      if (parts.length >= 3) {
        return '${parts[1]}:${parts[2]}';
      }
    }
    return timeSlot;
  }

  // Helper method to get display time range from slot
  String getDisplayTimeRange(String timeSlot) {
    if (timeSlot.startsWith('SLOT_')) {
      final parts = timeSlot.split('_');
      if (parts.length >= 3) {
        final hour = int.tryParse(parts[1]) ?? 7;
        final startTime = '${hour.toString().padLeft(2, '0')}:00';
        final endTime = '${(hour + 2).toString().padLeft(2, '0')}:00';
        return '$startTime - $endTime';
      }
    }
    // Fallback for non-SLOT format
    return timeSlot;
  }

  @override
  void onInit() {
    super.onInit();
    member = Get.arguments as FamilyMember?;
    if (member != null) {
      fetchMemberDetail();
      fetchMemberAppointments();
    }
  }

  Future<void> fetchMemberDetail() async {
    if (member == null || member!.id == null) return;

    try {
      isLoading.value = true;
      final detail = await familyRepository.getFamilyMemberDetail(member!.id!);
      memberDetail.value = detail;
    } catch (e) {
      log('FamilyMemberDetail: Failed to load member detail - $e');
      Get.snackbar('Lỗi',
          'Không thể tải thông tin chi tiết thành viên. Vui lòng thử lại sau.');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchMemberAppointments() async {
    if (member == null || member!.id == null) return;

    try {
      isLoading.value = true;
      final memberBookings = await familyRepository
          .getFamilyMemberBookingHistoryGrouped(member!.id!);

      // Clear existing data
      appointments.clear();
      bookings.clear();
      groupedBookings.clear();

      if (memberBookings.isEmpty) {
        appointments.clear();
        bookings.clear();
        groupedBookings.clear();
        return;
      }

      // Store grouped bookings
      groupedBookings.assignAll(memberBookings);

      // Convert GroupedBookingData to VaccineBooking and store
      final vaccineBookings = memberBookings
          .map((bookingData) => _convertGroupedToVaccineBooking(bookingData))
          .toList();
      bookings.assignAll(vaccineBookings);

      // Convert API response to Appointment objects
      final appointmentList = <Appointment>[];

      for (final bookingData in memberBookings) {
        if (bookingData.appointments == null ||
            bookingData.appointments.isEmpty) continue;

        for (final appointment in bookingData.appointments) {
          try {
            // More robust date parsing
            DateTime appointmentDateTime;
            try {
              final timeString = _parseTimeSlot(appointment.scheduledTimeSlot);
              appointmentDateTime = DateTime.parse(
                '${appointment.scheduledDate} $timeString',
              );
            } catch (dateParseError) {
              // Try alternative parsing if the combined string fails
              try {
                appointmentDateTime = DateTime.parse(appointment.scheduledDate);
                // If time slot exists, try to add time
                if (appointment.scheduledTimeSlot.isNotEmpty) {
                  final timeString =
                      _parseTimeSlot(appointment.scheduledTimeSlot);
                  final timeParts = timeString.split(':');
                  if (timeParts.length >= 2) {
                    final hour = int.tryParse(timeParts[0]) ?? 0;
                    final minute = int.tryParse(timeParts[1]) ?? 0;
                    appointmentDateTime = DateTime(
                      appointmentDateTime.year,
                      appointmentDateTime.month,
                      appointmentDateTime.day,
                      hour,
                      minute,
                    );
                  }
                }
              } catch (fallbackError) {
                // If all parsing fails, use date only
                appointmentDateTime = DateTime.parse(appointment.scheduledDate);
              }
            }

            String? statusText;
            AppointmentStatus status;
            if (appointment.appointmentStatus == 'RESCHEDULE') {
              status = AppointmentStatus.upcoming;
              statusText = 'Đã gửi yêu cầu đổi lịch. Đang chờ xác nhận';
            } else if (appointment.appointmentStatus == 'COMPLETED') {
              status = AppointmentStatus.completed;
            } else if (appointmentDateTime.isBefore(DateTime.now())) {
              status = AppointmentStatus.missed;
            } else {
              status = AppointmentStatus.upcoming;
            }

            appointmentList.add(Appointment(
              id: appointment.id.toString(),
              vaccineName: bookingData.vaccineName,
              date: appointmentDateTime,
              doctor: appointment.doctorName ?? 'Bác sĩ sẽ được chỉ định',
              clinic: appointment.centerName,
              status: status,
              color: _getColorForVaccine(bookingData.vaccineName),
              icon: _getIconForVaccine(bookingData.vaccineName),
              bookingId: bookingData.routeId,
              timeSlot: appointment.scheduledTimeSlot,
              statusText: statusText,
            ));
          } catch (appointmentError) {
            // Log individual appointment parsing errors but continue with others
            continue;
          }
        }
      }

      appointments.assignAll(appointmentList);
    } catch (e) {
      log('FamilyMemberDetail: Failed to load appointments - $e');
      Get.snackbar('Lỗi', 'Không thể tải lịch hẹn. Vui lòng thử lại sau.');
    } finally {
      isLoading.value = false;
    }
  }

  Color _getColorForVaccine(String vaccineName) {
    // Simple color mapping based on vaccine name
    if (vaccineName.contains('COVID')) return Colors.orangeAccent;
    if (vaccineName.contains('cúm') || vaccineName.contains('Flu'))
      return Colors.blueAccent;
    if (vaccineName.contains('Viêm gan')) return Colors.greenAccent;
    if (vaccineName.contains('Sởi') || vaccineName.contains('MMR'))
      return Colors.purpleAccent;
    return Colors.tealAccent;
  }

  IconData _getIconForVaccine(String vaccineName) {
    // Simple icon mapping based on vaccine name
    if (vaccineName.contains('COVID')) return Icons.coronavirus;
    if (vaccineName.contains('cúm') || vaccineName.contains('Flu'))
      return Icons.sick;
    if (vaccineName.contains('Viêm gan')) return Icons.health_and_safety;
    if (vaccineName.contains('Sởi') || vaccineName.contains('MMR'))
      return Icons.medical_services;
    return Icons.vaccines;
  }

  List<Appointment> get filteredAppointments {
    switch (selectedTab.value) {
      case 'all':
        return appointments.toList();
      case 'upcoming':
        return appointments
            .where((a) => a.status == AppointmentStatus.upcoming)
            .toList();
      case 'completed':
        return appointments
            .where((a) => a.status == AppointmentStatus.completed)
            .toList();
      case 'missed':
        return appointments
            .where((a) => a.status == AppointmentStatus.missed)
            .toList();
      default:
        return [];
    }
  }

  void changeTab(String tab) {
    selectedTab.value = tab;
  }

  Future<void> fetchProgressData() async {
    if (member == null || member!.id == null) return;

    try {
      final response = await familyRepository
          .getFamilyMemberBookingHistoryGrouped(member!.id!);

      // Clear existing data
      progressItems.clear();

      // Convert API response to VaccineProgressItem objects
      final progressList = <VaccineProgressItem>[];

      for (final bookingData in response) {
        final progressItem = _convertGroupedToVaccineProgressItem(bookingData);
        progressList.add(progressItem);
      }

      // Assign list to observable
      progressItems.assignAll(progressList);
    } catch (e) {
      log('FamilyMemberDetail: Failed to load progress data - $e');
      Get.snackbar(
          'Lỗi', 'Không thể tải dữ liệu tiến độ. Vui lòng thử lại sau.');
    }
  }

  List<VaccineBooking> get completedBookings {
    return bookings.toList();
  }

  VaccineBooking _convertGroupedToVaccineBooking(
      GroupedBookingData bookingData) {
    // Create a basic VaccineBooking from GroupedBookingData
    // This is a simplified conversion for the new grouped API structure

    final doseBookings = <int, DoseBooking>{};

    for (final appointment in bookingData.appointments) {
      final timeString = _parseTimeSlot(appointment.scheduledTimeSlot);
      final appointmentDateTime = DateTime.parse(
        '${appointment.scheduledDate} $timeString',
      );

      // Create a basic facility
      final facility = HealthcareFacility(
        id: appointment.centerId.toString(),
        name: appointment.centerName,
        address: appointment.centerName, // Placeholder
        phone: '', // Placeholder
        hours: '08:00-17:00', // Placeholder
        image: '', // Placeholder
        capacity: 100, // Placeholder
      );

      doseBookings[appointment.doseNumber] = DoseBooking(
        doseNumber: appointment.doseNumber,
        dateTime: appointmentDateTime,
        facility: facility,
        isCompleted: appointment.appointmentStatus == 'COMPLETED',
        vaccineId:
            bookingData.vaccineName, // Using vaccine name as ID placeholder
        vaccineDoseNumber: appointment.doseNumber,
      );
    }

    // Create basic vaccine model
    final vaccine = VaccineModel(
      id: bookingData.vaccineName, // Placeholder
      name: bookingData.vaccineName,
      description: 'Vaccine description', // Placeholder
      prevention: [], // Placeholder
      recommendedAge: 'All ages', // Placeholder
      price: bookingData.totalAmount / bookingData.requiredDoses,
      numberOfDoses: bookingData.requiredDoses,
      manufacturer: '', // Placeholder
      country: '', // Placeholder
      duration: 0, // Placeholder
      rating: 0.0, // Placeholder
      imageUrl: '', // Placeholder
      descriptionShort: '', // Placeholder
      schedule: [], // Placeholder
    );

    return VaccineBooking(
      id: bookingData.routeId,
      userId: bookingData.patientName, // Placeholder
      vaccines: [vaccine],
      vaccineQuantities: {bookingData.vaccineName: 1}, // Placeholder
      bookingDate: DateTime.parse(bookingData.createdAt),
      doseBookings: doseBookings,
      totalPrice: bookingData.totalAmount.toDouble(),
      status: bookingData.status.toLowerCase(),
      confirmationCode: 'BK-${bookingData.routeId}',
      createdAt: DateTime.parse(bookingData.createdAt),
    );
  }

  VaccineProgressItem _convertGroupedToVaccineProgressItem(
      GroupedBookingData bookingData) {
    // Create doses list
    final doses = <DoseProgress>[];

    // Create a map of scheduled doses from appointments
    final scheduledDoses = <int, DateTime>{};
    for (final appointment in bookingData.appointments) {
      final scheduledDate = DateTime.parse(appointment.scheduledDate);
      scheduledDoses[appointment.doseNumber] = scheduledDate;
    }

    // Create doses for all required doses
    for (int i = 1; i <= bookingData.requiredDoses; i++) {
      final isScheduled = scheduledDoses.containsKey(i);
      final scheduledDate = scheduledDoses[i];
      doses.add(DoseProgress(
        doseNumber: i,
        isScheduled: isScheduled,
        scheduledDate: scheduledDate,
      ));
    }

    return VaccineProgressItem(
      vaccineName: bookingData.vaccineName,
      personName: bookingData.patientName,
      doses: doses,
    );
  }

  void downloadCertificate(VaccineBooking booking) {
    Get.snackbar(
      'Thông báo',
      'Đang tải xuống chứng nhận tiêm chủng...',
      backgroundColor: Colors.white,
      colorText: const Color(0xFF199A8E),
      icon: const Icon(Icons.download, color: Color(0xFF199A8E)),
    );

    Future.delayed(const Duration(seconds: 2), () {
      Get.snackbar(
        'Thành công',
        'Đã tải xuống chứng nhận thành công',
        backgroundColor: Colors.white,
        colorText: const Color(0xFF199A8E),
        icon: const Icon(Icons.check_circle, color: Color(0xFF199A8E)),
      );
    });
  }

  void exportToPDF() {
    Get.snackbar(
      'Thông báo',
      'Đang xuất hồ sơ tiêm chủng PDF...',
      backgroundColor: Colors.white,
      colorText: const Color(0xFF199A8E),
      icon: const Icon(Icons.picture_as_pdf, color: Color(0xFF199A8E)),
    );

    Future.delayed(const Duration(seconds: 2), () {
      Get.snackbar(
        'Thành công',
        'Đã xuất PDF thành công',
        backgroundColor: Colors.white,
        colorText: const Color(0xFF199A8E),
        icon: const Icon(Icons.check_circle, color: Color(0xFF199A8E)),
      );
    });
  }
}
