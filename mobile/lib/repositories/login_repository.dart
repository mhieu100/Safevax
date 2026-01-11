import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:flutter_getx_boilerplate/api/api.dart';
import 'package:flutter_getx_boilerplate/models/models.dart';
import 'package:flutter_getx_boilerplate/models/response/error/error_response.dart';
import 'package:flutter_getx_boilerplate/repositories/base_repository.dart';
import 'package:get/get.dart';

class LoginRepository extends BaseRepository {
  final ApiServices apiClient;

  LoginRepository({required this.apiClient});

  Future<LoginResponse> login(LoginRequest request,
      {CancelToken? cancelToken}) async {
    try {
      debugPrint('Login Repository: Sending login request to API');
      debugPrint('Login Repository: Request data = ${request.toJson()}');

      final res = await apiClient.post(
        ApiEndpoints.login,
        data: request.toJson(),
        cancelToken: cancelToken,
      );

      return LoginResponse.fromJson(res.data);
    } on DioException catch (e) {
      throw handleError(e);
    } catch (e) {
      throw ErrorResponse(message: 'unknown_error'.tr);
    }
  }

  Future<LoginResponse> googleLogin(String idToken,
      {CancelToken? cancelToken}) async {
    try {
      final requestData = {'idToken': idToken};
      debugPrint('Google Login Repository: Sending idToken to API');
      debugPrint('Google Login Repository: Request data = $requestData');

      final res = await apiClient.post(
        ApiEndpoints.googleMobileLogin,
        data: requestData,
        cancelToken: cancelToken,
      );

      debugPrint('Google Login Repository: API response received');
      debugPrint(
          'Google Login Repository: Response status = ${res.statusCode}');
      debugPrint('Google Login Repository: Response headers = ${res.headers}');
      debugPrint(
          'Google Login Repository: Response data type = ${res.data.runtimeType}');
      debugPrint('Google Login Repository: Response data = ${res.data}');

      // Additional validation of response structure
      if (res.data is Map<String, dynamic>) {
        final data = res.data as Map<String, dynamic>;
        debugPrint(
            'Google Login Repository: Response keys = ${data.keys.toList()}');
        debugPrint(
            'Google Login Repository: Has accessToken = ${data.containsKey('accessToken')}');
        debugPrint(
            'Google Login Repository: Has user = ${data.containsKey('user')}');
        if (data.containsKey('accessToken')) {
          debugPrint(
              'Google Login Repository: accessToken length = ${data['accessToken']?.toString().length}');
        }
      } else {
        debugPrint(
            'Google Login Repository: WARNING - Response data is not a Map!');
      }

      final loginResponse = LoginResponse.fromJson(res.data);
      debugPrint(
          'Google Login Repository: Parsed LoginResponse = $loginResponse');
      debugPrint(
          'Google Login Repository: LoginResponse.data = ${loginResponse.data}');
      if (loginResponse.data != null) {
        debugPrint(
            'Google Login Repository: LoginData.accessToken = ${loginResponse.data!.accessToken}');
        debugPrint(
            'Google Login Repository: LoginData.user = ${loginResponse.data!.user}');
      }

      debugPrint(
          'Google Login Repository: Returning LoginResponse = $loginResponse');
      return loginResponse;
    } on DioException catch (e) {
      debugPrint('Google Login Repository: DioException occurred - $e');
      throw handleError(e);
    } catch (e) {
      debugPrint('Google Login Repository: Unknown error occurred - $e');
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
}
