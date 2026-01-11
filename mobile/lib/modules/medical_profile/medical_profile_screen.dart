// lib/modules/auth/medical_profile_screen.dart
// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_getx_boilerplate/modules/medical_profile/medical_profile_controller.dart';
import 'package:flutter_getx_boilerplate/shared/shared.dart';
import 'package:get/get.dart';

class MedicalProfileScreen extends GetView<MedicalProfileController> {
  const MedicalProfileScreen({super.key});

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
                              controller.nameController.text.isNotEmpty ||
                                  controller.birthDate.value != null ||
                                  controller.addressController.text.isNotEmpty;

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
                          'Hồ Sơ Y Tế',
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
                  'Tạo hồ sơ y tế',
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
                            'Thông tin hồ sơ y tế',
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            'Điền thông tin để bảo vệ sức khỏe của bạn',
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
                                  // Medical Profile Information
                                  Obx(() => _buildSection(
                                        title: 'Thông Tin Hồ Sơ Y Tế',
                                        icon: Icons.health_and_safety,
                                        children: [
                                          _buildInputField(
                                            controller:
                                                controller.nameController,
                                            label: 'Họ và Tên',
                                            hint: 'Nhập họ và tên',
                                            icon: Icons.person_outline,
                                            error: controller.nameError,
                                          ),
                                          SizedBox(height: 16.h),
                                          _buildInputField(
                                            controller:
                                                controller.addressController,
                                            label: 'Địa chỉ',
                                            hint: 'Nhập địa chỉ',
                                            icon: Icons.home_outlined,
                                            error: controller.addressError,
                                          ),
                                          SizedBox(height: 16.h),
                                          _buildInputField(
                                            controller:
                                                controller.heightController,
                                            label: 'Chiều cao (cm)',
                                            hint: 'Ví dụ: 170',
                                            icon: Icons.height,
                                            error: controller.heightError,
                                            keyboardType: TextInputType.number,
                                          ),
                                          SizedBox(height: 16.h),
                                          _buildInputField(
                                            controller:
                                                controller.weightController,
                                            label: 'Cân nặng (kg)',
                                            hint: 'Ví dụ: 70',
                                            icon: Icons.monitor_weight,
                                            error: controller.weightError,
                                            keyboardType: TextInputType.number,
                                          ),
                                          SizedBox(height: 16.h),
                                          _buildInputField(
                                            controller:
                                                controller.phoneController,
                                            label: 'Số điện thoại',
                                            hint: 'Ví dụ: 090xxxxxxx',
                                            icon: Icons.phone_outlined,
                                            error: controller.phoneError,
                                            keyboardType: TextInputType.phone,
                                          ),
                                          SizedBox(height: 16.h),
                                          _buildDatePicker(
                                            context: context,
                                            label: 'Ngày sinh',
                                            value: controller.birthDate,
                                            error: controller.birthDateError,
                                          ),
                                          SizedBox(height: 16.h),
                                          _buildDropdown(
                                            label: 'Giới tính',
                                            value: controller.selectedGender,
                                            items: ['Nam', 'Nữ'],
                                            icon: Icons.person,
                                            error: controller.genderError,
                                          ),
                                          SizedBox(height: 16.h),
                                          _buildInputField(
                                            controller: controller
                                                .identityNumberController,
                                            label: 'Số định danh',
                                            hint: 'Nhập số CCCD/CMND',
                                            icon: Icons.badge_outlined,
                                            error:
                                                controller.identityNumberError,
                                            keyboardType: TextInputType.number,
                                          ),
                                          SizedBox(height: 16.h),
                                          _buildDropdown(
                                            label: 'Nhóm máu',
                                            value: controller.selectedBloodType,
                                            items: ['A', 'B', 'AB', 'O'],
                                            icon: Icons.bloodtype,
                                            error: controller.bloodTypeError,
                                          ),
                                        ],
                                      )),
                                  SizedBox(height: 32.h),

