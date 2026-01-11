import 'package:dio/dio.dart';
import 'package:flutter_getx_boilerplate/api/api.dart';
import 'package:flutter_getx_boilerplate/models/models.dart';
import 'package:flutter_getx_boilerplate/models/response/error/error_response.dart';
import 'package:flutter_getx_boilerplate/models/response/booking_history_response.dart';
import 'package:flutter_getx_boilerplate/models/response/booking_history_grouped_response.dart';
import 'package:flutter_getx_boilerplate/repositories/base_repository.dart';
import 'package:get/get.dart';

class DashboardRepository extends BaseRepository {
  final ApiServices apiClient;

  DashboardRepository({required this.apiClient});

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

  Future<BookingHistoryGroupedResponse> getBookingHistoryGrouped() async {
    try {
      final res = await apiClient.get(
        ApiEndpoints.bookingHistoryGrouped,
      );

      return BookingHistoryGroupedResponse.fromJson(res.data);
    } on DioException catch (e) {
      throw handleError(e);
    } catch (e) {
      throw ErrorResponse(message: 'unknown_error'.tr);
    }
  }

  Future<BookingHistoryData?> getNextUpcomingBooking() async {
    try {
      final response = await getBookingHistory();

      // Find the next upcoming booking with confirmed status
      final now = DateTime.now();
      BookingHistoryData? nextBooking;

      for (final booking in response.data) {
        if (booking.bookingStatus.toLowerCase() == 'confirmed') {
          // Check if this booking has any upcoming appointments
          for (final appointment in booking.appointments) {
            final appointmentDateTime = DateTime.parse(
              '${appointment.scheduledDate} ${appointment.scheduledTime}',
            );

            if (appointmentDateTime.isAfter(now)) {
              // This is an upcoming appointment
              if (nextBooking == null ||
                  appointmentDateTime.isBefore(DateTime.parse(
                    '${nextBooking.appointments.first.scheduledDate} ${nextBooking.appointments.first.scheduledTime}',
                  ))) {
                nextBooking = booking;
              }
              break; // Found an upcoming appointment for this booking
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
