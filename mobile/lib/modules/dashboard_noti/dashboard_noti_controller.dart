import 'package:flutter/material.dart';
import 'package:flutter_getx_boilerplate/modules/base/base_controller.dart';
import 'package:flutter_getx_boilerplate/repositories/dashboard_noti_repository.dart';
import 'package:flutter_getx_boilerplate/routes/navigator_helper.dart';
import 'package:flutter_getx_boilerplate/shared/services/storage_service.dart';
import 'package:flutter_getx_boilerplate/models/response/user/user.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter_getx_boilerplate/models/response/booking_history_grouped_response.dart';

class DashboardNotiController extends BaseController<DashboardNotiRepository> {
  DashboardNotiController(super.repository);

  var userName = ''.obs;
  var dosesTaken = '0'.obs;
  var vaccinesMissing = '4'.obs;
  var appointmentCount = '0'.obs;
  var healthAlertsCount = '4'.obs;

  final upcomingAppointment = "".obs;
  final upcomingTime = "".obs;
  final upcomingVaccine = "".obs;
  final upcomingDoctor = "".obs;
  final upcomingLocation = "".obs;
  final hasUpcomingAppointment = false.obs;

  void _resetAppointmentFields() {
    upcomingAppointment.value = "";
    upcomingTime.value = "";
    upcomingVaccine.value = "";
    upcomingDoctor.value = "";
    upcomingLocation.value = "";
    hasUpcomingAppointment.value = false;
  }

  @override
  Future getData() async {
    _loadUserData();
    await _loadUpcomingAppointment();
  }

  void _loadUserData() {
    final userData = StorageService.userData;
    if (userData != null) {
      final user = User.fromJson(userData);
      userName.value = user.fullName ?? '';
    }
  }

  // Method to refresh user data from storage
  void refreshUserData() {
    _loadUserData();
  }

  Future<void> _loadUpcomingAppointment() async {
    try {
      final response = await repository.fetchBookingsGrouped();

      // Calculate total counts
      int totalBookings = response.data.length;
      int totalAppointments = 0;

      for (final booking in response.data) {
        totalAppointments += booking.appointments.length;
      }

      dosesTaken.value = totalBookings.toString();
      appointmentCount.value = totalAppointments.toString();

      // Find the next upcoming booking
      final booking = await repository.getNextUpcomingBooking();
      if (booking != null && booking.appointments.isNotEmpty) {
        // Find the next upcoming appointment
        final now = DateTime.now();
        GroupedAppointmentData? nextAppointment;

        for (final appointment in booking.appointments) {
          // Parse time slot format "SLOT_HH_MM" to extract hour and minute
          final timeSlotParts = appointment.scheduledTimeSlot.split('_');
          final hour = int.parse(timeSlotParts[1]);
          final minute = int.parse(timeSlotParts[2]);
          final scheduledDate = DateTime.parse(appointment.scheduledDate);
          final appointmentDateTime = DateTime(
            scheduledDate.year,
            scheduledDate.month,
            scheduledDate.day,
            hour,
            minute,
          );

          // Only consider appointments that are not cancelled
          if (appointment.appointmentStatus != 'CANCELLED') {
            if (nextAppointment == null) {
              nextAppointment = appointment;
            } else {
              // Compare with current next appointment
              final currentTimeSlotParts =
                  nextAppointment.scheduledTimeSlot.split('_');
              final currentHour = int.parse(currentTimeSlotParts[1]);
              final currentMinute = int.parse(currentTimeSlotParts[2]);
              final currentScheduledDate =
                  DateTime.parse(nextAppointment.scheduledDate);
              final currentAppointmentDateTime = DateTime(
                currentScheduledDate.year,
                currentScheduledDate.month,
                currentScheduledDate.day,
                currentHour,
                currentMinute,
              );

              if (appointmentDateTime.isBefore(currentAppointmentDateTime)) {
                nextAppointment = appointment;
              }
            }
          }
        }

        if (nextAppointment != null) {
          // Parse time slot format "SLOT_HH_MM" to extract hour and minute
          final timeSlotParts = nextAppointment.scheduledTimeSlot.split('_');
          final hour = int.parse(timeSlotParts[1]);
          final minute = int.parse(timeSlotParts[2]);
          final scheduledDate = DateTime.parse(nextAppointment.scheduledDate);
          final appointmentDateTime = DateTime(
            scheduledDate.year,
            scheduledDate.month,
            scheduledDate.day,
            hour,
            minute,
          );

          // Set the appointment details
          upcomingAppointment.value =
              DateFormat('dd/MM/yyyy').format(appointmentDateTime);
          upcomingTime.value = DateFormat('HH:mm').format(appointmentDateTime);
          upcomingVaccine.value =
              'Mũi ${nextAppointment.doseNumber} - ${booking.vaccineName}';
          upcomingDoctor.value =
              nextAppointment.doctorName ?? 'Bác sĩ sẽ được chỉ định';
          upcomingLocation.value = nextAppointment.centerName;
          hasUpcomingAppointment.value = true;
        } else {
          _resetAppointmentFields();
        }
      } else {
        _resetAppointmentFields();
      }
    } catch (e) {
      _resetAppointmentFields();
      // Reset counts to 0 on error
      dosesTaken.value = '0';
      appointmentCount.value = '0';
    }
  }

