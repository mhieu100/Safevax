import 'package:dio/dio.dart' as dio;
import 'package:flutter_getx_boilerplate/api/api.dart';
import 'package:flutter_getx_boilerplate/models/models.dart';
import 'package:flutter_getx_boilerplate/models/response/error/error_response.dart';
import 'package:flutter_getx_boilerplate/repositories/base_repository.dart';
import 'package:get/get.dart';

class VaccineConsultationRepository extends BaseRepository {
  final ApiServices apiClient;

  VaccineConsultationRepository({required this.apiClient});

  Future<String> chat(String query) async {
    try {
      final res = await apiClient.post(
        ApiEndpoints.ragChat,
        queryParameters: {'query': query},
      );

      return res.data as String;
    } on dio.DioException catch (e) {
      throw handleError(e);
    } catch (e) {
      throw ErrorResponse(message: 'unknown_error'.tr);
    }
  }

  Future<String> consult(ConsultationRequest request) async {
    try {
      final res = await apiClient.post(
        ApiEndpoints.ragConsult,
        data: request.toJson(),
      );

      return res.data as String;
    } on dio.DioException catch (e) {
      throw handleError(e);
    } catch (e) {
      throw ErrorResponse(message: 'unknown_error'.tr);
    }
  }
}
