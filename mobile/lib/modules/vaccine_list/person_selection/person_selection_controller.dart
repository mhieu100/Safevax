import 'dart:async';
import 'dart:developer';

import 'package:flutter_getx_boilerplate/models/family_member.dart';
import 'package:flutter_getx_boilerplate/modules/base/base_controller.dart';
import 'package:flutter_getx_boilerplate/repositories/family_management_repository.dart';
import 'package:flutter_getx_boilerplate/shared/services/storage_service.dart';
import 'package:get/get.dart';

class Person {
  final String id;
  final String name;
  final String relation;
  final String avatar;
  final String phone;
  final String email;
  final String dob;
  final String? gender;
  final bool isCurrentUser;

  Person({
    required this.id,
    required this.name,
    required this.relation,
    required this.avatar,
    required this.phone,
    required this.email,
    required this.dob,
    this.gender,
    this.isCurrentUser = false,
  });

  factory Person.fromFamilyMember(FamilyMember member,
      {bool isCurrentUser = false}) {
    return Person(
      id: isCurrentUser
          ? 'current_user'
          : member.id?.toString() ?? member.name.hashCode.toString(),
      name: member.name,
      relation: member.relation,
      avatar: member.avatar,
      phone: member.phone ?? '', // Use actual phone if available
      email: '', // No email field needed
      dob: member.dob,
      gender: member.gender,
      isCurrentUser: isCurrentUser,
    );
  }
}

class PersonSelectionController
    extends BaseController<FamilyManangementRepository> {
  PersonSelectionController(super.repository);

  final RxList<Person> persons = <Person>[].obs;
  final Rx<Person?> selectedPerson = Rx<Person?>(null);

  @override
  void onInit() {
    super.onInit();
    loadPersons();
  }

  Future<void> loadPersons() async {
    try {
      log('PersonSelection: Loading persons...');
      setLoading(true);

      // Load current user from storage
      final userData = StorageService.userData;
      final currentUser = Person(
        id: 'current_user',
        name: userData?['fullName'] ?? 'Người dùng',
        relation: 'Tôi',
        avatar: userData?['avatar'] ?? 'assets/images/circle_avatar.png',
        phone: userData?['phone'] ?? '',
        email: userData?['email'] ?? '',
        dob: userData?['birthday'] ?? '',
        gender: userData?['gender'],
        isCurrentUser: true,
      );

      // Load family members from API
      final familyMembers = await repository.getFamilyMembers().timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          throw TimeoutException('Request timed out');
        },
      );

      log('PersonSelection: Loaded ${familyMembers.length} family members successfully');

      persons.value = [
        currentUser,
        ...familyMembers.map((member) => Person.fromFamilyMember(member)),
      ];

      // Default select current user
      selectedPerson.value = currentUser;
    } catch (e) {
      log('PersonSelection: Failed to load persons - $e');
      // Fallback to basic current user if API fails
      final userData = StorageService.userData;
      final currentUser = Person(
        id: 'current_user',
        name: userData?['fullName'] ?? 'Người dùng',
        relation: 'Tôi',
        avatar: userData?['avatar'] ?? 'assets/images/circle_avatar.png',
        phone: userData?['phone'] ?? '',
        email: userData?['email'] ?? '',
        dob: userData?['birthday'] ?? '',
        gender: userData?['gender'],
        isCurrentUser: true,
      );

      persons.value = [currentUser];
      selectedPerson.value = currentUser;
    } finally {
      setLoading(false);
    }
  }

  void selectPerson(Person person) {
    selectedPerson.value = person;
  }

  // API interface for backend
  Future<List<Person>> fetchPersonsFromAPI() async {
    try {
      log('PersonSelection: Fetching persons from API...');
      setLoading(true);

      final familyMembers = await repository.getFamilyMembers().timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          throw TimeoutException('Request timed out');
        },
      );

      final currentUser = Person(
        id: 'current_user',
        name: 'Người dùng',
        relation: 'Tôi',
        avatar: 'assets/images/circle_avatar.png',
        phone: '',
        email: '',
        dob: '',
        gender: null,
        isCurrentUser: true,
      );

      final personsList = [
        currentUser,
        ...familyMembers.map((member) => Person.fromFamilyMember(member)),
      ];

      log('PersonSelection: Fetched ${personsList.length} persons from API successfully');
      return personsList;
    } catch (e) {
      log('PersonSelection: Failed to fetch persons from API - $e');
      rethrow;
    } finally {
      setLoading(false);
    }
  }

  // Method to add new person (for backend integration)
  Future<void> addPerson(Person person) async {
    try {
      log('PersonSelection: Adding person - ${person.name}');
      setLoading(true);

      // This would be the actual API call to add person
      // For now, just add locally
      persons.add(person);
      log('PersonSelection: Added person successfully');
    } catch (e) {
      log('PersonSelection: Failed to add person - $e');
      rethrow;
    } finally {
      setLoading(false);
    }
  }

  // Method to update person (for backend integration)
  Future<void> updatePerson(String personId, Person updatedPerson) async {
    try {
      log('PersonSelection: Updating person - ID: $personId, Name: ${updatedPerson.name}');
      setLoading(true);

      // This would be the actual API call to update person
      // For now, just update locally
      final index = persons.indexWhere((p) => p.id == personId);
      if (index != -1) {
        persons[index] = updatedPerson;
        log('PersonSelection: Updated person successfully');
      }
    } catch (e) {
      log('PersonSelection: Failed to update person - $e');
      rethrow;
    } finally {
      setLoading(false);
    }
  }

  // Method to delete person (for backend integration)
  Future<void> deletePerson(String personId) async {
    try {
      log('PersonSelection: Deleting person - ID: $personId');
      setLoading(true);

      // This would be the actual API call to delete person
      // For now, just remove locally
      persons.removeWhere((p) => p.id == personId);
      log('PersonSelection: Deleted person successfully');
    } catch (e) {
      log('PersonSelection: Failed to delete person - $e');
      rethrow;
    } finally {
      setLoading(false);
    }
  }
}
