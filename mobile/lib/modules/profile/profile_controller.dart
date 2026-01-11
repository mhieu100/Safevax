import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_getx_boilerplate/repositories/profile_repository.dart';
import 'package:flutter_getx_boilerplate/modules/base/base_controller.dart';
import 'package:flutter_getx_boilerplate/routes/app_pages.dart';
import 'package:flutter_getx_boilerplate/repositories/auth_repository.dart';
import 'package:flutter_getx_boilerplate/shared/services/storage_service.dart';
import 'package:flutter_getx_boilerplate/modules/edit_profile/edit_profile_controller.dart';
import 'package:flutter_getx_boilerplate/models/response/user/user.dart';
import 'package:flutter_getx_boilerplate/models/request/update_account_request.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart' as dio;

class ProfileController extends BaseController<ProfileRepository> {
  ProfileController(super.repository);

  var username = ''.obs;
  var age = ''.obs;
  var height = ''.obs;
  var weight = ''.obs;
  var avatarUrl = ''.obs;

  // Sync with edit profile controller when profile is updated
  void syncWithEditProfile() {
    final editController = Get.find<EditProfileController>();
    username.value = editController.fullNameController.text;
    height.value = '${editController.heightController.text}cm';
    weight.value = '${editController.weightController.text}kg';
    dateOfBirth.value = editController.dateOfBirthController.text;
  }

  // Calculate age from date of birth
  String _calculateAge(String dateOfBirth) {
    if (dateOfBirth.isEmpty) return '';
    try {
      final birthDate = DateTime.parse(dateOfBirth);
      final now = DateTime.now();
      int age = now.year - birthDate.year;
      if (now.month < birthDate.month ||
          (now.month == birthDate.month && now.day < birthDate.day)) {
        age--;
      }
      return age.toString();
    } catch (e) {
      return '';
    }
  }

