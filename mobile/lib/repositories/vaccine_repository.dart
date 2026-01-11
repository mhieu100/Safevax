import 'package:dio/dio.dart';
import 'package:flutter_getx_boilerplate/api/api.dart';
import 'package:flutter_getx_boilerplate/models/request/vaccine_list_request.dart';
import 'package:flutter_getx_boilerplate/models/request/create_schedule_request.dart';
import 'package:flutter_getx_boilerplate/models/response/error/error_response.dart';
import 'package:flutter_getx_boilerplate/models/response/vaccine_list_response/vaccine_list_response.dart';
import 'package:flutter_getx_boilerplate/models/response/create_schedule_response/create_schedule_response.dart';
import 'package:flutter_getx_boilerplate/repositories/base_repository.dart';
import 'package:get/get.dart';

class VaccineRepository extends BaseRepository {
  final ApiServices apiClient;

  VaccineRepository({required this.apiClient});

  Future<VaccineListResponse> getVaccines(VaccineListRequest request) async {
    try {
      final res = await apiClient.get(
        ApiEndpoints.vaccines,
        queryParameters: request.toQueryParameters(),
      );

      return VaccineListResponse.fromJson(res.data);
    } on DioException catch (e) {
      throw handleError(e);
    } catch (e) {
      throw ErrorResponse(message: 'unknown_error'.tr);
    }
  }

  Future<CreateScheduleResponse> createSchedule(
      CreateScheduleRequest request) async {
    try {
      final res = await apiClient.post(
        ApiEndpoints.createSchedule,
        data: request.toJson(),
      );

      return CreateScheduleResponse.fromJson(res.data);
    } on DioException catch (e) {
      throw handleError(e);
    } catch (e) {
      throw ErrorResponse(message: 'unknown_error'.tr);
    }
  }
}