  // Danh sách thông báo (thêm type và time)
  final notifications = <Map<String, dynamic>>[
    {
      'icon': Icons.calendar_today,
      'title': 'Lịch hẹn mới',
      'message': 'Bạn có lịch hẹn tiêm vào ngày 12/08 lúc 9:00 sáng',
      'time': '10 phút trước',
      'type': 'info',
    },
    {
      'icon': Icons.medical_services,
      'title': 'Vắc xin mới có sẵn',
      'message': 'Vắc xin COVID-19 mới của Pfizer hiện đã có',
      'time': '1 giờ trước',
      'type': 'info',
    },
    {
      'icon': Icons.warning,
      'title': 'Cảnh báo sức khỏe',
      'message': 'Khu vực của bạn đang có dịch sốt xuất huyết',
      'time': '2 ngày trước',
      'type': 'alert',
    },
  ].obs;

  void toVaccineManagementScreen() {
    NavigatorHelper.toVaccineManagementScreen();
  }

  void toVaccineListScreen() {
    NavigatorHelper.toVaccineListScreen();
  }

  void toVaccineMissingScreen() {
    NavigatorHelper.toVaccineMissingScreen();
  }

  void toMedicalAlertsScreen() {
    NavigatorHelper.toMedicalAlertsScreen();
  }

  void toMedicalAlertsDetailScreen() {
    NavigatorHelper.toMedicalAlertsDetailScreen();
  }

  void toAppointmentDetailScreen() async {
    // Get the upcoming appointment data
    final booking = await repository.getNextUpcomingBooking();
    if (booking != null && booking.appointments.isNotEmpty) {
      // Find the next upcoming appointment
      final now = DateTime.now();
      GroupedAppointmentData? nextAppointment;

      for (final appointment in booking.appointments) {
        // Parse time slot format "SLOT_HH_MM" to extract hour and minute
        final timeSlotParts = appointment.scheduledTimeSlot.split('_');
        final hour = int.parse(timeSlotParts[1]);
        final minute = int.parse(timeSlotParts[2]);
        final scheduledDate = DateTime.parse(appointment.scheduledDate);
        final appointmentDateTime = DateTime(
          scheduledDate.year,
          scheduledDate.month,
          scheduledDate.day,
          hour,
          minute,
        );

        // Only consider appointments that are not cancelled
        if (appointment.appointmentStatus != 'CANCELLED') {
          if (nextAppointment == null) {
            nextAppointment = appointment;
          } else {
            // Compare with current next appointment
            final currentTimeSlotParts =
                nextAppointment.scheduledTimeSlot.split('_');
            final currentHour = int.parse(currentTimeSlotParts[1]);
            final currentMinute = int.parse(currentTimeSlotParts[2]);
            final currentScheduledDate =
                DateTime.parse(nextAppointment.scheduledDate);
            final currentAppointmentDateTime = DateTime(
              currentScheduledDate.year,
              currentScheduledDate.month,
              currentScheduledDate.day,
              currentHour,
              currentMinute,
            );

            if (appointmentDateTime.isBefore(currentAppointmentDateTime)) {
              nextAppointment = appointment;
            }
          }
        }
      }

      if (nextAppointment != null) {
        // Parse time slot format "SLOT_HH_MM" to extract hour and minute
        final timeSlotParts = nextAppointment.scheduledTimeSlot.split('_');
        final hour = int.parse(timeSlotParts[1]);
        final minute = int.parse(timeSlotParts[2]);
        final scheduledDate = DateTime.parse(nextAppointment.scheduledDate);
        final appointmentDateTime = DateTime(
          scheduledDate.year,
          scheduledDate.month,
          scheduledDate.day,
          hour,
          minute,
        );

        // Create appointment data map with all available information
        final appointmentData = {
          "id": nextAppointment.id.toString(),
          "vaccineName": booking.vaccineName,
          "dose": "Mũi ${nextAppointment.doseNumber}",
          "date": DateFormat('dd/MM/yyyy').format(appointmentDateTime),
          "time": DateFormat('HH:mm').format(appointmentDateTime),
          "location": nextAppointment.centerName,
          "doctor": nextAppointment.doctorName ?? 'Bác sĩ sẽ được chỉ định',
          "status": nextAppointment.appointmentStatus == "COMPLETED"
              ? "Confirmed"
              : nextAppointment.appointmentStatus == "IN_PROGRESS"
                  ? "In Progress"
                  : "Pending",
          "notes": 'Appointment ID: ${nextAppointment.id}',
          "patientName": nextAppointment.patientName,
          "patientPhone": nextAppointment.patientPhone,
          "paymentAmount": "${nextAppointment.paymentAmount.toString()} VND",
          "paymentMethod": nextAppointment.paymentMethod == "EWALLET"
              ? "PAYPAL"
              : nextAppointment.paymentMethod,
          "paymentStatus": nextAppointment.paymentStatus,
          "createdAt": DateFormat('dd/MM/yyyy HH:mm')
              .format(DateTime.parse(nextAppointment.createdAt)),
          "totalAmount": "${booking.totalAmount.toString()} VND",
          "requiredDoses": booking.requiredDoses.toString(),
          "completedCount": booking.completedCount.toString(),
          "qrCodeUrl":
              "https://api.qrserver.com/v1/create-qr-code/?size=150x150&data=${nextAppointment.id}",
        };

        // NavigatorHelper.toAppointmentDetailScreen(
        //     appointmentData: appointmentData);
      }
    }
  }

