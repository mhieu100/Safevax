import 'package:flutter_getx_boilerplate/repositories/forgot_password_repository.dart';
import 'package:flutter_getx_boilerplate/routes/navigator_helper.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_getx_boilerplate/modules/base/base_controller.dart';

class ForgotPasswordController
    extends BaseController<ForgotPasswordRepository> {
  ForgotPasswordController(super.repository);
  final emailController = TextEditingController();
  final codeController = TextEditingController();

  var isEmailSelected = true.obs;
  var isLoading = false.obs;
  var emailError = ''.obs;

  void toggleEmailPhone(bool isEmail) {
    if (isEmailSelected.value != isEmail) {
      isEmailSelected.value = isEmail;
      emailController.clear();
      emailError.value = '';
    }
  }

  Future<void> sendCode() async {
    final input = emailController.text.trim();
    emailError.value = '';

    if (input.isEmpty) {
      emailError.value =
          'Vui lòng nhập ${isEmailSelected.value ? 'email' : 'số điện thoại'}';
      return;
    }

    if (isEmailSelected.value) {
      if (!_validateEmail(input)) {
        emailError.value = 'Vui lòng nhập địa chỉ email hợp lệ';
        return;
      }
    } else {
      if (!_validatePhone(input)) {
        emailError.value = 'Vui lòng nhập số điện thoại hợp lệ';
        return;
      }
    }

    // Nếu hợp lệ thì clear lỗi
    emailError.value = '';

    try {
      isLoading(true);
      await Future.delayed(const Duration(seconds: 1));
      Get.snackbar(
        'Thành công',
        'Mã xác nhận đã được gửi tới $input',
        backgroundColor: Colors.white,
        colorText: const Color(0xFF199A8E),
        icon: const Icon(Icons.check_circle, color: Color(0xFF199A8E)),
      );
      NavigatorHelper.toVerificationCodeScreen();
    } finally {
      isLoading(false);
    }
  }

  bool _validateEmail(String email) {
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    return emailRegex.hasMatch(email);
  }

  bool _validatePhone(String phone) {
    final phoneRegex =
        RegExp(r'^\+?\d{7,15}$'); // Kiểm tra cơ bản số điện thoại
    return phoneRegex.hasMatch(phone);
  }

  void onInputChanged(String value) {
    if (emailError.value.isNotEmpty) emailError.value = '';
  }

  Future<void> resetPassword() async {
    if (codeController.text.length != 6) {
      Get.snackbar(
        'Lỗi',
        'Vui lòng nhập mã xác nhận 6 chữ số hợp lệ',
        backgroundColor: Colors.white,
        colorText: Colors.red,
        icon: const Icon(Icons.warning_amber, color: Colors.red),
      );
      return;
    }

    try {
      isLoading(true);
      // Mô phỏng API call
      await Future.delayed(const Duration(seconds: 1));
      Get.offAllNamed('/login');
      Get.snackbar(
        'Thành công',
        'Đặt lại mật khẩu thành công',
        backgroundColor: Colors.white,
        colorText: const Color(0xFF199A8E),
        icon: const Icon(Icons.check_circle, color: Color(0xFF199A8E)),
      );
    } finally {
      isLoading(false);
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    codeController.dispose();
    super.onClose();
  }
}
