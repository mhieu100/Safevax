import 'package:flutter/material.dart';
import 'package:flutter_getx_boilerplate/models/request/update_password_request.dart';
import 'package:flutter_getx_boilerplate/modules/base/base_controller.dart';
import 'package:flutter_getx_boilerplate/repositories/auth_repository.dart';
import 'package:flutter_getx_boilerplate/shared/services/storage_service.dart';
import 'package:get/get.dart';

class ChangePasswordController extends BaseController<AuthRepository> {
  ChangePasswordController(super.repository);

  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  var oldPasswordVisible = false.obs;
  var newPasswordVisible = false.obs;
  var confirmPasswordVisible = false.obs;
  var isLoading = false.obs;

  // Error states
  var oldPasswordError = Rx<String?>(null);
  var newPasswordError = Rx<String?>(null);
  var confirmPasswordError = Rx<String?>(null);

  bool validatePassword(String password) {
    return password.length >= 6;
  }

  void validateForm() {
    // Reset errors
    oldPasswordError.value = null;
    newPasswordError.value = null;
    confirmPasswordError.value = null;

    // Old password validation
    if (oldPasswordController.text.isEmpty) {
      oldPasswordError.value = 'Vui lòng nhập mật khẩu hiện tại';
    }

    // New password validation
    if (newPasswordController.text.isEmpty) {
      newPasswordError.value = 'Vui lòng nhập mật khẩu mới';
    } else if (!validatePassword(newPasswordController.text)) {
      newPasswordError.value = 'Mật khẩu tối thiểu 6 ký tự';
    }

    // Confirm password validation
    if (confirmPasswordController.text.isEmpty) {
      confirmPasswordError.value = 'Vui lòng xác nhận mật khẩu mới';
    } else if (newPasswordController.text != confirmPasswordController.text) {
      confirmPasswordError.value = 'Mật khẩu xác nhận không khớp';
    }
  }

  Future<void> updatePassword() async {
    validateForm();

    // Check for errors
    if (oldPasswordError.value != null ||
        newPasswordError.value != null ||
        confirmPasswordError.value != null) {
      Get.snackbar(
        'Lỗi',
        'Vui lòng điền đầy đủ và chính xác các thông tin.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
      return;
    }

    try {
      isLoading(true);

      final userEmail = StorageService.userData?['email'] ?? '';

      final request = UpdatePasswordRequest(
        email: userEmail,
        oldPassword: oldPasswordController.text,
        newPassword: newPasswordController.text,
      );

      await repository.updatePassword(request);

      Get.snackbar(
        'Thành công',
        'Mật khẩu đã được cập nhật thành công',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green.withOpacity(0.8),
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );

      // Clear form and go back
      oldPasswordController.clear();
      newPasswordController.clear();
      confirmPasswordController.clear();
      Get.back();
    } catch (e) {
      String errorMessage = 'Có lỗi xảy ra. Vui lòng thử lại.';
      if (e is Exception) {
        errorMessage = 'Cập nhật mật khẩu thất bại. Vui lòng kiểm tra lại.';
      }

      Get.snackbar(
        'Lỗi',
        errorMessage,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isLoading(false);
    }
  }

  @override
  void onClose() {
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
