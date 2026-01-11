// lib/repositories/facility_map_repository.dart
import 'package:flutter_getx_boilerplate/api/api.dart';
import 'package:flutter_getx_boilerplate/models/vaccine_model/healthcare_facility_model.dart';
import 'package:flutter_getx_boilerplate/repositories/base_repository.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class FacilityMapRepository extends BaseRepository {
  final ApiServices apiClient;

  FacilityMapRepository({required this.apiClient});

  Future<List<HealthcareFacility>> getHealthcareFacilities() async {
    try {
      final response = await apiClient.get('/centers?page=1&size=10');

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['statusCode'] == 200 && data['data'] != null) {
          final List<dynamic> result = data['data']['result'];
          final facilities =
              result.map((json) => HealthcareFacility.fromJson(json)).toList();
          // Geocode facilities without coordinates
          for (var facility in facilities) {
            if (facility.latitude == null && facility.longitude == null) {
              print('Geocoding address: ${facility.address}');
              final coords = await _geocodeAddress(facility.address);
              if (coords != null) {
                facility.latitude = coords['lat'];
                facility.longitude = coords['lng'];
                print(
                    'Geocoding successful for ${facility.name}: ${coords['lat']}, ${coords['lng']}');
              } else {
                // Fallback to mock coordinates based on address
                final mockCoords =
                    _getMockCoordinatesForAddress(facility.address);
                if (mockCoords != null) {
                  facility.latitude = mockCoords['lat'];
                  facility.longitude = mockCoords['lng'];
                  print(
                      'Using mock coordinates for ${facility.name}: ${mockCoords['lat']}, ${mockCoords['lng']}');
                } else {
                  print('No coordinates found for ${facility.name}');
                }
              }
            } else {
              print(
                  'Facility ${facility.name} already has coordinates: ${facility.latitude}, ${facility.longitude}');
            }
          }
          return facilities;
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

  // Mock data with coordinates for Ho Chi Minh City
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

  Future<Map<String, double>?> _geocodeAddress(String address) async {
    try {
      final apiKey = dotenv.env['GOOGLE_MAPS_API_KEY'] ?? '';
      if (apiKey.isEmpty) {
        print('Google Maps API key not found');
        return null;
      }
      final encodedAddress = Uri.encodeComponent(address);
      final url =
          'https://maps.googleapis.com/maps/api/geocode/json?address=$encodedAddress&key=$apiKey';

      print('Geocoding URL: $url');
      final response = await http.get(Uri.parse(url));
      print('Geocoding response status: ${response.statusCode}');
      print('Geocoding response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('Geocoding API status: ${data['status']}');
        if (data['status'] == 'OK' && data['results'].isNotEmpty) {
          final location = data['results'][0]['geometry']['location'];
          print(
              'Geocoding success: lat=${location['lat']}, lng=${location['lng']}');
          return {
            'lat': location['lat'].toDouble(),
            'lng': location['lng'].toDouble(),
          };
        } else {
          print('Geocoding failed with status: ${data['status']}');
          if (data['error_message'] != null) {
            print('Error message: ${data['error_message']}');
          }
        }
      } else {
        print('HTTP error: ${response.statusCode}');
      }
      print('Geocoding failed for address: $address');
      return null;
    } catch (e) {
      print('Error geocoding address: $e');
      return null;
    }
  }

  Map<String, double>? _getMockCoordinatesForAddress(String address) {
    // Mock coordinates for known addresses (Ho Chi Minh City)
    final mockCoords = {
      '1 Quang Trung, P. 10, Q. Gò Vấp, TP.HCM': {
        'lat': 10.8230,
        'lng': 106.6908
      },
      '198 Hoàng Văn Thụ, P. 9, Q. Phú Nhuận, TP.HCM': {
        'lat': 10.7978,
        'lng': 106.6750
      },
      'Lô F1-01, 19 Đ. số 1, Tân Phong, Q. 7, TP.HCM': {
        'lat': 10.7340,
        'lng': 106.7218
      },
      '240 Võ Văn Ngân, P. Bình Thọ, TP. Thủ Đức, TP.HCM': {
        'lat': 10.8496,
        'lng': 106.7717
      },
      '12 Trường Chinh, P. 4, Q. Tân Bình, TP.HCM': {
        'lat': 10.7967,
        'lng': 106.6581
      },
      // Da Nang facilities coordinates
      '432-434-436 Cách Mạng Tháng 8, P. Hòa Thọ Đông, Q. Cẩm Lệ, TP. Đà Nẵng':
          {'lat': 16.0544, 'lng': 108.2022},
      '161 Âu Cơ, P. Hòa Khánh Bắc, Q. Liên Chiểu, TP. Đà Nẵng': {
        'lat': 16.0738,
        'lng': 108.1494
      },
      '28-30 Mê Linh, P. Hải Vân, TP. Đà Nẵng': {
        'lat': 16.0678,
        'lng': 108.2208
      },
      '367 Lê Văn Hiến, P. Ngũ Hành Sơn, TP. Đà Nẵng': {
        'lat': 16.0056,
        'lng': 108.2494
      },
      '369 Điện Biên Phủ, P. Thanh Khê, TP. Đà Nẵng': {
        'lat': 16.0644,
        'lng': 108.1694
      },
    };

    return mockCoords[address];
  }
}
