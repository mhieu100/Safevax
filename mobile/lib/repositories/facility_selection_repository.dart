// lib/repositories/facility__repository.dart
import 'package:flutter_getx_boilerplate/api/api.dart';
import 'package:flutter_getx_boilerplate/models/vaccine_model/healthcare_facility_model.dart';
import 'package:flutter_getx_boilerplate/repositories/base_repository.dart';

class FacilitySelectionRepository extends BaseRepository {
  final ApiServices apiClient;

  FacilitySelectionRepository({required this.apiClient});

  Future<List<HealthcareFacility>> getHealthcareFacilities() async {
    try {
      final response = await apiClient.get('/centers?page=1&size=10');

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['statusCode'] == 200 && data['data'] != null) {
          final List<dynamic> result = data['data']['result'];
          return result
              .map((json) => HealthcareFacility.fromJson(json))
              .toList();
        } else {
          throw Exception('Invalid response format');
        }
      } else {
        throw Exception(
            'Failed to load healthcare facilities: ${response.statusCode}');
      }
    } catch (e) {
      // Fallback to mock data if API fails
      return _getMockHealthcareFacilities();
    }
  }

  Future<List<HealthcareFacility>> searchHealthcareFacilities(
      String query, String vaccineId) async {
    try {
      final response =
          await apiClient.get('/vaccines/$vaccineId/facilities?search=$query');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => HealthcareFacility.fromJson(json)).toList();
      } else {
        throw Exception(
            'Failed to search healthcare facilities: ${response.statusCode}');
      }
    } catch (e) {
      // Fallback to filtered mock data if API fails
      final facilities = _getMockHealthcareFacilities();
      return facilities.where((facility) {
        return facility.name.toLowerCase().contains(query.toLowerCase()) ||
            facility.address.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
  }

  // lib/repositories/facility__repository.dart
  // Cập nhật mock data với địa chỉ Việt Nam thực tế
  List<HealthcareFacility> _getMockHealthcareFacilities() {
    return [
      HealthcareFacility(
        id: '1',
        name: 'VNVC Hoàng Văn Thụ',
        address: '198 Hoàng Văn Thụ, P. 9, Q. Phú Nhuận, TP.HCM',
        phone: '02871026595',
        hours: '07:30 - 17:00',
        image: 'https_example.com/images/center1.png',
        capacity: 100,
        distance: 2.5,
        rating: 4.8,
        latitude: 10.7978,
        longitude: 106.6750,
      ),
      HealthcareFacility(
        id: '2',
        name: 'VNVC Trường Chinh',
        address: '12 Trường Chinh, P. 4, Q. Tân Bình, TP.HCM',
        phone: '02871026596',
        hours: '07:30 - 17:00',
        image: 'https_example.com/images/center2.png',
        capacity: 120,
        distance: 4.2,
        rating: 4.5,
        latitude: 10.7967,
        longitude: 106.6581,
      ),
      HealthcareFacility(
        id: '3',
        name: 'VNVC Quận 7',
        address: 'Lô F1-01, 19 Đ. số 1, Tân Phong, Q. 7, TP.HCM',
        phone: '02871026597',
        hours: '08:00 - 17:00',
        image: 'https_example.com/images/center3.png',
        capacity: 80,
        distance: 3.8,
        rating: 4.7,
        latitude: 10.7340,
        longitude: 106.7218,
      ),
      HealthcareFacility(
        id: '4',
        name: 'VNVC Gò Vấp',
        address: '1 Quang Trung, P. 10, Q. Gò Vấp, TP.HCM',
        phone: '02871026598',
        hours: '07:30 - 17:00',
        image: 'https_example.com/images/center4.png',
        capacity: 90,
        distance: 1.2,
        rating: 4.9,
        latitude: 10.8230,
        longitude: 106.6908,
      ),
      HealthcareFacility(
        id: '5',
        name: 'VNVC Thủ Đức',
        address: '240 Võ Văn Ngân, P. Bình Thọ, TP. Thủ Đức, TP.HCM',
        phone: '02871026599',
        hours: '07:30 - 17:00',
        image: 'https_example.com/images/center5.png',
        capacity: 110,
        distance: 2.8,
        rating: 4.6,
        latitude: 10.8496,
        longitude: 106.7717,
      ),
    ];
  }
}
