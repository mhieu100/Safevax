// lib/modules/vaccination_certificate/vaccination_certificate_controller.dart
import 'package:flutter/material.dart';
import 'package:flutter_getx_boilerplate/models/response/booking_history_response.dart';
import 'package:flutter_getx_boilerplate/models/vaccine_model/booking_model.dart';
import 'package:flutter_getx_boilerplate/models/vaccine_model/vaccine_model.dart';
import 'package:flutter_getx_boilerplate/models/vaccine_model/healthcare_facility_model.dart';
import 'package:flutter_getx_boilerplate/modules/base/base_controller.dart';
import 'package:flutter_getx_boilerplate/repositories/vaccination_certificate_repository.dart';
import 'package:get/get.dart';

class VaccinationCertificateController
    extends BaseController<VaccinationCertificateRepository> {
  VaccinationCertificateController(super.repository);

  // Reactive variables
  final Rx<VaccineBooking?> certificate = Rx<VaccineBooking?>(null);
  final RxBool isLoading = true.obs;
  final RxBool isDownloading = false.obs;
  final RxBool isSharing = false.obs;
  final RxString errorMessage = ''.obs;

  // Certificate ID from arguments
  String? bookingId;

  // Original booking history data
  BookingHistoryData? bookingHistoryData;

  @override
  void onInit() {
    super.onInit();
    _loadCertificate();
  }

  // Load certificate from arguments or create mock data
  void _loadCertificate() {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Get booking from arguments first (for immediate display)
      final args = Get.arguments;
      if (args is BookingHistoryData) {
        // Store original booking history data
        bookingHistoryData = args;
        // Convert BookingHistoryData to VaccineBooking
        certificate.value = _convertBookingHistoryToVaccineBooking(args);
        bookingId = args.bookingId.toString();
        isLoading.value = false;
        return;
      }

      // If no arguments, create mock certificate data
      _createMockCertificate();
    } catch (e) {
      errorMessage.value = 'Có lỗi xảy ra khi tải chứng nhận';
      isLoading.value = false;
    }
  }

  // Create mock certificate data for demonstration
  void _createMockCertificate() {
    // Create mock vaccine
    final mockVaccine = VaccineModel(
      id: 'vac_001',
      name: 'Vaccine COVID-19',
      manufacturer: 'Pfizer-BioNTech',
      description: 'Vaccine phòng ngừa COVID-19 với hiệu quả cao',
      prevention: ['COVID-19'],
      numberOfDoses: 2,
      recommendedAge: '12+',
      price: 750000,
      sideEffects: ['Đau tại chỗ tiêm', 'Mệt mỏi', 'Đau đầu'],
    );

    // Create mock facility
    final mockFacility = HealthcareFacility(
      id: 'fac_001',
      name: 'Trung tâm Y tế Quận 1',
      address: '123 Đường Nguyễn Du, Quận 1, TP.HCM',
      phone: '0123 456 789',
      hours: '08:00 - 17:00',
      distance: 2.5,
      rating: 4.8,
      image: '',
      capacity: 100,
    );

    // Create mock dose bookings
    final doseBookings = <int, DoseBooking>{};

    // Dose 1 - completed
    final dose1Date = DateTime.now().subtract(const Duration(days: 60));
    doseBookings[1] = DoseBooking(
      doseNumber: 1,
      dateTime: dose1Date,
      facility: mockFacility,
      isCompleted: true,
      completedAt: dose1Date,
      vaccineId: mockVaccine.id,
      vaccineDoseNumber: 1,
    );

    // Dose 2 - completed
    final dose2Date = DateTime.now().subtract(const Duration(days: 30));
    doseBookings[2] = DoseBooking(
      doseNumber: 2,
      dateTime: dose2Date,
      facility: mockFacility,
      isCompleted: true,
      completedAt: dose2Date,
      vaccineId: mockVaccine.id,
      vaccineDoseNumber: 2,
    );

    // Create mock booking
    final mockBooking = VaccineBooking(
      id: 'booking_mock_001',
      userId: 'user_001',
      vaccines: [mockVaccine],
      vaccineQuantities: {mockVaccine.id: 1},
      bookingDate: DateTime.now().subtract(const Duration(days: 90)),
      doseBookings: doseBookings,
      totalPrice: 1500000,
      status: 'completed',
      paymentMethod: 'credit_card',
      confirmationCode: 'VAC-20241201001',
      createdAt: DateTime.now().subtract(const Duration(days: 90)),
      vaccineFacility: mockFacility,
    );

    certificate.value = mockBooking;
    bookingId = mockBooking.id;
    isLoading.value = false;
  }

  // Fetch certificate from API
  Future<void> fetchCertificate() async {
    if (bookingId == null) return;

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final result = await repository.getVaccinationCertificate(bookingId!);
      certificate.value = result;
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  // Download vaccination certificate
  Future<void> downloadCertificate() async {
    if (certificate.value == null) return;

    try {
      isDownloading.value = true;

      final downloadUrl =
          await repository.downloadCertificate(certificate.value!.id);

      // Show success message
      Get.snackbar(
        'Thành công',
        'Đã tải xuống chứng nhận thành công',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        icon: const Icon(
          Icons.download_done,
          color: Colors.white,
        ),
      );

      // Here you could open the download URL or handle the download
      // For now, just show success message
    } catch (e) {
      Get.snackbar(
        'Lỗi',
        'Không thể tải chứng nhận: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isDownloading.value = false;
    }
  }

  // Share vaccination certificate
  Future<void> shareCertificate() async {
    if (certificate.value == null) return;

    try {
      isSharing.value = true;

      final shareUrl = await repository.shareCertificate(certificate.value!.id);

      // Show success message
      Get.snackbar(
        'Thành công',
        'Đã tạo liên kết chia sẻ chứng nhận',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        icon: const Icon(
          Icons.share,
          color: Colors.white,
        ),
      );

      // Here you could open share dialog or copy to clipboard
      // For now, just show success message
    } catch (e) {
      Get.snackbar(
        'Lỗi',
        'Không thể chia sẻ chứng nhận: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isSharing.value = false;
    }
  }

  // Verify certificate authenticity
  Future<void> verifyCertificate() async {
    if (certificate.value == null) return;

    try {
      final isValid = await repository.verifyCertificate(certificate.value!.id);

      if (isValid) {
        Get.snackbar(
          'Xác thực thành công',
          'Chứng nhận này là hợp lệ và chính thống',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          icon: const Icon(
            Icons.verified,
            color: Colors.white,
          ),
        );
      } else {
        Get.snackbar(
          'Cảnh báo',
          'Không thể xác thực chứng nhận này',
          backgroundColor: Colors.orange,
          colorText: Colors.white,
          icon: const Icon(
            Icons.warning,
            color: Colors.white,
          ),
        );
      }
    } catch (e) {
      Get.snackbar(
        'Lỗi',
        'Không thể xác thực chứng nhận: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Get certificate status
  String getCertificateStatus() {
    if (certificate.value == null) return 'Không xác định';

    final completedDoses = certificate.value!.doseBookings.values
        .where((dose) => dose.isCompleted)
        .length;

    final totalDoses = certificate.value!.doseBookings.length;

    if (completedDoses == totalDoses) {
      return 'Hoàn thành ($completedDoses/$totalDoses)';
    } else {
      return 'Đang tiến hành ($completedDoses/$totalDoses)';
    }
  }

  // Get certificate validity period
  String getCertificateValidity() {
    if (certificate.value == null) return 'Không xác định';

    // Assuming certificates are valid for 5 years from last dose
    final lastDose = certificate.value!.doseBookings.values
        .where((dose) => dose.isCompleted)
        .fold<DateTime?>(null, (prev, dose) {
      if (prev == null || dose.dateTime.isAfter(prev)) {
        return dose.dateTime;
      }
      return prev;
    });

    if (lastDose != null) {
      final expiryDate = lastDose.add(const Duration(days: 365 * 5));
      return 'Hết hạn: ${expiryDate.day}/${expiryDate.month}/${expiryDate.year}';
    }

    return 'Chưa hoàn thành';
  }

  // Get vaccine names
  String getVaccineNames() {
    if (certificate.value == null) return 'Không xác định';
    return certificate.value!.vaccines.map((v) => v.name).join(', ');
  }

  // Get completed doses count
  int getCompletedDosesCount() {
    if (certificate.value == null) return 0;
    return certificate.value!.doseBookings.values
        .where((dose) => dose.isCompleted)
        .length;
  }

  // Get total doses count
  int getTotalDosesCount() {
    if (certificate.value == null) return 0;
    return certificate.value!.doseBookings.length;
  }

  // Check if certificate is fully completed
  bool isCertificateCompleted() {
    return getCompletedDosesCount() == getTotalDosesCount() &&
        getTotalDosesCount() > 0;
  }

  // Convert BookingHistoryData to VaccineBooking
  VaccineBooking _convertBookingHistoryToVaccineBooking(
      BookingHistoryData booking) {
    // Create mock vaccine from booking data
    final mockVaccine = VaccineModel(
      id: 'vac_${booking.bookingId}',
      name: booking.vaccineName,
      manufacturer: 'VNVC',
      description: 'Vaccine ${booking.vaccineName}',
      prevention: [booking.vaccineName],
      numberOfDoses: booking.totalDoses,
      recommendedAge: 'All ages',
      price: booking.totalAmount,
      sideEffects: [],
    );

    // Create mock facility from first appointment
    final firstAppointment = booking.appointments.first;
    final mockFacility = HealthcareFacility(
      id: 'fac_${firstAppointment.centerId}',
      name: firstAppointment.centerName,
      address: firstAppointment.centerName,
      phone: '',
      hours: '08:00 - 17:00',
      distance: 0.0,
      rating: 5.0,
      image: '',
      capacity: 100,
    );

    // Create dose bookings from appointments
    final doseBookings = <int, DoseBooking>{};
    for (final appointment in booking.appointments) {
      final doseDate = DateTime.parse(appointment.scheduledDate);
      final isCompleted = appointment.appointmentStatus == 'COMPLETED';

      doseBookings[appointment.doseNumber] = DoseBooking(
        doseNumber: appointment.doseNumber,
        dateTime: doseDate,
        facility: mockFacility,
        isCompleted: isCompleted,
        completedAt: isCompleted ? doseDate : null,
        vaccineId: mockVaccine.id,
        vaccineDoseNumber: appointment.doseNumber,
      );
    }

    // Create vaccine booking
    return VaccineBooking(
      id: booking.bookingId.toString(),
      userId: booking.patientId.toString(),
      vaccines: [mockVaccine],
      vaccineQuantities: {mockVaccine.id: 1},
      bookingDate: DateTime.parse(booking.createdAt),
      doseBookings: doseBookings,
      totalPrice: booking.totalAmount,
      status: booking.bookingStatus.toLowerCase(),
      paymentMethod: 'unknown',
      confirmationCode: 'VAC-${booking.bookingId}',
      createdAt: DateTime.parse(booking.createdAt),
      vaccineFacility: mockFacility,
    );
  }

  // Navigate back
  void goBack() {
    Get.back();
  }
}
