import 'package:dio/dio.dart';
import 'package:flutter_getx_boilerplate/api/api.dart';
import 'package:flutter_getx_boilerplate/models/models.dart';
import 'package:flutter_getx_boilerplate/models/response/error/error_response.dart';
import 'package:flutter_getx_boilerplate/models/response/booking_history_response.dart';
import 'package:flutter_getx_boilerplate/models/response/booking_history_grouped_response.dart';
import 'package:flutter_getx_boilerplate/repositories/base_repository.dart';
import 'package:get/get.dart';

class DashboardNotiRepository extends BaseRepository {
  final ApiServices apiClient;

  DashboardNotiRepository({required this.apiClient});

  Future<LoginResponse> login(LoginRequest request) async {
    try {
      final res = await apiClient.post(
        ApiEndpoints.login,
        data: request.toJson(),
      );

      return LoginResponse.fromJson(res.data);
    } on DioException catch (e) {
      throw handleError(e);
    } catch (e) {
      throw ErrorResponse(message: 'unknown_error'.tr);
    }
  }

  Future<User?> me() async {
    try {
      final res = await apiClient.get(
        ApiEndpoints.me,
      );

      return User.fromJson(res.data);
    } on DioException catch (e) {
      throw handleError(e);
    } catch (e) {
      throw ErrorResponse(message: 'unknown_error'.tr);
    }
  }

  Future<BookingHistoryResponse> getBookingHistory() async {
    try {
      final res = await apiClient.get(
        ApiEndpoints.booking,
      );

      return BookingHistoryResponse.fromJson(res.data);
    } on DioException catch (e) {
      throw handleError(e);
    } catch (e) {
      throw ErrorResponse(message: 'unknown_error'.tr);
    }
  }

  Future<BookingHistoryGroupedResponse> fetchBookingsGrouped() async {
    try {
      final res = await apiClient.get(ApiEndpoints.bookingHistoryGrouped);

      // Validate response data
      if (res.data == null) {
        throw ErrorResponse(message: 'Không thể tải dữ liệu lịch hẹn');
      }

      return BookingHistoryGroupedResponse.fromJson(res.data);
    } on DioException catch (e) {
      throw handleError(e);
    } catch (e) {
      throw ErrorResponse(message: 'Lỗi xử lý dữ liệu lịch hẹn');
    }
  }

  Future<GroupedBookingData?> getNextUpcomingBooking() async {
    try {
      final response = await fetchBookingsGrouped();

      // Find the next upcoming booking with upcoming appointments
      final now = DateTime.now();
      GroupedBookingData? nextBooking;
      DateTime? earliestAppointmentTime;

      for (final booking in response.data) {
        // Check if this booking has any appointments
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

          if (appointment.appointmentStatus != 'CANCELLED') {
            // This is an appointment
            if (nextBooking == null ||
                appointmentDateTime.isBefore(earliestAppointmentTime!)) {
              nextBooking = booking;
              earliestAppointmentTime = appointmentDateTime;
            }
          }
        }
      }

      return nextBooking;
    } on DioException catch (e) {
      throw handleError(e);
    } catch (e) {
      throw ErrorResponse(message: 'unknown_error'.tr);
    }
  }
}
