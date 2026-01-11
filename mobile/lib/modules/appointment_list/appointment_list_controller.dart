import 'package:flutter/material.dart';
import 'package:flutter_getx_boilerplate/models/request/reschedule_request.dart';
import 'package:flutter_getx_boilerplate/models/response/booking_history_response.dart';
import 'package:flutter_getx_boilerplate/models/response/booking_history_grouped_response.dart';
import 'package:flutter_getx_boilerplate/models/vaccine_model/booking_model.dart';
import 'package:flutter_getx_boilerplate/models/vaccine_model/healthcare_facility_model.dart';
import 'package:flutter_getx_boilerplate/models/vaccine_model/vaccine_model.dart';
import 'package:flutter_getx_boilerplate/modules/base/base_controller.dart';
import 'package:flutter_getx_boilerplate/modules/dashboarh_main/dashboard_controller.dart';
import 'package:flutter_getx_boilerplate/modules/dashboard_noti/dashboard_noti_controller.dart';
import 'package:flutter_getx_boilerplate/repositories/appointment_reschedule_repository.dart';
import 'package:flutter_getx_boilerplate/repositories/vaccine_management_repository.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

enum AppointmentStatus { upcoming, completed, missed, cancelled }

class Appointment {
  final String id;
  final String vaccineName;
  final DateTime date;
  final String doctor;
  final String clinic;
  final AppointmentStatus status;
  final Color? color;
  final IconData? icon;
  final String? bookingId; // Add booking ID for navigation to detail
  final String? timeSlot; // Store original time slot for display
  final String? statusText; // Custom status text for special cases

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

class AppointmentListController
    extends BaseController<VaccineManagementRepository> {
  AppointmentListController(super.repository);

  late final AppointmentRescheduleRepository _rescheduleRepository;

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

  // Helper method to convert TimeOfDay to SLOT format
  String _timeToSlot(DateTime dateTime) {
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return 'SLOT_${hour}_${minute}';
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

  final RxList<Appointment> appointments = <Appointment>[].obs;
  final RxBool isLoading = true.obs;
  final RxString selectedTab = 'upcoming'.obs;
  final RxList<VaccineBooking> bookings = <VaccineBooking>[].obs;

  @override
  void onInit() {
    super.onInit();
    _rescheduleRepository = Get.find<AppointmentRescheduleRepository>();
    fetchAppointments();
  }

  Future<void> fetchAppointments() async {
    try {
      isLoading.value = true;
      final response = await repository.fetchBookingsGrouped();

      // Clear existing data
      appointments.clear();
      bookings.clear();

      // Check if response data is valid
      if (response.data == null || response.data.isEmpty) {
        // No appointments to display, but not an error
        appointments.clear();
        bookings.clear();
        return;
      }

      // Convert GroupedBookingData to VaccineBooking and store
      final vaccineBookings = response.data
          .map((bookingData) => _convertGroupedToVaccineBooking(bookingData))
          .toList();
      bookings.assignAll(vaccineBookings);

      // Convert API response to Appointment objects
      final appointmentList = <Appointment>[];

      for (final bookingData in response.data) {
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
                // If all parsing fails, skip this appointment
                continue;
              }
            }

            String? statusText;
            AppointmentStatus status;
            if (appointment.appointmentStatus == 'RESCHEDULE') {
              status = AppointmentStatus.upcoming;
              statusText = 'Đã gửi yêu cầu đổi lịch. Đang chờ xác nhận';
            } else if (appointment.appointmentStatus == 'COMPLETED') {
              status = AppointmentStatus.completed;
            } else if (appointment.appointmentStatus == 'CANCELLED') {
              status = AppointmentStatus.cancelled;
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

  Color getStatusColor(AppointmentStatus status) {
    switch (status) {
      case AppointmentStatus.upcoming:
        return Colors.orange;
      case AppointmentStatus.completed:
        return Colors.green;
      case AppointmentStatus.missed:
        return Colors.red;
      case AppointmentStatus.cancelled:
        return Colors.grey;
    }
  }

  String getStatusText(AppointmentStatus status) {
    switch (status) {
      case AppointmentStatus.upcoming:
        return 'Sắp tới';
      case AppointmentStatus.completed:
        return 'Hoàn thành';
      case AppointmentStatus.missed:
        return 'Đã bỏ lỡ';
      case AppointmentStatus.cancelled:
        return 'Đã hủy';
    }
  }

  void changeTab(String tab) {
    selectedTab.value = tab;
  }

  Future<void> rescheduleAppointment(
      Appointment appointment, DateTime newDateTime, String reason) async {
    try {
      // Call the API to reschedule
      final request = RescheduleRequest(
        appointmentId: int.parse(appointment.id),
        desiredDate: DateFormat('yyyy-MM-dd').format(newDateTime),
        desiredTimeSlot: _timeToSlot(newDateTime),
        reason: reason,
      );

      await _rescheduleRepository.rescheduleAppointment(request);

      // Update local appointment data
      final updatedAppointment = Appointment(
        id: appointment.id,
        vaccineName: appointment.vaccineName,
        date: newDateTime,
        doctor: appointment.doctor,
        clinic: appointment.clinic,
        status: AppointmentStatus.upcoming, // Status becomes pending approval
        color: appointment.color,
        icon: appointment.icon,
        bookingId: appointment.bookingId,
        timeSlot: appointment.timeSlot,
        statusText: null,
      );

      // Replace in the list and trigger UI update
      final index = appointments.indexWhere((a) => a.id == appointment.id);
      if (index != -1) {
        appointments[index] = updatedAppointment;
        appointments.refresh(); // Trigger UI update
      }

      // Update dashboard and notification counts
      if (Get.isRegistered<DashboardController>()) {
        try {
          Get.find<DashboardController>().getData();
        } catch (e) {
          // Ignore dashboard update errors
        }
      }
      if (Get.isRegistered<DashboardNotiController>()) {
        try {
          Get.find<DashboardNotiController>().getData();
        } catch (e) {
          // Ignore notification update errors
        }
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> cancelAppointment(Appointment appointment) async {
    try {
      // Call the API to cancel appointment
      await _rescheduleRepository.cancelAppointment(appointment.id);
// Set status to cancelled instead of removing

      final index = appointments.indexWhere((a) => a.id == appointment.id);

      if (index != -1) {
        appointments[index] = Appointment(
          id: appointment.id,
          vaccineName: appointment.vaccineName,
          date: appointment.date,
          doctor: appointment.doctor,
          clinic: appointment.clinic,
          status: AppointmentStatus.cancelled,
          color: appointment.color,
          icon: appointment.icon,
          bookingId: appointment.bookingId,
          timeSlot: appointment.timeSlot,
          statusText: null,
        );

        appointments.refresh(); // Trigger UI update
      }
      // Update dashboard and notification counts
      if (Get.isRegistered<DashboardController>()) {
        try {
          Get.find<DashboardController>().getData();
        } catch (e) {
          // Ignore dashboard update errors
        }
      }
      if (Get.isRegistered<DashboardNotiController>()) {
        try {
          Get.find<DashboardNotiController>().getData();
        } catch (e) {
          // Ignore notification update errors
        }
      }

      Get.snackbar(
        'Thành công',
        'Đã hủy lịch hẹn',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Lỗi',
        'Có lỗi xảy ra khi hủy lịch. Vui lòng thử lại.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  VaccineBooking _convertToVaccineBooking(BookingHistoryData bookingData) {
    // Create a basic VaccineBooking from BookingHistoryData
    // This is a simplified conversion - you may need to adjust based on your actual data structure

    final doseBookings = <int, DoseBooking>{};

    for (final appointment in bookingData.appointments) {
      final appointmentDateTime = DateTime.parse(
        '${appointment.scheduledDate} ${appointment.scheduledTime}',
      );

      // Create a basic facility (you may need to get actual facility data)
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
      price: bookingData.totalAmount / bookingData.totalDoses,
      numberOfDoses: bookingData.totalDoses,
      manufacturer: '', // Placeholder
      country: '', // Placeholder
      duration: 0, // Placeholder
      rating: 0.0, // Placeholder
      imageUrl: '', // Placeholder
      descriptionShort: '', // Placeholder
      schedule: [], // Placeholder
    );

    return VaccineBooking(
      id: bookingData.bookingId.toString(),
      userId: bookingData.patientId.toString(),
      vaccines: [vaccine],
      vaccineQuantities: {bookingData.vaccineName: 1}, // Placeholder
      bookingDate: DateTime.parse(bookingData.createdAt),
      doseBookings: doseBookings,
      totalPrice: bookingData.totalAmount.toDouble(),
      status: bookingData.bookingStatus.toLowerCase(),
      confirmationCode: 'BK-${bookingData.bookingId}',
      createdAt: DateTime.parse(bookingData.createdAt),
    );
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
}
