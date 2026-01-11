// lib/repositories/facility_selection_repository.dart
import 'package:flutter_getx_boilerplate/api/api.dart';
import 'package:flutter_getx_boilerplate/models/vaccine_model/healthcare_facility_model.dart';
import 'package:flutter_getx_boilerplate/models/vaccine_model/vaccine_model.dart';
import 'package:flutter_getx_boilerplate/models/vaccine_model/vaccine_schedule.dart';
import 'package:flutter_getx_boilerplate/models/vietnam_address/vietnam_address.dart';
import 'package:flutter_getx_boilerplate/repositories/base_repository.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ScheduleSelectionRepository extends BaseRepository {
  final ApiServices apiClient;

  ScheduleSelectionRepository({required this.apiClient});

  Future<List<DateTime>> getAvailableDates(String facilityId) async {
    final response =
        await apiClient.get('/facilities/$facilityId/available-dates');

    if (response.statusCode == 200) {
      final List<dynamic> data = response.data;
      return data.map((dateString) => DateTime.parse(dateString)).toList();
    } else {
      throw Exception('Failed to load available dates: ${response.statusCode}');
    }
  }

  Future<List<String>> getAvailableTimeSlots(
      String facilityId, DateTime date) async {
    try {
      final dateString = DateFormat('yyyy-MM-dd').format(date);
      final response = await apiClient
          .get('/facilities/$facilityId/available-timeslots?date=$dateString');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((timeSlot) => timeSlot.toString()).toList();
      } else {
        throw Exception(
            'Failed to load available time slots: ${response.statusCode}');
      }
    } catch (e) {
      // Fallback to mock data
      return _getMockAvailableTimeSlots();
    }
  }

  List<String> _getMockAvailableTimeSlots() {
    return [
      '08:00 - 08:30',
      '08:30 - 09:00',
      '09:00 - 09:30',
      '09:30 - 10:00',
      '10:00 - 10:30',
      '14:00 - 14:30',
      '14:30 - 15:00',
      '15:00 - 15:30',
      '15:30 - 16:00',
    ];
  }
}

class VietnamAddressService {
  static const String baseUrl = 'https://provinces.open-api.vn/api';

  static Future<List<VietnamProvince>> getProvinces() async {
    final response = await http.get(Uri.parse('$baseUrl/?depth=1'));
    if (response.statusCode == 200) {
      // Ensure UTF-8 decoding
      final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
      return data.map((json) => VietnamProvince.fromJson(json)).toList();
    }
    throw Exception('Failed to load provinces');
  }

  static Future<List<VietnamDistrict>> getDistricts(String provinceCode) async {
    final response =
        await http.get(Uri.parse('$baseUrl/p/$provinceCode?depth=2'));
    if (response.statusCode == 200) {
      // Ensure UTF-8 decoding
      final data = json.decode(utf8.decode(response.bodyBytes));
      final districts = data['districts'] as List<dynamic>;
      return districts.map((json) => VietnamDistrict.fromJson(json)).toList();
    }
    throw Exception('Failed to load districts');
  }

  static Future<List<VietnamWard>> getWards(String districtCode) async {
    final response =
        await http.get(Uri.parse('$baseUrl/d/$districtCode?depth=2'));
    if (response.statusCode == 200) {
      // Ensure UTF-8 decoding
      final data = json.decode(utf8.decode(response.bodyBytes));
      final wards = data['wards'] as List<dynamic>;
      return wards.map((json) => VietnamWard.fromJson(json)).toList();
    }
    throw Exception('Failed to load wards');
  }

  Future<List<DateTime>> getAvailableDates(String facilityId) async {
    // Trong môi trường thực tế, bạn sẽ gọi API ở đây
    // return await apiClient.getAvailableDates(facilityId);

    // Sử dụng mock data cho mục đích phát triển
    return ScheduleMockData.mockGetAvailableDates(facilityId);
  }

  Future<List<String>> getAvailableTimeSlots(
      String facilityId, DateTime date) async {
    // Trong môi trường thực tế, bạn sẽ gọi API ở đây
    // return await apiClient.getAvailableTimeSlots(facilityId, date);

    // Sử dụng mock data cho mục đích phát triển
    return ScheduleMockData.mockGetAvailableTimeSlots(facilityId, date);
  }
}

class ScheduleMockData {
  // Mock vaccine data
  static VaccineModel get mockVaccine => VaccineModel(
        id: 'vac_001',
        name: 'Vắc xin Pfizer-BioNTech (Comirnaty)',
        numberOfDoses: 2,
        description: 'Vắc xin mRNA phòng COVID-19, hiệu quả 95%',
        manufacturer: 'Pfizer, BioNTech',
        schedule: [
          const VaccineSchedule(
            doseNumber: 2,
            timeInterval: '3 tuần',
          ),
        ],
        // contraindications: [
        //   'Dị ứng với bất kỳ thành phần nào của vắc xin',
        //   'Phản ứng dị ứng nghiêm trọng với liều vắc xin COVID-19 trước đó'
        // ],
        sideEffects: [
          'Đau, sưng, đỏ tại chỗ tiêm',
          'Mệt mỏi, đau đầu',
          'Đau cơ, ớn lạnh',
          'Sốt nhẹ'
        ],
        prevention: [],
        recommendedAge: '',
        price: 1,
      );

  // Mock healthcare facility data
  static HealthcareFacility get mockFacility => HealthcareFacility(
        id: 'fac_001',
        name: 'Trung tâm Y tế Quận 1',
        address: '123 Đường Nguyễn Huệ, Quận 1, TP.HCM',
        phone: '(028) 3822 1234',
        distance: 2.5,
        rating: 4.7,
        hours: '',
        image: '',
        capacity: 100,
      );

  // Mock available dates
  static List<DateTime> get mockAvailableDates {
    final now = DateTime.now();
    return [
      now.add(const Duration(days: 1)),
      now.add(const Duration(days: 2)),
      now.add(const Duration(days: 3)),
      now.add(const Duration(days: 5)),
      now.add(const Duration(days: 6)),
      now.add(const Duration(days: 7)),
      now.add(const Duration(days: 8)),
      now.add(const Duration(days: 9)),
      now.add(const Duration(days: 10)),
    ];
  }

  // Mock available time slots
  static List<String> get mockTimeSlots => [
        '07:00 - 07:30',
        '07:30 - 08:00',
        '08:00 - 08:30',
        '08:30 - 09:00',
        '09:00 - 09:30',
        '14:00 - 14:30',
        '14:30 - 15:00',
        '15:00 - 15:30',
        '15:30 - 16:00',
        '16:00 - 16:30',
      ];

  // Mock repository responses
  static Future<List<DateTime>> mockGetAvailableDates(String facilityId) async {
    await Future.delayed(
        const Duration(milliseconds: 500)); // Simulate network delay
    return mockAvailableDates;
  }

  static Future<List<String>> mockGetAvailableTimeSlots(
      String facilityId, DateTime date) async {
    await Future.delayed(
        const Duration(milliseconds: 300)); // Simulate network delay
    return mockTimeSlots;
  }
}
