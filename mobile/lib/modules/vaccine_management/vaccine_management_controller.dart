// lib/modules/vaccine_management/vaccine_management_controller.dart
import 'package:flutter/material.dart';
import 'package:flutter_getx_boilerplate/models/request/reschedule_request.dart';
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

class VaccineManagementController
    extends BaseController<VaccineManagementRepository> {
  VaccineManagementController(super.repository);

  late final AppointmentRescheduleRepository _rescheduleRepository;

  @override
  void onInit() {
    super.onInit();
    _rescheduleRepository = Get.find<AppointmentRescheduleRepository>();
    fetchBookings();
  }

  final RxInt selectedTab = 0.obs;
  final RxBool isLoading = true.obs;

  // RxList for bookings
  final RxList<VaccineBooking> upcomingBookings = <VaccineBooking>[].obs;
  final RxList<VaccineBooking> completedBookings = <VaccineBooking>[].obs;
  final RxList<VaccineBooking> allBookings = <VaccineBooking>[].obs;

  // RxList for grouped bookings
  final RxList<GroupedBookingData> groupedBookings = <GroupedBookingData>[].obs;

  // RxList for progress
  final RxList<VaccineProgressItem> progressItems = <VaccineProgressItem>[].obs;

  // Mock data for demonstration
  // This includes sample healthcare facilities, vaccines, and booking data
  // to showcase the vaccine management functionality
  final List<HealthcareFacility> mockFacilities = [
    HealthcareFacility(
      id: '1',
      name: 'Phòng khám Sky Health',
      address: '123 Đường ABC, Quận 1, TP.HCM',
      phone: '0123456789',
      hours: '08:00 - 17:00',
      distance: 10.762622,
      image: '',
      capacity: 100,
    ),
    HealthcareFacility(
      id: '2',
      name: 'Trung tâm Y tế City Medical',
      address: '456 Đường XYZ, Quận 3, TP.HCM',
      phone: '0987654321',
      hours: '07:00 - 20:00',
      distance: 10.772622,
      image: '',
      capacity: 120,
    ),
    HealthcareFacility(
      id: '3',
      name: 'Trung tâm Y tế cộng đồng',
      address: '789 Đường DEF, Quận 5, TP.HCM',
      phone: '0123987654',
      hours: '06:00 - 18:00',
      distance: 10.752622,
      image: '',
      capacity: 80,
    ),
    HealthcareFacility(
      id: '4',
      name: 'Bệnh viện Đa khoa Quốc tế',
      address: '222 Đường Lê Lợi, Quận 1, TP.HCM',
      phone: '02838222222',
      hours: '24/7',
      distance: 10.792622,
      image: '',
      capacity: 150,
    ),
    HealthcareFacility(
      id: '5',
      name: 'Trung tâm Tiêm chủng VNVC',
      address: '333 Đường Nguyễn Văn Linh, Quận 7, TP.HCM',
      phone: '02873007788',
      hours: '07:30 - 17:00',
      distance: 10.802622,
      image: '',
      capacity: 200,
    ),
  ];

  final List<VaccineModel> mockVaccines = [
    VaccineModel(
      id: '1',
      name: 'COVID-19 Pfizer',
      description: 'Vaccine mRNA phòng COVID-19, hiệu quả 95%',
      numberOfDoses: 3,
      price: 0.0,
      schedule: [],
      manufacturer: 'Pfizer-BioNTech',
      prevention: ['COVID-19'],
      recommendedAge: '12+',
      imageUrl: 'https://via.placeholder.com/150?text=Pfizer',
    ),
    VaccineModel(
      id: '2',
      name: 'COVID-19 Moderna',
      description: 'Vaccine mRNA phòng COVID-19, hiệu quả 94%',
      numberOfDoses: 2,
      price: 0.0,
      schedule: [],
      manufacturer: 'Moderna',
      prevention: ['COVID-19'],
      recommendedAge: '18+',
      imageUrl: 'https://via.placeholder.com/150?text=Moderna',
    ),
    VaccineModel(
      id: '3',
      name: 'Cúm (Influenza)',
      description: 'Vaccine phòng cúm mùa, bảo vệ hàng năm',
      numberOfDoses: 1,
      price: 150000.0,
      schedule: [],
      manufacturer: 'Various',
      prevention: ['Influenza'],
      recommendedAge: '6 months+',
      imageUrl: 'https://via.placeholder.com/150?text=Flu+Vaccine',
    ),
    VaccineModel(
      id: '4',
      name: 'HPV',
      description: 'Vaccine phòng ung thư cổ tử cung và các bệnh do HPV',
      numberOfDoses: 3,
      price: 1800000.0,
      schedule: [],
      manufacturer: 'Merck',
      prevention: ['HPV', 'Cervical Cancer'],
      recommendedAge: '9-26 years',
      imageUrl: 'https://via.placeholder.com/150?text=HPV+Vaccine',
    ),
    VaccineModel(
      id: '5',
      name: 'Viêm gan B',
      description: 'Vaccine phòng viêm gan B, 3 mũi cơ bản',
      numberOfDoses: 3,
      price: 250000.0,
      schedule: [],
      manufacturer: 'Various',
      prevention: ['Hepatitis B'],
      recommendedAge: 'All ages',
      imageUrl: 'https://via.placeholder.com/150?text=HepB+Vaccine',
    ),
    VaccineModel(
      id: '6',
      name: 'Sởi - Quai bị - Rubella (MMR)',
      description: 'Vaccine phòng 3 bệnh: Sởi, Quai bị, Rubella',
      numberOfDoses: 2,
      price: 450000.0,
      schedule: [],
      manufacturer: 'Merck',
      prevention: ['Measles', 'Mumps', 'Rubella'],
      recommendedAge: '12-15 months',
      imageUrl: 'https://via.placeholder.com/150?text=MMR+Vaccine',
    ),
  ];

  Future<void> fetchBookings() async {
    try {
      isLoading.value = true;
      final response = await repository.fetchBookingsGrouped();

      // Clear existing data
      upcomingBookings.clear();
      completedBookings.clear();
      allBookings.clear();
      groupedBookings.clear();

      // Assign grouped data
      groupedBookings.assignAll(response.data);

      // Convert API response to VaccineBooking objects
      final upcomingList = <VaccineBooking>[];
      final completedList = <VaccineBooking>[];
      final allList = <VaccineBooking>[];

      for (final bookingData in response.data) {
        final vaccineBooking = _convertGroupedToVaccineBooking(bookingData);
        allList.add(vaccineBooking);
        if (vaccineBooking.status.toLowerCase() == 'in_progress' ||
            vaccineBooking.status.toLowerCase() == 'ongoing') {
          upcomingList.add(vaccineBooking);
        } else if (vaccineBooking.status.toLowerCase() == 'completed') {
          completedList.add(vaccineBooking);
        }
      }

      // Assign lists to observables
      upcomingBookings.assignAll(upcomingList);
      completedBookings.assignAll(completedList);
      allBookings.assignAll(allList);
    } catch (e) {
      Get.snackbar(
        'Lỗi',
        'Không thể tải dữ liệu đặt lịch: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchProgressData() async {
    try {
      final response = await repository.fetchBookingsGrouped();

      // Clear existing data
      progressItems.clear();

      // Convert API response to VaccineProgressItem objects
      final progressList = <VaccineProgressItem>[];

      for (final bookingData in response.data) {
        final progressItem = _convertGroupedToVaccineProgressItem(bookingData);
        progressList.add(progressItem);
      }

      // Assign list to observable
      progressItems.assignAll(progressList);
    } catch (e) {
      Get.snackbar(
        'Lỗi',
        'Không thể tải dữ liệu tiến độ: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  VaccineBooking _convertGroupedToVaccineBooking(
      GroupedBookingData bookingData) {
    // Create a basic VaccineBooking from GroupedBookingData
    // This is a simplified conversion for the new grouped API structure

    final doseBookings = <int, DoseBooking>{};

    // Create a map of appointments by dose number
    final appointmentMap = <int, GroupedAppointmentData>{};
    for (final appointment in bookingData.appointments) {
      appointmentMap[appointment.doseNumber] = appointment;
    }

    // Create dose bookings for all required doses
    for (int doseNumber = 1;
        doseNumber <= bookingData.requiredDoses;
        doseNumber++) {
      final appointment = appointmentMap[doseNumber];

      if (appointment != null) {
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

        doseBookings[doseNumber] = DoseBooking(
          doseNumber: doseNumber,
          dateTime: appointmentDateTime,
          facility: facility,
          isCompleted: appointment.appointmentStatus == 'COMPLETED',
          vaccineId:
              bookingData.vaccineName, // Using vaccine name as ID placeholder
          vaccineDoseNumber: doseNumber,
          notes: 'Appointment ID: ${appointment.id}',
        );
      } else {
        // Create placeholder dose booking for doses without appointments
        final placeholderFacility = HealthcareFacility(
          id: 'unknown',
          name: 'Chưa cập nhật',
          address: 'Chưa cập nhật',
          phone: '',
          hours: '08:00-17:00',
          image: '',
          capacity: 100,
        );

        doseBookings[doseNumber] = DoseBooking(
          doseNumber: doseNumber,
          dateTime: DateTime.now(), // Placeholder date
          facility: placeholderFacility,
          isCompleted: false,
          vaccineId: bookingData.vaccineName,
          vaccineDoseNumber: doseNumber,
          notes: 'No appointment scheduled',
        );
      }
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

    final createdAt = DateTime.parse(bookingData.createdAt);
    return VaccineBooking(
      id: bookingData.routeId,
      userId: bookingData.patientName, // Placeholder
      vaccines: [vaccine],
      vaccineQuantities: {bookingData.vaccineName: 1}, // Placeholder
      bookingDate: createdAt,
      doseBookings: doseBookings,
      totalPrice: bookingData.totalAmount.toDouble(),
      status: bookingData.status.toLowerCase(),
      confirmationCode: 'BK-${bookingData.routeId}',
      createdAt: createdAt,
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

  // Tab management
  void changeTab(int index) => selectedTab.value = index;

  // Helper method to get facility by ID
  HealthcareFacility? getFacilityById(String id) {
    return mockFacilities.firstWhereOrNull((facility) => facility.id == id);
  }

  // Method to refresh data
  Future<void> refreshData() async {
    await fetchBookings();
  }

  // Helper methods for reschedule dialog
  (DateTime?, String?, String?) calculateDoseConstraints(
      VaccineBooking booking, int doseNumber, DoseBooking doseBooking) {
    final previousDoses = booking.doseBookings.values
        .where(
            (dose) => dose.vaccineDoseNumber < doseNumber && dose.isCompleted)
        .toList()
      ..sort((a, b) => a.vaccineDoseNumber.compareTo(b.vaccineDoseNumber));

    if (doseNumber > 1 && previousDoses.isNotEmpty) {
      final lastDose = previousDoses.last;
      if (doseNumber == 2) {
        return (
          lastDose.dateTime.add(const Duration(days: 28)),
          'Mũi 2 phải cách mũi 1 ít nhất 4 tuần',
          'Mũi 1: ${DateFormat('dd/MM/yyyy').format(lastDose.dateTime)}'
        );
      } else if (doseNumber == 3) {
        return (
          lastDose.dateTime.add(const Duration(days: 180)),
          'Mũi 3 phải cách mũi 2 ít nhất 6 tháng',
          'Mũi 2: ${DateFormat('dd/MM/yyyy').format(lastDose.dateTime)}'
        );
      }
    }
    return (null, null, null);
  }

  List<TimeOfDay> generateHourlyTimeSlots(int startHour, int endHour) {
    return List.generate(endHour - startHour + 1,
        (index) => TimeOfDay(hour: startHour + index, minute: 0));
  }

  // Helper method to convert DateTime to SLOT format
  String _timeToSlot(DateTime dateTime) {
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return 'SLOT_${hour}_${minute}';
  }

  Future<void> rescheduleDose(VaccineBooking booking, int doseNumber,
      DateTime newDateTime, String reason) async {
    final dose = booking.doseBookings[doseNumber];
    if (dose == null) return;

    try {
      // Extract appointment ID from dose notes (format: "Appointment ID: {id}")
      final notes = dose.notes ?? '';
      final appointmentIdMatch =
          RegExp(r'Appointment ID: (\d+)').firstMatch(notes);
      if (appointmentIdMatch == null) {
        throw Exception('Cannot find appointment ID in dose notes');
      }

      final appointmentId = int.parse(appointmentIdMatch.group(1)!);

      // Prepare API request
      final request = RescheduleRequest(
        appointmentId: appointmentId,
        desiredDate: DateFormat('yyyy-MM-dd').format(newDateTime),
        desiredTimeSlot: _timeToSlot(newDateTime),
        reason: reason,
      );

      // Call API
      final response =
          await _rescheduleRepository.rescheduleAppointment(request);

      // Update local data only if API call succeeds
      // Create updated dose booking with provided date/time
      final updatedDose = DoseBooking(
        doseNumber: doseNumber,
        dateTime: newDateTime,
        facility: dose.facility,
        isCompleted: dose.isCompleted,
        completedAt: dose.completedAt,
        notes: dose.notes,
        vaccineId: dose.vaccineId,
        vaccineDoseNumber: dose.vaccineDoseNumber,
      );

      // Update the booking
      final updatedDoseBookings =
          Map<int, DoseBooking>.from(booking.doseBookings);
      updatedDoseBookings[doseNumber] = updatedDose;

      final updatedBooking = VaccineBooking(
        id: booking.id,
        userId: booking.userId,
        vaccines: booking.vaccines,
        vaccineQuantities: booking.vaccineQuantities,
        bookingDate: booking.bookingDate,
        doseBookings: updatedDoseBookings,
        totalPrice: booking.totalPrice,
        status: response.status == 'PENDING_APPROVAL'
            ? 'pending_approval'
            : booking.status,
        paymentMethod: booking.paymentMethod,
        confirmationCode: booking.confirmationCode,
        createdAt: booking.createdAt,
        updatedAt: DateTime.now(),
        vaccineFacility: booking.vaccineFacility,
      );

      // Replace in the list and trigger UI update
      final index = upcomingBookings.indexWhere((b) => b.id == booking.id);
      if (index != -1) {
        upcomingBookings[index] = updatedBooking;
        upcomingBookings.refresh(); // Trigger UI update
      }

      // Update the controller state
      update();
    } catch (e) {
      // Re-throw to let the dialog handle the error
      rethrow;
    }
  }

  void updateDoseDateTime(DoseBooking doseBooking, DateTime newDateTime) {
    doseBooking.dateTime = newDateTime;
    // Force UI update by calling update on the controller
    update();
  }

  void cancelBooking(VaccineBooking booking) {
    Get.dialog(
      AlertDialog(
        title: const Text('Hủy lịch tiêm'),
        content:
            const Text('Bạn có chắc muốn hủy toàn bộ lịch tiêm này không?'),
        actions: [
          TextButton(
            onPressed: Get.back,
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () {
              upcomingBookings.removeWhere((b) => b.id == booking.id);
              Get.back();
              Get.snackbar(
                'Thành công',
                'Lịch tiêm đã được hủy',
                backgroundColor: Colors.white,
                colorText: const Color(0xFF199A8E),
                icon: const Icon(Icons.check_circle, color: Color(0xFF199A8E)),
              );

              // Refresh dashboard data
              try {
                Get.find<DashboardController>()?.getData();
              } catch (_) {}
              try {
                Get.find<DashboardNotiController>()?.getData();
              } catch (_) {}
            },
            child: const Text('Xác nhận', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
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
