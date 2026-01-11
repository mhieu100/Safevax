import 'package:flutter/material.dart';
import 'package:flutter_getx_boilerplate/modules/change_password/change_password_controller.dart';
import 'package:flutter_getx_boilerplate/shared/constants/colors.dart';
import 'package:flutter_getx_boilerplate/shared/utils/size_config.dart';
import 'package:get/get.dart';

class ChangePasswordScreen extends GetView<ChangePasswordController> {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Đổi mật khẩu'),
        backgroundColor: ColorConstants.primaryGreen,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFF8FCFC),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16.h),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Old Password Field
                        _buildSectionTitle('Mật khẩu hiện tại'),
                        SizedBox(height: 8.h),
                        Obx(() => TextField(
                              controller: controller.oldPasswordController,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16.sp,
                              ),
                              obscureText: !controller.oldPasswordVisible.value,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: ColorConstants.lightBackGround,
                                hintText: 'Nhập mật khẩu hiện tại',
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
                                    controller.oldPasswordVisible.value
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Colors.grey[500],
                                    size: 20.sp,
                                  ),
                                  onPressed: () =>
                                      controller.oldPasswordVisible.toggle(),
                                ),
                                errorText: controller.oldPasswordError.value,
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
                                  controller.oldPasswordError.value = null,
                            )),
                        SizedBox(height: 16.h),

                        // New Password Field
                        _buildSectionTitle('Mật khẩu mới'),
                        SizedBox(height: 8.h),
                        Obx(() => TextField(
                              controller: controller.newPasswordController,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16.sp,
                              ),
                              obscureText: !controller.newPasswordVisible.value,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: ColorConstants.lightBackGround,
                                hintText: 'Nhập mật khẩu mới',
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
                                    controller.newPasswordVisible.value
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Colors.grey[500],
                                    size: 20.sp,
                                  ),
                                  onPressed: () =>
                                      controller.newPasswordVisible.toggle(),
                                ),
                                errorText: controller.newPasswordError.value,
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
                                  controller.newPasswordError.value = null,
                            )),
                        SizedBox(height: 16.h),

                        // Confirm Password Field
                        _buildSectionTitle('Xác nhận mật khẩu mới'),
                        SizedBox(height: 8.h),
                        Obx(() => TextField(
                              controller: controller.confirmPasswordController,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16.sp,
                              ),
                              obscureText:
                                  !controller.confirmPasswordVisible.value,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: ColorConstants.lightBackGround,
                                hintText: 'Nhập lại mật khẩu mới',
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
                                    controller.confirmPasswordVisible.value
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Colors.grey[500],
                                    size: 20.sp,
                                  ),
                                  onPressed: () => controller
                                      .confirmPasswordVisible
                                      .toggle(),
                                ),
                                errorText:
                                    controller.confirmPasswordError.value,
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
                                  controller.confirmPasswordError.value = null,
                            )),
                        SizedBox(height: 24.h),

                        // Update Password Button
                        Obx(() => ElevatedButton(
                              onPressed: controller.isLoading.value
                                  ? null
                                  : () => controller.updatePassword(),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: controller.isLoading.value
                                    ? Colors.grey
                                    : ColorConstants.primaryGreen,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: EdgeInsets.symmetric(
                                  vertical: 18.h,
                                ),
                                elevation: controller.isLoading.value ? 0 : 2,
                              ),
                              child: controller.isLoading.value
                                  ? SizedBox(
                                      width: 24.w,
                                      height: 24.h,
                                      child: const CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : Text(
                                      'Cập nhật mật khẩu',
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                            )),
                        SizedBox(height: 16.h),
                      ],
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
