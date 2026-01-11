import 'package:flutter/material.dart';
import 'package:flutter_getx_boilerplate/modules/veification_code/verification_code_controller.dart';
import 'package:flutter_getx_boilerplate/shared/constants/colors.dart';
import 'package:flutter_getx_boilerplate/shared/utils/size_config.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';

class VerificationCodeScreen extends GetView<VerificationCodeController> {
  const VerificationCodeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
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
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
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
                      onPressed: () => Get.back(),
                    ),
                    Expanded(
                      child: Text(
                        'Xác thực',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
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
                'Xác thực tài khoản',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.black.withOpacity(0.8),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24.h),
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
                    padding: EdgeInsets.all(24.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Nhập mã xác thực',
                          style: TextStyle(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        RichText(
                          text: TextSpan(
                            style: TextStyle(fontSize: 16.sp),
                            children: const [
                              TextSpan(
                                text: 'Nhập mã chúng tôi đã gửi đến số ',
                                style: TextStyle(color: Colors.grey),
                              ),
                              TextSpan(
                                text: '08528188***',
                                style: TextStyle(
                                    color: ColorConstants.primaryGreen),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 40.h),

                        // Nhập mã 4 chữ số
                        Center(
                          child: Pinput(
                            length: 4,
                            controller: controller.codeController,
                            focusNode: controller.codeFocusNode,
                            defaultPinTheme: PinTheme(
                              width: 64.w,
                              height: 64.h,
                              textStyle: TextStyle(
                                fontSize: 32.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: ColorConstants.primaryGreen,
                                    width: 2),
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            focusedPinTheme: PinTheme(
                              width: 64.w,
                              height: 64.h,
                              textStyle: TextStyle(
                                fontSize: 32.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: ColorConstants.primaryGreen,
                                    width: 2.w),
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            onCompleted: (pin) {
                              controller.verifyCode();
                            },
                          ),
                        ),
                        SizedBox(height: 40.h),

                        // Nút xác nhận
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: controller.verifyCode,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ColorConstants.primaryGreen,
                              padding: EdgeInsets.symmetric(vertical: 16.h),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.w),
                              ),
                            ),
                            child: Text(
                              'Xác nhận',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 16.h),

                        // Gửi lại mã
                        Obx(
                          () => Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  controller.canResend.value
                                      ? 'Chưa nhận được mã? '
                                      : 'Gửi lại mã sau ',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14.sp,
                                  ),
                                ),
                                TextButton(
                                  onPressed: controller.canResend.value
                                      ? controller.resendCode
                                      : null,
                                  child: Text(
                                    controller.canResend.value
                                        ? 'Gửi lại'
                                        : '${controller.countdown.value}s',
                                    style: TextStyle(
                                      color: controller.canResend.value
                                          ? ColorConstants.primaryGreen
                                          : Colors.grey,
                                      fontSize: 14.sp,
                                    ),
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
