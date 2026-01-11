import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_getx_boilerplate/repositories/verification_code_repository.dart';
import 'package:flutter_getx_boilerplate/modules/base/base_controller.dart';
import 'package:flutter_getx_boilerplate/routes/navigator_helper.dart';
import 'package:flutter_getx_boilerplate/shared/constants/colors.dart';
import 'package:flutter_getx_boilerplate/shared/utils/size_config.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class VerificationCodeController
    extends BaseController<VerificationCodeRepository> {
  VerificationCodeController(super.repository);

  final codeController = TextEditingController();
  final codeFocusNode = FocusNode();

  final countdown = 5.obs;
  final canResend = false.obs;
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    _startCountdown();
  }

  void _startCountdown() {
    canResend.value = false;
    countdown.value = 5;

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countdown.value > 0) {
        countdown.value--;
      } else {
        canResend.value = true;
        timer.cancel();
      }
    });
  }

  void resendCode() {
    _startCountdown();
    Get.snackbar(
      'Thành công',
      'Mã xác nhận mới đã được gửi',
      backgroundColor: Colors.white,
      colorText: const Color(0xFF199A8E),
      icon: const Icon(Icons.check_circle, color: Color(0xFF199A8E)),
    );
  }

  void verifyCode() {
    final code = codeController.text.trim();
    if (code.length == 4) {
      _showSuccessDialog();
      NavigatorHelper.toBottomNavigationScreen();
    } else {
      Get.snackbar(
        'Lỗi',
        'Vui lòng nhập đủ mã xác nhận 4 chữ số',
        backgroundColor: Colors.white,
        colorText: Colors.red,
        icon: const Icon(Icons.warning_amber, color: Colors.red),
      );
    }
  }

  Future<void> _showSuccessDialog() async {
    return await Get.dialog(
      AlertDialog(
        backgroundColor: ColorConstants.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
              'Tài khoản đã được xác thực! Bạn có thể đăng nhập và sử dụng tất cả các tính năng.',
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
    _timer?.cancel();
    codeController.dispose();
    codeFocusNode.dispose();
    super.onClose();
  }
}
