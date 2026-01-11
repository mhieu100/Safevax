import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_getx_boilerplate/routes/navigator_helper.dart';
import 'package:flutter_getx_boilerplate/shared/services/storage_service.dart';
import 'package:flutter_getx_boilerplate/models/request/complete_profile_request.dart';
import 'package:flutter_getx_boilerplate/models/response/error/error_response.dart';
import 'package:flutter_getx_boilerplate/repositories/register_repository.dart';
import 'package:flutter_getx_boilerplate/modules/base/base_controller.dart';
import 'package:flutter_getx_boilerplate/modules/dashboarh_main/dashboard_controller.dart';

class CompleteProfileController extends BaseController<RegisterRepository> {
  CompleteProfileController(super.repository);
  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final heightController = TextEditingController();
  final weightController = TextEditingController();
  final phoneController = TextEditingController();
  final identityNumberController = TextEditingController();
  final occupationController = TextEditingController();
  final lifestyleNotesController = TextEditingController();
  final insuranceNumberController = TextEditingController();

  late final TextEditingController genderController;
  late final TextEditingController bloodTypeController;
  final birthDate = Rx<DateTime?>(null);
  final isLoading = false.obs;

  // Error messages for fields
  final nameError = ''.obs;
  final addressError = ''.obs;
  final phoneError = ''.obs;
  final identityError = ''.obs;
  final birthDateError = ''.obs;
  final heightError = ''.obs;
  final weightError = ''.obs;
  final genderError = ''.obs;
  final bloodTypeError = ''.obs;

  @override
  void onInit() {
    super.onInit();
    genderController = TextEditingController();
    bloodTypeController = TextEditingController();
    _loadUserData();
    _addListeners();
  }

  void _addListeners() {
    nameController.addListener(() => nameError.value = '');
    addressController.addListener(() => addressError.value = '');
    phoneController.addListener(() => phoneError.value = '');
    identityNumberController.addListener(() => identityError.value = '');
    heightController.addListener(() => heightError.value = '');
    weightController.addListener(() => weightError.value = '');
    genderController.addListener(() => genderError.value = '');
    bloodTypeController.addListener(() => bloodTypeError.value = '');
  }

  void _loadUserData() {
    final userData = StorageService.userData;
    if (userData != null) {
      // Load existing user data
      nameController.text = userData['fullName'] ?? '';
      phoneController.text = userData['phone'] ?? '';
      addressController.text = userData['address'] ?? '';
      identityNumberController.text = userData['identityNumber'] ?? '';
      genderController.text =
          _convertGenderFromApi(userData['gender'] ?? 'Nam');
      bloodTypeController.text = userData['bloodType'] ?? 'A';
      heightController.text = userData['heightCm']?.toString() ?? '';
      weightController.text = userData['weightKg']?.toString() ?? '';

      if (userData['birthday'] != null) {
        try {
          birthDate.value = DateTime.parse(userData['birthday']);
        } catch (e) {
          // Invalid date format
        }
      }
    }
  }

  // Convert API gender values (MALE/FEMALE) to UI values (Nam/Nữ)
  String _convertGenderFromApi(String apiGender) {
    switch (apiGender.toUpperCase()) {
      case 'MALE':
        return 'Nam';
      case 'FEMALE':
        return 'Nữ';
      default:
        return 'Nam'; // Default fallback
    }
  }

  // Convert UI gender values (Nam/Nữ) to API values (MALE/FEMALE)
  String _convertGenderToApi(String uiGender) {
    switch (uiGender) {
      case 'Nam':
        return 'MALE';
      case 'Nữ':
        return 'FEMALE';
      case 'Khác':
        return 'OTHER';
      default:
        return 'MALE'; // Default fallback
    }
  }

