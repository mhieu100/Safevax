import 'package:dio/dio.dart';
import 'package:flutter_getx_boilerplate/repositories/register_repository.dart';
import 'package:flutter_getx_boilerplate/routes/routes.dart';
import 'package:flutter_getx_boilerplate/shared/constants/colors.dart';
import 'package:flutter_getx_boilerplate/shared/services/storage_service.dart';
import 'package:flutter_getx_boilerplate/shared/utils/size_config.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_getx_boilerplate/modules/base/base_controller.dart';
import 'package:flutter_getx_boilerplate/models/request/register_request.dart';
import 'package:flutter_getx_boilerplate/models/request/complete_profile_request.dart';
import 'package:flutter_getx_boilerplate/models/response/error/error_response.dart';

// RegisterController updated part
class RegisterController extends BaseController<RegisterRepository> {
  RegisterController(super.repository);

  @override
  Future getData() async {
    // Load patient profile data from storage
    final patientData = StorageService.patientProfileData;
    if (patientData != null) {
      nameController.text = patientData['ho_ten'] ?? '';
      phoneController.text = patientData['so_dien_thoai'] ?? '';
    }

    // Mock data for account creation
    emailController.text = 'thuphuong@gmail.com';
    passwordController.text = 'phuong123456';
    confirmPasswordController.text = 'phuong123456';
    agreeToTerms.value = true;
  }

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  var passwordVisible = false.obs;
  var confirmPasswordVisible = false.obs;
  var agreeToTerms = false.obs;
  var isLoading = false.obs;

  // Error states
  var emailError = Rx<String?>(null);
  var passwordError = Rx<String?>(null);
  var confirmPasswordError = Rx<String?>(null);

