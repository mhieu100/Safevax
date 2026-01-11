import 'package:dio/dio.dart';
import 'package:flutter_getx_boilerplate/api/api.dart';
import 'package:flutter_getx_boilerplate/models/models.dart';
import 'package:flutter_getx_boilerplate/models/request/update_account_request.dart';
import 'package:flutter_getx_boilerplate/models/request/update_password_request.dart';
import 'package:flutter_getx_boilerplate/models/response/error/error_response.dart';
import 'package:flutter_getx_boilerplate/models/response/update_profile_response.dart';
import 'package:flutter_getx_boilerplate/models/response/account_response.dart';
import 'package:flutter_getx_boilerplate/repositories/base_repository.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart';

class AuthRepository extends BaseRepository {
  final ApiServices apiClient;

  AuthRepository({required this.apiClient});

  Future<LoginResponse> login(LoginRequest request) async {
    try {
      final res = await apiClient.post(
        ApiEndpoints.login,
        data: request.toJson(),
      );
      debugPrint("Nội dung log rất dài...");

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

      // API response format: {error, message, statusCode, data: userObject}
      return User.fromJson(res.data['data']);
    } on DioException catch (e) {
      throw handleError(e);
    } catch (e) {
      throw ErrorResponse(message: 'unknown_error'.tr);
    }
  }

  Future<AccountResponse> getAccount() async {
    try {
      final res = await apiClient.get(
        ApiEndpoints.account,
      );

      if (res.data['data'] == null) {
        throw ErrorResponse(message: 'Account data is null');
      }

      return AccountResponse.fromJson(res.data);
    } on DioException catch (e) {
      throw handleError(e);
    } catch (e) {
      throw ErrorResponse(message: 'unknown_error'.tr);
    }
  }

  Future<RefreshTokenResponse> refreshToken(RefreshTokenRequest request) async {
    try {
      final res = await apiClient.post(
        ApiEndpoints.refresh,
        data: request.toJson(),
      );

      return RefreshTokenResponse.fromJson(res.data);
    } on DioException catch (e) {
      throw handleError(e);
    } catch (e) {
      throw ErrorResponse(message: 'unknown_error'.tr);
    }
  }

  Future<void> logout() async {
    try {
      await apiClient.post(
        ApiEndpoints.logout,
      );
    } on DioException catch (e) {
      throw handleError(e);
    } catch (e) {
      throw ErrorResponse(message: 'unknown_error'.tr);
    }
  }

  Future<User> updateAccount(UpdateAccountRequest request) async {
    try {
      final res = await apiClient.put(
        ApiEndpoints.updateAccount,
        data: request.toJson(),
      );

      // API response format: {statusCode, message, data: userObject}
      final response = UpdateProfileResponse.fromJson(res.data);
      return response.data!;
    } on DioException catch (e) {
      throw handleError(e);
    } catch (e) {
      throw ErrorResponse(message: 'unknown_error'.tr);
    }
  }

  Future<void> updatePassword(UpdatePasswordRequest request) async {
    try {
      await apiClient.post(
        ApiEndpoints.updatePassword,
        data: request.toJson(),
      );
    } on DioException catch (e) {
      throw handleError(e);
    } catch (e) {
      throw ErrorResponse(message: 'unknown_error'.tr);
    }
  }
}
