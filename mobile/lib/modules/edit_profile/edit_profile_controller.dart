import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_getx_boilerplate/modules/profile/profile_controller.dart';
import 'package:flutter_getx_boilerplate/modules/dashboarh_main/dashboard_controller.dart';
import 'package:flutter_getx_boilerplate/modules/dashboard_noti/dashboard_noti_controller.dart';
import 'package:flutter_getx_boilerplate/shared/services/storage_service.dart';
import 'package:flutter_getx_boilerplate/models/request/update_account_request.dart';
import 'package:flutter_getx_boilerplate/repositories/auth_repository.dart';
import 'package:get/get.dart';

class EditProfileController extends GetxController {
  // Username observables
  final RxString username = ''.obs;
  final RxString age = ''.obs;
  final RxString height = ''.obs;
  final RxString weight = ''.obs;

  // Form fields - Initialize with current profile data
  late final TextEditingController fullNameController;
  late final TextEditingController emailController;
  late final TextEditingController phoneController;
  late final TextEditingController dateOfBirthController;
  late final TextEditingController genderController;
  late final TextEditingController identityNumberController;
  late final TextEditingController bloodTypeController;
  late final TextEditingController heightController;
  late final TextEditingController weightController;
  late final TextEditingController addressController;
  late final TextEditingController occupationController;
  late final TextEditingController insuranceNumberController;
  late final TextEditingController lifestyleNotesController;

  @override
  void onInit() {
    super.onInit();
    super.onInit();
    super.onInit();
    // Initialize controllers as empty first
    fullNameController = TextEditingController();
    emailController = TextEditingController();
    phoneController = TextEditingController();
    dateOfBirthController = TextEditingController();
    genderController = TextEditingController();
    identityNumberController = TextEditingController();
    bloodTypeController = TextEditingController();
    heightController = TextEditingController();
    weightController = TextEditingController();
    addressController = TextEditingController();
    occupationController = TextEditingController();
    insuranceNumberController = TextEditingController();
    lifestyleNotesController = TextEditingController();

    // Load user data from API
    _loadUserData();

    // Add listeners to validate form
    fullNameController.addListener(_validateForm);
    emailController.addListener(_validateForm);
    phoneController.addListener(_validateForm);
    dateOfBirthController.addListener(_validateForm);
    genderController.addListener(_validateForm);
    identityNumberController.addListener(_validateForm);
    bloodTypeController.addListener(_validateForm);
    heightController.addListener(_validateForm);
    weightController.addListener(_validateForm);
    addressController.addListener(_validateForm);
    occupationController.addListener(_validateForm);
    insuranceNumberController.addListener(_validateForm);
    lifestyleNotesController.addListener(_validateForm);

    // Load avatar from storage
    // _loadAvatar();
  }

  Future<void> _loadUserData() async {
    try {
      final authRepo = Get.find<AuthRepository>();
      final response = await authRepo.getAccount();
      final user = response.data;

      if (user != null) {
        // Update controllers with user data
        fullNameController.text = user.fullName ?? '';
        emailController.text = user.email ?? '';
        phoneController.text = user.phone ?? '';
        dateOfBirthController.text = user.birthday ?? '';
        genderController.text = _mapGenderToDisplay(user.gender ?? '');
        identityNumberController.text = user.identityNumber ?? '';
        bloodTypeController.text = user.bloodType ?? '';
        heightController.text = user.heightCm?.toString() ?? '';
        weightController.text = user.weightKg?.toString() ?? '';
        addressController.text = user.address ?? '';
        occupationController.text = user.occupation ?? '';
        insuranceNumberController.text = user.insuranceNumber ?? '';
        lifestyleNotesController.text = user.lifestyleNotes ?? '';

        // Update storage with the latest user data including correct avatar
        StorageService.userData = user.toJson();
      }
    } catch (e) {
      // Handle error - perhaps show snackbar
      Get.snackbar('Lỗi', 'Không thể tải thông tin người dùng');
    }
  }

  // Observable for form validation
  var isFormValid = false.obs;

  // Error messages
  var fullNameError = ''.obs;
  var emailError = ''.obs;
  var phoneError = ''.obs;
  var dateOfBirthError = ''.obs;
  var genderError = ''.obs;
  var identityNumberError = ''.obs;
  var bloodTypeError = ''.obs;
  var heightError = ''.obs;
  var weightError = ''.obs;
  var addressError = ''.obs;
  var occupationError = ''.obs;
  var insuranceNumberError = ''.obs;
  var lifestyleNotesError = ''.obs;

  void _validateForm() {
    _validateFullName();
    _validateEmail();
    _validatePhone();
    _validateDateOfBirth();
    _validateGender();
    _validateIdentityNumber();
    _validateBloodType();
    _validateHeight();
    _validateWeight();
    _validateAddress();
    _validateOccupation();
    _validateInsuranceNumber();
    _validateLifestyleNotes();

    isFormValid.value = fullNameError.isEmpty &&
        emailError.isEmpty &&
        phoneError.isEmpty &&
        dateOfBirthError.isEmpty &&
        genderError.isEmpty &&
        identityNumberError.isEmpty &&
        bloodTypeError.isEmpty &&
        heightError.isEmpty &&
        weightError.isEmpty &&
        addressError.isEmpty &&
        occupationError.isEmpty &&
        insuranceNumberError.isEmpty &&
        lifestyleNotesError.isEmpty;
  }

