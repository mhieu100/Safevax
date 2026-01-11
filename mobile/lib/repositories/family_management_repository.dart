import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_getx_boilerplate/api/api.dart';
import 'package:flutter_getx_boilerplate/models/models.dart';
import 'package:flutter_getx_boilerplate/models/response/booking_history_grouped_response.dart';
import 'package:flutter_getx_boilerplate/models/response/error/error_response.dart';
import 'package:flutter_getx_boilerplate/repositories/base_repository.dart';
import 'package:get/get.dart';

class FamilyManangementRepository extends BaseRepository {
  final ApiServices apiClient;

  FamilyManangementRepository({required this.apiClient});

  Future<List<FamilyMember>> getFamilyMembers() async {
    try {
      log('FamilyManagementRepository: Fetching family members from ${ApiEndpoints.familyMembers}?page=1&size=10');
      final res = await apiClient.get(
        '${ApiEndpoints.familyMembers}?page=1&size=10',
      );

      // log('FamilyManagementRepository: API Response - ${res.data}'); // Commented out to reduce log noise

      // Handle the API response structure with meta and result
      if (res.data != null && res.data['data'] != null) {
        final data = res.data['data'];
        if (data['result'] != null) {
          final members = (data['result'] as List)
              .map((json) => FamilyMember.fromJson(json))
              .toList();
          log('FamilyManagementRepository: Successfully parsed ${members.length} family members');
          return members;
        }
      }

      log('FamilyManagementRepository: No data found in response');
      return [];
    } on DioException catch (e) {
      log('FamilyManagementRepository: DioException - ${e.message}');
      throw handleError(e);
    } catch (e) {
      log('FamilyManagementRepository: Unknown error - $e');
      throw ErrorResponse(message: 'unknown_error'.tr);
    }
  }

  Future<FamilyMember> addFamilyMember(FamilyMember member) async {
    try {
      log('FamilyManagementRepository: Adding family member - Name: ${member.name}, DOB: ${member.dob}, Relation: ${member.relation}, Gender: ${member.gender}');
      final res = await apiClient.post(
        ApiEndpoints.familyMembers,
        data: {
          'fullName': member.name,
          'dateOfBirth': member.dob,
          'relationship': member.relation,
          'gender': member.gender,
          'phone': member.phone,
          'identityNumber': member.identityNumber,
        },
      );

      // log('FamilyManagementRepository: Add API Response - ${res.data}'); // Commented out to reduce log noise

      // Handle the API response structure
      if (res.data != null && res.data['data'] != null) {
        final addedMember = FamilyMember.fromJson(res.data['data']);
        log('FamilyManagementRepository: Successfully added family member with ID: ${addedMember.id}');
        return addedMember;
      }

      log('FamilyManagementRepository: No data in add response, using fallback');
      return member; // Fallback
    } on DioException catch (e) {
      log('FamilyManagementRepository: DioException while adding family member - ${e.message}');
      throw handleError(e);
    } catch (e) {
      log('FamilyManagementRepository: Unknown error while adding family member - $e');
      throw ErrorResponse(message: 'unknown_error'.tr);
    }
  }

  Future<FamilyMember> updateFamilyMember(
      String id, FamilyMember member) async {
    try {
      log('FamilyManagementRepository: Updating family member - ID: $id, Name: ${member.name}');
      final res = await apiClient.put(
        ApiEndpoints.familyMembers,
        data: {
          'id': id,
          'fullName': member.name,
          'dateOfBirth': member.dob,
          'relationship': member.relation,
          'gender': member.gender,
          'phone': member.phone,
          'identityNumber': member.identityNumber,
        },
      );

      // log('FamilyManagementRepository: Update API Response - ${res.data}'); // Commented out to reduce log noise

      if (res.data != null && res.data['data'] != null) {
        final updatedMember = FamilyMember.fromJson(res.data['data']);
        log('FamilyManagementRepository: Successfully updated family member - ID: $id');
        return updatedMember;
      }

      return member; // Fallback
    } on DioException catch (e) {
      log('FamilyManagementRepository: DioException while updating family member - ${e.message}');
      throw handleError(e);
    } catch (e) {
      log('FamilyManagementRepository: Unknown error while updating family member - $e');
      throw ErrorResponse(message: 'unknown_error'.tr);
    }
  }

  Future<void> deleteFamilyMember(String id) async {
    try {
      log('FamilyManagementRepository: Deleting family member - ID: $id');
      await apiClient.delete(
        '${ApiEndpoints.familyMembers}/$id',
      );
      log('FamilyManagementRepository: Successfully deleted family member - ID: $id');
    } on DioException catch (e) {
      log('FamilyManagementRepository: DioException while deleting family member - ${e.message}');
      throw handleError(e);
    } catch (e) {
      log('FamilyManagementRepository: Unknown error while deleting family member - $e');
      throw ErrorResponse(message: 'unknown_error'.tr);
    }
  }

  Future<Map<String, dynamic>> getFamilyMemberDetail(int id) async {
    try {
      log('FamilyManagementRepository: Fetching family member detail - ID: $id');
      final res = await apiClient.post(
        '${ApiEndpoints.familyMembers}/detail',
        data: {'id': id},
      );

      if (res.data != null && res.data['data'] != null) {
        log('FamilyManagementRepository: Successfully fetched family member detail - ID: $id');
        return res.data['data'];
      }

      log('FamilyManagementRepository: No data found in detail response');
      return {};
    } on DioException catch (e) {
      log('FamilyManagementRepository: DioException while fetching family member detail - ${e.message}');
      throw handleError(e);
    } catch (e) {
      log('FamilyManagementRepository: Unknown error while fetching family member detail - $e');
      throw ErrorResponse(message: 'unknown_error'.tr);
    }
  }

  Future<List<GroupedBookingData>> getFamilyMemberBookingHistoryGrouped(
      int id) async {
    try {
      log('FamilyManagementRepository: Fetching family member booking history grouped - ID: $id');
      final res = await apiClient.post(
        '${ApiEndpoints.familyMembers}/booking-history-grouped',
        data: {'id': id},
      );

      if (res.data != null && res.data['data'] != null) {
        final data = res.data['data'] as List;
        final groupedBookings =
            data.map((json) => GroupedBookingData.fromJson(json)).toList();
        log('FamilyManagementRepository: Successfully fetched ${groupedBookings.length} booking history groups for family member - ID: $id');
        return groupedBookings;
      }

      log('FamilyManagementRepository: No data found in booking history grouped response');
      return [];
    } on DioException catch (e) {
      log('FamilyManagementRepository: DioException while fetching family member booking history grouped - ${e.message}');
      throw handleError(e);
    } catch (e) {
      log('FamilyManagementRepository: Unknown error while fetching family member booking history grouped - $e');
      throw ErrorResponse(message: 'unknown_error'.tr);
    }
  }
}
