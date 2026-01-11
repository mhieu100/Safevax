import 'package:dio/dio.dart';
import 'package:flutter_getx_boilerplate/api/api.dart';
import 'package:flutter_getx_boilerplate/models/response/error/error_response.dart';
import 'package:flutter_getx_boilerplate/models/response/featured_news_response.dart';
import 'package:flutter_getx_boilerplate/models/response/news_response.dart';
import 'package:flutter_getx_boilerplate/repositories/base_repository.dart';
import 'package:get/get.dart';

class MedicalNewsRepository extends BaseRepository {
  final ApiServices apiClient;

  MedicalNewsRepository({required this.apiClient});

  Future<FeaturedNewsResponse> getFeaturedNews() async {
    try {
      final res = await apiClient.get(
        ApiEndpoints.featuredNews,
      );

      return FeaturedNewsResponse.fromJson(res.data);
    } on DioException catch (e) {
      throw handleError(e);
    } catch (e) {
      throw ErrorResponse(message: 'unknown_error'.tr);
    }
  }

  Future<NewsResponse> getNews({
    int page = 1,
    int limit = 10,
    String? sortBy,
    String? sortOrder,
    String? category,
    String? search,
  }) async {
    try {
      final queryParameters = <String, dynamic>{
        'page': page,
        'limit': limit,
      };

      if (sortBy != null) queryParameters['sortBy'] = sortBy;
      if (sortOrder != null) queryParameters['sortOrder'] = sortOrder;
      if (category != null) queryParameters['category'] = category;
      if (search != null) queryParameters['search'] = search;

      final res = await apiClient.get(
        ApiEndpoints.news,
        queryParameters: queryParameters,
      );

      return NewsResponse.fromJson(res.data);
    } on DioException catch (e) {
      throw handleError(e);
    } catch (e) {
      throw ErrorResponse(message: 'unknown_error'.tr);
    }
  }
}
