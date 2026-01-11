import 'package:flutter/material.dart';
import 'package:flutter_getx_boilerplate/modules/forgot_password/forgot_password_controller.dart';
import 'package:flutter_getx_boilerplate/shared/shared.dart';
import 'package:get/get.dart';

class ForgotPasswordScreen extends GetView<ForgotPasswordController> {
  const ForgotPasswordScreen({super.key});
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
                        'Quên mật khẩu',
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
                'Khôi phục mật khẩu',
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
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(24.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Quên mật khẩu?',
                          style: TextStyle(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          'Nhập email hoặc số điện thoại để nhận mã xác nhận',
                          style: TextStyle(fontSize: 16.sp, color: Colors.grey),
                        ),
                        SizedBox(height: 30.h),

            // Chọn Email/Phone
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[200], 
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  _buildToggleButton('Email', true),
                  _buildToggleButton('Số điện thoại', false),
                ],
              ),
            ),
            SizedBox(height: 20.h),

            // Input Email/Phone
            Obx(
              () => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: TextField(
                  controller: controller.emailController,
                  style: const TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey.withOpacity(0.1),
                    hintText: controller.isEmailSelected.value
                        ? 'Nhập email của bạn'
                        : 'Nhập số điện thoại',
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 14.sp),
                    prefixIcon: Obx(() => AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: Icon(
                        controller.isEmailSelected.value
                            ? Icons.email_outlined
                            : Icons.phone_iphone_outlined,
                        color: ColorConstants.primaryGreen,
                        key: ValueKey(controller.isEmailSelected.value),
                      ),
                    )),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: controller.emailError.value.isNotEmpty
                            ? Colors.red.withOpacity(0.5)
                            : ColorConstants.primaryGreen.withOpacity(0.3),
                        width: controller.emailError.value.isNotEmpty ? 2 : 1,
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
                      borderSide: const BorderSide(color: Colors.red, width: 2),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 16.h,
                      horizontal: 16.w,
                    ),
                  ),
                  keyboardType: controller.isEmailSelected.value
                      ? TextInputType.emailAddress
                      : TextInputType.number,
                  onChanged: controller.onInputChanged,
                ),
              ),
            ),
            Obx(() => AnimatedOpacity(
              opacity: controller.emailError.value.isNotEmpty ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 300),
              child: controller.emailError.value.isNotEmpty
                  ? Padding(
                      padding: EdgeInsets.only(top: 8.0.h),
                      child: Row(
                        children: [
                          Icon(Icons.error_outline, color: Colors.red, size: 16.sp),
                          SizedBox(width: 4.w),
                          Text(
                            controller.emailError.value,
                            style: TextStyle(color: Colors.red, fontSize: 12.sp),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox.shrink(),
            )),

            SizedBox(height: 20.h),

            // Nút Đặt lại mật khẩu
            Obx(() => SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed:
                        controller.isLoading.value ? null : controller.sendCode,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      backgroundColor: ColorConstants.primaryGreen,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: controller.isLoading.value
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text('Đặt lại mật khẩu',
                            style: TextStyle(
                                color: Colors.white, fontSize: 16.sp)),
                  ),
                )),
                     ],
                   ),
                 ),
               ),
             ),
           ],
         ),
       ),
     ),
   );
  }

  Widget _buildToggleButton(String text, bool isEmail) {
    return Obx(() => Expanded(
          child: Material(
            color: controller.isEmailSelected.value == isEmail
                ? ColorConstants.primaryGreen
                : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            child: InkWell(
              onTap: () => controller.toggleEmailPhone(isEmail),
              borderRadius: BorderRadius.circular(10),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 12.h),
                alignment: Alignment.center,
                child: Text(
                  text,
                  style: TextStyle(
                    color: controller.isEmailSelected.value == isEmail
                        ? Colors.white
                        : Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
