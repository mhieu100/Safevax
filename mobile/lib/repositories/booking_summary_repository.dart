import 'package:dio/dio.dart';
import 'package:flutter_getx_boilerplate/api/api.dart';
import 'package:flutter_getx_boilerplate/models/models.dart';
import 'package:flutter_getx_boilerplate/models/request/booking_request.dart';
import 'package:flutter_getx_boilerplate/models/response/error/error_response.dart';
import 'package:flutter_getx_boilerplate/models/response/booking_response.dart';
import 'package:flutter_getx_boilerplate/repositories/base_repository.dart';
import 'package:get/get.dart';

class BookingSummaryRepository extends BaseRepository {
  final ApiServices apiClient;

  BookingSummaryRepository({required this.apiClient});

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

  Future<BookingResponse> createBooking(
      Map<String, dynamic> bookingData) async {
    try {
      final res = await apiClient.post(
        '/bookings',
        data: bookingData,
      );

      if (res.statusCode == 200) {
        final data = res.data;
        if (data['statusCode'] == 200 && data['data'] != null) {
          return BookingResponse.fromJson(data['data']);
        } else {
          throw ErrorResponse(
              message: data['message'] ?? 'Invalid response format');
        }
      } else {
        throw ErrorResponse(
            message: 'Failed to create booking: ${res.statusCode}');
      }
    } on DioException catch (e) {
      throw handleError(e);
    } catch (e) {
      throw ErrorResponse(message: 'unknown_error'.tr);
    }
  }

  Future<Map<String, dynamic>> createBookingNew(
      Map<String, dynamic> bookingData) async {
    try {
      final res = await apiClient.post(
        ApiEndpoints.bookings,
        data: bookingData,
      );

      if (res.statusCode == 200) {
        final data = res.data;
        if (data['statusCode'] == 200 && data['data'] != null) {
          return data['data'] as Map<String, dynamic>;
        } else {
          // Check for 'error' field in the response
          if (data['error'] != null) {
            throw ErrorResponse(message: data['error']);
          } else {
            throw ErrorResponse(
                message: data['message'] ?? 'Invalid response format');
          }
        }
      } else {
        throw ErrorResponse(
            message: 'Failed to create booking: ${res.statusCode}');
      }
    } on DioException catch (e) {
      throw handleError(e);
    } catch (e) {
      throw ErrorResponse(message: 'unknown_error'.tr);
    }
  }

  Future<BookingResponse> createVaccineBooking(BookingRequest request) async {
    try {
      final res = await apiClient.post(
        ApiEndpoints.bookings,
        data: request.toJson(),
      );

      if (res.statusCode == 200 || res.statusCode == 201) {
        final data = res.data;
        if (data['statusCode'] == 200 && data['data'] != null) {
          return BookingResponse.fromJson(data['data']);
        } else {
          throw ErrorResponse(
              message: data['message'] ?? 'Invalid response format');
        }
      } else {
        throw ErrorResponse(
            message: 'Failed to create vaccine booking: ${res.statusCode}');
      }
    } on DioException catch (e) {
      throw handleError(e);
    } catch (e) {
      throw ErrorResponse(message: 'unknown_error'.tr);
    }
  }
}
