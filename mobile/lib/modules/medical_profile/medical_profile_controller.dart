import 'package:flutter_getx_boilerplate/repositories/medical_profile_repository.dart';
import 'package:flutter_getx_boilerplate/routes/navigator_helper.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_getx_boilerplate/modules/base/base_controller.dart';
import 'package:flutter_getx_boilerplate/shared/services/storage_service.dart';
import 'package:flutter_getx_boilerplate/mock_medical_profile_data.dart';

class MedicalProfileController
    extends BaseController<MedicalProfileRepository> {
  MedicalProfileController(super.repository);
  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final heightController = TextEditingController();
  final weightController = TextEditingController();
  final phoneController = TextEditingController();
  final identityNumberController = TextEditingController();
  final bloodTypeController = TextEditingController();

  final nameError = Rx<String?>(null);
  final addressError = Rx<String?>(null);
  final heightError = Rx<String?>(null);
  final weightError = Rx<String?>(null);
  final phoneError = Rx<String?>(null);
  final birthDateError = Rx<String?>(null);
  final genderError = Rx<String?>(null);
  final identityNumberError = Rx<String?>(null);
  final bloodTypeError = Rx<String?>(null);

  final selectedGender = Rx<String>('Nam');
  final selectedBloodType = Rx<String>('A');
  final birthDate = Rx<DateTime?>(null);
  final isLoading = false.obs;

  Future<void> selectBirthDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      birthDate.value = picked;
      birthDateError.value = null;
    }
  }

  Future<void> createMedicalProfile() async {
    // Clear all previous errors
    nameError.value = null;
    addressError.value = null;
    heightError.value = null;
    weightError.value = null;
    phoneError.value = null;
    birthDateError.value = null;
    genderError.value = null;
    identityNumberError.value = null;
    bloodTypeError.value = null;

    // Validate required fields for patient profile
    bool hasError = false;

    if (nameController.text.trim().isEmpty) {
      nameError.value = 'Vui lòng nhập họ và tên đầy đủ của bạn.';
      hasError = true;
    }

    if (addressController.text.trim().isEmpty) {
      addressError.value = 'Vui lòng nhập địa chỉ nơi ở hiện tại.';
      hasError = true;
    }

    if (heightController.text.trim().isEmpty) {
      heightError.value = 'Vui lòng nhập chiều cao của bạn (đơn vị cm).';
      hasError = true;
    }

    if (weightController.text.trim().isEmpty) {
      weightError.value = 'Vui lòng nhập cân nặng của bạn (đơn vị kg).';
      hasError = true;
    }

    if (phoneController.text.trim().isEmpty) {
      phoneError.value = 'Vui lòng nhập số điện thoại (ví dụ: 090xxxxxxx).';
      hasError = true;
    }

    if (birthDate.value == null) {
      birthDateError.value = 'Vui lòng chọn hoặc nhập ngày/tháng/năm sinh.';
      hasError = true;
    }

    if (selectedGender.value.isEmpty) {
      genderError.value = 'Vui lòng chọn giới tính.';
      hasError = true;
    }

    if (identityNumberController.text.trim().isEmpty) {
      identityNumberError.value = 'Vui lòng nhập số CCCD / CMND.';
      hasError = true;
    } else {
      final idRegex = RegExp(r'^\d{9,12}$');
      if (!idRegex.hasMatch(identityNumberController.text.trim())) {
        identityNumberError.value = 'Số CCCD / CMND phải có 9-12 chữ số.';
        hasError = true;
      }
    }

    if (selectedBloodType.value.isEmpty) {
      bloodTypeError.value = 'Vui lòng chọn nhóm máu.';
      hasError = true;
    }

    if (hasError) {
      return;
    }

    // Store patient profile data for registration
    final patientProfileData = {
      'ho_ten': nameController.text.trim(),
      'dia_chi': addressController.text.trim(),
      'chieu_cao_cm': int.tryParse(heightController.text.trim()) ?? 170,
      'can_nang_kg': int.tryParse(weightController.text.trim()) ?? 70,
      'so_dien_thoai': phoneController.text.trim(),
      'ngay_sinh':
          '${birthDate.value!.year}-${birthDate.value!.month.toString().padLeft(2, '0')}-${birthDate.value!.day.toString().padLeft(2, '0')}',
      'gioi_tinh': selectedGender.value,
      'so_dinh_danh': identityNumberController.text.trim(),
      'nhom_mau': selectedBloodType.value,
    };

    // Save to storage for use in register screen
    StorageService.patientProfileData = patientProfileData;

    isLoading.value = true;
    // 🚀 Demo: delay 1 giây để giả lập gọi API
    await Future.delayed(const Duration(seconds: 1));

    // Navigate to register screen to create account
    NavigatorHelper.toRegisterScreen();

    isLoading.value = false;
  }

  Future<void> skipProfileCreation() async {
    isLoading.value = true;
    // 🚀 Demo: delay 1 giây để giả lập gọi API
    await Future.delayed(const Duration(seconds: 2));

    // Chuyển sang màn hình login
    NavigatorHelper.toBottomNavigationScreen();

    // Navigate to main app without creating profile
    // User can create profile later from settings
  }

  @override
  void onInit() {
    super.onInit();
    // Load existing user data if available
    _loadExistingData();
  }

  void _loadExistingData() {
    final userData = StorageService.userData;
    if (userData != null) {
      // Load from user data if exists
      // For now, leave empty for new profile creation
    }
  }

  // Method to load mock data for testing purposes
  void loadMockData([int profileIndex = 0]) {
    final mockData = MockMedicalProfileData.getProfileByIndex(profileIndex);

    nameController.text = mockData['ho_ten'];
    addressController.text = mockData['dia_chi'];
    heightController.text = mockData['chieu_cao_cm'].toString();
    weightController.text = mockData['can_nang_kg'].toString();
    phoneController.text = mockData['so_dien_thoai'];
    identityNumberController.text = mockData['so_dinh_danh'];
    selectedGender.value = mockData['gioi_tinh'];
    selectedBloodType.value = mockData['nhom_mau'];

    // Parse birth date
    try {
      final dateParts = mockData['ngay_sinh'].split('-');
      final birthDateParsed = DateTime(
        int.parse(dateParts[0]), // year
        int.parse(dateParts[1]), // month
        int.parse(dateParts[2]), // day
      );
      birthDate.value = birthDateParsed;
    } catch (e) {
      // If date parsing fails, set to null
      birthDate.value = null;
    }

    // Clear any existing errors
    nameError.value = null;
    addressError.value = null;
    heightError.value = null;
    weightError.value = null;
    phoneError.value = null;
    birthDateError.value = null;
    genderError.value = null;
    identityNumberError.value = null;
    bloodTypeError.value = null;
  }

  // Method to load random mock data
  void loadRandomMockData() {
    final mockData = MockMedicalProfileData.getRandomProfile();

    nameController.text = mockData['ho_ten'];
    addressController.text = mockData['dia_chi'];
    heightController.text = mockData['chieu_cao_cm'].toString();
    weightController.text = mockData['can_nang_kg'].toString();
    phoneController.text = mockData['so_dien_thoai'];
    identityNumberController.text = mockData['so_dinh_danh'];
    selectedGender.value = mockData['gioi_tinh'];
    selectedBloodType.value = mockData['nhom_mau'];

    // Parse birth date
    try {
      final dateParts = mockData['ngay_sinh'].split('-');
      final birthDateParsed = DateTime(
        int.parse(dateParts[0]), // year
        int.parse(dateParts[1]), // month
        int.parse(dateParts[2]), // day
      );
      birthDate.value = birthDateParsed;
    } catch (e) {
      // If date parsing fails, set to null
      birthDate.value = null;
    }

    // Clear any existing errors
    nameError.value = null;
    addressError.value = null;
    heightError.value = null;
    weightError.value = null;
    phoneError.value = null;
    birthDateError.value = null;
    genderError.value = null;
    identityNumberError.value = null;
    bloodTypeError.value = null;
  }

  @override
  void onClose() {
    nameController.dispose();
    addressController.dispose();
    heightController.dispose();
    weightController.dispose();
    phoneController.dispose();
    identityNumberController.dispose();
    bloodTypeController.dispose();
    super.onClose();
  }
}
