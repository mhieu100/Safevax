import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:flutter_getx_boilerplate/api/api.dart';
import 'package:flutter_getx_boilerplate/models/models.dart';
import 'package:flutter_getx_boilerplate/models/request/complete_profile_request.dart';
import 'package:flutter_getx_boilerplate/models/response/complete_profile_response.dart';
import 'package:flutter_getx_boilerplate/models/response/error/error_response.dart';
import 'package:flutter_getx_boilerplate/repositories/base_repository.dart';
import 'package:get/get.dart';

class RegisterRepository extends BaseRepository {
  final ApiServices apiClient;

  RegisterRepository({required this.apiClient});

  Future<RegisterResponse> register(RegisterRequest request) async {
    try {
      debugPrint('Register Repository: Sending register request to API');
      debugPrint('Register Repository: Request data = ${request.toJson()}');

      final res = await apiClient.post(
        ApiEndpoints.register,
        data: request.toJson(),
      );

      debugPrint('Register Repository: API response received');
      debugPrint('Register Repository: Response status = ${res.statusCode}');
      debugPrint('Register Repository: Response headers = ${res.headers}');
      debugPrint(
          'Register Repository: Response data type = ${res.data.runtimeType}');
      debugPrint('Register Repository: Response data = ${res.data}');

      // Additional validation of response structure
      if (res.data is Map<String, dynamic>) {
        final data = res.data as Map<String, dynamic>;
        debugPrint(
            'Register Repository: Response keys = ${data.keys.toList()}');
      } else {
        debugPrint(
            'Register Repository: WARNING - Response data is not a Map!');
      }

      final registerResponse = RegisterResponse.fromJson(res.data);
      debugPrint(
          'Register Repository: Parsed RegisterResponse = $registerResponse');
      debugPrint(
          'Register Repository: Returning RegisterResponse = $registerResponse');

      return registerResponse;
    } on DioException catch (e) {
      debugPrint('Register Repository: DioException occurred - $e');
      throw handleError(e);
    } catch (e) {
      debugPrint('Register Repository: Unknown error occurred - $e');
      throw ErrorResponse(message: 'unknown_error'.tr);
    }
  }

  Future<CompleteProfileResponse> completeProfile(
      CompleteProfileRequest request) async {
    try {
      debugPrint(
          'Register Repository: Sending complete profile request to API');
      debugPrint('Register Repository: Request data = ${request.toJson()}');

      final res = await apiClient.post(
        ApiEndpoints.completeProfile,
        data: request.toJson(),
      );

      debugPrint('Register Repository: Complete profile API response received');
      debugPrint('Register Repository: Response status = ${res.statusCode}');
      debugPrint('Register Repository: Response data = ${res.data}');

      // Handle error responses that come as successful HTTP responses
      if (res.data is Map<String, dynamic> &&
          res.data['statusCode'] == 400 &&
          (res.data['message'] != null || res.data['error'] != null)) {
        return CompleteProfileResponse(
          statusCode: res.data['statusCode'],
          message: res.data['message'] ?? res.data['error'],
          data: null,
        );
      }

      final completeProfileResponse =
          CompleteProfileResponse.fromJson(res.data);
      debugPrint(
          'Register Repository: Parsed CompleteProfileResponse = $completeProfileResponse');

      return completeProfileResponse;
    } on DioException catch (e) {
      debugPrint(
          'Register Repository: Complete profile DioException occurred - $e');
      throw handleError(e);
    } catch (e) {
      debugPrint(
          'Register Repository: Complete profile unknown error occurred - $e');
      throw ErrorResponse(message: 'unknown_error'.tr);
    }
  }
}
