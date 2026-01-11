// lib/repositories/vaccine_list_repository.dart
import 'package:flutter_getx_boilerplate/api/api.dart';
import 'package:flutter_getx_boilerplate/models/request/vaccine_list_request.dart';
import 'package:flutter_getx_boilerplate/models/response/vaccine_list_response.dart';
import 'package:flutter_getx_boilerplate/models/vaccine_model/healthcare_facility_model.dart';
import 'package:flutter_getx_boilerplate/models/vaccine_model/vaccine_model.dart';
import 'package:flutter_getx_boilerplate/repositories/base_repository.dart';

class VaccineListRepository extends BaseRepository {
  final ApiServices _apiClient;

  VaccineListRepository({required ApiServices apiClient})
      : _apiClient = apiClient;

  Future<VaccineListResponse> getVaccines({VaccineListRequest? request}) async {
    final queryParams = request?.toQueryParameters() ?? {};
    final response =
        await _apiClient.get('vaccines', queryParameters: queryParams);

    if (response.statusCode == 200) {
      return VaccineListResponse.fromJson(response.data);
    } else {
      throw Exception('Failed to load vaccines: ${response.statusCode}');
    }
  }

  Future<List<String>> getCountries() async {
    final response = await _apiClient.get('vaccines/countries');

    if (response.statusCode == 200) {
      final data = response.data['data'] as List<dynamic>;
      return data.map((country) => country.toString()).toList();
    } else {
      throw Exception('Failed to load countries: ${response.statusCode}');
    }
  }
}
