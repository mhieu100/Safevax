import 'package:dio/dio.dart';
import 'package:flutter_getx_boilerplate/api/api.dart';
import 'package:flutter_getx_boilerplate/models/response/booking_history_grouped_response.dart';
import 'package:flutter_getx_boilerplate/models/response/error/error_response.dart';
import 'package:flutter_getx_boilerplate/repositories/base_repository.dart';
import 'package:get/get.dart';

class VaccinationHistoryRepository extends BaseRepository {
  final ApiServices apiClient;

  VaccinationHistoryRepository({required this.apiClient});

  Future<BookingHistoryGroupedResponse> getBookingHistory() async {
    try {
      final res = await apiClient.get('/auth/booking-history-grouped');
      return BookingHistoryGroupedResponse.fromJson(res.data);
    } on DioException catch (e) {
      throw handleError(e);
    } catch (e) {
      throw ErrorResponse(message: 'unknown_error'.tr);
    }
  }
}
