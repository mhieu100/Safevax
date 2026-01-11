import 'package:dio/dio.dart' as dio;
import 'package:flutter_getx_boilerplate/api/api.dart';
import 'package:flutter_getx_boilerplate/models/models.dart';
import 'package:flutter_getx_boilerplate/models/response/error/error_response.dart';
import 'package:flutter_getx_boilerplate/models/response/file_upload_response.dart';
import 'package:flutter_getx_boilerplate/repositories/base_repository.dart';
import 'package:flutter_getx_boilerplate/shared/services/storage_service.dart';
import 'package:get/get.dart';

class ProfileRepository extends BaseRepository {
  final ApiServices apiClient;

  ProfileRepository({required this.apiClient});

  Future<LoginResponse> login(LoginRequest request) async {
    try {
      final res = await apiClient.post(
        ApiEndpoints.login,
        data: request.toJson(),
      );

      return LoginResponse.fromJson(res.data);
    } on dio.DioException catch (e) {
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
    } on dio.DioException catch (e) {
      throw handleError(e);
    } catch (e) {
      throw ErrorResponse(message: 'unknown_error'.tr);
    }
  }

  Future<FileUploadResponse> uploadAvatar(Object formData) async {
    try {
      // Create a separate Dio instance for file uploads (no baseUrl)
      final dioClient = dio.Dio(dio.BaseOptions(
        connectTimeout: const Duration(seconds: 120),
        receiveTimeout: const Duration(seconds: 120),
      ));

      // Add authorization header manually
      final token = StorageService.token;
      final headers = <String, dynamic>{};
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }

      final res = await dioClient.post(
        'https://backend.mhieu100.space/files',
        data: formData,
        options: dio.Options(headers: headers),
      );

      return FileUploadResponse.fromJson(res.data);
    } on dio.DioException catch (e) {
      throw handleError(e);
    } catch (e) {
      throw ErrorResponse(message: 'unknown_error'.tr);
    }
  }

  Future<void> updateAvatar(String avatarUrl) async {
    try {
      await apiClient.put(
        ApiEndpoints.updateAvatar,
        data: {'avatarUrl': avatarUrl},
      );
    } on dio.DioException catch (e) {
      throw handleError(e);
    } catch (e) {
      throw ErrorResponse(message: 'unknown_error'.tr);
    }
  }
}
