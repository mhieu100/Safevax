// lib/repositories/history_vaccine_detail_repository.dart
import 'package:dio/dio.dart';
import 'package:flutter_getx_boilerplate/api/api.dart';
import 'package:flutter_getx_boilerplate/models/response/error/error_response.dart';
import 'package:flutter_getx_boilerplate/models/vaccine_model/booking_model.dart';
import 'package:flutter_getx_boilerplate/repositories/base_repository.dart';
import 'package:get/get.dart';

class HistoryVaccineDetailRepository extends BaseRepository {
  final ApiServices apiClient;

  HistoryVaccineDetailRepository({required this.apiClient});

  // Get detailed booking information
  Future<VaccineBooking> getBookingDetail(String bookingId) async {
    try {
      final res = await apiClient.get('/bookings/$bookingId');
      return VaccineBooking.fromJson(res.data);
    } on DioException catch (e) {
      throw handleError(e);
    } catch (e) {
      throw ErrorResponse(message: 'unknown_error'.tr);
    }
  }

  // Get booking history for a user
  Future<List<VaccineBooking>> getUserBookingHistory(String userId) async {
    try {
      final res = await apiClient.get('/users/$userId/bookings');
      return (res.data as List).map((e) => VaccineBooking.fromJson(e)).toList();
    } on DioException catch (e) {
      throw handleError(e);
    } catch (e) {
      throw ErrorResponse(message: 'unknown_error'.tr);
    }
  }

  // Download vaccination certificate
  Future<String> downloadCertificate(String bookingId) async {
    try {
      final res = await apiClient.get('/bookings/$bookingId/certificate');
      return res.data['downloadUrl'] as String;
    } on DioException catch (e) {
      throw handleError(e);
    } catch (e) {
      throw ErrorResponse(message: 'unknown_error'.tr);
    }
  }

  // Update booking status
  Future<bool> updateBookingStatus(String bookingId, String status) async {
    try {
      final res = await apiClient.put('/bookings/$bookingId/status', data: {
        'status': status,
      });
      return res.data['success'] as bool;
    } on DioException catch (e) {
      throw handleError(e);
    } catch (e) {
      throw ErrorResponse(message: 'unknown_error'.tr);
    }
  }

  // Cancel booking
  Future<bool> cancelBooking(String bookingId, String reason) async {
    try {
      final res = await apiClient.put('/bookings/$bookingId/cancel', data: {
        'reason': reason,
      });
      return res.data['success'] as bool;
    } on DioException catch (e) {
      throw handleError(e);
    } catch (e) {
      throw ErrorResponse(message: 'unknown_error'.tr);
    }
  }
}