  Future<void> selectBirthDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: birthDate.value ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      birthDate.value = picked;
      birthDateError.value = '';
    }
  }

  Future<void> completeProfile() async {
    // Clear previous errors
    nameError.value = '';
    addressError.value = '';
    phoneError.value = '';
    identityError.value = '';
    birthDateError.value = '';
    heightError.value = '';
    weightError.value = '';
    genderError.value = '';
    bloodTypeError.value = '';

    // Validation
    bool hasErrors = false;

    // Validate full name
    final name = nameController.text.trim();
    if (name.isEmpty) {
      nameError.value = 'Vui lòng nhập họ và tên đầy đủ của bạn.';
      hasErrors = true;
    } else if (name.length < 2) {
      nameError.value = 'Họ và tên phải có ít nhất 2 ký tự.';
      hasErrors = true;
    } else if (name.length > 100) {
      nameError.value = 'Họ và tên không được vượt quá 100 ký tự.';
      hasErrors = true;
    }

    // Validate address
    final address = addressController.text.trim();
    if (address.isEmpty) {
      addressError.value = 'Vui lòng nhập địa chỉ nơi ở hiện tại.';
      hasErrors = true;
    } else if (address.length < 5) {
      addressError.value = 'Địa chỉ phải có ít nhất 5 ký tự.';
      hasErrors = true;
    } else if (address.length > 255) {
      addressError.value = 'Địa chỉ không được vượt quá 255 ký tự.';
      hasErrors = true;
    }

    // Validate phone
    final phoneRegex = RegExp(r'^(0[3|5|7|8|9])+([0-9]{8})$');
    if (phoneController.text.trim().isEmpty) {
      phoneError.value = 'Vui lòng nhập số điện thoại (ví dụ: 090xxxxxxx).';
      hasErrors = true;
    } else if (!phoneRegex.hasMatch(phoneController.text.trim())) {
      phoneError.value = 'Vui lòng nhập số điện thoại hợp lệ.';
      hasErrors = true;
    }

    // Validate identity number
    final idRegex = RegExp(r'^\d{9,12}$');
    if (identityNumberController.text.trim().isEmpty) {
      identityError.value = 'Vui lòng nhập số CCCD / CMND.';
      hasErrors = true;
    } else if (!idRegex.hasMatch(identityNumberController.text.trim())) {
      identityError.value = 'Số CCCD / CMND phải có 9-12 chữ số.';
      hasErrors = true;
    }

    // Validate birth date
    if (birthDate.value == null) {
      birthDateError.value = 'Vui lòng chọn hoặc nhập ngày/tháng/năm sinh.';
      hasErrors = true;
    } else {
      final now = DateTime.now();
      if (birthDate.value!.isAfter(now)) {
        birthDateError.value = 'Ngày sinh không được là ngày trong tương lai.';
        hasErrors = true;
      } else if (birthDate.value!.year < 1900) {
        birthDateError.value = 'Năm sinh phải từ 1900 trở lên.';
        hasErrors = true;
      }
    }

    // Validate height
    final height = double.tryParse(heightController.text.trim());
    if (heightController.text.trim().isEmpty) {
      heightError.value = 'Vui lòng nhập chiều cao của bạn (đơn vị cm).';
      hasErrors = true;
    } else if (height == null || height < 50 || height > 250) {
      heightError.value = 'Chiều cao phải từ 50-250 cm.';
      hasErrors = true;
    }

    // Validate weight
    final weight = double.tryParse(weightController.text.trim());
    if (weightController.text.trim().isEmpty) {
      weightError.value = 'Vui lòng nhập cân nặng của bạn (đơn vị kg).';
      hasErrors = true;
    } else if (weight == null || weight < 10 || weight > 200) {
      weightError.value = 'Cân nặng phải từ 10-200 kg.';
      hasErrors = true;
    }

    if (hasErrors) {
      update();
      return;
    }

    try {
      isLoading.value = true;

      // Create complete profile request
      final completeProfileRequest = CompleteProfileRequest(
        phone: phoneController.text.trim(),
        address: addressController.text.trim(),
        birthday: birthDate.value!.toIso8601String().split('T')[0],
        gender: _convertGenderToApi(genderController.text),
        identityNumber: identityNumberController.text.trim(),
        bloodType: bloodTypeController.text,
        heightCm: heightController.text.trim(),
        weightKg: weightController.text.trim(),
        occupation: occupationController.text.trim().isEmpty
            ? null
            : occupationController.text.trim(),
        lifestyleNotes: lifestyleNotesController.text.trim().isEmpty
            ? null
            : lifestyleNotesController.text.trim(),
        insuranceNumber: insuranceNumberController.text.trim().isEmpty
            ? null
            : insuranceNumberController.text.trim(),
      );

      // Call API
      final response = await repository.completeProfile(completeProfileRequest);

      if (response.statusCode == 200 && response.data != null) {
        // Update local storage with the response data
        final userData = {
          'id': response.data!.id,
          'avatar': response.data!.avatar,
          'fullName': response.data!.fullName,
          'email': response.data!.email,
          'phone': response.data!.phone,
          'birthday': response.data!.birthday,
          'gender': response.data!.gender,
          'address': response.data!.address,
          'identityNumber': response.data!.identityNumber,
          'bloodType': response.data!.bloodType,
          'heightCm': response.data!.heightCm,
          'weightKg': response.data!.weightKg,
          'consentForAIAnalysis': response.data!.consentForAIAnalysis,
          'role': response.data!.role,
          'isActive': response.data!.isActive,
        };

        StorageService.userData = userData;

        // Check if user is active
        if (response.data!.isActive == true) {
          // Update dashboard controller if it exists
          if (Get.isRegistered<DashboardController>()) {
            final dashboardController = Get.find<DashboardController>();
            dashboardController.userName.value = response.data!.fullName ?? '';
            dashboardController.avatar.value = response.data!.avatar ?? '';
          }

          // Navigate to home screen
          NavigatorHelper.toBottomNavigationScreen();
        } else {
          // User is not active, stay on complete profile screen
          // Could show a message or just stay
        }
      } else if (response.statusCode == 400 &&
          response.message != null &&
          response.message!
              .toLowerCase()
              .contains('profile already completed')) {
        // Profile already completed - navigate to home screen
        NavigatorHelper.toBottomNavigationScreen();
      } else {
        Get.dialog(
          AlertDialog(
            title: const Text('Lỗi'),
            content: Text(response.message ?? 'Lỗi không xác định'),
            actions: [
              TextButton(
                onPressed: () => Get.back(),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      // Handle network or parsing errors
      String errorMessage = 'Lỗi không xác định';
      if (e is ErrorResponse) {
        errorMessage = e.message ?? errorMessage;
        // Check if profile is already completed
        if (errorMessage.toLowerCase().contains('profile already completed')) {
          // Navigate to home screen
          NavigatorHelper.toBottomNavigationScreen();
          return;
        }
      }
      Get.dialog(
        AlertDialog(
          title: const Text('Lỗi'),
          content: Text(errorMessage),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    addressController.dispose();
    heightController.dispose();
    weightController.dispose();
    phoneController.dispose();
    identityNumberController.dispose();
    occupationController.dispose();
    lifestyleNotesController.dispose();
    insuranceNumberController.dispose();
    genderController.dispose();
    bloodTypeController.dispose();
    super.onClose();
  }
}
