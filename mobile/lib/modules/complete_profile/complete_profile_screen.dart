import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_getx_boilerplate/modules/complete_profile/complete_profile_controller.dart';
import 'package:flutter_getx_boilerplate/shared/shared.dart';
import 'package:get/get.dart';

class CompleteProfileScreen extends GetView<CompleteProfileController> {
  const CompleteProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hoàn thiện hồ sơ'),
        backgroundColor: ColorConstants.primaryGreen,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Vui lòng điền đầy đủ thông tin hồ sơ y tế để tiếp tục',
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(height: 24.h),
                      Obx(() => _buildInputField(
                            controller: controller.nameController,
                            label: 'Họ và Tên',
                            hint: 'Nhập họ và tên',
                            icon: Icons.person,
                            error: controller.nameError,
                          )),
                      SizedBox(height: 16.h),
                      Obx(() => _buildInputField(
                            controller: controller.addressController,
                            label: 'Địa chỉ',
                            hint: 'Nhập địa chỉ',
                            icon: Icons.home,
                            error: controller.addressError,
                          )),
                      SizedBox(height: 16.h),
                      Obx(() => _buildInputField(
                            controller: controller.phoneController,
                            label: 'Số điện thoại',
                            hint: 'Nhập số điện thoại',
                            icon: Icons.phone,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(10)
                            ],
                            error: controller.phoneError,
                          )),
                      SizedBox(height: 16.h),
                      Obx(() => _buildInputField(
                            controller: controller.identityNumberController,
                            label: 'Số định danh',
                            hint: 'Nhập số CCCD/CMND',
                            icon: Icons.badge,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(12)
                            ],
                            error: controller.identityError,
                          )),
                      SizedBox(height: 16.h),
                      _buildInputField(
                        controller: controller.insuranceNumberController,
                        label: 'Số bảo hiểm',
                        hint: 'Nhập số bảo hiểm y tế (nếu có)',
                        icon: Icons.health_and_safety,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(10),
                        ],
                      ),
                      SizedBox(height: 16.h),
                      Obx(() => _buildDatePicker(context,
                          error: controller.birthDateError)),
                      SizedBox(height: 16.h),
                      Obx(() => _buildDropdown(
                            label: 'Giới tính',
                            controller: controller.genderController,
                            items: ['Nam', 'Nữ', 'Khác'],
                            icon: Icons.person,
                            error: controller.genderError,
                          )),
                      SizedBox(height: 16.h),
                      Obx(() => _buildDropdown(
                            label: 'Nhóm máu',
                            controller: controller.bloodTypeController,
                            items: ['A', 'B', 'AB', 'O'],
                            icon: Icons.bloodtype,
                            error: controller.bloodTypeError,
                          )),
                      SizedBox(height: 16.h),
                      Obx(() => _buildInputField(
                            controller: controller.heightController,
                            label: 'Chiều cao (cm)',
                            hint: 'Ví dụ: 170',
                            icon: Icons.height,
                            keyboardType: TextInputType.number,
                            error: controller.heightError,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(3),
                            ],
                          )),
                      SizedBox(height: 16.h),
                      Obx(() => _buildInputField(
                            controller: controller.weightController,
                            label: 'Cân nặng (kg)',
                            hint: 'Ví dụ: 65',
                            icon: Icons.monitor_weight,
                            keyboardType: TextInputType.number,
                            error: controller.weightError,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(3),
                            ],
                          )),
                      SizedBox(height: 16.h),
                      _buildInputField(
                        controller: controller.occupationController,
                        label: 'Nghề nghiệp',
                        hint: 'Ví dụ: Kỹ sư, Giáo viên...',
                        icon: Icons.work,
                      ),
                      SizedBox(height: 16.h),
                      _buildInputField(
                        controller: controller.lifestyleNotesController,
                        label: 'Ghi chú lối sống',
                        hint: 'Ví dụ: Hút thuốc, Uống rượu...',
                        icon: Icons.notes,
                        maxLines: 3,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24.h),
              Obx(() => ElevatedButton(
                    onPressed: controller.isLoading.value
                        ? null
                        : controller.completeProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorConstants.primaryGreen,
                      foregroundColor: Colors.white,
                      minimumSize: Size(double.infinity, 50.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: controller.isLoading.value
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                            'Hoàn thành',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
    List<TextInputFormatter>? inputFormatters,
    RxString? error,
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
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.grey.withOpacity(0.3),
              width: 1.5,
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0F000000),
                blurRadius: 3,
                offset: Offset(0, 1),
              ),
            ],
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            maxLines: maxLines,
            inputFormatters: inputFormatters,
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
                padding: const EdgeInsets.all(12),
                child: Icon(
                  icon,
                  color: error?.value.isNotEmpty == true
                      ? Colors.red.withOpacity(0.7)
                      : ColorConstants.primaryGreen,
                  size: 20,
                ),
              ),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                vertical: maxLines > 1 ? 16 : 18,
                horizontal: 16,
              ),
            ),
            onChanged: (_) => error?.value = '',
          ),
        ),
        if (error?.value.isNotEmpty == true) ...[
          SizedBox(height: 6.h),
          Row(
            children: [
              Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 16,
              ),
              SizedBox(width: 6.w),
              Expanded(
                child: Text(
                  error!.value,
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

  Widget _buildDatePicker(BuildContext context, {RxString? error}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ngày sinh',
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
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.grey.withOpacity(0.3),
              width: 1.5,
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0F000000),
                blurRadius: 3,
                offset: Offset(0, 1),
              ),
            ],
          ),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => controller.selectBirthDate(context),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 18.h),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    child: Icon(
                      Icons.calendar_today,
                      color: error?.value.isNotEmpty == true
                          ? Colors.red.withOpacity(0.7)
                          : ColorConstants.primaryGreen,
                      size: 20,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Obx(() => Text(
                        controller.birthDate.value != null
                            ? '${controller.birthDate.value!.day}/${controller.birthDate.value!.month}/${controller.birthDate.value!.year}'
                            : 'Chọn ngày sinh',
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: controller.birthDate.value != null
                              ? Colors.black
                              : Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      )),
                ],
              ),
            ),
          ),
        ),
        if (error?.value.isNotEmpty == true) ...[
          SizedBox(height: 6.h),
          Row(
            children: [
              Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 16,
              ),
              SizedBox(width: 6.w),
              Expanded(
                child: Text(
                  error!.value,
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

  Widget _buildDropdown({
    required String label,
    required TextEditingController controller,
    required List<String> items,
    required IconData icon,
    RxString? error,
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
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.grey.withOpacity(0.3),
              width: 1.5,
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0F000000),
                blurRadius: 3,
                offset: Offset(0, 1),
              ),
            ],
          ),
          child: DropdownButtonFormField<String>(
            value: controller.text.isNotEmpty ? controller.text : null,
            decoration: InputDecoration(
              filled: false,
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
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
              size: 20,
            ),
            hint: Text(
              'Chọn $label',
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.grey[500],
                fontWeight: FontWeight.w400,
              ),
            ),
            items: items.map((item) {
              return DropdownMenuItem(
                value: item,
                child: Row(
                  children: [
                    Icon(
                      icon,
                      color: ColorConstants.primaryGreen,
                      size: 20,
                    ),
                    SizedBox(width: 12.w),
                    Text(
                      item,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
            onChanged: (newValue) {
              if (newValue != null) {
                controller.text = newValue;
                error?.value = '';
              }
            },
          ),
        ),
        if (error?.value.isNotEmpty == true) ...[
          SizedBox(height: 6.h),
          Row(
            children: [
              Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 16,
              ),
              SizedBox(width: 6.w),
              Expanded(
                child: Text(
                  error!.value,
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
}
