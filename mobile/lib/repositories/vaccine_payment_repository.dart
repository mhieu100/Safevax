import 'package:dio/dio.dart';
import 'package:flutter_getx_boilerplate/api/api.dart';
import 'package:flutter_getx_boilerplate/models/models.dart';
import 'package:flutter_getx_boilerplate/models/response/error/error_response.dart';
import 'package:flutter_getx_boilerplate/repositories/base_repository.dart';
import 'package:get/get.dart';

class VaccinePaymentRepository extends BaseRepository {
  final ApiServices apiClient;

  VaccinePaymentRepository({required this.apiClient});

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
  Future<void> connectEWallet() async {
    // print("Connecting to e-wallet...");
  }

  Future<void> bankTransfer() async {
    // print("Fetching bank transfer details...");
  }

  Future<void> makePayment() async {
    // print("Processing vaccine payment...");
  }
}
