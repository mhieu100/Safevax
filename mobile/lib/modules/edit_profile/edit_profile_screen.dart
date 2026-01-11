import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_getx_boilerplate/modules/edit_profile/edit_profile_controller.dart';
import 'package:flutter_getx_boilerplate/shared/shared.dart';
import 'package:get/get.dart';

class EditProfileScreen extends GetView<EditProfileController> {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Chỉnh Sửa Hồ Sơ',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        backgroundColor: ColorConstants.primaryGreen,
        foregroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(() => _buildInputField(
                    controller: controller.fullNameController,
                    label: 'Họ và Tên',
                    hint: 'Nhập họ và tên',
                    icon: Icons.person_outline,
                    error: controller.fullNameError,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(100),
                    ],
                  )),
              const SizedBox(height: 16),
              Obx(() => _buildInputField(
                    controller: controller.emailController,
                    label: 'Email',
                    hint: 'Nhập email',
                    icon: Icons.email_outlined,
                    error: controller.emailError,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(254),
                    ],
                  )),
              const SizedBox(height: 16),
              Obx(() => _buildInputField(
                    controller: controller.phoneController,
                    label: 'Số điện thoại',
                    hint: 'Ví dụ: 090xxxxxxx',
                    icon: Icons.phone_outlined,
                    keyboardType: TextInputType.phone,
                    error: controller.phoneError,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10),
                    ],
                  )),
              const SizedBox(height: 16),
              Obx(() => _buildInputField(
                    controller: controller.dateOfBirthController,
                    label: 'Ngày sinh',
                    hint: 'Ví dụ: 1990-01-01',
                    icon: Icons.calendar_today,
                    error: controller.dateOfBirthError,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(10),
                    ],
                  )),
              const SizedBox(height: 16),
              Obx(() => _buildDropdown(
                    label: 'Giới tính',
                    controller: controller.genderController,
                    items: const ['Nam', 'Nữ', 'Khác'],
                    icon: Icons.person,
                    error: controller.genderError,
                  )),
              const SizedBox(height: 16),
              Obx(() => _buildInputField(
                    controller: controller.identityNumberController,
                    label: 'Số định danh',
                    hint: 'Nhập số CCCD/CMND',
                    icon: Icons.badge_outlined,
                    error: controller.identityNumberError,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(12),
                    ],
                  )),
              const SizedBox(height: 16),
              Obx(() => _buildDropdown(
                    label: 'Nhóm máu',
                    controller: controller.bloodTypeController,
                    items: const ['A', 'B', 'AB', 'O'],
                    icon: Icons.bloodtype,
                    error: controller.bloodTypeError,
                  )),
              const SizedBox(height: 16),
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
              const SizedBox(height: 16),
              Obx(() => _buildInputField(
                    controller: controller.weightController,
                    label: 'Cân nặng (kg)',
                    hint: 'Ví dụ: 70',
                    icon: Icons.monitor_weight,
                    keyboardType: TextInputType.number,
                    error: controller.weightError,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(3),
                    ],
                  )),
              const SizedBox(height: 16),
              Obx(() => _buildInputField(
                    controller: controller.addressController,
                    label: 'Địa chỉ',
                    hint: 'Nhập địa chỉ',
                    icon: Icons.home_outlined,
                    error: controller.addressError,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(255),
                    ],
                  )),
              const SizedBox(height: 16),
              Obx(() => _buildInputField(
                    controller: controller.occupationController,
                    label: 'Nghề nghiệp',
                    hint: 'Nhập nghề nghiệp',
                    icon: Icons.work_outline,
                    error: controller.occupationError,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(100),
                    ],
                  )),
              const SizedBox(height: 16),
              Obx(() => _buildInputField(
                    controller: controller.insuranceNumberController,
                    label: 'Số bảo hiểm',
                    hint: 'Nhập số bảo hiểm',
                    icon: Icons.health_and_safety_outlined,
                    keyboardType: TextInputType.number,
                    error: controller.insuranceNumberError,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10),
                    ],
                  )),
              const SizedBox(height: 16),
              Obx(() => _buildInputField(
                    controller: controller.lifestyleNotesController,
                    label: 'Ghi chú lối sống',
                    hint: 'Nhập ghi chú về lối sống',
                    icon: Icons.note_outlined,
                    maxLines: 3,
                    error: controller.lifestyleNotesError,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(500),
                    ],
                  )),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: controller.saveProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorConstants.primaryGreen,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Lưu Hồ Sơ',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
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

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
    TextInputType? keyboardType,
    RxString? error,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
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
            maxLines: maxLines,
            keyboardType: keyboardType,
            inputFormatters: inputFormatters,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              filled: false,
              hintText: hint,
              hintStyle: TextStyle(
                fontSize: 16,
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
          const SizedBox(height: 6),
          Row(
            children: [
              Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 16,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  error!.value,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 13,
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
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
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
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            ),
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
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
                fontSize: 16,
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
                    const SizedBox(width: 12),
                    Text(
                      item,
                      style: const TextStyle(
                        fontSize: 16,
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
          const SizedBox(height: 6),
          Row(
            children: [
              Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 16,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  error!.value,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 13,
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