                                  // Debug buttons for testing (only in debug mode)
                                  if (const bool.fromEnvironment(
                                          'dart.vm.product') ==
                                      false) ...[
                                    Container(
                                      margin: EdgeInsets.only(bottom: 16.h),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: ElevatedButton.icon(
                                              onPressed: () =>
                                                  controller.loadMockData(0),
                                              icon: Icon(Icons.person,
                                                  size: 16.sp),
                                              label: Text(
                                                'Mock 1',
                                                style:
                                                    TextStyle(fontSize: 14.sp),
                                              ),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.blue,
                                                foregroundColor: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 12.h),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 8.w),
                                          Expanded(
                                            child: ElevatedButton.icon(
                                              onPressed: () =>
                                                  controller.loadMockData(1),
                                              icon: Icon(Icons.person,
                                                  size: 16.sp),
                                              label: Text(
                                                'Mock 2',
                                                style:
                                                    TextStyle(fontSize: 14.sp),
                                              ),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.orange,
                                                foregroundColor: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 12.h),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 8.w),
                                          Expanded(
                                            child: ElevatedButton.icon(
                                              onPressed:
                                                  controller.loadRandomMockData,
                                              icon: Icon(Icons.shuffle,
                                                  size: 16.sp),
                                              label: Text(
                                                'Random',
                                                style:
                                                    TextStyle(fontSize: 14.sp),
                                              ),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.purple,
                                                foregroundColor: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 12.h),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],

                                  // Submit Button
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
                                              : () => controller
                                                  .createMedicalProfile(),
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
                                                    'Tạo Hồ Sơ Y Tế',
                                                    key: const ValueKey(
                                                        'create_profile_text'),
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

  Widget _buildSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.h),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
        border: Border.all(
          color: Colors.grey.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: ColorConstants.primaryGreen.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10.h),
                  ),
                  child: Icon(
                    icon,
                    color: ColorConstants.primaryGreen,
                    size: 20.sp,
                  ),
                ),
                SizedBox(width: 12.w),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    Rx<String?>? error,
    int maxLines = 1,
    bool obscureText = false,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.h),
            border: Border.all(
              color: error?.value != null
                  ? Colors.red.withOpacity(0.4)
                  : Colors.grey.withOpacity(0.3),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 3,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: TextField(
            controller: controller,
            maxLines: maxLines,
            obscureText: obscureText,
            keyboardType: keyboardType,
            style: TextStyle(
              color: Colors.black,
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              filled: false,
              hintText: hint,
              hintStyle: TextStyle(
                fontSize: 16.sp,
                color: Colors.grey[500],
                fontWeight: FontWeight.w400,
              ),
              prefixIcon: Container(
                padding: EdgeInsets.all(12.w),
                child: Icon(
                  icon,
                  color: error?.value != null
                      ? Colors.red.withOpacity(0.7)
                      : ColorConstants.primaryGreen,
                  size: 20.sp,
                ),
              ),
              errorText: null, // Handle error separately
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                vertical: maxLines > 1 ? 16.h : 18.h,
                horizontal: 16.w,
              ),
            ),
            onChanged: (_) => error?.value = null,
          ),
        ),
        if (error?.value != null) ...[
          SizedBox(height: 6.h),
          Row(
            children: [
              Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 16.sp,
              ),
              SizedBox(width: 6.w),
              Expanded(
                child: Text(
                  error!.value!,
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildDatePicker({
    required BuildContext context,
    required String label,
    required Rx<DateTime?> value,
    required Rx<String?> error,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 8.h),
        GestureDetector(
          onTap: () => controller.selectBirthDate(context),
          child: Container(
            height: 56.h,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.h),
              border: Border.all(
                color: error.value != null
                    ? Colors.red.withOpacity(0.4)
                    : Colors.grey.withOpacity(0.3),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 3,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: error.value != null
                        ? Colors.red.withOpacity(0.1)
                        : ColorConstants.primaryGreen.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.h),
                  ),
                  child: Icon(
                    Icons.calendar_today,
                    color: error.value != null
                        ? Colors.red.withOpacity(0.7)
                        : ColorConstants.primaryGreen,
                    size: 18.sp,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Obx(() => Text(
                        value.value != null
                            ? '${value.value!.day}/${value.value!.month}/${value.value!.year}'
                            : 'Chọn ngày sinh',
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: value.value != null
                              ? Colors.black
                              : Colors.grey[500],
                          fontWeight: FontWeight.w500,
                        ),
                      )),
                ),
                Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.grey[400],
                  size: 20.sp,
                ),
              ],
            ),
          ),
        ),
        if (error.value != null) ...[
          SizedBox(height: 6.h),
          Row(
            children: [
              Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 16.sp,
              ),
              SizedBox(width: 6.w),
              Expanded(
                child: Text(
                  error.value!,
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  // }

  Widget _buildDropdown({
    required String label,
    required Rx<String> value,
    required List<String> items,
    required IconData icon,
    Rx<String?>? error,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.h),
            border: Border.all(
              color: error?.value != null
                  ? Colors.red.withOpacity(0.4)
                  : Colors.grey.withOpacity(0.3),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 3,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: DropdownButtonFormField<String>(
            value: value.value,
            decoration: InputDecoration(
              filled: false,
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              prefixIcon: Container(
                padding: EdgeInsets.all(8.w),
                child: Icon(
                  icon,
                  color: error?.value != null
                      ? Colors.red.withOpacity(0.7)
                      : ColorConstants.primaryGreen,
                  size: 20.sp,
                ),
              ),
            ),
            style: TextStyle(
              color: Colors.black,
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
            ),
            dropdownColor: Colors.white,
            icon: Icon(
              Icons.keyboard_arrow_down,
              color: Colors.grey[400],
              size: 20.sp,
            ),
            items: items.map((item) {
              return DropdownMenuItem(
                value: item,
                child: Text(
                  item,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }).toList(),
            onChanged: (newValue) {
              if (newValue != null) {
                value.value = newValue;
              }
            },
          ),
        ),
        if (error?.value != null) ...[
          SizedBox(height: 6.h),
          Row(
            children: [
              Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 16.sp,
              ),
              SizedBox(width: 6.w),
              Expanded(
                child: Text(
                  error!.value!,
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  // Widget _buildGenderOption(
  //     String value, IconData icon, String label, bool isSelected) {
  //   return GestureDetector(
  //     onTap: () {
  //       controller.selectedGender.value = value;
  //       controller.genderError.value = null;
  //     },
  //     child: AnimatedContainer(
  //       duration: Duration(milliseconds: 200),
  //       margin: EdgeInsets.all(3.w),
  //       decoration: BoxDecoration(
  //         color: isSelected
  //             ? ColorConstants.primaryGreen.withOpacity(0.15)
  //             : Colors.transparent,
  //         borderRadius: BorderRadius.circular(12.h),
  //         border: Border.all(
  //           color: isSelected
  //               ? ColorConstants.primaryGreen
  //               : Colors.grey.withOpacity(0.3),
  //           width: isSelected ? 2 : 1.5,
  //         ),
  //         boxShadow: isSelected
  //             ? [
  //                 BoxShadow(
  //                   color: ColorConstants.primaryGreen.withOpacity(0.2),
  //                   blurRadius: 8,
  //                   offset: const Offset(0, 2),
  //                 ),
  //               ]
  //             : null,
  //       ),
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: [
  //           Icon(
  //             icon,
  //             color:
  //               isSelected ? ColorConstants.primaryGreen : Colors.grey[500],
  //             size: 20.sp,
  //           ),
  //           SizedBox(height: 6.h),
  //           Text(
  //             label,
  //             style: TextStyle(
  //               fontSize: 15.sp,
  //               color:
  //                   isSelected ? ColorConstants.primaryGreen : Colors.grey[600],
  //               fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
  //               letterSpacing: -0.1,
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}

Future<bool> _showExitConfirmation(BuildContext context) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(
        'Hủy bỏ thay đổi?',
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
        borderRadius: BorderRadius.circular(16.h),
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
