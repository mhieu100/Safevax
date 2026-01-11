// lib/modules/auth/signup_screen.dart
// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_getx_boilerplate/modules/register/register_controller.dart';
import 'package:flutter_getx_boilerplate/shared/constants/colors.dart';
import 'package:flutter_getx_boilerplate/shared/services/storage_service.dart';
import 'package:flutter_getx_boilerplate/shared/utils/size_config.dart';
import 'package:get/get.dart';

class RegisterScreen extends GetView<RegisterController> {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        Navigator.pop(context);
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                ColorConstants.primaryGreen.withOpacity(0.1),
                ColorConstants.lightBackGround,
              ],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                // Custom App Bar
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Container(
                          padding: EdgeInsets.all(8.w),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.arrow_back_ios_rounded,
                            color: Colors.black,
                            size: 18.sp,
                          ),
                        ),
                        onPressed: () async {
                          final hasUnsavedChanges =
                              controller.emailController.text.isNotEmpty ||
                                  controller.passwordController.text.isNotEmpty;
                          if (!hasUnsavedChanges) {
                            Get.back();
                            return;
                          }

                          final shouldPop =
                              await _showExitConfirmation(context);
                          if (shouldPop) {
                            Get.back();
                          }
                        },
                      ),
                      Expanded(
                        child: Text(
                          'Đăng Ký',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.black.withOpacity(0.8),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(width: 48.w), // Balance the back button
                    ],
                  ),
                ),
                // Logo
                Hero(
                  tag: 'logo',
                  child: Image.asset(
                    'assets/images/safe_vax_logo.png',
                    height: 60.h,
                    width: 60.h,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Tạo tài khoản mới',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16.h),
                // Form Card
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(top: 16.h),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 24.h),
                          Text(
                            'Tạo tài khoản',
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            'Điền thông tin tài khoản để hoàn tất đăng ký',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.grey[600],
                              height: 1.4,
                            ),
                          ),
                          SizedBox(height: 24.h),
                          // Scrollable content
                          Expanded(
                            child: SingleChildScrollView(
                              physics: const ClampingScrollPhysics(),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  // Email Field
                                  _buildSectionTitle('Email'),
                                  SizedBox(height: 8.h),
                                  Obx(
                                    () => TextField(
                                      controller: controller.emailController,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16.sp,
                                      ),
                                      keyboardType: TextInputType.emailAddress,
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor:
                                            ColorConstants.lightBackGround,
                                        hintText: 'Nhập địa chỉ email',
                                        hintStyle: TextStyle(
                                          fontSize: 16.sp,
                                          color: Colors.grey[400],
                                        ),
                                        prefixIcon: Icon(
                                          Icons.email_outlined,
                                          color: Colors.grey[500],
                                          size: 20.sp,
                                        ),
                                        errorText: controller.emailError.value,
                                        border: _inputBorder(),
                                        enabledBorder: _inputBorder(),
                                        focusedBorder: _inputBorder().copyWith(
                                          borderSide: const BorderSide(
                                            color: ColorConstants.primaryGreen,
                                            width: 1.5,
                                          ),
                                        ),
                                        errorBorder: _inputBorder().copyWith(
                                          borderSide: const BorderSide(
                                            color: Colors.red,
                                            width: 1.5,
                                          ),
                                        ),
                                        contentPadding: EdgeInsets.symmetric(
                                          vertical: 16.h,
                                          horizontal: 16.w,
                                        ),
                                      ),
                                      onChanged: (_) =>
                                          controller.emailError.value = null,
                                    ),
                                  ),
                                  SizedBox(height: 20.h),

                                  // Password Field
                                  _buildSectionTitle('Mật khẩu'),
                                  SizedBox(height: 8.h),
                                  Obx(() => TextField(
                                        controller:
                                            controller.passwordController,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16.sp,
                                        ),
                                        obscureText:
                                            !controller.passwordVisible.value,
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor:
                                              ColorConstants.lightBackGround,
                                          hintText: 'Nhập mật khẩu',
                                          hintStyle: TextStyle(
                                            fontSize: 16.sp,
                                            color: Colors.grey[400],
                                          ),
                                          prefixIcon: Icon(
                                            Icons.lock_outline,
                                            color: Colors.grey[500],
                                            size: 20.sp,
                                          ),
                                          suffixIcon: IconButton(
                                            icon: Icon(
                                              controller.passwordVisible.value
                                                  ? Icons.visibility
                                                  : Icons.visibility_off,
                                              color: Colors.grey[500],
                                              size: 20.sp,
                                            ),
                                            onPressed: () => controller
                                                .passwordVisible
                                                .toggle(),
                                          ),
                                          errorText:
                                              controller.passwordError.value,
                                          border: _inputBorder(),
                                          enabledBorder: _inputBorder(),
                                          focusedBorder:
                                              _inputBorder().copyWith(
                                            borderSide: const BorderSide(
                                              color:
                                                  ColorConstants.primaryGreen,
                                              width: 1.5,
                                            ),
                                          ),
                                          errorBorder: _inputBorder().copyWith(
                                            borderSide: const BorderSide(
                                              color: Colors.red,
                                              width: 1.5,
                                            ),
                                          ),
                                          contentPadding: EdgeInsets.symmetric(
                                            vertical: 16.h,
                                            horizontal: 16.w,
                                          ),
                                        ),
                                        onChanged: (_) => controller
                                            .passwordError.value = null,
                                      )),
                                  SizedBox(height: 20.h),

                                  // Confirm Password Field
                                  _buildSectionTitle('Xác nhận mật khẩu'),
                                  SizedBox(height: 8.h),
                                  Obx(() => TextField(
                                        controller: controller
                                            .confirmPasswordController,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16.sp,
                                        ),
                                        obscureText: !controller
                                            .confirmPasswordVisible.value,
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor:
                                              ColorConstants.lightBackGround,
                                          hintText: 'Nhập lại mật khẩu',
                                          hintStyle: TextStyle(
                                            fontSize: 16.sp,
                                            color: Colors.grey[400],
                                          ),
                                          prefixIcon: Icon(
                                            Icons.lock_outline,
                                            color: Colors.grey[500],
                                            size: 20.sp,
                                          ),
                                          suffixIcon: IconButton(
                                            icon: Icon(
                                              controller.confirmPasswordVisible
                                                      .value
                                                  ? Icons.visibility
                                                  : Icons.visibility_off,
                                              color: Colors.grey[500],
                                              size: 20.sp,
                                            ),
                                            onPressed: () => controller
                                                .confirmPasswordVisible
                                                .toggle(),
                                          ),
                                          errorText: controller
                                              .confirmPasswordError.value,
                                          border: _inputBorder(),
                                          enabledBorder: _inputBorder(),
                                          focusedBorder:
                                              _inputBorder().copyWith(
                                            borderSide: const BorderSide(
                                              color:
                                                  ColorConstants.primaryGreen,
                                              width: 1.5,
                                            ),
                                          ),
                                          errorBorder: _inputBorder().copyWith(
                                            borderSide: const BorderSide(
                                              color: Colors.red,
                                              width: 1.5,
                                            ),
                                          ),
                                          contentPadding: EdgeInsets.symmetric(
                                            vertical: 16.h,
                                            horizontal: 16.w,
                                          ),
                                        ),
                                        onChanged: (_) => controller
                                            .confirmPasswordError.value = null,
                                      )),
                                  SizedBox(height: 24.h),

                                  // Display patient info from medical profile
                                  Container(
                                    padding: EdgeInsets.all(16.w),
                                    decoration: BoxDecoration(
                                      color: ColorConstants.lightBackGround,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: ColorConstants.primaryGreen
                                            .withOpacity(0.2),
                                        width: 1,
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.check_circle,
                                              color:
                                                  ColorConstants.primaryGreen,
                                              size: 20.sp,
                                            ),
                                            SizedBox(width: 8.w),
                                            Text(
                                              'Thông tin hồ sơ đã được lưu',
                                              style: TextStyle(
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w600,
                                                color:
                                                    ColorConstants.primaryGreen,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 12.h),
                                        Text(
                                          'Họ tên: ${controller.nameController.text}',
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        SizedBox(height: 4.h),
                                        Text(
                                          'Số điện thoại: ${controller.phoneController.text}',
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        SizedBox(height: 4.h),
                                        Text(
                                          'Địa chỉ: ${StorageService.patientProfileData?['dia_chi'] ?? ''}',
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        SizedBox(height: 4.h),
                                        Text(
                                          'Chiều cao: ${StorageService.patientProfileData?['chieu_cao_cm'] ?? ''} cm',
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        SizedBox(height: 4.h),
                                        Text(
                                          'Cân nặng: ${StorageService.patientProfileData?['can_nang_kg'] ?? ''} kg',
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        SizedBox(height: 4.h),
                                        Text(
                                          'Ngày sinh: ${StorageService.patientProfileData?['ngay_sinh'] ?? ''}',
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        SizedBox(height: 4.h),
                                        Text(
                                          'Giới tính: ${StorageService.patientProfileData?['gioi_tinh'] ?? ''}',
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        SizedBox(height: 4.h),
                                        Text(
                                          'Số định danh: ${StorageService.patientProfileData?['so_dinh_danh'] ?? ''}',
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        SizedBox(height: 4.h),
                                        Text(
                                          'Nhóm máu: ${StorageService.patientProfileData?['nhom_mau'] ?? ''}',
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 20.h),

                                  // Terms Checkbox
                                  Obx(() => Container(
                                        decoration: BoxDecoration(
                                          color: ColorConstants.lightBackGround,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Row(
                                          children: [
                                            Checkbox(
                                              value:
                                                  controller.agreeToTerms.value,
                                              onChanged: (value) => controller
                                                  .agreeToTerms(value),
                                              fillColor: WidgetStateProperty
                                                  .resolveWith<Color>((states) {
                                                if (states.contains(
                                                    WidgetState.selected)) {
                                                  return ColorConstants
                                                      .primaryGreen;
                                                }
                                                return Colors.transparent;
                                              }),
                                              checkColor: Colors.white,
                                              side: WidgetStateBorderSide
                                                  .resolveWith((states) {
                                                return BorderSide(
                                                  color: controller
                                                          .agreeToTerms.value
                                                      ? ColorConstants
                                                          .primaryGreen
                                                      : Colors.grey[400]!,
                                                );
                                              }),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ),
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                    right: 16.w),
                                                child: Text.rich(
                                                  TextSpan(
                                                    text: 'Tôi đồng ý với ',
                                                    style: TextStyle(
                                                      color: Colors.grey[700],
                                                      fontSize: 14.sp,
                                                    ),
                                                    children: [
                                                      const TextSpan(
                                                        text:
                                                            'Điều khoản dịch vụ',
                                                        style: TextStyle(
                                                          color: ColorConstants
                                                              .primaryGreen,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text: ' và ',
                                                        style: TextStyle(
                                                          color:
                                                              Colors.grey[700],
                                                          fontSize: 14.sp,
                                                        ),
                                                      ),
                                                      const TextSpan(
                                                        text:
                                                            'Chính sách bảo mật',
                                                        style: TextStyle(
                                                          color: ColorConstants
                                                              .primaryGreen,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )),
                                  SizedBox(height: 32.h),

                                  // Enhanced Sign Up Button with micro-interactions
                                  Obx(() => AnimatedContainer(
                                        duration:
                                            const Duration(milliseconds: 200),
                                        curve: Curves.easeInOut,
                                        transform: controller.isLoading.value
                                            ? Matrix4.identity()
                                                .scaled(0.95, 0.95)
                                            : Matrix4.identity(),
                                        child: ElevatedButton(
                                          onPressed: controller.isLoading.value
                                              ? null
                                              : () => controller.signUp(),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: controller
                                                    .isLoading.value
                                                ? Colors.grey
                                                : ColorConstants.primaryGreen,
                                            foregroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            padding: EdgeInsets.symmetric(
                                              vertical: 18.h,
                                            ),
                                            elevation:
                                                controller.isLoading.value
                                                    ? 0
                                                    : 2,
                                            shadowColor: controller
                                                    .isLoading.value
                                                ? Colors.transparent
                                                : ColorConstants.primaryGreen
                                                    .withOpacity(0.3),
                                          ),
                                          child: AnimatedSwitcher(
                                            duration: const Duration(
                                                milliseconds: 200),
                                            child: controller.isLoading.value
                                                ? SizedBox(
                                                    width: 24.w,
                                                    height: 24.h,
                                                    child:
                                                        const CircularProgressIndicator(
                                                      color: Colors.white,
                                                      strokeWidth: 2,
                                                    ),
                                                  )
                                                : Text(
                                                    'Đăng ký',
                                                    key: const ValueKey(
                                                        'register_text'),
                                                    style: TextStyle(
                                                      fontSize: 16.sp,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                          ),
                                        ),
                                      )),
                                  SizedBox(height: 24.h),

                                  // Already have an account? Login
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Đã có tài khoản? ",
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 14.sp,
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () => Get.back(),
                                        style: TextButton.styleFrom(
                                          padding: EdgeInsets.zero,
                                          minimumSize: Size.zero,
                                          tapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                        ),
                                        child: Text(
                                          'Đăng nhập',
                                          style: TextStyle(
                                            color: ColorConstants.primaryGreen,
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 32.h),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
        color: Colors.black,
      ),
    );
  }

  OutlineInputBorder _inputBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    );
  }
}

Future<bool> _showExitConfirmation(BuildContext context) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(
        'Hủy thay đổi?',
        style: TextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
      content: Text(
        'Bạn có thay đổi chưa lưu. Bạn có chắc chắn muốn thoát?',
        style: TextStyle(
          fontSize: 14.sp,
          color: Colors.grey[600],
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          style: TextButton.styleFrom(
            foregroundColor: Colors.grey[600],
          ),
          child: Text(
            'Hủy',
            style: TextStyle(
              fontSize: 14.sp,
            ),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          style: TextButton.styleFrom(
            foregroundColor: ColorConstants.primaryGreen,
          ),
          child: Text(
            'Thoát',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    ),
  );
  return result ?? false;
}
