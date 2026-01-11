import 'dart:async';
import 'dart:developer';

import 'package:flutter_getx_boilerplate/modules/base/base_controller.dart';
import 'package:flutter_getx_boilerplate/models/models.dart';
import 'package:flutter_getx_boilerplate/repositories/family_management_repository.dart';
import 'package:get/get.dart';

class FamilyManangementController
    extends BaseController<FamilyManangementRepository> {
  FamilyManangementController(super.repository);

  var familyMembers = <FamilyMember>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadFamilyMembers();
  }

  Future<void> loadFamilyMembers() async {
    try {
      log('FamilyManagement: Loading family members...');
      setLoading(true);
      final members = await repository.getFamilyMembers().timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          throw TimeoutException('Request timed out');
        },
      );
      log('FamilyManagement: Loaded ${members.length} family members successfully');
      familyMembers.value = members;
    } catch (e) {
      log('FamilyManagement: Failed to load family members - $e');
      // Show empty list if API fails or times out
      familyMembers.value = [];
    } finally {
      setLoading(false);
    }
  }

  Future<void> addFamilyMember(FamilyMember member) async {
    try {
      log('FamilyManagement: Adding family member - ${member.name}');
      setLoading(true);
      final addedMember = await repository.addFamilyMember(member).timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          throw TimeoutException('Request timed out');
        },
      );
      log('FamilyManagement: Added family member successfully - ID: ${addedMember.id}');
      familyMembers.add(addedMember);
    } catch (e) {
      log('FamilyManagement: Failed to add family member - $e');
      // For now, just add locally if API fails or times out
      familyMembers.add(member);
    } finally {
      setLoading(false);
    }
  }

  Future<void> updateFamilyMember(String id, FamilyMember member) async {
    try {
      log('FamilyManagement: Updating family member - ID: $id, Name: ${member.name}');
      setLoading(true);
      final updatedMember =
          await repository.updateFamilyMember(id, member).timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          throw TimeoutException('Request timed out');
        },
      );
      log('FamilyManagement: Updated family member successfully - ID: $id');
      final index = familyMembers.indexWhere((m) =>
          m.id?.toString() == id ||
          m.name == member.name); // Use ID if available
      if (index != -1) {
        familyMembers[index] = updatedMember;
      }
    } catch (e) {
      log('FamilyManagement: Failed to update family member - $e');
      // Handle error
    } finally {
      setLoading(false);
    }
  }

  Future<void> deleteFamilyMember(String id) async {
    try {
      log('FamilyManagement: Deleting family member - ID: $id');
      setLoading(true);
      await repository.deleteFamilyMember(id).timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          throw TimeoutException('Request timed out');
        },
      );
      log('FamilyManagement: Deleted family member successfully - ID: $id');
      familyMembers.removeWhere(
          (m) => m.id?.toString() == id || m.name == id); // Use ID if available
    } catch (e) {
      log('FamilyManagement: Failed to delete family member - $e');
      // Handle error
    } finally {
      setLoading(false);
    }
  }
}