  void _validateFullName() {
    final name = fullNameController.text.trim();
    if (name.isEmpty) {
      fullNameError.value = 'Vui lòng nhập họ và tên đầy đủ của bạn.';
    } else if (name.length < 2) {
      fullNameError.value = 'Họ và tên phải có ít nhất 2 ký tự.';
    } else if (name.length > 100) {
      fullNameError.value = 'Họ và tên không được vượt quá 100 ký tự.';
    } else {
      fullNameError.value = '';
    }
  }

  void _validateEmail() {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    final email = emailController.text.trim();
    if (email.isEmpty) {
      emailError.value = 'Vui lòng nhập địa chỉ email của bạn.';
    } else if (email.length > 254) {
      emailError.value = 'Địa chỉ email không được vượt quá 254 ký tự.';
    } else if (!emailRegex.hasMatch(email)) {
      emailError.value = 'Vui lòng nhập địa chỉ email hợp lệ.';
    } else {
      emailError.value = '';
    }
  }

  void _validatePhone() {
    final phoneRegex = RegExp(r'^(0[3|5|7|8|9])+([0-9]{8})$');
    if (phoneController.text.trim().isEmpty) {
      phoneError.value = 'Vui lòng nhập số điện thoại (ví dụ: 090xxxxxxx).';
    } else if (!phoneRegex.hasMatch(phoneController.text.trim())) {
      phoneError.value = 'Vui lòng nhập số điện thoại hợp lệ.';
    } else {
      phoneError.value = '';
    }
  }

  void _validateDateOfBirth() {
    final dateStr = dateOfBirthController.text.trim();
    if (dateStr.isEmpty) {
      dateOfBirthError.value = 'Vui lòng chọn hoặc nhập ngày/tháng/năm sinh.';
    } else {
      final dateRegex = RegExp(r'^\d{4}-\d{2}-\d{2}$');
      if (!dateRegex.hasMatch(dateStr)) {
        dateOfBirthError.value = 'Ngày sinh phải có định dạng YYYY-MM-DD.';
      } else {
        try {
          final date = DateTime.parse(dateStr);
          final now = DateTime.now();
          if (date.isAfter(now)) {
            dateOfBirthError.value =
                'Ngày sinh không được là ngày trong tương lai.';
          } else if (date.year < 1900) {
            dateOfBirthError.value = 'Năm sinh phải từ 1900 trở lên.';
          } else {
            dateOfBirthError.value = '';
          }
        } catch (e) {
          dateOfBirthError.value = 'Ngày sinh không hợp lệ.';
        }
      }
    }
  }

  void _validateGender() {
    if (genderController.text.trim().isEmpty) {
      genderError.value = 'Vui lòng chọn giới tính.';
    } else {
      genderError.value = '';
    }
  }

  void _validateIdentityNumber() {
    final idRegex = RegExp(r'^\d{9,12}$');
    if (identityNumberController.text.trim().isEmpty) {
      identityNumberError.value = 'Vui lòng nhập số CCCD / CMND.';
    } else if (!idRegex.hasMatch(identityNumberController.text.trim())) {
      identityNumberError.value = 'Số CCCD / CMND phải có 9-12 chữ số.';
    } else {
      identityNumberError.value = '';
    }
  }

  void _validateBloodType() {
    if (bloodTypeController.text.trim().isEmpty) {
      bloodTypeError.value = 'Vui lòng chọn nhóm máu.';
    } else {
      bloodTypeError.value = '';
    }
  }

  void _validateHeight() {
    final height = double.tryParse(heightController.text.trim());
    if (heightController.text.trim().isEmpty) {
      heightError.value = 'Vui lòng nhập chiều cao của bạn (đơn vị cm).';
    } else if (height == null || height < 50 || height > 250) {
      heightError.value = 'Chiều cao phải từ 50-250 cm.';
    } else {
      heightError.value = '';
    }
  }

  void _validateWeight() {
    final weight = double.tryParse(weightController.text.trim());
    if (weightController.text.trim().isEmpty) {
      weightError.value = 'Vui lòng nhập cân nặng của bạn (đơn vị kg).';
    } else if (weight == null || weight < 10 || weight > 200) {
      weightError.value = 'Cân nặng phải từ 10-200 kg.';
    } else {
      weightError.value = '';
    }
  }

  void _validateAddress() {
    final address = addressController.text.trim();
    if (address.isEmpty) {
      addressError.value = 'Vui lòng nhập địa chỉ nơi ở hiện tại.';
    } else if (address.length < 5) {
      addressError.value = 'Địa chỉ phải có ít nhất 5 ký tự.';
    } else if (address.length > 255) {
      addressError.value = 'Địa chỉ không được vượt quá 255 ký tự.';
    } else {
      addressError.value = '';
    }
  }

