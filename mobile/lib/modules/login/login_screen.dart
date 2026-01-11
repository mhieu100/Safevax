// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_getx_boilerplate/modules/login/login_controller.dart';
import 'package:flutter_getx_boilerplate/shared/constants/colors.dart';
import 'package:flutter_getx_boilerplate/shared/utils/size_config.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:get/get.dart';

class LoginScreen extends GetView<LoginController> {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.0.h, vertical: 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 40.h),
                // Animated logo with scale effect
                TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0.0, end: 1.0),
                  duration: const Duration(milliseconds: 800),
                  curve: Curves.elasticOut,
                  builder: (context, value, child) {
                    return Transform.scale(
                      scale: value,
                      child: Hero(
                        tag: 'logo',
                        child: Image.asset(
                          'assets/images/safe_vax_logo.png',
                          height: 80.h,
                          width: 80.h,
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: 16.h),
                // Animated title
                TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0.0, end: 1.0),
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.easeOut,
                  builder: (context, value, child) {
                    return Opacity(
                      opacity: value,
                      child: Transform.translate(
                        offset: Offset(0, 20 * (1 - value)),
                        child: Text(
                          'Đăng nhập',
                          style: TextStyle(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: 8.h),
                // Animated subtitle
                TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0.0, end: 1.0),
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.easeOut,
                  builder: (context, value, child) {
                    return Opacity(
                      opacity: value,
                      child: Transform.translate(
                        offset: Offset(0, 20 * (1 - value)),
                        child: Text(
                          'Chào mừng bạn quay trở lại',
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.grey[600],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: 32.h),
                Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(24.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Obx(() => AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                              child: TextField(
                                keyboardType: TextInputType.emailAddress,
                                style: const TextStyle(color: Colors.black),
                                controller: controller.emailController,
                                decoration: InputDecoration(
                                  fillColor: Colors.grey.withOpacity(0.1),
                                  filled: true,
                                  hintText: 'Nhập email của bạn',
                                  hintStyle: TextStyle(
                                    fontSize: 14.sp,
                                    color: Colors.grey,
                                  ),
                                  prefixIcon: const Icon(
                                    Icons.email_outlined,
                                    color: ColorConstants.primaryGreen,
                                  ),
                                  suffixIcon: Obx(() => AnimatedSwitcher(
                                        duration:
                                            const Duration(milliseconds: 300),
                                        child: controller.isEmailValid.value
                                            ? const Icon(Icons.check_circle,
                                                color: Colors.green,
                                                key: ValueKey('valid'))
                                            : const Icon(Icons.error,
                                                color: Colors.red,
                                                key: ValueKey('invalid')),
                                      )),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: controller.isEmailValid.value
                                          ? ColorConstants.primaryGreen
                                              .withOpacity(0.3)
                                          : Colors.red.withOpacity(0.5),
                                      width:
                                          controller.isEmailValid.value ? 1 : 2,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                        color: ColorConstants.primaryGreen,
                                        width: 2),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                        color: Colors.red, width: 2),
                                  ),
                                ),
                                onChanged: (value) {
                                  controller.isEmailValid.value =
                                      controller.validateEmail(value);
                                },
                              ),
                            )),
                        Obx(() => AnimatedOpacity(
                              opacity:
                                  !controller.isEmailValid.value ? 1.0 : 0.0,
                              duration: const Duration(milliseconds: 300),
                              child: !controller.isEmailValid.value
                                  ? Padding(
                                      padding: EdgeInsets.only(top: 8.0.h),
                                      child: Row(
                                        children: [
                                          Icon(Icons.error_outline,
                                              color: Colors.red, size: 16.sp),
                                          SizedBox(width: 4.w),
                                          Text(
                                            '*Vui lòng nhập email hợp lệ',
                                            style: TextStyle(
                                                color: Colors.red,
                                                fontSize: 12.sp),
                                          ),
                                        ],
                                      ),
                                    )
                                  : const SizedBox.shrink(),
                            )),
                        SizedBox(height: 16.h),
                        Obx(() => AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                              child: TextField(
                                controller: controller.passwordController,
                                obscureText: !controller.passwordVisible.value,
                                style: const TextStyle(color: Colors.black),
                                decoration: InputDecoration(
                                  fillColor: Colors.grey.withOpacity(0.1),
                                  filled: true,
                                  hintText: 'Nhập mật khẩu',
                                  hintStyle: TextStyle(
                                    fontSize: 14.sp,
                                    color: Colors.grey,
                                  ),
                                  prefixIcon: const Icon(
                                    Icons.lock_outline,
                                    color: ColorConstants.primaryGreen,
                                  ),
                                  suffixIcon: IconButton(
                                    icon: AnimatedSwitcher(
                                      duration:
                                          const Duration(milliseconds: 200),
                                      child: Icon(
                                        controller.passwordVisible.value
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                        color: ColorConstants.primaryGreen,
                                        key: ValueKey(
                                            controller.passwordVisible.value),
                                      ),
                                    ),
                                    onPressed: () =>
                                        controller.passwordVisible.toggle(),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: controller.isPasswordWrong.value
                                          ? Colors.red.withOpacity(0.5)
                                          : ColorConstants.primaryGreen
                                              .withOpacity(0.3),
                                      width: controller.isPasswordWrong.value
                                          ? 2
                                          : 1,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                      color: ColorConstants.primaryGreen,
                                      width: 2,
                                    ),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                        color: Colors.red, width: 2),
                                  ),
                                ),
                              ),
                            )),
                        Obx(() => AnimatedOpacity(
                              opacity:
                                  controller.isPasswordWrong.value ? 1.0 : 0.0,
                              duration: const Duration(milliseconds: 300),
                              child: controller.isPasswordWrong.value
                                  ? Padding(
                                      padding: EdgeInsets.only(top: 8.0.h),
                                      child: Row(
                                        children: [
                                          Icon(Icons.error_outline,
                                              color: Colors.red, size: 16.sp),
                                          SizedBox(width: 4.w),
                                          Text(
                                            'Sai tên tài khoản hoặc mật khẩu',
                                            style: TextStyle(
                                                color: Colors.red,
                                                fontSize: 12.sp),
                                          ),
                                        ],
                                      ),
                                    )
                                  : const SizedBox.shrink(),
                            )),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              controller.toForgotPasswordScreen();
                            },
                            child: const Text(
                              'Quên mật khẩu?',
                              style:
                                  TextStyle(color: ColorConstants.primaryGreen),
                            ),
                          ),
                        ),
                        SizedBox(height: 24.h),
                        // Enhanced login button with micro-interactions
                        Obx(() => AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              curve: Curves.easeInOut,
                              transform: controller.isLoading.value
                                  ? Matrix4.identity()
                                  : Matrix4.identity(),
                              child: ElevatedButton(
                                onPressed: () => controller.onLogin(),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: controller.isLoading.value
                                      ? Colors.grey
                                      : ColorConstants.primaryGreen,
                                  elevation: controller.isLoading.value ? 0 : 4,
                                  shadowColor: ColorConstants.primaryGreen
                                      .withOpacity(0.3),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  padding: EdgeInsets.symmetric(vertical: 16.h),
                                ),
                                child: AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 200),
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
                                          'Đăng nhập',
                                          key: const ValueKey('login_text'),
                                          style: TextStyle(
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                          ),
                                        ),
                                ),
                              ),
                            )),
                        SizedBox(height: 24.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Chưa có tài khoản? ",
                              style: TextStyle(
                                  color: Colors.black, fontSize: 14.sp),
                            ),
                            TextButton(
                              onPressed: () {
                                controller.toRegister();
                              },
                              child: const Text(
                                'Đăng ký',
                                style: TextStyle(
                                    color: ColorConstants.primaryGreen),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16.h),
                        Row(
                          children: [
                            const Expanded(child: Divider()),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.h),
                              child: const Text(
                                "HOẶC",
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                            const Expanded(child: Divider()),
                          ],
                        ),
                        SizedBox(height: 20.h),
                        SignInButton(
                          Buttons.Google,
                          text: "Đăng nhập với Google",
                          onPressed: () => controller.onGoogleLogin(),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
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
}