  // Additional user profile fields
  var email = ''.obs;
  var phone = ''.obs;
  var dateOfBirth = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Update age when date of birth changes
    ever(dateOfBirth, (_) {
      age.value = _calculateAge(dateOfBirth.value);
    });
  }

  @override
  Future getData() async {
    await _loadUserProfile();
  }

  // Method to refresh profile data (can be called from other controllers)
  Future<void> refreshProfile() async {
    await _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    try {
      setLoading(true);
      final userData = StorageService.userData;
      if (userData != null) {
        final user = User.fromJson(userData);
        username.value = user.fullName ?? '';
        email.value = user.email ?? '';
        phone.value = user.phone ?? '';
        dateOfBirth.value = user.birthday ?? '';
        age.value = _calculateAge(dateOfBirth.value);
        gender.value = user.gender ?? '';
        identityNumber.value = user.identityNumber ?? '';
        bloodType.value = user.bloodType ?? '';
        height.value = user.heightCm != null ? '${user.heightCm}cm' : '';
        weight.value = user.weightKg != null ? '${user.weightKg}kg' : '';
        address.value = user.address ?? '';
        occupation.value = user.occupation ?? '';
        insuranceNumber.value = user.insuranceNumber ?? '';
        lifestyleNotes.value = user.lifestyleNotes ?? '';
        avatarUrl.value = user.avatar ?? '';
        log('Loaded avatar from user data: ${user.avatar}',
            name: 'PROFILE_LOAD');
      } else {
        // Fallback to default values if no user data
        _loadDefaultProfile();
      }
    } catch (e) {
      log('Error loading user profile: $e');
      showError('Error', 'Failed to load user profile');
      _loadDefaultProfile();
    } finally {
      setLoading(false);
    }
  }

  void _loadDefaultProfile() {
    username.value = '';
    email.value = '';
    phone.value = '';
    dateOfBirth.value = '';
    gender.value = '';
    identityNumber.value = '';
    bloodType.value = '';
    height.value = '';
    weight.value = '';
    address.value = '';
    occupation.value = '';
    insuranceNumber.value = '';
    lifestyleNotes.value = '';
    avatarUrl.value = '';
  }

  var gender = ''.obs;
  var identityNumber = ''.obs;
  var bloodType = ''.obs;
  var address = ''.obs;
  var occupation = ''.obs;
  var insuranceNumber = ''.obs;
  var lifestyleNotes = ''.obs;

  // Navigation methods for menu items
  void goToSavedItems() {
    Get.toNamed(Routes.savedItems);
  }

  void goToEditProfile() {
    Get.toNamed(Routes.editProfile);
  }

  void goToPaymentMethods() {
    Get.toNamed(Routes.paymentMethods);
  }

  void goToFAQs() {
    Get.toNamed(Routes.faqs);
  }

  void goToAccountSecurity() {
    Get.toNamed(Routes.accountSecurity);
  }

  void changeAvatar() async {
    log('Starting avatar change', name: 'AVATAR_UPLOAD_PROFILE');

    try {
      final picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image == null) {
        log('No image selected', name: 'AVATAR_UPLOAD_PROFILE');
        return;
      }

      // Show loading
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      log('Image selected: ${image.path}', name: 'AVATAR_UPLOAD_PROFILE');

      final formData = dio.FormData.fromMap({
        'folder': 'user', // đúng API
        'file': await dio.MultipartFile.fromFile(
          image.path,
          filename: image.name,
        ),
      });

      log('Uploading to /files ...', name: 'AVATAR_UPLOAD_PROFILE');

      /// Gọi API upload
      final profileRepo = Get.find<ProfileRepository>();
      final response = await profileRepo.uploadAvatar(formData);

      if (response.data?.fileName == null) {
        throw Exception(
            "Upload success nhưng không có fileName trong response");
      }

      final newAvatarUrl = response.data!.fileName!;
      avatarUrl.value = newAvatarUrl;

      log('Uploaded URL: $newAvatarUrl', name: 'AVATAR_UPLOAD_PROFILE');

      /// Gọi API update avatar
      await profileRepo.updateAvatar(newAvatarUrl);

      /// Update local storage
      final userData = StorageService.userData;
      if (userData != null) {
        userData['avatar'] = newAvatarUrl;
        StorageService.userData = userData;
      }

      // Close loading dialog
      Get.back();

      Get.snackbar('Thành công', 'Avatar đã được cập nhật!');
    } catch (e) {
      // Close loading dialog if open
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }

      log('Error upload avatar: $e', name: 'AVATAR_UPLOAD_PROFILE');
      Get.snackbar('Lỗi', 'Không thể cập nhật avatar!');
    }
  }

  void logout() async {
    Get.dialog(
      AlertDialog(
        title: const Text('Xác nhận đăng xuất'),
        content: const Text('Bạn có chắc chắn muốn đăng xuất khỏi ứng dụng?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () async {
              Get.back();

              // Log logout initiation
              log('User initiated logout from profile screen',
                  name: 'LOGOUT_PROCESS');

              // Clear storage and navigate to login first
              log('Clearing storage and navigating to login',
                  name: 'LOGOUT_PROCESS');
              StorageService.clear();
              Get.offAllNamed(Routes.login);

              // Call API logout after clearing local data (fire and forget)
              if (StorageService.token != null) {
                log('Calling API logout from profile screen',
                    name: 'LOGOUT_PROCESS');
                try {
                  final authRepo = Get.find<AuthRepository>();
                  await authRepo.logout();
                  log('API logout completed successfully from profile',
                      name: 'LOGOUT_PROCESS');
                } catch (e) {
                  log('API logout failed from profile: $e',
                      name: 'LOGOUT_PROCESS');
                  // API logout failure doesn't affect local logout
                }
              } else {
                log('No token found, skipping API logout from profile',
                    name: 'LOGOUT_PROCESS');
              }
            },
            child: const Text(
              'Đăng xuất',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