  // Validation functions
  bool validateEmail(String email) {
    if (email.isEmpty) return false;
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  bool validatePhone(String phone) {
    if (phone.isEmpty) return false;
    // Vietnamese phone number validation (10-11 digits, may start with 0, +84, or 84)
    final phoneRegex = RegExp(r'^(0|\+84|84)(\d{9,10})$');
    return phoneRegex.hasMatch(phone);
  }

  bool validatePassword(String password) {
    return password.length >= 6;
  }

  bool validateDateOfBirth(String date) {
    if (date.isEmpty) return false;
    // Simple date validation (you might want to add more complex validation)
    return true;
  }

  void validateForm() {
    // Reset errors
    emailError.value = null;
    passwordError.value = null;
    confirmPasswordError.value = null;

    // Email validation
    if (emailController.text.isEmpty) {
      emailError.value = 'Vui lòng nhập email';
    } else if (!validateEmail(emailController.text)) {
      emailError.value = 'Vui lòng nhập email hợp lệ';
    }

    // Password validation
    if (passwordController.text.isEmpty) {
      passwordError.value = 'Vui lòng nhập mật khẩu';
    } else if (!validatePassword(passwordController.text)) {
      passwordError.value = 'Mật khẩu tối thiểu 6 ký tự';
    }

    // Confirm password validation
    if (confirmPasswordController.text.isEmpty) {
      confirmPasswordError.value = 'Vui lòng xác nhận mật khẩu';
    } else if (passwordController.text != confirmPasswordController.text) {
      confirmPasswordError.value = 'Mật khẩu không khớp';
    }
  }

  Future<void> signUp() async {
    validateForm();

    // Nếu có lỗi hoặc chưa đồng ý điều khoản thì dừng lại
    if (emailError.value != null ||
        passwordError.value != null ||
        confirmPasswordError.value != null ||
        !agreeToTerms.value) {
      Get.snackbar(
        'Lỗi',
        'Vui lòng điền đầy đủ và chính xác các thông tin bắt buộc.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
      return;
    }

    try {
      isLoading(true);

      // Get patient profile data from storage
      final patientData = StorageService.patientProfileData;

      // Step 1: Register basic user account
      final registerRequest = RegisterRequest(
        user: UserData(
          fullName: nameController.text,
          email: emailController.text,
          password: passwordController.text,
        ),
        patientProfile: PatientProfileData(
          address: '',
          phone: '',
          birthday: '',
          gender: 'MALE',
          identityNumber: '',
          bloodType: '',
          heightCm: 170,
          weightKg: 70,
        ),
      );

      final registerResponse = await repository.register(registerRequest);

      // Check if basic registration successful
      if (registerResponse.statusCode == 200 &&
          registerResponse.data?.accessToken != null) {
        // Store the access token temporarily for the complete-profile call
        final tempToken = registerResponse.data!.accessToken;
        StorageService.token = tempToken;

        // Step 2: Complete patient profile
        final completeProfileRequest = CompleteProfileRequest(
          phone: patientData?['so_dien_thoai'] ?? phoneController.text,
          address: patientData?['dia_chi'] ?? '',
          birthday: patientData?['ngay_sinh'] ?? '',
          gender: patientData?['gioi_tinh'] == 'Nam' ? 'MALE' : 'FEMALE',
          identityNumber: patientData?['so_dinh_danh'] ?? '',
          bloodType: patientData?['nhom_mau'] ?? '',
          heightCm: (patientData?['chieu_cao_cm'] ?? 170).toString(),
          weightKg: (patientData?['can_nang_kg'] ?? 70).toString(),
        );

        final completeProfileResponse =
            await repository.completeProfile(completeProfileRequest);

        // Clear temporary token
        StorageService.token = null;

        // ✅ Nếu cả hai bước thành công → hiển thị dialog
        await _showSuccessDialog();

        // Chuyển sang màn hình login
        NavigatorHelper.toLoginScreen();
      } else {
        // Basic registration failed
        if (registerResponse.data is Map<String, dynamic>) {
          emailError.value =
              (registerResponse.data as Map<String, dynamic>)['error'] ??
                  registerResponse.message ??
                  'Đăng ký thất bại. Vui lòng thử lại.';
        } else {
          emailError.value =
              registerResponse.message ?? 'Đăng ký thất bại. Vui lòng thử lại.';
        }
      }
    } catch (e) {
      // Clear any temporary token on error
      StorageService.token = null;

      // Set error text for UI feedback
      if (e is ErrorResponse) {
        emailError.value = e.message;
      } else if (e is DioException && e.response != null) {
        if (e.response!.data is Map<String, dynamic>) {
          emailError.value =
              (e.response!.data as Map<String, dynamic>)['error'] ??
                  'Có lỗi xảy ra. Vui lòng thử lại.';
        } else if (e.response!.data is String) {
          emailError.value = e.response!.data as String;
        } else {
          emailError.value = 'Có lỗi xảy ra. Vui lòng thử lại.';
        }
      } else {
        emailError.value = 'Có lỗi xảy ra. Vui lòng thử lại.';
      }
      // Also show snackbar alert
      Get.snackbar(
        'Lỗi',
        emailError.value ?? 'Có lỗi xảy ra. Vui lòng thử lại.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isLoading(false);
    }
  }

  // ... rest of the controller code remains the same

  Future<void> _showSuccessDialog() async {
    return await Get.dialog(
      AlertDialog(
        backgroundColor: ColorConstants.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 102.w,
              height: 102.h,
              decoration: const BoxDecoration(
                color: Color(0xFFF2F7FA),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: SvgPicture.asset(
                  'assets/svgs/ic_done.svg',
                  width: 102.w,
                  height: 102.h,
                ),
              ),
            ),
            SizedBox(height: 24.h),
            Text(
              'Thành công',
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              'Tài khoản của bạn đã được đăng ký thành công',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 32.h),
            SizedBox(
              width: 183,
              child: ElevatedButton(
                onPressed: () => Get.back(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorConstants.primaryGreen,
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32),
                  ),
                ),
                child: Text(
                  'Đăng nhập',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      barrierDismissible: false,
    );
  }

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();

    super.onClose();
  }
}
