import 'package:dio/dio.dart';
import 'package:flutter_getx_boilerplate/api/api.dart';
import 'package:flutter_getx_boilerplate/models/models.dart';
import 'package:flutter_getx_boilerplate/models/request/reschedule_request.dart';
import 'package:flutter_getx_boilerplate/models/response/error/error_response.dart';
import 'package:flutter_getx_boilerplate/models/response/reschedule_response.dart';
import 'package:flutter_getx_boilerplate/repositories/base_repository.dart';
import 'package:get/get.dart';

class AppointmentRescheduleRepository extends BaseRepository {
  final ApiServices apiClient;

  AppointmentRescheduleRepository({required this.apiClient});

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

  Future<RescheduleResponse> rescheduleAppointment(
      RescheduleRequest request) async {
    try {
      final res = await apiClient.put(
        ApiEndpoints.rescheduleAppointment,
        data: request.toJson(),
      );

      return RescheduleResponse.fromJson(res.data['data']);
    } on DioException catch (e) {
      throw handleError(e);
    } catch (e) {
      throw ErrorResponse(message: 'unknown_error'.tr);
    }
  }

  Future<void> cancelAppointment(String appointmentId) async {
    try {
      await apiClient.put(
        ApiEndpoints.cancelAppointment(appointmentId),
      );
    } on DioException catch (e) {
      throw handleError(e);
    } catch (e) {
      throw ErrorResponse(message: 'unknown_error'.tr);
    }
  }
}
