// lib/repositories/vaccination_certificate_repository.dart
import 'package:dio/dio.dart';
import 'package:flutter_getx_boilerplate/api/api.dart';
import 'package:flutter_getx_boilerplate/models/response/error/error_response.dart';
import 'package:flutter_getx_boilerplate/models/vaccine_model/booking_model.dart';
import 'package:flutter_getx_boilerplate/repositories/base_repository.dart';
import 'package:get/get.dart';

class VaccinationCertificateRepository extends BaseRepository {
  final ApiServices apiClient;

  VaccinationCertificateRepository({required this.apiClient});

  // Get vaccination certificate details
  Future<VaccineBooking> getVaccinationCertificate(String bookingId) async {
    try {
      final res = await apiClient.get('/bookings/$bookingId/certificate-details');
      return VaccineBooking.fromJson(res.data);
    } on DioException catch (e) {
      throw handleError(e);
    } catch (e) {
      throw ErrorResponse(message: 'unknown_error'.tr);
    }
  }

  // Download vaccination certificate as PDF
  Future<String> downloadCertificate(String bookingId) async {
    try {
      final res = await apiClient.get('/bookings/$bookingId/certificate/download');
      return res.data['downloadUrl'] as String;
    } on DioException catch (e) {
      throw handleError(e);
    } catch (e) {
      throw ErrorResponse(message: 'unknown_error'.tr);
    }
  }

  // Share vaccination certificate
  Future<String> shareCertificate(String bookingId) async {
    try {
      final res = await apiClient.post('/bookings/$bookingId/certificate/share');
      return res.data['shareUrl'] as String;
    } on DioException catch (e) {
      throw handleError(e);
    } catch (e) {
      throw ErrorResponse(message: 'unknown_error'.tr);
    }
  }

  // Get vaccination history for certificate
  Future<List<VaccineBooking>> getVaccinationHistory(String userId) async {
    try {
      final res = await apiClient.get('/users/$userId/vaccination-history');
      return (res.data as List).map((e) => VaccineBooking.fromJson(e)).toList();
    } on DioException catch (e) {
      throw handleError(e);
    } catch (e) {
      throw ErrorResponse(message: 'unknown_error'.tr);
    }
  }

  // Verify certificate authenticity
  Future<bool> verifyCertificate(String certificateId) async {
    try {
      final res = await apiClient.get('/certificates/$certificateId/verify');
      return res.data['isValid'] as bool;
    } on DioException catch (e) {
      throw handleError(e);
    } catch (e) {
      throw ErrorResponse(message: 'unknown_error'.tr);
    }
  }
}