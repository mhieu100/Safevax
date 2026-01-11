// lib/modules/history_vaccine_detail/history_vaccine_detail_controller.dart
import 'package:flutter/material.dart';
import 'package:flutter_getx_boilerplate/models/vaccine_model/booking_model.dart';
import 'package:flutter_getx_boilerplate/modules/base/base_controller.dart';
import 'package:flutter_getx_boilerplate/repositories/history_vaccine_detail_repository.dart';
import 'package:get/get.dart';

class HistoryVaccineDetailController extends BaseController<HistoryVaccineDetailRepository> {
  HistoryVaccineDetailController(super.repository);

  // Reactive variables
  final Rx<VaccineBooking?> booking = Rx<VaccineBooking?>(null);
  final RxBool isLoading = true.obs;
  final RxBool isDownloading = false.obs;
  final RxString errorMessage = ''.obs;

  // Booking ID from arguments
  String? bookingId;

  @override
  void onInit() {
    super.onInit();
    _loadBookingDetail();
  }

  // Load booking detail from arguments or API
  void _loadBookingDetail() {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Get booking from arguments first (for immediate display)
      final args = Get.arguments;
      if (args is VaccineBooking) {
        booking.value = args;
        bookingId = args.id;
        isLoading.value = false;
        return;
      }

      // If no arguments, try to get booking ID and fetch from API
      if (args is String) {
        bookingId = args;
        fetchBookingDetail();
      } else {
        errorMessage.value = 'Không tìm thấy thông tin lịch hẹn';
        isLoading.value = false;
      }
    } catch (e) {
      errorMessage.value = 'Có lỗi xảy ra khi tải dữ liệu';
      isLoading.value = false;
    }
  }

  // Fetch booking detail from API
  Future<void> fetchBookingDetail() async {
    if (bookingId == null) return;

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final result = await repository.getBookingDetail(bookingId!);
      booking.value = result;
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  // Download vaccination certificate
  Future<void> downloadCertificate() async {
    if (booking.value == null) return;

    try {
      isDownloading.value = true;

      final downloadUrl = await repository.downloadCertificate(booking.value!.id);

      // Show success message
      Get.snackbar(
        'Thành công',
        'Đã tải xuống chứng nhận thành công',
        backgroundColor: Colors.green,
        colorText: Colors.white,
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

  // Update booking status
  Future<void> updateBookingStatus(String status) async {
    if (booking.value == null) return;

    try {
      await repository.updateBookingStatus(booking.value!.id, status);

      // Update local booking status
      booking.value = booking.value!.copyWith(status: status);

      Get.snackbar(
        'Thành công',
        'Đã cập nhật trạng thái lịch hẹn',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Lỗi',
        'Không thể cập nhật trạng thái: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Cancel booking
  Future<void> cancelBooking(String reason) async {
    if (booking.value == null) return;

    try {
      await repository.cancelBooking(booking.value!.id, reason);

      // Update local booking status
      booking.value = booking.value!.copyWith(status: 'cancelled');

      Get.snackbar(
        'Thành công',
        'Đã hủy lịch hẹn thành công',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Lỗi',
        'Không thể hủy lịch hẹn: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Get status color
  Color getStatusColor(String status) {
    return switch (status) {
      'completed' => Colors.green,
      'partially_completed' => Colors.green,
      'cancelled' => Colors.red,
      _ => Colors.orange,
    };
  }

  // Get status text
  String getStatusText(String status) {
    return switch (status) {
      'completed' => 'Đã hoàn thành',
      'partially_completed' => 'Đã tiêm một phần',
      'cancelled' => 'Đã hủy',
      _ => 'Sắp tới',
    };
  }

  // Get status icon
  IconData getStatusIcon(String status) {
    return switch (status) {
      'completed' => Icons.check_circle,
      'partially_completed' => Icons.check_circle_outline,
      'cancelled' => Icons.cancel,
      _ => Icons.schedule,
    };
  }

  // Calculate days left for upcoming doses
  int calculateDaysLeft(DateTime appointmentDate) {
    final now = DateTime.now();
    final difference = appointmentDate.difference(now);
    return difference.inDays;
  }

  // Get next upcoming dose
  DoseBooking? getNextDose() {
    if (booking.value == null) return null;

    final now = DateTime.now();
    final upcomingDoses = booking.value!.doseBookings.values
        .where((dose) => !dose.isCompleted && dose.dateTime.isAfter(now))
        .toList()
      ..sort((a, b) => a.dateTime.compareTo(b.dateTime));

    return upcomingDoses.isNotEmpty ? upcomingDoses.first : null;
  }

  // Check if booking is completed
  bool isBookingCompleted() {
    if (booking.value == null) return false;
    return booking.value!.doseBookings.values.every((dose) => dose.isCompleted);
  }

  // Navigate back
  void goBack() {
    Get.back();
  }

}