  void toAppointmentRescheduleScreen() async {
    // Get the upcoming appointment data
    final booking = await repository.getNextUpcomingBooking();
    if (booking != null && booking.appointments.isNotEmpty) {
      // Find the next upcoming appointment
      final now = DateTime.now();
      GroupedAppointmentData? nextAppointment;

      for (final appointment in booking.appointments) {
        // Parse time slot format "SLOT_HH_MM" to extract hour and minute
        final timeSlotParts = appointment.scheduledTimeSlot.split('_');
        final hour = int.parse(timeSlotParts[1]);
        final minute = int.parse(timeSlotParts[2]);
        final scheduledDate = DateTime.parse(appointment.scheduledDate);
        final appointmentDateTime = DateTime(
          scheduledDate.year,
          scheduledDate.month,
          scheduledDate.day,
          hour,
          minute,
        );

        // Only consider appointments that are not cancelled
        if (appointment.appointmentStatus != 'CANCELLED') {
          if (nextAppointment == null) {
            nextAppointment = appointment;
          } else {
            // Compare with current next appointment
            final currentTimeSlotParts =
                nextAppointment.scheduledTimeSlot.split('_');
            final currentHour = int.parse(currentTimeSlotParts[1]);
            final currentMinute = int.parse(currentTimeSlotParts[2]);
            final currentScheduledDate =
                DateTime.parse(nextAppointment.scheduledDate);
            final currentAppointmentDateTime = DateTime(
              currentScheduledDate.year,
              currentScheduledDate.month,
              currentScheduledDate.day,
              currentHour,
              currentMinute,
            );

            if (appointmentDateTime.isBefore(currentAppointmentDateTime)) {
              nextAppointment = appointment;
            }
          }
        }
      }

      if (nextAppointment != null) {
        // Create appointment data map
        final appointmentData = {
          "id": nextAppointment.id.toString(),
          "vaccineName": booking.vaccineName,
          "dose": "Mũi ${nextAppointment.doseNumber}",
          "date": DateFormat('dd/MM/yyyy')
              .format(DateTime.parse(nextAppointment.scheduledDate)),
          "time": nextAppointment.scheduledTimeSlot
              .replaceAll('SLOT_', '')
              .replaceAll('_', ':'),
          "location": nextAppointment.centerName,
          "doctor": nextAppointment.doctorName ?? 'Bác sĩ sẽ được chỉ định',
          "status": nextAppointment.appointmentStatus == "COMPLETED"
              ? "Confirmed"
              : nextAppointment.appointmentStatus == "IN_PROGRESS"
                  ? "In Progress"
                  : "Pending",
          "notes": 'Appointment ID: ${nextAppointment.id}',
          "patientName": nextAppointment.patientName,
          "patientPhone": nextAppointment.patientPhone,
          "paymentAmount": "${nextAppointment.paymentAmount.toString()} VND",
          "paymentMethod": nextAppointment.paymentMethod == "EWALLET"
              ? "PAYPAL"
              : nextAppointment.paymentMethod,
          "paymentStatus": nextAppointment.paymentStatus,
          "createdAt": DateFormat('dd/MM/yyyy HH:mm')
              .format(DateTime.parse(nextAppointment.createdAt)),
          "totalAmount": "${booking.totalAmount.toString()} VND",
          "requiredDoses": booking.requiredDoses.toString(),
          "completedCount": booking.completedCount.toString(),
          "qrCodeUrl":
              "https://api.qrserver.com/v1/create-qr-code/?size=150x150&data=${nextAppointment.id}",
        };

        NavigatorHelper.toVaccineScheduleScreen(arguments: {
          'isReschedule': true,
          'appointment': appointmentData,
        });
      }
    }
  }

  void toAppointmentListScreen() {
    NavigatorHelper.toAppointmentListScreen();
  }

  void toVaccinationHistoryScreen() {
    NavigatorHelper.toVaccinationHistoryScreen();
  }
}