  void _validateOccupation() {
    final occupation = occupationController.text.trim();
    if (occupation.isEmpty) {
      occupationError.value = 'Vui lòng nhập nghề nghiệp của bạn.';
    } else if (occupation.length > 100) {
      occupationError.value = 'Nghề nghiệp không được vượt quá 100 ký tự.';
    } else {
      occupationError.value = '';
    }
  }

  void _validateInsuranceNumber() {
    final insuranceRegex = RegExp(r'^\d{10}$');
    final text = insuranceNumberController.text.trim();
    print('Debug: Validating insurance number: "$text"');
    if (text.isEmpty) {
      insuranceNumberError.value = 'Vui lòng nhập số bảo hiểm y tế.';
    } else if (!insuranceRegex.hasMatch(text)) {
      insuranceNumberError.value = 'Số bảo hiểm y tế phải có đúng 10 chữ số.';
    } else {
      insuranceNumberError.value = '';
    }
    print(
        'Debug: Insurance number validation result: "${insuranceNumberError.value}"');
  }

  void _validateLifestyleNotes() {
    if (lifestyleNotesController.text.length > 500) {
      lifestyleNotesError.value = 'Ghi chú không được vượt quá 500 ký tự';
    } else {
      lifestyleNotesError.value = '';
    }
  }

  String _mapGenderToDisplay(String apiGender) {
    switch (apiGender.toUpperCase()) {
      case 'MALE':
        return 'Nam';
      case 'FEMALE':
        return 'Nữ';
      default:
        return 'Khác';
    }
  }

  String _mapGenderToApi(String displayGender) {
    switch (displayGender) {
      case 'Nam':
        return 'MALE';
      case 'Nữ':
        return 'FEMALE';
      default:
        return 'OTHER';
    }
  }

  Future<void> saveProfile() async {
    // Validate all fields before saving
    _validateForm();

    if (isFormValid.value) {
      try {
        // Show loading
        Get.dialog(
          const Center(child: CircularProgressIndicator()),
          barrierDismissible: false,
        );

        // Prepare API request
        final request = UpdateAccountRequest(
          avatar: StorageService.userData?['avatar'], // Include current avatar
          fullName: fullNameController.text,
          email: emailController.text,
          phone: phoneController.text,
          birthday: dateOfBirthController.text,
          gender: _mapGenderToApi(genderController.text),
          identityNumber: identityNumberController.text,
          bloodType: bloodTypeController.text,
          heightCm: heightController.text.isNotEmpty
              ? int.tryParse(heightController.text)
              : null,
          weightKg: weightController.text.isNotEmpty
              ? int.tryParse(weightController.text)
              : null,
          address: addressController.text,
          occupation: occupationController.text,
          insuranceNumber: insuranceNumberController.text,
          lifestyleNotes: lifestyleNotesController.text,
        );

        // Call API
        final authRepo = Get.find<AuthRepository>();
        final updatedUser = await authRepo.updateAccount(request);

        // Update local storage with the response
        StorageService.userData = updatedUser.toJson();

        // Refresh dashboard controllers with new user data
        try {
          final dashboardController = Get.find<DashboardController>();
          dashboardController.refreshUserData();
        } catch (e) {
          // Dashboard controller not found, skip refresh
        }

        try {
          final dashboardNotiController = Get.find<DashboardNotiController>();
          dashboardNotiController.refreshUserData();
        } catch (e) {
          // Dashboard noti controller not found, skip refresh
        }

        // Close loading dialog
        Get.back();

        // Show beautiful success dialog
        Get.dialog(
          Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Success Icon
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: const Color(0xFF298267).withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_circle,
                      size: 60,
                      color: Color(0xFF298267),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Success Title
                  const Text(
                    'Thành công!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1F36),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Success Message
                  const Text(
                    'Hồ sơ của bạn đã được cập nhật thành công.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF6B7280),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),

                  // OK Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        Get.back(); // Close dialog
                        // Navigate back to profile screen
                        Get.back();
                        // Refresh profile data after navigation
                        await Future.delayed(const Duration(milliseconds: 100));
                        final profileController = Get.find<ProfileController>();
                        await profileController.refreshProfile();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF298267),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'OK',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          barrierDismissible: false,
        );
      } catch (e) {
        // Close loading dialog
        Get.back();

        Get.snackbar(
          'Lỗi',
          'Có lỗi xảy ra khi cập nhật hồ sơ. Vui lòng thử lại.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } else {
      Get.snackbar(
        'Lỗi',
        'Vui lòng kiểm tra và điền đầy đủ thông tin hợp lệ',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  void onClose() {
    fullNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    dateOfBirthController.dispose();
    genderController.dispose();
    identityNumberController.dispose();
    bloodTypeController.dispose();
    heightController.dispose();
    weightController.dispose();
    addressController.dispose();
    occupationController.dispose();
    insuranceNumberController.dispose();
    lifestyleNotesController.dispose();
  }
}
